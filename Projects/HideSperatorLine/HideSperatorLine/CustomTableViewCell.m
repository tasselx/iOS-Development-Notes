//
//  CustomTableViewCell.m
//  HidenTableViewCell
//
//  Created by Tassel on 15/4/8.
//  Copyright (c) 2015年 Tassel. All rights reserved.
//

#import "CustomTableViewCell.h"
@interface CustomTableViewCell()
@property (nonatomic,strong) UIView *speratorView;
@end

@implementation CustomTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{

    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        _hideSpeartor = NO;
        
    }

    return self;

}

- (UIView *)speratorView{

    
    if (!_speratorView) {
        
        _speratorView = [[UIView alloc] init];
        _speratorView.backgroundColor = [UIColor grayColor];
        _speratorView.alpha = 0.6;
        [self addSubview:_speratorView];
    }

    return _speratorView;


}

- (void)layoutSubviews{


    [super layoutSubviews];

    if (self.hideSpeartor) {
        
        self.speratorView.hidden = YES;
    }else{
    
        self.speratorView.hidden = NO;
        self.speratorView.frame = CGRectMake(0, CGRectGetHeight(self.frame)-0.5, CGRectGetWidth(self.frame), 0.5);
    
    
    }
    
    




}
- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
