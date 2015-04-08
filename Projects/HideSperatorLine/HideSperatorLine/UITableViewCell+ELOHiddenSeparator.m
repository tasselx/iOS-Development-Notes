//
//  UITableViewCell+ELOHiddenSeparator.m
//  TableViewCellWithoutSeparator
//
//  Created by Ross LeBeau on 10/2/14.
//  Copyright (c) 2014 Ross LeBeau. All rights reserved.
//

#import "UITableViewCell+ELOHiddenSeparator.h"
#import <objc/runtime.h>
#import <objc/message.h>

static NSString * const ELOHiddenSeparatorTableViewCellClassName = @"ELOHiddenSeparatorTableViewCell";
static void * ELOHiddenSeparatorTableViewCellProperty_separatorHidden = &ELOHiddenSeparatorTableViewCellProperty_separatorHidden;
static void * ELOHiddenSeparatorTableViewCellProperty_previousSeparatorInset = &ELOHiddenSeparatorTableViewCellProperty_previousSeparatorInset;

@implementation UITableViewCell (ELOHiddenSeparator)

- (void)elo_setSeparatorHidden:(BOOL)hidden {
    [self elo_createHiddenSeparatorSubclassIfNeeded];
    
    Class hiddenSeparatorSubclass = objc_lookUpClass(ELOHiddenSeparatorTableViewCellClassName.UTF8String);
    
    if (!hiddenSeparatorSubclass) {
        // it ain't gonna work - something went wrong when trying to create it when we initially dispatched
        // checking here so we can return with an error and not try to do all the fancy stuff below
        NSLog(@"custom subclass doesnt exist");
        return;
    }
    
    if (![self isKindOfClass:hiddenSeparatorSubclass]) {
        object_setClass(self, hiddenSeparatorSubclass);
        objc_setAssociatedObject(self, ELOHiddenSeparatorTableViewCellProperty_separatorHidden, [NSNumber numberWithBool:hidden], OBJC_ASSOCIATION_RETAIN);
        [self elo_saveAndHideSeparator];
    }
    
    if ([self elo_separatorHidden] == hidden) {
        return;
    }
    
    objc_setAssociatedObject(self, ELOHiddenSeparatorTableViewCellProperty_separatorHidden, [NSNumber numberWithBool:hidden], OBJC_ASSOCIATION_RETAIN);
    
    if (hidden) {
        [self elo_saveAndHideSeparator];
    } else {
        [self elo_restoreSeparator];
    }
}

- (BOOL)elo_separatorHidden {
    NSNumber *currentSeparatorHiddenProperty = objc_getAssociatedObject(self, ELOHiddenSeparatorTableViewCellProperty_separatorHidden);
    return currentSeparatorHiddenProperty.boolValue;
}

- (void)elo_moveSeparatorToHidden {
    self.separatorInset = UIEdgeInsetsMake(0, self.bounds.size.width, 0, 0);
    
    // Setting the separator inset also moves the cell's default content views: 'textLabel', 'detailLabel', etc
    // Therefore, we want to offset this by setting the cell's content indentation
    self.indentationWidth = -self.bounds.size.width;
    self.indentationLevel = 1;
}

- (void)elo_saveAndHideSeparator {
    UIEdgeInsets currentSeparatorInset = self.separatorInset;
    objc_setAssociatedObject(self, ELOHiddenSeparatorTableViewCellProperty_previousSeparatorInset, [NSValue valueWithBytes:&currentSeparatorInset objCType:@encode(UIEdgeInsets)], OBJC_ASSOCIATION_RETAIN);
    [self elo_moveSeparatorToHidden];
}

- (void)elo_restoreSeparator {
    NSValue *previousSeparatorInsetValue = objc_getAssociatedObject(self, ELOHiddenSeparatorTableViewCellProperty_previousSeparatorInset);
    UIEdgeInsets previousSeparatorInset;
    [previousSeparatorInsetValue getValue:&previousSeparatorInset];
    self.separatorInset = previousSeparatorInset;
}

- (void)elo_createHiddenSeparatorSubclassIfNeeded {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Class hiddenSeparatorSubclass = objc_allocateClassPair([self class], ELOHiddenSeparatorTableViewCellClassName.UTF8String, 0);
        
        if (!hiddenSeparatorSubclass) {
            // error! Not much to do here besides let the dev know...
            return;
        }
        
        objc_registerClassPair(hiddenSeparatorSubclass);
        
        void (^layoutSubviewsOverrideBlock)(UITableViewCell * self, SEL _cmd) = ^void(UITableViewCell * self, SEL _cmd) {
            /*
             We cannot just use '[super layoutSubviews]', because calls to the 'super' keyword are generated at compile-time, at which point our class hasn't been created yet.
             
             "When it encounters a method call, the compiler generates a call to one of the functions objc_msgSend, objc_msgSend_stret, objc_msgSendSuper, or objc_msgSendSuper_stret."
             https://developer.apple.com/library/mac/documentation/Cocoa/Reference/ObjCRuntimeRef/Reference/reference.html#//apple_ref/c/func/objc_msgSendSuper
             
             Additionally, we cannot just resolve the Method once, outside of this block, and invoke it inside this block, because that will fail to invoke the correct function
             if the method is modified by someone else using the objc runtime (e.g. swizzling)
            */
            
            
            // Method 1 for calling the superclass's implementation
            struct objc_super dynamicallyResolvedSuper;
            dynamicallyResolvedSuper.receiver = self;
            dynamicallyResolvedSuper.super_class = [self superclass];
            
            // From the documentation: "These functions must be cast to an appropriate function pointer type before being called."
            void (*layoutSubviews_cast_msgSendSuper)(struct objc_super*, SEL) = (void *)objc_msgSendSuper;
            layoutSubviews_cast_msgSendSuper(&dynamicallyResolvedSuper, @selector(layoutSubviews));
            
            
            /*
            // Method 2 for calling the superclass's implementation
            Method dynamicallyResolvedSuperclassLayoutSubviewsMethod = class_getInstanceMethod([self superclass], @selector(layoutSubviews));
            
            // From the documentation: "These functions must be cast to an appropriate function pointer type before being called."
            void (*layoutSubviews_cast_method_invoke)(id, Method) = (void *)method_invoke;
            layoutSubviews_cast_method_invoke(self, dynamicallyResolvedSuperclassLayoutSubviewsMethod);
            */
            
            if ([self elo_separatorHidden]) {
                [self elo_moveSeparatorToHidden];
            }
        };
        
        IMP layoutSubviewsOverrideImp = imp_implementationWithBlock(layoutSubviewsOverrideBlock);
        class_addMethod(hiddenSeparatorSubclass, @selector(layoutSubviews), layoutSubviewsOverrideImp, "v@:");
    });
}

@end
