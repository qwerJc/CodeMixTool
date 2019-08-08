//
//  ViewController.m
//  CodeMixTool
//
//  Created by 贾辰 on 2019/3/26.
//  Copyright © 2019年 JJC. All rights reserved.
//
#import "ViewController.h"
#import "FileMixedHelper.h"
#import "TableViewCell.h"
#import "FunctionModel.h"
#import "FileManager.h"
#import "ModelLocator.h"
#import "JJCNavigationController.h"

@interface ViewController()<JJCNavigationControllerDelegate>
//@property (strong, nonatomic) NSMutableArray *dataSource;

@property (strong, nonatomic) NSTableView *tableView;
@property (strong, nonatomic) NSMutableArray<FunctionModel *> *arrData;

@property (strong, nonatomic) NSTextField *txfProjPath;
@property (strong, nonatomic) NSTextField *txfCodePath;
@property (strong, nonatomic) NSTextField *txfSonPath;
@property (strong, nonatomic) NSTextField *txfSpamCodePath;
@property (strong, nonatomic) NSTextField *txfNewCodeFilePath;

@property (strong, nonatomic) NSTextField *txfIgnoreWord;

@property (strong, nonatomic) FileManager *fileManager;

@property (assign, nonatomic) EnumTaskType task;                    // 任务数组

/**************************************************************/
@property (strong, nonatomic) JJCNavigationController *navigation;
@property (strong, nonatomic) NSView *viewMix;
@property (strong, nonatomic) NSView *viewDel;
@property (strong, nonatomic) NSView *viewIntegrate;
@property (strong, nonatomic) NSView *viewSpamCode;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    // Do any additional setup after loading the view.

//    [self createUI];
    [self createUI1];
    
    [self createData];
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
    
    model.projPath = @"/Users/jiachen/xiuchang_iPhone/greenhouse-iPhone.xcodeproj";
    [_txfProjPath setStringValue:@"/Users/jiachen/xiuchang_iPhone/greenhouse-iPhone.xcodeproj"];
    model.sourceCodePath = @"/Users/jiachen/xiuchang_iPhone/greenhouse-iPhone";
    [_txfCodePath setStringValue:@"/Users/jiachen/xiuchang_iPhone/greenhouse-iPhone"];
    
    
    // home
//    model.projPath = @"/Users/jiachen/Desktop/xiuchang_iPhone/v6cn-iPhone.xcodeproj";
//    model.sourceCodePath = @"/Users/jiachen/Desktop/xiuchang_iPhone/v6cn-iPhone";
    
    // demo
//    [FileMixedHelper sharedHelper].projPath = @"/Users/jiachen/demo/demo.xcodeproj";
//    [_txfProjPath setStringValue:@"/Users/jiachen/demo/demo.xcodeproj"];
//    [FileMixedHelper sharedHelper].sourceCodePath = @"/Users/jiachen/demo/demo";
//    [_txfCodePath setStringValue:@"/Users/jiachen/demo/demo"];
}

- (void)createUI1 {
    CGFloat btnProjPathMarginY = kWindowHeight - 16 - 34;
    NSButton *btnProjPath = [[NSButton alloc] initWithFrame:CGRectMake(20, btnProjPathMarginY, 200, 34)];
    btnProjPath.title = @"选择.xcodeproj文件";
    [btnProjPath setAction:@selector(onOpenXcodeproj)];
    [self.view addSubview:btnProjPath];
    
    CGFloat btnLibraryProjPathMarginY = btnProjPathMarginY - 10 - 34;
    NSButton *btnLibraryProjPath = [[NSButton alloc] initWithFrame:CGRectMake(60, btnLibraryProjPathMarginY, 200, 34)];
    btnLibraryProjPath.title = @"选择 库里.xcodeproj文件";
    [btnLibraryProjPath setAction:@selector(onOpenLibraryXcodeproj)];
    [self.view addSubview:btnLibraryProjPath];
    
    
    [self.navigation addItemWithTitle:@"混淆" andBackgroundImg:nil andTag:0];
    [self.navigation addItemWithTitle:@"删除" andBackgroundImg:nil andTag:1];
    [self.navigation addItemWithTitle:@"整合" andBackgroundImg:nil andTag:2];
    [self.navigation addItemWithTitle:@"垃圾代码" andBackgroundImg:nil andTag:3];
    
    [self onClickItem:0];
    
}

//- (void)createUI {
//
//    CGFloat viewWidth = CGRectGetWidth(self.view.bounds);
//    CGFloat viewHeight = CGRectGetHeight(self.view.bounds);
//
//    NSButton *btnProjPath = [[NSButton alloc] initWithFrame:CGRectMake(20, MarginTop(50,34), 200, 34)];
//    btnProjPath.title = @"选择.xcodeproj文件";
//    [btnProjPath setAction:@selector(onOpenXcodeproj)];
//    [self.view addSubview:btnProjPath];
//
//    _txfProjPath = [[NSTextField alloc] initWithFrame:CGRectMake(CGRectGetMaxX(btnProjPath.frame) +20,CGRectGetMinY(btnProjPath.frame)-10,viewWidth - CGRectGetWidth(btnProjPath.frame) - 40, 40)];
//    [_txfProjPath setStringValue:@"/Users/jiachen/xiuchang_iPhone/greenhouse-iPhone.xcodeproj"];
//    //    _txfProjPath.alignment = NSTextAlignmentCenter;
//    [_txfProjPath setBezeled:NO];
//    [_txfProjPath setDrawsBackground:NO];
//    [_txfProjPath setEditable:NO];
//    [_txfProjPath setSelectable:NO];
//    [self.view addSubview:_txfProjPath];
//
//    NSButton *btnLibraryProjPath = [[NSButton alloc] initWithFrame:CGRectMake(60, MarginTop(100,35), 200, 34)];
//    btnLibraryProjPath.title = @"选择 库里.xcodeproj文件";
//    [btnLibraryProjPath setAction:@selector(onOpenLibraryXcodeproj)];
//    [self.view addSubview:btnLibraryProjPath];
//
//    NSButton *btnCodePath = [[NSButton alloc] initWithFrame:CGRectMake(20, MarginTop(150,34), 200, 34)];
//    btnCodePath.title = @"选择代码文件夹";
//    [btnCodePath setAction:@selector(onOpenCodePath)];
//    [self.view addSubview:btnCodePath];
//
//    _txfCodePath = [[NSTextField alloc] initWithFrame:CGRectMake(CGRectGetMaxX(btnCodePath.frame) +20,CGRectGetMinY(btnCodePath.frame)-10,viewWidth - CGRectGetWidth(btnCodePath.frame) - 40, 40)];
//    [_txfCodePath setStringValue:@"/Users/jiachen/xiuchang_iPhone/greenhouse-iPhone"];
//    [_txfCodePath setBezeled:NO];
//    [_txfCodePath setDrawsBackground:NO];
//    [_txfCodePath setEditable:NO];
//    [_txfCodePath setSelectable:NO];
//    [self.view addSubview:_txfCodePath];
//
//    NSButton *btnChoseSonPath = [[NSButton alloc] initWithFrame:CGRectMake(20, MarginTop(200,34), 200, 34)];
//    btnChoseSonPath.title = @"选择需要执行的子文件夹";
//    [btnChoseSonPath setAction:@selector(onOpenSonPath)];
//    [self.view addSubview:btnChoseSonPath];
//
//    _txfSonPath = [[NSTextField alloc] initWithFrame:CGRectMake(CGRectGetMaxX(btnCodePath.frame) +20,CGRectGetMinY(btnChoseSonPath.frame)-10,viewWidth - CGRectGetWidth(btnCodePath.frame) - 40, 40)];
//    [_txfSonPath setStringValue:@"选择子文件夹的绝对路径"];
//    [_txfSonPath setBezeled:NO];
//    [_txfSonPath setDrawsBackground:NO];
//    [_txfSonPath setEditable:NO];
//    [_txfSonPath setSelectable:NO];
//    [self.view addSubview:_txfSonPath];
//
//    NSButton *btnSpamCodeFilePath = [[NSButton alloc] initWithFrame:CGRectMake(20, MarginTop(250,34), 200, 34)];
//    btnSpamCodeFilePath.title = @"选择垃圾代码存放路径";
//    [btnSpamCodeFilePath setAction:@selector(onOpenSpamCodeFilePath)];
//    [self.view addSubview:btnSpamCodeFilePath];
//
//    _txfSpamCodePath = [[NSTextField alloc] initWithFrame:CGRectMake(CGRectGetMaxX(btnSpamCodeFilePath.frame) +20,CGRectGetMinY(btnSpamCodeFilePath.frame)-10,viewWidth - CGRectGetWidth(btnSpamCodeFilePath.frame) - 40, 40)];
//    [_txfSpamCodePath setStringValue:@""];
//    [_txfSpamCodePath setBezeled:NO];
//    [_txfSpamCodePath setDrawsBackground:NO];
//    [_txfSpamCodePath setEditable:NO];
//    [_txfSpamCodePath setSelectable:NO];
//    [self.view addSubview:_txfSpamCodePath];
//
//    NSButton *btnNewCodeFilePath = [[NSButton alloc] initWithFrame:CGRectMake(20, MarginTop(300,34), 200, 34)];
//    btnNewCodeFilePath.title = @"选择整合后的代码存放路径";
//    [btnNewCodeFilePath setAction:@selector(onSetModifySavePath)];
//    [self.view addSubview:btnNewCodeFilePath];
//
//    _txfNewCodeFilePath = [[NSTextField alloc] initWithFrame:CGRectMake(CGRectGetMaxX(btnNewCodeFilePath.frame) +20,CGRectGetMinY(btnNewCodeFilePath.frame)-10,viewWidth - CGRectGetWidth(btnNewCodeFilePath.frame) - 40, 40)];
//    [_txfNewCodeFilePath setStringValue:@""];
//    [_txfNewCodeFilePath setBezeled:NO];
//    [_txfNewCodeFilePath setDrawsBackground:NO];
//    [_txfNewCodeFilePath setEditable:NO];
//    [_txfNewCodeFilePath setSelectable:NO];
//    [self.view addSubview:_txfNewCodeFilePath];
//
//    _txfIgnoreWord = [[NSTextField alloc] initWithFrame:CGRectMake(20, 200, NSWidth(self.view.frame)-40, 100)];
//    [_txfIgnoreWord setStringValue:@"IMChatListMessageData,IMChatDetailMessageData,KLSwitch"];
//    [_txfIgnoreWord setBezeled:NO];
//    [self.view addSubview:_txfIgnoreWord];
//
//    NSButton *btnRunMix = [NSButton buttonWithTitle:@"类名混淆" target:self action:@selector(onMixAction)];
//    btnRunMix.frame = CGRectMake(50, 50, 150, 60);
//    [self.view addSubview:btnRunMix];
//
//    NSButton *btnRunDel = [NSButton buttonWithTitle:@"删除" target:self action:@selector(onDelAction)];
//    btnRunDel.frame = CGRectMake(220, 50, 150, 60);
//    [self.view addSubview:btnRunDel];
//
//    NSButton *btnRunModify = [NSButton buttonWithTitle:@"整合" target:self action:@selector(onModifyAction)];
//    btnRunModify.frame = CGRectMake(400, 50, 150, 60);
//    [self.view addSubview:btnRunModify];
//}

#pragma mark - JJCNavigationController Delegate
- (void)onClickItem:(NSUInteger)tag {
    switch (tag) {
        case 0:
            [self.viewMix setHidden:NO];
            [_viewDel setHidden:YES];
            [_viewIntegrate setHidden:YES];
            [_viewSpamCode setHidden:YES];
            break;
        case 1:
            [self.viewDel setHidden:NO];
            [_viewMix setHidden:YES];
            [_viewIntegrate setHidden:YES];
            [_viewSpamCode setHidden:YES];
            break;
        case 2:
            [self.viewIntegrate setHidden:NO];
            [_viewDel setHidden:YES];
            [_viewMix setHidden:YES];
            [_viewSpamCode setHidden:YES];
            break;
        case 3:
            [self.viewSpamCode setHidden:NO];
            [_viewDel setHidden:YES];
            [_viewIntegrate setHidden:YES];
            [_viewMix setHidden:YES];
            break;
        default:
            break;
    }
}

#pragma mark - LazyLoad
- (JJCNavigationController *)navigation {
    if (!_navigation) {
        CGFloat navigationlHeight = NSHeight(self.view.frame) - 250;
        CGFloat nacigationMarginY = kWindowHeight - 110 - navigationlHeight;
        _navigation = [[JJCNavigationController alloc] initWithFrame:NSMakeRect(kNavigationMarginLeft,nacigationMarginY, kNavigationWidth, navigationlHeight)];
        _navigation.delegate = self;
        [self.view addSubview:_navigation];
    }
    return _navigation;
}

- (NSView *)viewMix {
    if (!_viewMix) {
        _viewMix = [[NSView alloc] initWithFrame:NSMakeRect(NSMaxX(self.navigation.frame), NSMinY(self.navigation.frame), kWindowWidth - kNavigationMarginLeft*2 - kNavigationWidth, NSHeight(self.navigation.frame))];
        _viewMix.hidden = YES;
        [_viewMix setWantsLayer:YES];
        _viewMix.layer.backgroundColor = [NSColor redColor].CGColor;
        [self.view addSubview:_viewMix];
    }
    return _viewMix;
}

- (NSView *)viewDel {
    if (!_viewDel) {
        _viewDel = [[NSView alloc] initWithFrame:NSMakeRect(NSMaxX(self.navigation.frame), NSMinY(self.navigation.frame), kWindowWidth - kNavigationMarginLeft*2 - kNavigationWidth, NSHeight(self.navigation.frame))];
        _viewDel.hidden = YES;
        [_viewDel setWantsLayer:YES];
        _viewDel.layer.backgroundColor = [NSColor greenColor].CGColor;
        [self.view addSubview:_viewDel];
    }
    return _viewDel;
}

- (NSView *)viewIntegrate {
    if (!_viewIntegrate) {
        _viewIntegrate = [[NSView alloc] initWithFrame:NSMakeRect(NSMaxX(self.navigation.frame), NSMinY(self.navigation.frame), kWindowWidth - kNavigationMarginLeft*2 - kNavigationWidth, NSHeight(self.navigation.frame))];
        _viewIntegrate.hidden = YES;
        [_viewIntegrate setWantsLayer:YES];
        _viewIntegrate.layer.backgroundColor = [NSColor orangeColor].CGColor;
        [self.view addSubview:_viewIntegrate];
    }
    return _viewIntegrate;
}

- (NSView *)viewSpamCode {
    if (!_viewSpamCode) {
        _viewSpamCode = [[NSView alloc] initWithFrame:NSMakeRect(NSMaxX(self.navigation.frame), NSMinY(self.navigation.frame), kWindowWidth - kNavigationMarginLeft*2 - kNavigationWidth, NSHeight(self.navigation.frame))];
        _viewSpamCode.hidden = YES;
        [_viewSpamCode setWantsLayer:YES];
        _viewSpamCode.layer.backgroundColor = [NSColor blueColor].CGColor;
        [self.view addSubview:_viewSpamCode];
    }
    return _viewSpamCode;
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
        
        model.projPath = newPath;
    }
}

- (void)onOpenLibraryXcodeproj {
    NSOpenPanel *oPanel = [NSOpenPanel openPanel];
    [oPanel setCanChooseDirectories:YES]; //可以打开目录
    [oPanel setCanChooseFiles:YES]; //不能打开文件(我需要处理一个目录内的所有文件)
    [oPanel setAllowsMultipleSelection:YES];//是否允许多选file
    NSInteger finded = [oPanel runModal]; //获取panel的响应
    
    NSMutableArray *arrXcodeprojPath = [NSMutableArray arrayWithCapacity:0];
    
    if (finded == NSModalResponseOK) {
        NSString *newPath;
        
        for (NSURL *pathURL in [oPanel URLs]) {
            
            NSString *path = [NSString stringWithFormat:@"%@",pathURL];
            if ([path hasPrefix:@"file://"]) {
                [arrXcodeprojPath addObject:[path substringFromIndex:7]];
            } else {
                [arrXcodeprojPath addObject:path];
            }
            
            NSLog(@"选择 库里 XcodeProj路径：%@",newPath);
            [_txfProjPath setStringValue:newPath];
        }
        
        model.arrLibraryProjPath = [arrXcodeprojPath copy];
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
        
        model.sourceCodePath = newPath;
    }
}

- (void)onOpenSonPath {
    NSMutableArray *arrSonPath = [NSMutableArray arrayWithCapacity:0];
    
    NSOpenPanel *oPanel = [NSOpenPanel openPanel];
    [oPanel setCanChooseDirectories:YES]; //可以打开目录
    [oPanel setCanChooseFiles:NO]; //不能打开文件(我需要处理一个目录内的所有文件)
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
        
        model.arrSonPath = [arrSonPath copy];
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
        
        model.spamCodePath = newPath;
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
        model.modifyFileSavePath = newPath;
    }
}

- (void)onRunAction {
    
    
    
    
//
    
//    [fileManager addSpamCodeWithOutPath:_txfSpamCodePath.stringValue];
}

- (void)onMixAction {
    [model setup];
    
    // 读取忽略的类名
    NSArray *arrIgnoreClassName = [_txfIgnoreWord.stringValue componentsSeparatedByString:@","];
    NSMutableSet *mset = [NSMutableSet setWithArray:arrIgnoreClassName];
    model.ignoreClassNamesSet = [mset copy];
    
    FileManager *fileManager = [[FileManager alloc] init];
    [fileManager randomClassName];
}

- (void)onDelAction {
    [model setup];
    
    // 读取忽略的类名
    NSArray *arrIgnoreClassName = [_txfIgnoreWord.stringValue componentsSeparatedByString:@","];
    NSMutableSet *mset = [NSMutableSet setWithArray:arrIgnoreClassName];
    model.ignoreClassNamesSet = [mset copy];
    
    FileManager *fileManager = [[FileManager alloc] init];
    [fileManager deleteUselessCode];
}

- (void)onModifyAction {
    [model setup];
    
    // 读取忽略的类名
    NSArray *arrIgnoreClassName = [_txfIgnoreWord.stringValue componentsSeparatedByString:@","];
    NSMutableSet *mset = [NSMutableSet setWithArray:arrIgnoreClassName];
    model.ignoreClassNamesSet = [mset copy];
    
    FileManager *fileManager = [[FileManager alloc] init];
    [fileManager modifyCodeFile];
}

- (void)onAddSpamCodeAction {
    [model setup];
    // 读取忽略的类名
    NSArray *arrIgnoreClassName = [_txfIgnoreWord.stringValue componentsSeparatedByString:@","];
    NSMutableSet *mset = [NSMutableSet setWithArray:arrIgnoreClassName];
    model.ignoreClassNamesSet = [mset copy];
    
    FileManager *fileManager = [[FileManager alloc] init];
    [fileManager addSpamCodeWithOutPath:_txfSpamCodePath.stringValue];
}
- (void)setRepresentedObject:(id)representedObject {
    [super setRepresentedObject:representedObject];

    // Update the view, if already loaded.
}


@end
