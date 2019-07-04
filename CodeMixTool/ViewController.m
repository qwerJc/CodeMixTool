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
#import "FileMixedHelper.h"
#import "TableViewCell.h"
#import "FunctionModel.h"
#import "FileManager.h"

#import "SettingViewController.h"

@interface ViewController()<NSTableViewDelegate,NSTableViewDataSource>
//@property (strong, nonatomic) NSMutableArray *dataSource;

@property (strong, nonatomic) NSTableView *tableView;
@property (strong, nonatomic) NSMutableArray<FunctionModel *> *arrData;

@property (strong, nonatomic) NSTextField *txfProjPath;
@property (strong, nonatomic) NSTextField *txfCodePath;
@property (strong, nonatomic) NSTextField *txfSonPath;
@property (strong, nonatomic) NSTextField *txfSpamCodePath;
@property (strong, nonatomic) NSTextField *txfNewCodeFilePath;

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
    
    [FileMixedHelper sharedHelper].projPath = @"/Users/jiachen/demo/demo.xcodeproj";
    [FileMixedHelper sharedHelper].sourceCodePath = @"/Users/jiachen/demo/demo";
    
}

- (void)createUI {
    
    CGFloat viewWidth = CGRectGetWidth(self.view.bounds);
    CGFloat viewHeight = CGRectGetHeight(self.view.bounds);
    
    NSButton *btnProjPath = [[NSButton alloc] initWithFrame:CGRectMake(20, MarginTop(50), 200, 34)];
    btnProjPath.title = @"选择.xcodeproj文件";
    [btnProjPath setAction:@selector(onOpenXcodeproj)];
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
    
    NSButton *btnSpamCodeFilePath = [[NSButton alloc] initWithFrame:CGRectMake(20, MarginTop(200), 200, 34)];
    btnSpamCodeFilePath.title = @"选择垃圾代码存放路径";
    [btnSpamCodeFilePath setAction:@selector(onOpenSpamCodeFilePath)];
    [self.view addSubview:btnSpamCodeFilePath];
    
    _txfSpamCodePath = [[NSTextField alloc] initWithFrame:CGRectMake(CGRectGetMaxX(btnSpamCodeFilePath.frame) +20,CGRectGetMinY(btnSpamCodeFilePath.frame)-10,viewWidth - CGRectGetWidth(btnSpamCodeFilePath.frame) - 40, 40)];
    [_txfSpamCodePath setStringValue:@""];
    [_txfSpamCodePath setBezeled:NO];
    [_txfSpamCodePath setDrawsBackground:NO];
    [_txfSpamCodePath setEditable:NO];
    [_txfSpamCodePath setSelectable:NO];
    [self.view addSubview:_txfSpamCodePath];
    
    NSButton *btnNewCodeFilePath = [[NSButton alloc] initWithFrame:CGRectMake(20, MarginTop(250), 200, 34)];
    btnNewCodeFilePath.title = @"选择整合后的代码存放路径";
    [btnNewCodeFilePath setAction:@selector(onSetModifySavePath)];
    [self.view addSubview:btnNewCodeFilePath];
    
    _txfNewCodeFilePath = [[NSTextField alloc] initWithFrame:CGRectMake(CGRectGetMaxX(btnNewCodeFilePath.frame) +20,CGRectGetMinY(btnNewCodeFilePath.frame)-10,viewWidth - CGRectGetWidth(btnNewCodeFilePath.frame) - 40, 40)];
    [_txfNewCodeFilePath setStringValue:@""];
    [_txfNewCodeFilePath setBezeled:NO];
    [_txfNewCodeFilePath setDrawsBackground:NO];
    [_txfNewCodeFilePath setEditable:NO];
    [_txfNewCodeFilePath setSelectable:NO];
    [self.view addSubview:_txfNewCodeFilePath];
    
    NSButton *btnRun = [NSButton buttonWithTitle:@"Run" target:self action:@selector(onRunAction)];
    btnRun.frame = CGRectMake(50, 50, 200, 100);
    [self.view addSubview:btnRun];
    
}

#pragma mark - BtnAction

- (void)onOpenXcodeproj {
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
        
        [FileMixedHelper sharedHelper].projPath = newPath;
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
        
        [FileMixedHelper sharedHelper].sourceCodePath = newPath;
    }
}

- (void)onOpenSonPath {
    NSMutableArray *arrSonPath = [NSMutableArray arrayWithCapacity:0];
    
    NSOpenPanel *oPanel = [NSOpenPanel openPanel];
    [oPanel setCanChooseDirectories:YES]; //可以打开目录
    [oPanel setCanChooseFiles:YES]; //不能打开文件(我需要处理一个目录内的所有文件)
    [oPanel setAllowsMultipleSelection:YES];//是否允许多选file
    NSInteger finded = [oPanel runModal]; //获取panel的响应
    
    if (finded == NSModalResponseOK) {
        for (NSURL *pathURL in [oPanel URLs]) {
            
            NSString *path = [NSString stringWithFormat:@"%@",pathURL];
            if ([path hasPrefix:@"file://"]) {
                [arrSonPath addObject:[path substringFromIndex:7]];
            } else {
                [arrSonPath addObject:path];
            }
        }
        
        [_txfSonPath setStringValue:[NSString stringWithFormat:@"%@",[oPanel URL]]];
        
        [FileMixedHelper sharedHelper].arrSonPath = [arrSonPath copy];
    }
}

- (void)onOpenSpamCodeFilePath {
    NSOpenPanel *oPanel = [NSOpenPanel openPanel];
    [oPanel setCanChooseDirectories:YES]; //可以打开目录
    [oPanel setCanChooseFiles:NO]; //不能打开文件(我需要处理一个目录内的所有文件)
    [oPanel setCanCreateDirectories:YES];
    NSInteger finded = [oPanel runModal]; //获取panel的响应
    
    if (finded == NSModalResponseOK) {
        NSString *newPath;
        
        NSString *preString = [[NSString stringWithFormat:@"%@",[oPanel URL]] substringToIndex:7];
        if ([preString isEqualToString:@"file://"]) {
            newPath = [[NSString stringWithFormat:@"%@",[oPanel URL]] substringFromIndex:7];
        } else {
            newPath = [NSString stringWithFormat:@"%@",[oPanel URL]];
        }
        
        [_txfSpamCodePath setStringValue:newPath];
        
        [FileMixedHelper sharedHelper].spamCodePath = newPath;
    }
}

- (void)onSetModifySavePath {
    NSOpenPanel *oPanel = [NSOpenPanel openPanel];
    [oPanel setCanChooseDirectories:YES]; //可以打开目录
    [oPanel setCanChooseFiles:YES]; //不能打开文件(我需要处理一个目录内的所有文件)
    [oPanel setCanCreateDirectories:YES];
    NSInteger finded = [oPanel runModal]; //获取panel的响应
    
    if (finded == NSModalResponseOK) {
        NSString *newPath;
        
        NSString *preString = [[NSString stringWithFormat:@"%@",[oPanel URL]] substringToIndex:7];
        if ([preString isEqualToString:@"file://"]) {
            newPath = [[NSString stringWithFormat:@"%@",[oPanel URL]] substringFromIndex:7];
        } else {
            newPath = [NSString stringWithFormat:@"%@",[oPanel URL]];
        }
        
        [_txfNewCodeFilePath setStringValue:newPath];
        [FileMixedHelper sharedHelper].modifyFileSavePath = newPath;
    }
}

- (void)onRunAction {
    
    NSLog(@"=========================");
    [[FileMixedHelper sharedHelper] getAllCategoryFileClassNameWithSourceCodeDir:[FileMixedHelper sharedHelper].sourceCodePath];
    NSLog(@"输出所有category 文件：%@",[FileMixedHelper sharedHelper].categoryFileSet);
    NSLog(@"=========================");
    
    FileManager *fileManager = [[FileManager alloc] init];
    
//    [fileManager deleteUselessCode];
//    [fileManager randomClassName];
    [fileManager addSpamCodeWithOutPath:_txfSpamCodePath.stringValue];
}

- (void)setRepresentedObject:(id)representedObject {
    [super setRepresentedObject:representedObject];

    // Update the view, if already loaded.
}


@end
