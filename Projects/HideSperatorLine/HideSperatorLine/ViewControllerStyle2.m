//
//  ViewControllerStyle2.m
//  HidenTableViewCell
//
//  Created by Tassel on 15/4/8.
//  Copyright (c) 2015年 Tassel. All rights reserved.
//

#import "ViewControllerStyle2.h"
#import "UITableViewCell+ELOHiddenSeparator.h"
@interface ViewControllerStyle2 ()<UITableViewDelegate,UITableViewDataSource>

@end

@implementation ViewControllerStyle2

- (void)viewDidLoad {
    [super viewDidLoad];

    UITableView *tableView = [[UITableView alloc] initWithFrame:self.view.bounds];
    tableView.delegate =self;
    tableView.dataSource =self;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:tableView];
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIndentifer=@"cell";
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:cellIndentifer];
    if (!cell) {
        cell=[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIndentifer];
    }
    cell.textLabel.text = [NSString stringWithFormat:@"%ld",(long)indexPath.row];
    
    if (indexPath.row ==5) {
        
        [cell elo_setSeparatorHidden:YES];
    }
    
    return cell;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 30;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    return 1;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
