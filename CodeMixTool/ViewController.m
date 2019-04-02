//
//  ViewController.m
//  CodeMixTool
//
//  Created by 贾辰 on 2019/3/26.
//  Copyright © 2019年 JJC. All rights reserved.
//
#define WindowHeight CGRectGetHeight(self.view.frame)
#define MarginTop(originY) WindowHeight - originY

#import "ViewController.h"
#import "TableViewCell.h"
#import "DetailView.h"
#import "FunctionModel.h"

@interface ViewController()<NSTableViewDelegate,NSTableViewDataSource>
//@property (strong, nonatomic) NSMutableArray *dataSource;

@property (strong, nonatomic) NSTableView *tableView;
@property (strong, nonatomic) NSMutableArray<FunctionModel *> *arrData;

@property (strong, nonatomic) NSTextField *txfProjPath;
@property (strong, nonatomic) NSTextField *txfCodePath;
@property (strong, nonatomic) NSTextField *txfSonPath;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    // Do any additional setup after loading the view.
//    [self createUI];
    [self createData];
    [self createUI];
}

- (void)createData {
    _arrData = [NSMutableArray arrayWithCapacity:0];
    
    FunctionModel *data1 = [[FunctionModel alloc] initWithTitle:@"添加固定类前缀" andIsNeedParameter:NO];
    FunctionModel *data2 = [[FunctionModel alloc] initWithTitle:@"添加随机类前缀" andIsNeedParameter:NO];
    FunctionModel *data3 = [[FunctionModel alloc] initWithTitle:@"替换类前缀" andIsNeedParameter:YES];
    
    FunctionModel *data4 = [[FunctionModel alloc] initWithTitle:@"删除换行注释NSLog" andIsNeedParameter:NO];
    
    [_arrData addObject:data1];
    [_arrData addObject:data2];
    [_arrData addObject:data3];
    [_arrData addObject:data4];
}

- (void)createUI {
    
    CGFloat viewWidth = CGRectGetWidth(self.view.bounds);
    CGFloat viewHeight = CGRectGetHeight(self.view.bounds);
    
    NSButton *btnProjPath = [[NSButton alloc] initWithFrame:CGRectMake(20, MarginTop(50), 200, 34)];
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
    
    NSButton *btnCodePath = [[NSButton alloc] initWithFrame:CGRectMake(20, MarginTop(100), 200, 34)];
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
    
    NSButton *btnChoseSonPath = [[NSButton alloc] initWithFrame:CGRectMake(20, MarginTop(150), 200, 34)];
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
    
//    _dataArr = [NSMutableArray arrayWithCapacity:0];
//    for (int i = 0; i< 20; i++) {
//        [_dataArr addObject:[NSString stringWithFormat:@"%d 行数据",i]];
//    }
    
//    NSLog(@"min %f,Max %f,o:%f",CGRectGetMinY(btnChoseSonPath.frame),CGRectGetMaxY(btnChoseSonPath.frame),MarginTop(300));
    _tableView = [[NSTableView alloc] initWithFrame:CGRectMake(CGRectGetMinX(btnChoseSonPath.frame), MarginTop(350), 300, 300)];
    NSTableColumn *column = [[NSTableColumn alloc] initWithIdentifier:@"zzzJC"];
    column.width = CGRectGetWidth(_tableView.frame);
    [_tableView addTableColumn:column];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [_tableView reloadData];
//    [self.view addSubview:_tableView];
    
    for (int i =0 ; i<[_arrData count]; i++) {
//        TableViewCell *cell = [[TableViewCell alloc] initWithFrame:CGRectMake(20, MarginTop(200 - 30*i), viewWidth - 40, 20)];
        
        TableViewCell *cellView = [[TableViewCell alloc] initWithFrame:CGRectMake(20, MarginTop(200 - 30*i), viewWidth - 40, 20)
                                                              andTitle:_arrData[i].title
                                                    andIsNeedParameter:_arrData[i].isNeedParameter];
        [self.view addSubview:cellView];
    }
    
//    for (int i =0 ; i<3; i++) {
//        DetailView *dView = [[DetailView alloc] initWithFrame:CGRectMake(20, MarginTop(200 - 50*i), viewWidth - 40, 30)];
//        dView.txfInfo.stringValue = @"qwerewr";
//        [self.view addSubview:dView];
//    }

}

//cell 个数
- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView {
    return  10;
}

- (nullable NSView *)tableView:(NSTableView *)tableView viewForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row {
    TableViewCell *cell = [tableView makeViewWithIdentifier:@"cellID" owner:self];
    if (!cell) {
        cell = [[TableViewCell alloc] initWithFrame:CGRectMake(0, 0, 400, 100)];
        cell.txfInfo.stringValue = @"qwerewr";
        cell.identifier = @"cellID";
    }
    return cell;
}


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

//- (NSView*)tableView:(NSTableView*)tableView
//  viewForTableColumn:(NSTableColumn*)tableColumn
//                 row:(NSInteger)row {
////    NSTableCellView *cell = [tableView makeViewWithIdentifier:@"NSTableCellView的标识" owner:nil];
//    NSTableCellView *cell = [[NSTableCellView alloc] init];
//    cell.textField.stringValue = @"weqr";
//    return cell;
//}

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
