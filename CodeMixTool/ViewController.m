//
//  ViewController.m
//  CodeMixTool
//
//  Created by 贾辰 on 2019/3/26.
//  Copyright © 2019年 JJC. All rights reserved.
//
#define WindowHeight CGRectGetHeight(self.view.frame)
#define MacOriginY(originY) WindowHeight - originY

#import "ViewController.h"
#import "TableViewCell.h"
#import "UserDetailDataModel.h"

@interface ViewController()<NSTableViewDelegate,NSTableViewDataSource>
@property (strong, nonatomic) NSMutableArray *dataSource;
@property (weak) IBOutlet NSTableView *tableview;

@property (strong, nonatomic) NSTextField *txfProjPath;
@property (strong, nonatomic) NSTextField *txfCodePath;
@property (strong, nonatomic) NSTextField *txfSonPath;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    // Do any additional setup after loading the view.
//    [self createUI];
    [self createUI];
    
}

//- (void)createUI1 {
//    self.dataSource = [NSMutableArray new];
//
//    CGFloat viewWidth = CGRectGetWidth(self.view.bounds);
//    CGFloat viewHeight = CGRectGetHeight(self.view.bounds);
//
//    self.tableview = [[NSTableView alloc] initWithFrame:CGRectMake(20, MacOriginY(100),viewWidth - 40, viewHeight -120)];
//    self.tableview.delegate = self;
//    self.tableview.dataSource = self;
//    self.tableview.backgroundColor = [NSColor colorWithRed:1 green:1 blue:0 alpha:1];
//    [self.view addSubview:self.tableview];
//
//    //设置Cell 高度
//    [self.tableview setRowHeight:45];
//
//    //创建数据Model
//    NSArray *userIdArray = @[@"101",@"102",@"103",@"104"];
//    NSArray *userNameArray = @[@"Allen",@"Jack",@"Luck",@"Tony"];
//    NSArray *userAvatarArray = @[[NSImage imageNamed:@"tag_1.png"],[NSImage imageNamed:@"tag_2.jpg"],[NSImage imageNamed:@"tag_3.jpg"],[NSImage imageNamed:@"tag_4.jpeg"]];
//
//    for (NSInteger i = 0; i < userNameArray.count; i++) {
//        UserDetailDataModel *detail = [[UserDetailDataModel alloc]init];
//        detail.userid = userIdArray[i];
//        detail.username = userNameArray[i];
//        detail.useravatar = userAvatarArray[i];
//        [self.dataSource addObject:detail];
//
//    }
//
//    [self.tableview reloadData];
//}

- (void)onOpen {
    NSOpenPanel *oPanel = [NSOpenPanel openPanel];
    [oPanel setCanChooseDirectories:YES]; //可以打开目录
    [oPanel setCanChooseFiles:YES]; //不能打开文件(我需要处理一个目录内的所有文件)
    NSInteger finded = [oPanel runModal]; //获取panel的响应
    
    if (finded == NSModalResponseOK) {
        NSLog(@"选择路径：%@",[oPanel URL]);
        [_txfProjPath setStringValue:[NSString stringWithFormat:@"%@",[oPanel URL]]];
    }
}

- (void)onOpenCodePath {
    NSOpenPanel *oPanel = [NSOpenPanel openPanel];
    [oPanel setCanChooseDirectories:YES]; //可以打开目录
    [oPanel setCanChooseFiles:NO]; //不能打开文件(我需要处理一个目录内的所有文件)
    NSInteger finded = [oPanel runModal]; //获取panel的响应
    
    if (finded == NSModalResponseOK) {
        NSLog(@"选择路径：%@",[oPanel URL]);
        [_txfCodePath setStringValue:[NSString stringWithFormat:@"%@",[oPanel URL]]];
    }
}

- (void)onOpenSonPath {
    NSOpenPanel *oPanel = [NSOpenPanel openPanel];
    [oPanel setCanChooseDirectories:YES]; //可以打开目录
    [oPanel setCanChooseFiles:YES]; //不能打开文件(我需要处理一个目录内的所有文件)
    [oPanel setAllowsMultipleSelection:YES];//是否允许多选file
    NSInteger finded = [oPanel runModal]; //获取panel的响应
    
    if (finded == NSModalResponseOK) {
        NSArray *arrSonPath = [oPanel URLs];
        NSLog(@"选择子路径：%@",arrSonPath);
        [_txfCodePath setStringValue:[NSString stringWithFormat:@"%@",[oPanel URL]]];
    }
}

- (void)createUI {
    
    CGFloat viewWidth = CGRectGetWidth(self.view.bounds);
    CGFloat viewHeight = CGRectGetHeight(self.view.bounds);
    
    NSButton *btnProjPath = [[NSButton alloc] initWithFrame:CGRectMake(20, MacOriginY(50), 120, 34)];
    btnProjPath.title = @"选择.xcodeproj文件";
    [btnProjPath setAction:@selector(onOpen)];
    [self.view addSubview:btnProjPath];
    
    _txfProjPath = [[NSTextField alloc] initWithFrame:CGRectMake(CGRectGetMaxX(btnProjPath.frame) +20,CGRectGetMinY(btnProjPath.frame)-10,viewWidth - CGRectGetWidth(btnProjPath.frame) - 40, 40)];
    [_txfProjPath setStringValue:@"输入.xcodeproj的绝对路径"];
//    _txfProjPath.alignment = NSTextAlignmentCenter;
    [_txfProjPath setBezeled:NO];
    [_txfProjPath setDrawsBackground:NO];
    [_txfProjPath setEditable:NO];
    [_txfProjPath setSelectable:NO];
    [self.view addSubview:_txfProjPath];
    
    NSButton *btnCodePath = [[NSButton alloc] initWithFrame:CGRectMake(20, MacOriginY(100), 120, 34)];
    btnCodePath.title = @"选择代码文件夹";
    [btnCodePath setAction:@selector(onOpenCodePath)];
    [self.view addSubview:btnCodePath];
    
    _txfCodePath = [[NSTextField alloc] initWithFrame:CGRectMake(CGRectGetMaxX(btnCodePath.frame) +20,CGRectGetMinY(btnCodePath.frame)-10,viewWidth - CGRectGetWidth(btnCodePath.frame) - 40, 40)];
    [_txfCodePath setStringValue:@"选择代码文件夹的绝对路径"];
    [_txfCodePath setBezeled:NO];
    [_txfCodePath setDrawsBackground:NO];
    [_txfCodePath setEditable:NO];
    [_txfCodePath setSelectable:NO];
    [self.view addSubview:_txfCodePath];
    
    NSButton *btnChoseSonPath = [[NSButton alloc] initWithFrame:CGRectMake(20, MacOriginY(150), 120, 34)];
    btnChoseSonPath.title = @"选择需要执行的子文件夹";
    [btnChoseSonPath setAction:@selector(onOpenSonPath)];
    [self.view addSubview:btnChoseSonPath];
    
    _txfSonPath = [[NSTextField alloc] initWithFrame:CGRectMake(CGRectGetMaxX(btnCodePath.frame) +20,CGRectGetMinY(btnCodePath.frame)-10,viewWidth - CGRectGetWidth(btnCodePath.frame) - 40, 40)];
    [_txfCodePath setStringValue:@"选择子文件夹的绝对路径"];
    [_txfCodePath setBezeled:NO];
    [_txfCodePath setDrawsBackground:NO];
    [_txfCodePath setEditable:NO];
    [_txfCodePath setSelectable:NO];
    [self.view addSubview:_txfCodePath];

//    NSTableView *tableview = [[NSTableView alloc] initWithFrame:CGRectMake(20, MacOriginY(200),viewWidth - 40, viewHeight -120)];
//    tableview.delegate = self;
//    tableview.dataSource = self;
//    tableview.backgroundColor = [NSColor colorWithRed:1 green:1 blue:0 alpha:1];
//    [self.view addSubview:tableview];
//
//    NSTableColumn * column = [[NSTableColumn alloc]initWithIdentifier:@"test"];
//    NSTableColumn * column2 = [[NSTableColumn alloc]initWithIdentifier:@"test2"];
//    column2.width = 100;
//    column2.minWidth = 100;
//    column2.maxWidth = 100;
//    column2.title = @"数据";
//    column2.editable = YES ;
//    column2.headerToolTip = @"提示";
//    column2.hidden=NO;
//    column2.sortDescriptorPrototype = [NSSortDescriptor sortDescriptorWithKey:@"title" ascending:NO];
//    column.resizingMask =NSTableColumnUserResizingMask;
//
//    [tableview addTableColumn:column];
    
    _tableview.delegate = self;
    _tableview.dataSource = self;
    
}

//cell 个数
- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView {
    return  5;
}

//- (NSView *)tableView:(NSTableView *)tableView
//   viewForTableColumn:(NSTableColumn *)tableColumn
//                  row:(NSInteger)row {
//
//    NSString *cellIdentifier = @"";
//    NSString *text;
//
//    if (tableColumn == tableView.tableColumns[0]) {
////        image = item.icon
//        cellIdentifier = @"PickerCell";
//    } else if (tableColumn == tableView.tableColumns[1]) {
//        text = @"111";
//        cellIdentifier = @"DescribeCell";
//    } else if (tableColumn == tableView.tableColumns[2]) {
//        text = @"222";
//        cellIdentifier = @"DetailInfoCell";
//    }
//
//    NSTableCellView *cell = [tableView makeViewWithIdentifier:cellIdentifier owner:nil];
//    cell.textField.stringValue = text;
//    return cell;
//}

- (NSView*)tableView:(NSTableView*)tableView
  viewForTableColumn:(NSTableColumn*)tableColumn
                 row:(NSInteger)row {
    NSTableCellView *cell = [tableView makeViewWithIdentifier:@"NSTableCellView的标识" owner:nil];
//    cell.imageView.image = [NSImage imageNamed:dic[@"icon"]];
    cell.textField.stringValue = @"weqr";
    return cell;
}
////设置列表Value
//- (nullable id)tableView:(NSTableView *)tableView objectValueForTableColumn:(nullable NSTableColumn *)tableColumn row:(NSInteger)row
//{
//    if([self.dataSource count] <= 0){
//        return nil;
//    }
//    UserDetailDataModel *detail = self.dataSource[row];
//
//    return   [detail valueForKey: [tableColumn identifier]];
//}
////cell绑定对象模型
//- (void)tableView:(NSTableView *)tableView setObjectValue:(nullable id)object forTableColumn:(nullable NSTableColumn *)tableColumn row:(NSInteger)row {
//    UserDetailDataModel *detail = self.dataSource[row];
//    [detail setValue:object forKey: [tableColumn identifier]];
//}


- (void)setRepresentedObject:(id)representedObject {
    [super setRepresentedObject:representedObject];

    // Update the view, if already loaded.
}


@end
