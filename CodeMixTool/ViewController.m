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
#import "FunctionModel.h"
#import "FileManager.h"

@interface ViewController()<NSTableViewDelegate,NSTableViewDataSource>
//@property (strong, nonatomic) NSMutableArray *dataSource;

@property (strong, nonatomic) NSTableView *tableView;
@property (strong, nonatomic) NSMutableArray<FunctionModel *> *arrData;

@property (strong, nonatomic) NSTextField *txfProjPath;
@property (strong, nonatomic) NSTextField *txfCodePath;
@property (strong, nonatomic) NSTextField *txfSonPath;

@property (strong, nonatomic) FileManager *fileManager;

@property (assign, nonatomic) EnumTaskType task;                    // 任务数组

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
    
    FunctionModel *data1 = [[FunctionModel alloc] initWithTitle:@"添加固定类前缀" andTask:EnumTaskTypeAddFixClassPreName andIsNeedParameter:NO];
    FunctionModel *data2 = [[FunctionModel alloc] initWithTitle:@"添加随机类前缀" andTask:EnumTaskTypeAddRandomClassPreName andIsNeedParameter:NO];
    FunctionModel *data3 = [[FunctionModel alloc] initWithTitle:@"替换类前缀" andTask:EnumTaskTypeReplaceClassPreName andIsNeedParameter:YES];
    
    FunctionModel *data4 = [[FunctionModel alloc] initWithTitle:@"删除换行注释NSLog" andTask:EnumTaskTypeDelLog andIsNeedParameter:NO];
    
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
    [_txfProjPath setStringValue:@"/Users/jiachen/demo/demo.xcodeproj"];
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
    [_txfCodePath setStringValue:@"/Users/jiachen/demo/demo"];
    [_txfCodePath setBezeled:NO];
    [_txfCodePath setDrawsBackground:NO];
    [_txfCodePath setEditable:NO];
    [_txfCodePath setSelectable:NO];
    [self.view addSubview:_txfCodePath];
    
    NSButton *btnChoseSonPath = [[NSButton alloc] initWithFrame:CGRectMake(20, MarginTop(150), 200, 34)];
    btnChoseSonPath.title = @"选择需要执行的子文件夹";
    [btnChoseSonPath setAction:@selector(onOpenSonPath)];
    [self.view addSubview:btnChoseSonPath];
    
    _txfSonPath = [[NSTextField alloc] initWithFrame:CGRectMake(CGRectGetMaxX(btnCodePath.frame) +20,CGRectGetMinY(btnChoseSonPath.frame)-10,viewWidth - CGRectGetWidth(btnCodePath.frame) - 40, 40)];
    [_txfSonPath setStringValue:@"选择子文件夹的绝对路径"];
    [_txfSonPath setBezeled:NO];
    [_txfSonPath setDrawsBackground:NO];
    [_txfSonPath setEditable:NO];
    [_txfSonPath setSelectable:NO];
    [self.view addSubview:_txfSonPath];
    
    // item
    for (int i =0 ; i<[_arrData count]; i++) {
        TableViewCell *cellView = [[TableViewCell alloc] initWithFrame:CGRectMake(20, MarginTop(200 - 30*i), viewWidth - 40, 20)
                                                                andTag:i
                                                              andTitle:_arrData[i].title
                                                    andIsNeedParameter:_arrData[i].isNeedParameter];
    
        [cellView.btncheckBox setTarget:self];
        [cellView.btncheckBox setAction:@selector(onCheckBoxAction:)];
        cellView.btncheckBox.tag = i;
        [self.view addSubview:cellView];
    }

    NSButton *btnRun = [NSButton buttonWithTitle:@"Run" target:self action:@selector(onRunAction)];
    btnRun.frame = CGRectMake(50, 50, 200, 100);
    [self.view addSubview:btnRun];
    
}

#pragma mark - BtnAction
- (void)try1 {
    
    if (_task & EnumTaskTypeAddFixClassPreName) {
        NSLog(@"选择了 添加固定的 类名前缀");
    }
    
    if (_task & EnumTaskTypeAddRandomClassPreName) {
        NSLog(@"选择了 添加随机的 类名前缀");
    }
    
    if (_task & EnumTaskTypeReplaceClassPreName) {
        NSLog(@"选择了 替换 类前缀");
    }
    
    if (_task & EnumTaskTypeDelLog) {
        NSLog(@"选择了 删除 NSLog");
    }
}

- (void)onCheckBoxAction:(NSButton *)btn {
    if (btn.tag & _task) {
        
    }
    NSLog(@"click:zz,%ld",(long)btn.tag);
}

- (void)onOpen {
    NSOpenPanel *oPanel = [NSOpenPanel openPanel];
    [oPanel setCanChooseDirectories:YES]; //可以打开目录
    [oPanel setCanChooseFiles:YES]; //不能打开文件(我需要处理一个目录内的所有文件)
    NSInteger finded = [oPanel runModal]; //获取panel的响应
    
    if (finded == NSModalResponseOK) {
        NSString *newPath;
        
        NSString *preString = [[NSString stringWithFormat:@"%@",[oPanel URL]] substringToIndex:7];
        if ([preString isEqualToString:@"file://"]) {
            newPath = [[NSString stringWithFormat:@"%@",[oPanel URL]] substringFromIndex:7];
        } else {
            newPath = [NSString stringWithFormat:@"%@",[oPanel URL]];
        }
        NSLog(@"选择路径：%@",newPath);
        [_txfProjPath setStringValue:newPath];
    }
}

- (void)onOpenCodePath {
    NSOpenPanel *oPanel = [NSOpenPanel openPanel];
    [oPanel setCanChooseDirectories:YES]; //可以打开目录
    [oPanel setCanChooseFiles:NO]; //不能打开文件(我需要处理一个目录内的所有文件)
    NSInteger finded = [oPanel runModal]; //获取panel的响应
    
    if (finded == NSModalResponseOK) {
        NSString *preString = [[NSString stringWithFormat:@"%@",[oPanel URL]] substringToIndex:7];
        NSString *newPath;
        
        // 通常选取后 会以 "file:///Users/jiachen/demo/demo/" 这样的路径形式，需要去除头部的 file:// 和 尾部的 /
        if ([preString isEqualToString:@"file://"]) {
            newPath = [[NSString stringWithFormat:@"%@",[oPanel URL]] substringFromIndex:7];
        } else {
            newPath = [NSString stringWithFormat:@"%@",[oPanel URL]];
        }
        
        NSString *endString = [newPath substringFromIndex:[newPath length]-1];
        if ([endString isEqualToString:@"/"]) {
            newPath = [newPath substringToIndex:newPath.length-1];
        }
        
        NSLog(@"选择路径：%@",newPath);
        [_txfCodePath setStringValue:newPath];
        
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

- (void)onRunAction {
    
    FileManager *fileManager = [[FileManager alloc] init];
    [fileManager setupWithXcodeProjPath:_txfProjPath.stringValue andCodeFilePath:_txfCodePath.stringValue andTask:1];
//    [fileManager deleteUselessCodeWithLineBreak:YES andAnnotation:YES andNSLog:YES];
//    [fileManager randomClassName];
    
    [fileManager addSpamCode];
    
}

- (void)setRepresentedObject:(id)representedObject {
    [super setRepresentedObject:representedObject];

    // Update the view, if already loaded.
}


@end
