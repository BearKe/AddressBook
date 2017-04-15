//
//  ViewController.m
//  addressBook_K
//
//  Created by KeX on 2017/4/13.
//  Copyright © 2017年 KeX. All rights reserved.
//

#import "ViewController.h"
#import "FMDatabase.h"
#import "FMDB.h"

@interface ViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) NSMutableArray *Array;

@property (nonatomic,assign) NSInteger indexPath;

@property (strong, nonatomic) UITableView* tableView;

@end


@implementation ViewController

- (void)viewDidLoad {
    
    
    [super viewDidLoad];
    [self.view addSubview:self.tableView];
    
    // Do any additional setup after loading the view, typically from a nib.
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"Array"])
    {
        NSMutableArray *A_array = [[NSMutableArray alloc] initWithArray:[[NSUserDefaults standardUserDefaults] objectForKey:@"Array"]];
        
        self.Array = A_array;
    }
    else{
        self.Array = [[NSMutableArray alloc] init];
        
        for (int i = 0; i<30; i++) {
            NSString *str = [NSString stringWithFormat:@"%d",i];
            [self.Array addObject:str];
        }
        
        [[NSUserDefaults standardUserDefaults] setObject:self.Array forKey:@"Array"];
        
    }
    
 //   [self setNavTitle];
    
 //   [self setNavBtn];
    
    [self.view addSubview:self.tableView];
    
    [self.tableView reloadData];
    
    UINavigationBar *navBar = [[UINavigationBar alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 64)];
    // UIButton * tempButton = [UIButton buttonWithType:UIButtonTypeInfoLight];
    
    UINavigationItem * navTitle = [[UINavigationItem alloc] init];
    navTitle.title = @"Title";
    
    //[tempButton addTarget:self action:@selector(infoButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    
   // UIBarButtonItem * infoButton = [[UIBarButtonItem alloc] initWithCustomView:tempButton];
    //-----
    UIBarButtonItem *rBtn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(add)];
    self.navigationItem.rightBarButtonItem = rBtn;
    
    //In this case your button will be on the right side
    navTitle.rightBarButtonItem = rBtn;
    
    //Add NavigationBar on main view
    navBar.items = @[navTitle];
    [self.view addSubview:navBar];
    
    
}


#pragma mark - 设置导航栏标题
/*
-(void)setNavTitle{
    
    self.title = @"addressBook";
}

- (void)setNavBtn{
    
    
    UIBarButtonItem *rBtn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(add)];
    self.navigationItem.rightBarButtonItem = rBtn;
    
}
*/
- (void)add{
    [self.Array insertObject:@"add" atIndex:0];
    [[NSUserDefaults standardUserDefaults] setObject:self.Array forKey:@"Array"];
    [self.tableView reloadData];
}




- (UITableView*)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
    }
    return _tableView;
}

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _Array.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * CellIdentifier = @"ShowUserInfoCell";
    UITableViewCell * cell = [_tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
    {
        // Create a cell to display an ingredient.
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle
                                      reuseIdentifier:CellIdentifier];
    }
    
    // Configure the cell.
    cell.textLabel.text= self.Array[indexPath.row];
    //[NSString stringWithFormat:@"section:%ld row:%ld",(long)indexPath.section, (long)indexPath.row];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Title" message:@"AddressBook Title" preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    
    
    [alertController addAction:okAction];
    [alertController addAction:cancelAction];
    
    [self presentViewController:alertController animated:YES completion:nil];
    
}

#pragma mark -- cell左滑退出

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return YES;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    //    [tableView setEditing:YES animated:YES];
    return UITableViewCellEditingStyleDelete;
}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath{
    return @"删除";
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"确定删除？" preferredStyle:UIAlertControllerStyleAlert];
        //        [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
        [alertController addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
            [_Array removeObjectAtIndex:indexPath.row];
            
            [[NSUserDefaults standardUserDefaults] setObject:self.Array forKey:@"Array"];
            
            [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationLeft];
        }]];
        
        [self presentViewController:alertController animated:YES completion:nil];
    }
}

//下部分代码能显示 左划删除、更多、置顶  但仅仅只能展现效果 然而并没有什么卵用

/*
 #pragma mark - tableView自带的编辑功能
 - (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
 if (editingStyle == UITableViewCellEditingStyleDelete) {
 NSLog(@"标记为已回访");
 }
 }
 // 选择编辑的样式
 - (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
 return UITableViewCellEditingStyleDelete;
 }
 // 修改delete的文字
 - (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath {
 return @"标记为\n已回访";
 }
 
 // 设置显示多个按钮
 - (NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath {
 //    UITableViewRowAction 通过此类创建按钮
 
 UITableViewRowAction * deleteRowAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:@"删除" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
 
 }];
 deleteRowAction.backgroundColor = [UIColor redColor];
 
 UITableViewRowAction * topRowAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:@"置顶" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
 
 }];
 topRowAction.backgroundColor = [UIColor blueColor];
 
 UITableViewRowAction * moreRowAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal title:@"更多" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
 
 }];
 
 return @[deleteRowAction,topRowAction,moreRowAction];
 }
 */


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
