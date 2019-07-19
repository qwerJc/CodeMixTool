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

@interface ViewController()<NSTableViewDelegate,NSTableViewDataSource>
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

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    // Do any additional setup after loading the view.

    [self createUI];
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
    
//    [FileMixedHelper sharedHelper].projPath = @"/Users/jiachen/xiuchang_iPhone/greenhouse-iPhone.xcodeproj";
//    [FileMixedHelper sharedHelper].sourceCodePath = @"/Users/jiachen/xiuchang_iPhone/greenhouse-iPhone";
    
    // demo
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
    [_txfProjPath setStringValue:@"/Users/jiachen/xiuchang_iPhone/greenhouse-iPhone.xcodeproj"];
    //    _txfProjPath.alignment = NSTextAlignmentCenter;
    [_txfProjPath setBezeled:NO];
    [_txfProjPath setDrawsBackground:NO];
    [_txfProjPath setEditable:NO];
    [_txfProjPath setSelectable:NO];
    [self.view addSubview:_txfProjPath];
    
    NSButton *btnLibraryProjPath = [[NSButton alloc] initWithFrame:CGRectMake(60, MarginTop(100), 200, 34)];
    btnLibraryProjPath.title = @"选择 库里.xcodeproj文件";
    [btnLibraryProjPath setAction:@selector(onOpenLibraryXcodeproj)];
    [self.view addSubview:btnLibraryProjPath];
    
    NSButton *btnCodePath = [[NSButton alloc] initWithFrame:CGRectMake(20, MarginTop(150), 200, 34)];
    btnCodePath.title = @"选择代码文件夹";
    [btnCodePath setAction:@selector(onOpenCodePath)];
    [self.view addSubview:btnCodePath];
    
    _txfCodePath = [[NSTextField alloc] initWithFrame:CGRectMake(CGRectGetMaxX(btnCodePath.frame) +20,CGRectGetMinY(btnCodePath.frame)-10,viewWidth - CGRectGetWidth(btnCodePath.frame) - 40, 40)];
    [_txfCodePath setStringValue:@"/Users/jiachen/xiuchang_iPhone/greenhouse-iPhone"];
    [_txfCodePath setBezeled:NO];
    [_txfCodePath setDrawsBackground:NO];
    [_txfCodePath setEditable:NO];
    [_txfCodePath setSelectable:NO];
    [self.view addSubview:_txfCodePath];
    
    NSButton *btnChoseSonPath = [[NSButton alloc] initWithFrame:CGRectMake(20, MarginTop(200), 200, 34)];
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
    
    NSButton *btnSpamCodeFilePath = [[NSButton alloc] initWithFrame:CGRectMake(20, MarginTop(250), 200, 34)];
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
    
    NSButton *btnNewCodeFilePath = [[NSButton alloc] initWithFrame:CGRectMake(20, MarginTop(300), 200, 34)];
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
    
    _txfIgnoreWord = [[NSTextField alloc] initWithFrame:CGRectMake(20, 200, NSWidth(self.view.frame)-40, 100)];
    [_txfIgnoreWord setStringValue:@"IMChatListMessageData,IMChatDetailMessageData,KLSwitch"];
    [_txfIgnoreWord setBezeled:NO];
    [self.view addSubview:_txfIgnoreWord];
    
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
        
        [FileMixedHelper sharedHelper].arrLibraryProjPath = [arrXcodeprojPath copy];
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
    [self temp];
    
    // 读取忽略的类名
    NSArray *arrIgnoreClassName = [_txfIgnoreWord.stringValue componentsSeparatedByString:@","];
    NSMutableSet *mset = [NSMutableSet setWithArray:arrIgnoreClassName];
    [FileMixedHelper sharedHelper].ignoreClassNamesSet = [mset copy];
    
    NSLog(@"=========================");
    [[FileMixedHelper sharedHelper] getAllCategoryFileClassNameWithSourceCodeDir:[FileMixedHelper sharedHelper].sourceCodePath];
    NSLog(@"输出所有category 文件：%@",[FileMixedHelper sharedHelper].categoryFileSet);
    NSLog(@"=========================");

    FileManager *fileManager = [[FileManager alloc] init];

//    [fileManager deleteUselessCode];
    [fileManager randomClassName];
//    [fileManager addSpamCodeWithOutPath:_txfSpamCodePath.stringValue];
}

- (void)temp {
    NSString *nWord = @"ability,absence,abstract,abuse,academy,accent,acceptance,access,accident,accommodation,accord,accordance,account,accountant,accuracy,ache,achievement,acid,acquaintance,acquisition,acre,action,activity,addition,administration,admission,adult,advantage,adventure,advertisement,advocate,aeroplane,affection,agency,agenda,agent,agriculture,aid,aircraft,airline,airplane,airport,alarm,alcohol,belief,benefit,bet,Bible,billion,biology,blade,blanket,blast,bloom,board,boast,bolt,bond,boom,boot,border,bore,boring,bound,boundary,brake,brand,brass,breadth,breast,breeze,brick,bride,brief,broom,brow,bubble,bucket,budget,bulb,bulk,bullet,bump,bunch,bundle,burden,bureau,butcher,butterfly,cabbage,cabin,cabinet,cable,calculator,calendar,camel,campaign,campus,canal,cancer,candidate,candy,capacity,confusion,congratulation,congress,conjunction,connection,connexion,conquest,conscience,consequence,conservation,consideration,constant,constitution,construction,consultant,consumer,consumption,contact,container,contemporary,contest,contract,contradiction,contribution,controversy,convenience,convention,convert,conviction,coordinate,cop,copper,copyright,cord,core,corporation,correspondence,correspondent,corridor,council,counsel,counter,county,court,courtyard,crack,craft,crane,crash,dot,draft,dragon,drain,drama,draught,drawer,drift,drill,drip,drum,duration,dusk,dye,eagle,earthquake,ease,echo,economy,edition,editor,editorial,efficiency,effort,elbow,election,electricity,electron,element,elevator,embassy,emergency,emotion,emperor,emphasis,empire,employee,employer,employment,ending,formula,fortnight,foundation,fountain,fraction,fragment,frame,framework,freight,frequency,frog,frontier,frost,fry,fuel,function,fund,funeral,fur,furnace,furniture,fuss,gallery,gallon,gang,gaol,gap,garbage,gardener,garlic,gasoline,gear,gene,generator,genius,geometry,germ,gesture,ghost,giant,glimpse,globe,glory,glove,glue,golf,goodness,governor,grace,graduate,grain,gram,grammar,gramme,input,inquiry,insect,insight,installation,instance,instinct,institute,institution,instruction,instrument,insult,insurance,intelligence,intensity,intention,interaction,interest,interference,interpretation,interval,introduction,invasion,invention,investment,invitation,issue,item,jail,jar,jaw,jazz,jeans,jet,jewel,joint,journal,journalist,journey,judgement,jungle,junior,jury,justice,minor,minority,miracle,missile,mission,mist,mixture,moisture,mold,molecule,monitor,monument,mood,mosquito,motion,motive,motor,mould,mount,mud,mug,murder,muscle,museum,mushroom,musician,mystery,myth,nationality,nature,navigation,navy,necessity,negative,Negro,neighbourhood,nephew,nerve,nest,network,neutral,niece,nightmare,nitrogen,nonsense,normal,notebook,notion,nuisance,poetry,poison,pole,policy,polish,politician,politics,poll,pollution,pond,porter,portion,portrait,pose,possession,possibility,postage,poverty,powder,prayer,precaution,precision,preface,preference,prejudice,preparation,preposition,presence,presentation,pressure,priest,prime,principal,principle,priority,privilege,procedure,process,procession,product,profession,professional,profile,profit,progressive,project,response,responsibility,restraint,result,resume,revenue,reverse,reward,rhythm,rib,ribbon,ridge,rifle,riot,rival,roar,rocket,rod,roller,rope,route,routine,rug,rumour,rust,sack,sacrifice,saddle,sailor,saint,sake,salad,salary,salesman,sample,sanction,satellite,sauce,saucer,sausage,saving,scale,scandal,scenery,schedule,scheme,scholar,stir,stock,stocking,stoop,storage,stove,strain,strap,strategy,straw,stream,stress,string,stripe,stroke,structure,studio,stuff,subject,substance,substitute,suburb,subway,succession,suggestion,suicide,sum,summary,summit,sunlight,sunrise,sunset,sunshine,superior,supplement,supply,surgery,surplus,surrounding,survey,survival,suspect,suspicion,swallow,swift,switch,sword,symbol,sympathy,symptom,veteran,vice,victim,video,viewpoint,vinegar,violence,violet,violin,virtue,virus,vision,vitamin,vocabulary,volcano,volt,voltage,volume,volunteer,vote,wagon,waist,warmth,wax,wealth,weapon,weave,weed,weep,welfare,whale,whip,whisper,whistle,widow,width,wisdom,wit,witness,wolf,wool,workman,workshop,worm,worship,worthy,wrap,wreck,wardrobe,warfare,alliance,allowance,alphabet,alternative,altitude,aluminium,amateur,ambassador,ambition,ambulance,analysis,ancestor,anchor,angle,ankle,anniversary,annual,antique,anxiety,apartment,apology,appeal,appearance,appetite,applause,appliance,applicant,application,appointment,approach,approval,architect,architecture,argument,arithmetic,arrangement,arrival,arrow,ash,aspect,assembly,asset,capture,carbon,career,cargo,carpenter,carpet,carriage,carrier,carrot,cart,cartoon,cash,cashier,cassette,cast,catalog,catalogue,category,cattle,cement,center,centimetre,ceremony,certificate,challenge,chamber,champion,channel,chaos,chap,chapter,character,charge,charity,charm,chart,chase,cheat,chemist,chest,chief,childhood,chill,chin,chip,chop,Christ,Christian,cigar,cigarette,circuit,circumstance,civilian,civilization,claim,clap,clash,classic,classification,clause,claw,clay,creature,credit,crew,crime,criminal,crisis,critic,criticism,crowd,crown,crust,cube,cue,culture,cupboard,curiosity,currency,curriculum,curse,curtain,curve,cushion,cycle,dairy,dam,damp,dash,data,daylight,deadline,debt,decade,deck,declaration,decrease,defeat,defect,definition,delegate,delivery,demand,democracy,density,departure,engine,engineering,enquiry,entertainment,enthusiasm,entry,environment,envy,episode,equality,equation,era,error,establishment,estate,eve,event,evidence,evolution,exception,excess,excitement,excursion,existence,expansion,expectation,expense,expert,explosion,exposure,expression,extension,extent,grape,graph,gratitude,grave,gravity,greenhouse,grocer,growth,guarantee,guidance,guideline,guitar,gulf,gum,guy,gymnasium,halt,hammer,handbag,handful,handle,handwriting,harbour,hardship,hardware,harmony,harness,haste,hatred,hay,hazard,heading,headline,headquarters,heap,hearing,hedge,heel,helicopter,hell,hen,herd,highlight,highway,hint,hip,hire,hobby,hollow,honey,hook,horizon,kettle,keyboard,kid,kindergarten,kindness,kingdom,knot,label,laboratory,lad,lag,lamb,landlord,landscape,lane,lap,laser,laughter,launch,laundry,lavatory,lawn,layer,layout,leader,leadership,leak,lean,learning,lease,leather,legislation,leisure,lemon,lens,liberal,liberty,librarian,license,lick,lid,lightning,limb,limitation,link,liquid,liquor,liter,literature,liver,livingRoom,loaf,loan,lobby,location,lodge,log,logic,loop,loose,lord,lorry,lover,nursery,nylon,object,objection,objective,obligation,observation,observer,obstacle,occasion,occupation,occurrence,offense,official,onion,opening,opera,operator,opportunity,option,orbit,orchestra,ore,organ,organize,organization,origin,ounce,outcome,outlet,outline,outlook,output,outset,outside,oven,overnight,owner,ownership,oxygen,pace,pack,package,packet,pad,prompt,pronoun,proof,property,proportion,proposal,prospect,prosperity,protection,protein,protest,province,provision,publication,publicity,pulse,pump,punch,purse,puzzle,qualification,queue,quiz,quotation,rack,radar,radiation,rag,rage,raid,rail,railroad,railway,rainbow,range,rank,rat,rate,ratio,raw,reaction,reality,realm,rear,rebel,receipt,receiver,reception,recession,recognition,scholarship,scissors,scope,score,scout,scrape,scratch,screen,screw,script,seal,section,sector,security,segment,selection,semester,semiconductor,seminar,senate,senator,sequence,series,session,setting,settle,settlement,shell,shelter,shield,shift,shortage,shortcoming,shrug,sigh,sightseeing,signal,signature,significance,simplicity,sin,singular,site,sketch,sleeve,slice,system,tackle,tag,talent,target,tax,technician,technique,technology,teenager,telescope,temper,temple,temptation,tendency,tension,terminal,territory,terror,textile,theme,theory,therapy,thermometer,thinking,threat,throat,thrust,thumb,thunder,tide,tidy,timber,tissue,title,toast,tolerance,tone,topic,torch,torture,tough,tour,towel,trace,tractor,tradition,tragedy,trail,transfer,translation,transmission,transport,transportation,trap,trash,tray,treatment,treaty,tremble,wrist,writer,writing,youngster,zone,abundance,aisle,appraisal,auction,aviation,bachelor,ballet,breakthrough,briefcase,calorie,casualty,census,commonplace,continuity,costume,courtesy,coverage,creation,defiance,deficiency,dock,endurance,erosion,expedition,fake,flaw,heir,heritage,humanity,hurricane,identification,illusion,imitation,imperative,assignment,assistance,assistant,association,assumption,athlete,atmosphere,attack,attempt,attitude,attorney,attraction,attribute,audience,author,auto,automatic,automobile,avenue,average,award,ax,background,bacon,bacteria,baggage,balance,balcony,balloon,ban,band,bang,bankrupt,banner,barber,bargain,bark,barn,barrel,barrier,baseball,basis,bat,battery,bay,beam,bean,beard,bearing,beast,beggar,behalf,behavior,being,clerk,client,cliff,climate,clue,coach,collapse,colleague,collection,collision,colony,column,comb,combat,combination,comedy,command,commander,comment,commerce,commission,commitment,committee,communication,community,companion,comparison,compass,competition,complaint,component,compound,comprehension,compromise,concentration,concept,concession,conclusion,condition,conduct,conductor,conference,confidence,conflict,deposit,depression,deputy,design,despair,dessert,destination,destruction,detail,detection,detective,determination,device,devil,diagram,dialect,diameter,dictation,digest,dimension,dirt,disaster,discipline,discount,disease,disgust,disorder,disposal,distinction,distress,distribution,ditch,division,divorce,document,donation,donkey,dorm,dormitory,dose,eyesight,fabric,facility,factor,faculty,failure,faint,fairy,faith,fame,famine,fantasy,fare,farewell,fashion,fate,fatigue,favour,feather,feature,fee,feedback,female,fertilizer,festival,fibre,fiction,figure,filter,finance,finding,fireman,fisherman,flame,fleet,flesh,float,flock,flood,flour,fluid,focus,fog,fold,folk,following,footstep,force,forecast,forehead,format,formation,horn,horror,horsepower,household,housing,humour,hut,hydrogen,ideal,identity,illustration,image,imagination,impact,implement,implication,import,impression,improvement,incident,incline,independence,independent,index,indication,indispensable,individual,infant,inference,infinite,inflation,influence,ingredient,inhabitant,initiative,injection,injury,inn,loyalty,luggage,lump,lung,luxury,machinery,magic,magnet,maid,mainland,maintenance,major,majority,management,mankind,manner,manual,manufacturer,margin,marine,market,marriage,mask,mass,mat,mate,material,mathematics,maximum,mayor,meaning,means,meantime,measure,measurement,mechanic,mechanism,medal,media,medium,membership,memorial,menu,merchant,mercy,merit,mess,microphone,microscope,mill,millimetre,mineral,minister,ministry,painter,palm,panel,panic,pants,parade,paragraph,parcel,parliament,particle,partner,passion,passport,paste,pat,patch,patience,patient,pattern,paw,payment,pea,peak,peer,penalty,pension,pepper,percentage,perception,performance,permission,personality,personnel,perspective,petrol,petroleum,phase,phenomenon,philosopher,philosophy,physician,physicist,pigeon,pill,pillar,pillow,pilot,pinch,pine,pint,pit,pitch,planet,plantation,plastic,platform,pledge,plot,plunge,poem,poet,recommendation,recorder,recovery,recreation,recruit,reduction,reference,reflection,reflexion,reform,refrigerator,refugee,refusal,region,register,regulation,reject,relationship,relative,relativity,release,relief,religion,remark,remedy,removal,repetition,replacement,reporter,representative,reputation,requirement,reservation,reserve,reservior,residence,resident,resign,resistance,resolution,resolve,resource,respect,slip,slope,socialism,socialist,soda,software,solution,sorrow,source,sow,spacecraft,spade,span,spark,specialist,species,specific,specimen,spelling,sphere,spider,spill,spit,spite,spokesman,sponsor,spot,spray,spur,squeeze,stack,stadium,staff,stain,stake,stale,standpoint,statement,statistic,status,steamer,stem,sting,trend,trial,triangle,triumph,troop,trumpet,trunk,tube,tune,tunnel,turbine,tutor,twist,typewriter,typist,tyre,umbrella,undergraduate,understanding,union,unity,universe,usage,utility,utmost,vacation,vacuum,van,vapour,variable,variation,variety,vehicle,venture,version,vessel,irrigation,likelihood,literacy,locality,lounge,monopoly,nurture,olive,optimum,paperback,pedestrian,pest,plague,prescription,prestige,productivity,pumpkin,purity,pursuit,quest,random,rap,referee,relay,repertoire,reunion,revelation,revenge,scrutiny,silicon,slogan,smuggle,snack,stability,stereo,telecommuications,tile,token,toll,tract,transition,tuition,unemployment,wallet,";
    [FileMixedHelper sharedHelper].arrayNWordLibrary = [nWord componentsSeparatedByString:@","];
    
    NSString *vtWord = @"absorb,accompany,accomplish,accuse,acknowledge,acquire,adapt,adjust,adopt,affect,afford,bid,blend,cancel,confuse,congratulate,conquer,constitute,construct,consume,contrast,convey,convict,convince,dump,educate,elect,eliminate,embarrass,embrace,emit,emphasize,enable,enclose,encourage,enforce,engage,fulfil,fulfill,furnish,generate,insert,inspect,inspire,install,instruct,insure,integrate,intend,interrupt,interview,invade,invent,involve,isolate,mislead,misunderstand,modify,neglect,pollute,possess,postpone,preserve,pretend,prohibit,promote,restore,restrain,restrict,retain,reveal,revise,rid,risk,strip,suffer,support,suppose,surrender,surround,suspend,sustain,violate,weld,withdraw,withstand,allocate,allow,amaze,amuse,analyse,annoy,anticipate,apply,appoint,appreciate,arouse,arrest,assemble,assess,characterize,charter,chew,cite,civilize,classify,create,crush,cultivate,define,delete,demonstrate,enhance,ensure,entertain,entitle,equip,essay,establish,evaluate,exceed,exchange,exclude,execute,exert,exhaust,exhibit,expand,explode,exploit,export,expose,grant,grasp,grip,harden,harm,locate,oblige,observe,obtain,occupy,omit,oppose,organism,overcome,overlook,overtake,owe,propose,prove,provoke,purchase,pursue,quote,recall,reckon,recognize,select,shed,simplify,slap,threaten,tolerate,transform,transmit,accommodate,baffle,conform,console,enrich,foster,induce,assign,associate,assume,assure,astonish,attach,attain,attract,avoid,await,commit,compel,compress,conceal,concede,concern,condemn,confine,confirm,confront,depress,derive,describe,deserve,desire,detect,devise,devote,discard,discharge,discourage,dismiss,display,distribute,disturb,fasten,flee,forbid,identify,ignore,illustrate,imitate,imply,impose,impress,include,indicate,industrialize,infect,inherit,injure,maintain,manufacture,marry,mention,penetrate,perceive,perform,pierce,plug,recommend,recover,refine,regulate,reinforce,relate,relieve,remind,render,renew,replace,represent,require,rescue,resemble,resist,solve,specify,spoil,starve,statue,stimulate,uncover,undergo,underline,undertake,undo,upset,urge,utilize,vary,verify,reconcile,sue,unify,";
    [FileMixedHelper sharedHelper].arrayVtWordLibrary = [vtWord componentsSeparatedByString:@","];
    
    NSString *adjWord = @"absent,absolute,abundant,academic,accidental,accurate,accustomed,active,acute,additional,adequate,advanced,advisable,aggressive,alert,beloved,beneficial,blank,bloody,bold,brave,brilliant,calm,capable,conscious,conservative,considerable,considerate,consistent,continual,continuous,contrary,controversial,conventional,corresponding,costly,doubtful,downward,dramatic,drunk,dull,dumb,durable,dynamic,earnest,economic,economical,effective,efficient,elaborate,elastic,elderly,electric,electrical,electronic,elegant,elementary,emotional,endless,former,frank,frequent,fruitful,fundamental,generous,genuine,given,global,glorious,graceful,gradual,inner,innocent,instant,intellectual,intelligent,intense,intensive,interior,intermediate,internal,intimate,invisible,jealous,keen,minus,miserable,missing,mobile,moderate,modest,moist,moral,multiple,mutual,mysterious,naked,naval,nearby,noticeable,nuclear,poisonous,portable,positive,potential,powerful,preceding,precious,precise,preferable,pregnant,preliminary,previous,primary,primitive,prior,private,probable,prominent,responsible,restless,revolutionary,ridiculous,rigid,ripe,romantic,rotten,royal,rude,rural,satisfactory,scarce,strategic,striking,subsequent,substantial,successive,sufficient,superb,superficial,supreme,sympathetic,vigorous,virtual,visible,visual,vital,vivid,voluntary,waterproof,wealthy,weekly,wellKnown,wicked,widespread,worldwide,worthless,worthwhile,alike,ancient,anxious,apparent,applicable,appropriate,approximate,arbitrary,artificial,artistic,ashamed,casual,cautious,centigrade,characteristic,cheerful,chemical,circular,civil,classical,creative,critical,crucial,crude,crystal,curious,current,deaf,decent,definite,deliberate,delicate,delicious,democratic,dense,dental,enormous,entire,equivalent,erect,essential,evident,evil,exact,excessive,exclusive,executive,experimental,explosive,extensive,exterior,external,extra,extraordinary,grand,grateful,greedy,gross,guilty,handy,harsh,helpful,helpless,heroic,historic,historical,holy,honourable,hopeful,hopeless,latter,leading,learned,legal,liable,likely,limited,literary,local,logical,numerous,obvious,occasional,odd,offensive,operational,opponent,optical,optimistic,optional,oral,orderly,organic,original,outer,outstanding,outward,oval,overall,overhead,owing,proportional,prosperous,protective,psychological,punctual,purple,racial,radical,rare,rational,realistic,reasonable,scientific,secondary,secure,selfish,senior,sensible,sensitive,severe,sexual,shallow,sheer,significant,similar,sincere,single,skilled,skillful,slender,slight,synthetic,systematic,tame,tedious,temporary,tender,tense,thick,thirsty,thorough,thoughtful,transparent,yearly,aerial,ambitious,brutal,cognitive,concise,consequent,cooperative,corporate,cumulative,deadly,decisive,destructive,diligent,disastrous,divine,energetic,enthusiastic,eternal,ethnic,fitting,grim,imaginative,indicative,inland,instrumental,atomic,attractive,audio,auxiliary,available,aware,awful,awkward,bare,clumsy,coarse,collective,commercial,comparable,comparative,competent,competitive,complex,complicated,comprehensive,concrete,confident,dependent,desirable,desperate,digital,dim,diplomatic,distinct,diverse,domestic,dominant,extreme,faithful,fancy,fantastic,fascinating,fashionable,fatal,faulty,favourable,favourite,fearful,feasible,federal,fertile,fierce,financial,flat,flexible,fluent,formal,horizontal,horrible,hostile,humble,humorous,identical,idle,ignorant,illegal,imaginary,immense,immigrant,impatient,impressive,incredible,indifferent,indirect,indoor,industrial,inevitable,inferior,influential,initial,lower,loyal,lucky,magnetic,magnificent,male,married,marvelous,Marxist,massive,mathematical,mature,mechanical,mental,mere,merry,metric,mild,military,minimum,painful,parallel,partial,passive,peculiar,permanent,pessimistic,physical,plentiful,plural,regardless,relevant,reliable,religious,reluctant,remarkable,remote,republican,resistant,respective,slim,slippery,soak,social,solar,sole,solemn,sophisticated,sore,sour,spectacular,spiritual,splendid,stable,static,steady,steep,sticky,stiff,tremendous,trim,tropical,troublesome,typical,ugly,ultimate,underground,uneasy,unexpected,unique,universal,unlike,unusual,upper,upright,uptoDate,urban,urgent,utter,vacant,vague,vain,valid,various,vast,vertical,monetary,morality,muscular,permissible,physiological,premature,prevalent,productive,profitable,profound,prospective,residential,solitary,stern,subjective,subordinate,timely,tolerant,transient,vocal,vulnerable,";
    [FileMixedHelper sharedHelper].arrayAdjWordLibrary = [adjWord componentsSeparatedByString:@","];
    
    NSString *advWord = @"aboard,abroad,according,accordingly,afterward,beneath,besides,consequently,conversely,elsewhere,forth,fortunately,furthermore,generally,instead,inward,moreover,namely,naturally,necessarily,normally,nowhere,practically,presently,presumably,primarily,scarcely,virtually,wholly,alongside,anyhow,anyway,apart,aside,definitely,evidently,exceedingly,hence,highly,largely,likewise,overseas,rarely,readily,recently,shortly,sideways,similarly,thereby,therefore,beforehand,backward,barely,basically,directly,fairly,finally,immediately,increasingly,merely,particularly,repeatedly,respectively,somehow,somewhat,specifically,truly,underneath,undoubtedly,unfortunately,invariably,seemingly,thereafter,";
    [FileMixedHelper sharedHelper].arrayAdvWordLibrary = [advWord componentsSeparatedByString:@","];
}

- (void)setRepresentedObject:(id)representedObject {
    [super setRepresentedObject:representedObject];

    // Update the view, if already loaded.
}


@end
