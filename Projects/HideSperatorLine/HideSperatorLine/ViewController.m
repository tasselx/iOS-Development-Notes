//
//  ViewController.m
//  HidenTableViewCell
//
//  Created by Tassel on 15/4/8.
//  Copyright (c) 2015年 Tassel. All rights reserved.
//

#import "ViewController.h"
#import "ViewControllerStyle1.h"
#import "ViewControllerStyle2.h"
@interface ViewController ()
@property (nonatomic,strong) NSArray *dataAry;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _dataAry = @[@"自定Cell",@"类别实现"];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.row) {
        case 0:
        {
        
            ViewControllerStyle1 *viewController = [[ViewControllerStyle1 alloc] init];
            [self.navigationController pushViewController:viewController animated:YES];
        
        }
            break;
        case 1:
        {
            
            ViewControllerStyle2 *viewController = [[ViewControllerStyle2 alloc] init];
            [self.navigationController pushViewController:viewController animated:YES];
            
        }
            break;
   
        default:
            break;
    }
    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIndentifer=@"cell";
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:cellIndentifer];
    if (!cell) {
        cell=[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIndentifer];
    }
    cell.textLabel.text = _dataAry[indexPath.row];
    return cell;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    return 1;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
