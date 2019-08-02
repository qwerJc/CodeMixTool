//
//  FileMixedHelper.m
//  CodeMixTool
//
//  Created by 贾辰 on 2019/6/24.
//  Copyright © 2019年 JJC. All rights reserved.
//

#import "FileMixedHelper.h"
#import "ModelLocator.h"

static const NSString *kRandomAlphabet = @"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789";

@interface FileMixedHelper()

@property (strong, nonatomic) NSArray *arrayNWordLibrary;
@property (strong, nonatomic) NSArray *arrayAdvWordLibrary;
@property (strong, nonatomic) NSArray *arrayAdjWordLibrary;
@property (strong, nonatomic) NSArray *arrayVtWordLibrary;

@end

@implementation FileMixedHelper
+(instancetype)sharedHelper {
    static FileMixedHelper *fileMixedHelper;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        fileMixedHelper = [[self alloc] init];
    });
    
    return fileMixedHelper;
}

#pragma mark - 替换
// 正则替换
- (BOOL)regularReplacement:(NSMutableString *)originalString regularExpression:(NSString *)regularExpression newString:(NSString *)newString {
    
    __block BOOL isChanged = NO;
    BOOL isGroupNo1 = [newString isEqualToString:@"\\1"]; // \1 代表与第一个小括号中要匹配的内容相同
    NSRegularExpression *expression = [NSRegularExpression regularExpressionWithPattern:regularExpression options:NSRegularExpressionAnchorsMatchLines|NSRegularExpressionUseUnixLineSeparators error:nil];
    NSArray<NSTextCheckingResult *> *matches = [expression matchesInString:originalString options:0 range:NSMakeRange(0, originalString.length)];
    [matches enumerateObjectsWithOptions:NSEnumerationReverse usingBlock:^(NSTextCheckingResult * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (!isChanged) {
            isChanged = YES;
        }
        if (isGroupNo1) {
            NSString *withString = [originalString substringWithRange:[obj rangeAtIndex:1]];
            [originalString replaceCharactersInRange:obj.range withString:withString];
        } else {
            [originalString replaceCharactersInRange:obj.range withString:newString];
        }
    }];
    return isChanged;
}

// 新旧文件替换
- (void)resaveFileWithOldFilePath:(NSString *)oldPath andNewFilePath:(NSString *)newPath {
    NSError *error;
    [[NSFileManager defaultManager] moveItemAtPath:oldPath toPath:newPath error:&error];
    if (error) {
        printf("修改文件名称失败。\n  oldPath=%s\n  newPath=%s\n  ERROR:%s\n", oldPath.UTF8String, newPath.UTF8String, error.localizedDescription.UTF8String);
    }
}
#pragma mark - Return String
+ (NSString *)randomWordWithIndex:(NSInteger)index {
    // index : 1-4
    
    if (index == 0) {
        // n.
        NSInteger i = arc4random()%[FileMixedHelper sharedHelper].arrayNWordLibrary.count;
        return [FileMixedHelper sharedHelper].arrayNWordLibrary[i];
    
    } else if (index == 1) {
        // adv.(修饰adj,vt)
        NSInteger i = arc4random()%[FileMixedHelper sharedHelper].arrayAdvWordLibrary.count;
        return [FileMixedHelper sharedHelper].arrayAdvWordLibrary[i];
        
    } else if (index == 2) {
        // adj.
        NSInteger i = arc4random()%[FileMixedHelper sharedHelper].arrayAdjWordLibrary.count;
        return [FileMixedHelper sharedHelper].arrayAdjWordLibrary[i];
        
    } else if (index == 3) {
        // vt.
        NSInteger i = arc4random()%[FileMixedHelper sharedHelper].arrayVtWordLibrary.count;
        return [FileMixedHelper sharedHelper].arrayVtWordLibrary[i];
    }
    return @"";
}

+ (NSString *)randomWordPropertyName {
    NSMutableString *mstr = [[NSMutableString alloc] initWithCapacity:0];
    
    NSInteger lengthN = arc4random()%3;
    if (lengthN == 0) {
        [mstr appendString:[[self randomWordWithIndex:2] capitalizedString]];
    }
    [mstr appendString:[[self randomWordWithIndex:0] capitalizedString]];
    [mstr appendString:[[self randomWordWithIndex:0] capitalizedString]];
    
    return [mstr copy];
}

+ (NSString *)randomWordClassName {
    NSMutableString *mstr = [[NSMutableString alloc] initWithCapacity:0];
    
    NSInteger lengthAdj = arc4random()%1+1;
    if (lengthAdj==0) {
        [mstr appendString:[self randomWordWithIndex:2]];
    } else {
        [mstr appendString:[[self randomWordWithIndex:2] capitalizedString]];
    }
    
    
    NSInteger lengthN = arc4random()%2+2;
    for (int i = 0; i<lengthN ; i++) {
        [mstr appendString:[[self randomWordWithIndex:0] capitalizedString]];
    }
    
    [mstr appendString:[[self randomWordWithIndex:1] capitalizedString]];
    [mstr appendString:[[self randomWordWithIndex:2] capitalizedString]];
    [mstr appendString:[[self randomWordWithIndex:0] capitalizedString]];
    return [mstr copy];
}

+ (NSString *)randomWordMethodName {
    NSMutableString *mstr = [[NSMutableString alloc] initWithCapacity:0];
    
    NSInteger lengthADV = arc4random()%1+1;
    if (lengthADV==0) {
        [mstr appendString:[self randomWordWithIndex:1]];
    } else {
        [mstr appendString:[[self randomWordWithIndex:1] capitalizedString]];
    }
    
    NSInteger lengthVT = arc4random()%1+1;
    for (int i = 0; i<lengthVT ; i++) {
        [mstr appendString:[[self randomWordWithIndex:3] capitalizedString]];
    }
    
    [mstr appendString:[[self randomWordWithIndex:0] capitalizedString]];
    [mstr appendString:[[self randomWordWithIndex:0] capitalizedString]];

    return [mstr copy];
}

+ (NSString *)randomString:(NSInteger )length {
    NSMutableString *str = [NSMutableString stringWithCapacity:length];
    [str appendString:[self randomLetter]];
    for (int i = 0; i < length-1; i++) {
        [str appendFormat:@"%C",[kRandomAlphabet characterAtIndex:arc4random_uniform((uint32_t)[kRandomAlphabet length])]];
    }
    return str;
}

+ (NSString *)randomLetter {
    return [NSString stringWithFormat:@"%C", [kRandomAlphabet characterAtIndex:arc4random_uniform(52)]];
}

+ (NSString *)randomCapital {
    return [NSString stringWithFormat:@"%C", [kRandomAlphabet characterAtIndex:arc4random_uniform(26)]];
}

+ (NSString *)randomNum {
    return [NSString stringWithFormat:@"%d",(arc4random_uniform(8)+1)];
}

#pragma mark - 忽略列表
- (BOOL)isNeedChangedFileName:(NSString *)name {
    if ([model.ignoreClassNamesSet containsObject:name]) {
        return NO;
    } else {
        return YES;
    }
}

- (void)getAllCategoryFileClassNameWithSourceCodeDir:(NSString *)sourceCodeDir {
    NSFileManager *fm = [NSFileManager defaultManager];
    
    // 遍历源代码文件 h 与 m 配对，swift
    NSArray<NSString *> *files = [fm contentsOfDirectoryAtPath:sourceCodeDir error:nil];
    BOOL isDirectory;
    
    for (NSString *file in files) { // filePath
        NSString *filePath = [sourceCodeDir stringByAppendingPathComponent:file];
        if ([fm fileExistsAtPath:filePath isDirectory:&isDirectory] && isDirectory) {
//            [self getIgnoreFileWithSourceCodeDir:filePath];
            continue;
        }
        
        NSString *fileName = file.lastPathComponent.stringByDeletingPathExtension; //类名：JJCView
        NSString *fileExtension = file.pathExtension; // h/m 文件
        
        if ([fileExtension isEqualToString:@"h"] || [fileExtension isEqualToString:@"m"]) {
            // 获取文件名带+的
            [self getAllCategoryFileWithFileName:fileName];
        }
    }
}
- (void)getIgnoreFileWithSourceCodeDir:(NSString *)sourceCodeDir {
    NSFileManager *fm = [NSFileManager defaultManager];
    
    // 遍历源代码文件 h 与 m 配对，swift
    NSArray<NSString *> *files = [fm contentsOfDirectoryAtPath:sourceCodeDir error:nil];
    BOOL isDirectory;
    
    for (NSString *file in files) { // filePath
        NSString *filePath = [sourceCodeDir stringByAppendingPathComponent:file];
        if ([fm fileExistsAtPath:filePath isDirectory:&isDirectory] && isDirectory) {
            [self getIgnoreFileWithSourceCodeDir:filePath];
            continue;
        }
        
        NSString *fileName = file.lastPathComponent.stringByDeletingPathExtension; //类名：JJCView
        NSString *fileExtension = file.pathExtension; // h/m 文件
        
//        if ([fileExtension isEqualToString:@"h"] && ![files containsObject:[fileName stringByAppendingPathExtension:@"m"]]) {
//            // 当前为.h且不存在.m
//            // 可能为实现文件在库中，暴露出了.h
//            [_categoryFileSet addObject:fileName];
//            continue;
//        }
        
        if ([fileExtension isEqualToString:@"h"] || [fileExtension isEqualToString:@"m"]) {
            // 获取文件名带+的
            [self getAllCategoryFileWithFileName:fileName];
            
//            // 获取import<>的和@class的
//            NSMutableString *fileContent = [NSMutableString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil];
//            [self getImportFileNameWithFileContent:fileContent];
        }
    }
}
- (void)getAllCategoryFileWithFileName:(NSString *)fileName {
    //处理是category的情况。
    if ([fileName containsString:@"+"]) {
        // 带+（category的方法）
        [model.categoryFileSet addObject:fileName];
        
        // category 所拓展的类名q
        NSUInteger index = [fileName rangeOfString:@"+"].location;
        NSString *className = [fileName substringToIndex:index];
        
        if (![model.categoryFileSet containsObject:className]) {
            [model.categoryFileSet addObject:className];
        }
    }
}

- (void)getImportFileNameWithFileContent:(NSString *)fileContent {
    
    // #import"" 和 #import<>
    NSString *mRegularExpression = [NSString stringWithFormat:@"(?<=[<]).*(?=.h[>])"];
    NSRegularExpression *mExpression = [NSRegularExpression regularExpressionWithPattern:mRegularExpression options:NSRegularExpressionAnchorsMatchLines|NSRegularExpressionUseUnixLineSeparators error:nil];
    NSArray<NSTextCheckingResult *> *mMatches = [mExpression matchesInString:fileContent options:0 range:NSMakeRange(0, fileContent.length)];
    
    if (mMatches.count > 0) {
        for (NSTextCheckingResult *result in mMatches) {
            NSRange range = result.range;
            NSString *className = [fileContent substringWithRange:range];
            if (![model.categoryFileSet containsObject:className]) {
                [model.categoryFileSet addObject:className];
            }
        }
    }
    
    // @class XX,xx,xx;
    NSString *classRegularExpression = [NSString stringWithFormat:@"(?<=@class ).*(?=;)"];
    mExpression = [NSRegularExpression regularExpressionWithPattern:classRegularExpression options:NSRegularExpressionAnchorsMatchLines|NSRegularExpressionUseUnixLineSeparators error:nil];
    mMatches = [mExpression matchesInString:fileContent options:0 range:NSMakeRange(0, fileContent.length)];
    if (mMatches.count > 0) {
        for (NSTextCheckingResult *result in mMatches) {
            NSRange range = result.range;
            // sumClassName 中可能包含
            NSString *sumClassName = [fileContent substringWithRange:range];
            
            if ([sumClassName containsString:@","]) {
                for (NSString *className in [sumClassName componentsSeparatedByString:@","]) {
                    if (![model.categoryFileSet containsObject:className]) {
                        [model.categoryFileSet addObject:className];
                    }
                }
            } else {
                // @class 只包含一个
                if (![model.categoryFileSet containsObject:sumClassName]) {
                    [model.categoryFileSet addObject:sumClassName];
                }
            }
        }
    }
}

#pragma mark - Other
+ (void)showAlert:(NSString *)string andDetailString:(NSString *)detailString {
    NSLog(@"%@ \n %@",string, detailString);
}

+ (BOOL)isFolderEmpryWithPath:(NSString *)path {
    NSFileManager *fm = [NSFileManager defaultManager];
    NSArray<NSString *> *arrFiles = [fm contentsOfDirectoryAtPath:path error:nil];
    
    if ([arrFiles count] == 0) {
        return YES;
    } else {
        return NO;
    }
}
#pragma mark - Lazy Load
- (NSArray *)arrayNWordLibrary {
    if (!_arrayNWordLibrary) {
        NSString *nWord = @"ability,absence,abstract,abuse,academy,accent,acceptance,access,accident,accommodation,accord,accordance,account,accountant,accuracy,ache,achievement,acid,acquaintance,acquisition,acre,action,activity,addition,administration,admission,adult,advantage,adventure,advertisement,advocate,aeroplane,affection,agency,agenda,agent,agriculture,aid,aircraft,airline,airplane,airport,alarm,alcohol,belief,benefit,bet,Bible,billion,biology,blade,blanket,blast,bloom,board,boast,bolt,bond,boom,boot,border,bore,boring,bound,boundary,brake,brand,brass,breadth,breast,breeze,brick,bride,brief,broom,brow,bubble,bucket,budget,bulb,bulk,bullet,bump,bunch,bundle,burden,bureau,butcher,butterfly,cabbage,cabin,cabinet,cable,calculator,calendar,camel,campaign,campus,canal,cancer,candidate,candy,capacity,confusion,congratulation,congress,conjunction,connection,connexion,conquest,conscience,consequence,conservation,consideration,constant,constitution,construction,consultant,consumer,consumption,contact,container,contemporary,contest,contract,contradiction,contribution,controversy,convenience,convention,convert,conviction,coordinate,cop,copper,copyright,cord,core,corporation,correspondence,correspondent,corridor,council,counsel,counter,county,court,courtyard,crack,craft,crane,crash,dot,draft,dragon,drain,drama,draught,drawer,drift,drill,drip,drum,duration,dusk,dye,eagle,earthquake,ease,echo,economy,edition,editor,editorial,efficiency,effort,elbow,election,electricity,electron,element,elevator,embassy,emergency,emotion,emperor,emphasis,empire,employee,employer,employment,ending,formula,fortnight,foundation,fountain,fraction,fragment,frame,framework,freight,frequency,frog,frontier,frost,fry,fuel,function,fund,funeral,fur,furnace,furniture,fuss,gallery,gallon,gang,gaol,gap,garbage,gardener,garlic,gasoline,gear,gene,generator,genius,geometry,germ,gesture,ghost,giant,glimpse,globe,glory,glove,glue,golf,goodness,governor,grace,graduate,grain,gram,grammar,gramme,input,inquiry,insect,insight,installation,instance,instinct,institute,institution,instruction,instrument,insult,insurance,intelligence,intensity,intention,interaction,interest,interference,interpretation,interval,introduction,invasion,invention,investment,invitation,issue,item,jail,jar,jaw,jazz,jeans,jet,jewel,joint,journal,journalist,journey,judgement,jungle,junior,jury,justice,minor,minority,miracle,missile,mission,mist,mixture,moisture,mold,molecule,monitor,monument,mood,mosquito,motion,motive,motor,mould,mount,mud,mug,murder,muscle,museum,mushroom,musician,mystery,myth,nationality,nature,navigation,navy,necessity,negative,Negro,neighbourhood,nephew,nerve,nest,network,neutral,niece,nightmare,nitrogen,nonsense,normal,notebook,notion,nuisance,poetry,poison,pole,policy,polish,politician,politics,poll,pollution,pond,porter,portion,portrait,pose,possession,possibility,postage,poverty,powder,prayer,precaution,precision,preface,preference,prejudice,preparation,preposition,presence,presentation,pressure,priest,prime,principal,principle,priority,privilege,procedure,process,procession,product,profession,professional,profile,profit,progressive,project,response,responsibility,restraint,result,resume,revenue,reverse,reward,rhythm,rib,ribbon,ridge,rifle,riot,rival,roar,rocket,rod,roller,rope,route,routine,rug,rumour,rust,sack,sacrifice,saddle,sailor,saint,sake,salad,salary,salesman,sample,sanction,satellite,sauce,saucer,sausage,saving,scale,scandal,scenery,schedule,scheme,scholar,stir,stock,stocking,stoop,storage,stove,strain,strap,strategy,straw,stream,stress,string,stripe,stroke,structure,studio,stuff,subject,substance,substitute,suburb,subway,succession,suggestion,suicide,sum,summary,summit,sunlight,sunrise,sunset,sunshine,superior,supplement,supply,surgery,surplus,surrounding,survey,survival,suspect,suspicion,swallow,swift,switch,sword,symbol,sympathy,symptom,veteran,vice,victim,video,viewpoint,vinegar,violence,violet,violin,virtue,virus,vision,vitamin,vocabulary,volcano,volt,voltage,volume,volunteer,vote,wagon,waist,warmth,wax,wealth,weapon,weave,weed,weep,welfare,whale,whip,whisper,whistle,widow,width,wisdom,wit,witness,wolf,wool,workman,workshop,worm,worship,worthy,wrap,wreck,wardrobe,warfare,alliance,allowance,alphabet,alternative,altitude,aluminium,amateur,ambassador,ambition,ambulance,analysis,ancestor,anchor,angle,ankle,anniversary,annual,antique,anxiety,apartment,apology,appeal,appearance,appetite,applause,appliance,applicant,application,appointment,approach,approval,architect,architecture,argument,arithmetic,arrangement,arrival,arrow,ash,aspect,assembly,asset,capture,carbon,career,cargo,carpenter,carpet,carriage,carrier,carrot,cart,cartoon,cash,cashier,cassette,cast,catalog,catalogue,category,cattle,cement,center,centimetre,ceremony,certificate,challenge,chamber,champion,channel,chaos,chap,chapter,character,charge,charity,charm,chart,chase,cheat,chemist,chest,chief,childhood,chill,chin,chip,chop,Christ,Christian,cigar,cigarette,circuit,circumstance,civilian,civilization,claim,clap,clash,classic,classification,clause,claw,clay,creature,credit,crew,crime,criminal,crisis,critic,criticism,crowd,crown,crust,cube,cue,culture,cupboard,curiosity,currency,curriculum,curse,curtain,curve,cushion,cycle,dairy,dam,damp,dash,data,daylight,deadline,debt,decade,deck,declaration,decrease,defeat,defect,definition,delegate,delivery,demand,democracy,density,departure,engine,engineering,enquiry,entertainment,enthusiasm,entry,environment,envy,episode,equality,equation,era,error,establishment,estate,eve,event,evidence,evolution,exception,excess,excitement,excursion,existence,expansion,expectation,expense,expert,explosion,exposure,expression,extension,extent,grape,graph,gratitude,grave,gravity,greenhouse,grocer,growth,guarantee,guidance,guideline,guitar,gulf,gum,guy,gymnasium,halt,hammer,handbag,handful,handle,handwriting,harbour,hardship,hardware,harmony,harness,haste,hatred,hay,hazard,heading,headline,headquarters,heap,hearing,hedge,heel,helicopter,hell,hen,herd,highlight,highway,hint,hip,hire,hobby,hollow,honey,hook,horizon,kettle,keyboard,kid,kindergarten,kindness,kingdom,knot,label,laboratory,lad,lag,lamb,landlord,landscape,lane,lap,laser,laughter,launch,laundry,lavatory,lawn,layer,layout,leader,leadership,leak,lean,learning,lease,leather,legislation,leisure,lemon,lens,liberal,liberty,librarian,license,lick,lid,lightning,limb,limitation,link,liquid,liquor,liter,literature,liver,livingRoom,loaf,loan,lobby,location,lodge,log,logic,loop,loose,lord,lorry,lover,nursery,nylon,object,objection,objective,obligation,observation,observer,obstacle,occasion,occupation,occurrence,offense,official,onion,opening,opera,operator,opportunity,option,orbit,orchestra,ore,organ,organize,organization,origin,ounce,outcome,outlet,outline,outlook,output,outset,outside,oven,overnight,owner,ownership,oxygen,pace,pack,package,packet,pad,prompt,pronoun,proof,property,proportion,proposal,prospect,prosperity,protection,protein,protest,province,provision,publication,publicity,pulse,pump,punch,purse,puzzle,qualification,queue,quiz,quotation,rack,radar,radiation,rag,rage,raid,rail,railroad,railway,rainbow,range,rank,rat,rate,ratio,raw,reaction,reality,realm,rear,rebel,receipt,receiver,reception,recession,recognition,scholarship,scissors,scope,score,scout,scrape,scratch,screen,screw,script,seal,section,sector,security,segment,selection,semester,semiconductor,seminar,senate,senator,sequence,series,session,setting,settle,settlement,shell,shelter,shield,shift,shortage,shortcoming,shrug,sigh,sightseeing,signal,signature,significance,simplicity,sin,singular,site,sketch,sleeve,slice,system,tackle,tag,talent,target,tax,technician,technique,technology,teenager,telescope,temper,temple,temptation,tendency,tension,terminal,territory,terror,textile,theme,theory,therapy,thermometer,thinking,threat,throat,thrust,thumb,thunder,tide,tidy,timber,tissue,title,toast,tolerance,tone,topic,torch,torture,tough,tour,towel,trace,tractor,tradition,tragedy,trail,transfer,translation,transmission,transport,transportation,trap,trash,tray,treatment,treaty,tremble,wrist,writer,writing,youngster,zone,abundance,aisle,appraisal,auction,aviation,bachelor,ballet,breakthrough,briefcase,calorie,casualty,census,commonplace,continuity,costume,courtesy,coverage,creation,defiance,deficiency,dock,endurance,erosion,expedition,fake,flaw,heir,heritage,humanity,hurricane,identification,illusion,imitation,imperative,assignment,assistance,assistant,association,assumption,athlete,atmosphere,attack,attempt,attitude,attorney,attraction,attribute,audience,author,auto,automatic,automobile,avenue,average,award,ax,background,bacon,bacteria,baggage,balance,balcony,balloon,ban,band,bang,bankrupt,banner,barber,bargain,bark,barn,barrel,barrier,baseball,basis,bat,battery,bay,beam,bean,beard,bearing,beast,beggar,behalf,behavior,being,clerk,client,cliff,climate,clue,coach,collapse,colleague,collection,collision,colony,column,comb,combat,combination,comedy,command,commander,comment,commerce,commission,commitment,committee,communication,community,companion,comparison,compass,competition,complaint,component,compound,comprehension,compromise,concentration,concept,concession,conclusion,condition,conduct,conductor,conference,confidence,conflict,deposit,depression,deputy,design,despair,dessert,destination,destruction,detail,detection,detective,determination,device,devil,diagram,dialect,diameter,dictation,digest,dimension,dirt,disaster,discipline,discount,disease,disgust,disorder,disposal,distinction,distress,distribution,ditch,division,divorce,document,donation,donkey,dorm,dormitory,dose,eyesight,fabric,facility,factor,faculty,failure,faint,fairy,faith,fame,famine,fantasy,fare,farewell,fashion,fate,fatigue,favour,feather,feature,fee,feedback,female,fertilizer,festival,fibre,fiction,figure,filter,finance,finding,fireman,fisherman,flame,fleet,flesh,float,flock,flood,flour,fluid,focus,fog,fold,folk,following,footstep,force,forecast,forehead,format,formation,horn,horror,horsepower,household,housing,humour,hut,hydrogen,ideal,identity,illustration,image,imagination,impact,implement,implication,import,impression,improvement,incident,incline,independence,independent,index,indication,indispensable,individual,infant,inference,infinite,inflation,influence,ingredient,inhabitant,initiative,injection,injury,inn,loyalty,luggage,lump,lung,luxury,machinery,magic,magnet,maid,mainland,maintenance,major,majority,management,mankind,manner,manual,manufacturer,margin,marine,market,marriage,mask,mass,mat,mate,material,mathematics,maximum,mayor,meaning,means,meantime,measure,measurement,mechanic,mechanism,medal,media,medium,membership,memorial,menu,merchant,mercy,merit,mess,microphone,microscope,mill,millimetre,mineral,minister,ministry,painter,palm,panel,panic,pants,parade,paragraph,parcel,parliament,particle,partner,passion,passport,paste,pat,patch,patience,patient,pattern,paw,payment,pea,peak,peer,penalty,pension,pepper,percentage,perception,performance,permission,personality,personnel,perspective,petrol,petroleum,phase,phenomenon,philosopher,philosophy,physician,physicist,pigeon,pill,pillar,pillow,pilot,pinch,pine,pint,pit,pitch,planet,plantation,plastic,platform,pledge,plot,plunge,poem,poet,recommendation,recorder,recovery,recreation,recruit,reduction,reference,reflection,reflexion,reform,refrigerator,refugee,refusal,region,register,regulation,reject,relationship,relative,relativity,release,relief,religion,remark,remedy,removal,repetition,replacement,reporter,representative,reputation,requirement,reservation,reserve,reservior,residence,resident,resign,resistance,resolution,resolve,resource,respect,slip,slope,socialism,socialist,soda,software,solution,sorrow,source,sow,spacecraft,spade,span,spark,specialist,species,specific,specimen,spelling,sphere,spider,spill,spit,spite,spokesman,sponsor,spot,spray,spur,squeeze,stack,stadium,staff,stain,stake,stale,standpoint,statement,statistic,status,steamer,stem,sting,trend,trial,triangle,triumph,troop,trumpet,trunk,tube,tune,tunnel,turbine,tutor,twist,typewriter,typist,tyre,umbrella,undergraduate,understanding,union,unity,universe,usage,utility,utmost,vacation,vacuum,van,vapour,variable,variation,variety,vehicle,venture,version,vessel,irrigation,likelihood,literacy,locality,lounge,monopoly,nurture,olive,optimum,paperback,pedestrian,pest,plague,prescription,prestige,productivity,pumpkin,purity,pursuit,quest,random,rap,referee,relay,repertoire,reunion,revelation,revenge,scrutiny,silicon,slogan,smuggle,snack,stability,stereo,telecommuications,tile,token,toll,tract,transition,tuition,unemployment,wallet,";
        _arrayNWordLibrary = [nWord componentsSeparatedByString:@","];
    }
    return _arrayNWordLibrary;
}

- (NSArray *)arrayVtWordLibrary {
    if (!_arrayVtWordLibrary) {
        NSString *vtWord = @"absorb,accompany,accomplish,accuse,acknowledge,acquire,adapt,adjust,adopt,affect,afford,bid,blend,cancel,confuse,congratulate,conquer,constitute,construct,consume,contrast,convey,convict,convince,dump,educate,elect,eliminate,embarrass,embrace,emit,emphasize,enable,enclose,encourage,enforce,engage,fulfil,fulfill,furnish,generate,insert,inspect,inspire,install,instruct,insure,integrate,intend,interrupt,interview,invade,invent,involve,isolate,mislead,misunderstand,modify,neglect,pollute,possess,postpone,preserve,pretend,prohibit,promote,restore,restrain,restrict,retain,reveal,revise,rid,risk,strip,suffer,support,suppose,surrender,surround,suspend,sustain,violate,weld,withdraw,withstand,allocate,allow,amaze,amuse,analyse,annoy,anticipate,apply,appoint,appreciate,arouse,arrest,assemble,assess,characterize,charter,chew,cite,civilize,classify,create,crush,cultivate,define,delete,demonstrate,enhance,ensure,entertain,entitle,equip,essay,establish,evaluate,exceed,exchange,exclude,execute,exert,exhaust,exhibit,expand,explode,exploit,export,expose,grant,grasp,grip,harden,harm,locate,oblige,observe,obtain,occupy,omit,oppose,organism,overcome,overlook,overtake,owe,propose,prove,provoke,purchase,pursue,quote,recall,reckon,recognize,select,shed,simplify,slap,threaten,tolerate,transform,transmit,accommodate,baffle,conform,console,enrich,foster,induce,assign,associate,assume,assure,astonish,attach,attain,attract,avoid,await,commit,compel,compress,conceal,concede,concern,condemn,confine,confirm,confront,depress,derive,describe,deserve,desire,detect,devise,devote,discard,discharge,discourage,dismiss,display,distribute,disturb,fasten,flee,forbid,identify,ignore,illustrate,imitate,imply,impose,impress,include,indicate,industrialize,infect,inherit,injure,maintain,manufacture,marry,mention,penetrate,perceive,perform,pierce,plug,recommend,recover,refine,regulate,reinforce,relate,relieve,remind,render,renew,replace,represent,require,rescue,resemble,resist,solve,specify,spoil,starve,statue,stimulate,uncover,undergo,underline,undertake,undo,upset,urge,utilize,vary,verify,reconcile,sue,unify,";
        _arrayVtWordLibrary = [vtWord componentsSeparatedByString:@","];
    }
    return _arrayVtWordLibrary;
}

- (NSArray *)arrayAdjWordLibrary {
    if (!_arrayAdjWordLibrary) {
        NSString *adjWord = @"absent,absolute,abundant,academic,accidental,accurate,accustomed,active,acute,additional,adequate,advanced,advisable,aggressive,alert,beloved,beneficial,blank,bloody,bold,brave,brilliant,calm,capable,conscious,conservative,considerable,considerate,consistent,continual,continuous,contrary,controversial,conventional,corresponding,costly,doubtful,downward,dramatic,drunk,dull,dumb,durable,dynamic,earnest,economic,economical,effective,efficient,elaborate,elastic,elderly,electric,electrical,electronic,elegant,elementary,emotional,endless,former,frank,frequent,fruitful,fundamental,generous,genuine,given,global,glorious,graceful,gradual,inner,innocent,instant,intellectual,intelligent,intense,intensive,interior,intermediate,internal,intimate,invisible,jealous,keen,minus,miserable,missing,mobile,moderate,modest,moist,moral,multiple,mutual,mysterious,naked,naval,nearby,noticeable,nuclear,poisonous,portable,positive,potential,powerful,preceding,precious,precise,preferable,pregnant,preliminary,previous,primary,primitive,prior,private,probable,prominent,responsible,restless,revolutionary,ridiculous,rigid,ripe,romantic,rotten,royal,rude,rural,satisfactory,scarce,strategic,striking,subsequent,substantial,successive,sufficient,superb,superficial,supreme,sympathetic,vigorous,virtual,visible,visual,vital,vivid,voluntary,waterproof,wealthy,weekly,wellKnown,wicked,widespread,worldwide,worthless,worthwhile,alike,ancient,anxious,apparent,applicable,appropriate,approximate,arbitrary,artificial,artistic,ashamed,casual,cautious,centigrade,characteristic,cheerful,chemical,circular,civil,classical,creative,critical,crucial,crude,crystal,curious,current,deaf,decent,definite,deliberate,delicate,delicious,democratic,dense,dental,enormous,entire,equivalent,erect,essential,evident,evil,exact,excessive,exclusive,executive,experimental,explosive,extensive,exterior,external,extra,extraordinary,grand,grateful,greedy,gross,guilty,handy,harsh,helpful,helpless,heroic,historic,historical,holy,honourable,hopeful,hopeless,latter,leading,learned,legal,liable,likely,limited,literary,local,logical,numerous,obvious,occasional,odd,offensive,operational,opponent,optical,optimistic,optional,oral,orderly,organic,original,outer,outstanding,outward,oval,overall,overhead,owing,proportional,prosperous,protective,psychological,punctual,purple,racial,radical,rare,rational,realistic,reasonable,scientific,secondary,secure,selfish,senior,sensible,sensitive,severe,sexual,shallow,sheer,significant,similar,sincere,single,skilled,skillful,slender,slight,synthetic,systematic,tame,tedious,temporary,tender,tense,thick,thirsty,thorough,thoughtful,transparent,yearly,aerial,ambitious,brutal,cognitive,concise,consequent,cooperative,corporate,cumulative,deadly,decisive,destructive,diligent,disastrous,divine,energetic,enthusiastic,eternal,ethnic,fitting,grim,imaginative,indicative,inland,instrumental,atomic,attractive,audio,auxiliary,available,aware,awful,awkward,bare,clumsy,coarse,collective,commercial,comparable,comparative,competent,competitive,complex,complicated,comprehensive,concrete,confident,dependent,desirable,desperate,digital,dim,diplomatic,distinct,diverse,domestic,dominant,extreme,faithful,fancy,fantastic,fascinating,fashionable,fatal,faulty,favourable,favourite,fearful,feasible,federal,fertile,fierce,financial,flat,flexible,fluent,formal,horizontal,horrible,hostile,humble,humorous,identical,idle,ignorant,illegal,imaginary,immense,immigrant,impatient,impressive,incredible,indifferent,indirect,indoor,industrial,inevitable,inferior,influential,initial,lower,loyal,lucky,magnetic,magnificent,male,married,marvelous,Marxist,massive,mathematical,mature,mechanical,mental,mere,merry,metric,mild,military,minimum,painful,parallel,partial,passive,peculiar,permanent,pessimistic,physical,plentiful,plural,regardless,relevant,reliable,religious,reluctant,remarkable,remote,republican,resistant,respective,slim,slippery,soak,social,solar,sole,solemn,sophisticated,sore,sour,spectacular,spiritual,splendid,stable,static,steady,steep,sticky,stiff,tremendous,trim,tropical,troublesome,typical,ugly,ultimate,underground,uneasy,unexpected,unique,universal,unlike,unusual,upper,upright,uptoDate,urban,urgent,utter,vacant,vague,vain,valid,various,vast,vertical,monetary,morality,muscular,permissible,physiological,premature,prevalent,productive,profitable,profound,prospective,residential,solitary,stern,subjective,subordinate,timely,tolerant,transient,vocal,vulnerable,";
        _arrayAdjWordLibrary = [adjWord componentsSeparatedByString:@","];
    }
    return _arrayAdjWordLibrary;
}

- (NSArray *)arrayAdvWordLibrary {
    if (_arrayAdvWordLibrary) {
        NSString *advWord = @"aboard,abroad,according,accordingly,afterward,beneath,besides,consequently,conversely,elsewhere,forth,fortunately,furthermore,generally,instead,inward,moreover,namely,naturally,necessarily,normally,nowhere,practically,presently,presumably,primarily,scarcely,virtually,wholly,alongside,anyhow,anyway,apart,aside,definitely,evidently,exceedingly,hence,highly,largely,likewise,overseas,rarely,readily,recently,shortly,sideways,similarly,thereby,therefore,beforehand,backward,barely,basically,directly,fairly,finally,immediately,increasingly,merely,particularly,repeatedly,respectively,somehow,somewhat,specifically,truly,underneath,undoubtedly,unfortunately,invariably,seemingly,thereafter,";
        _arrayAdvWordLibrary = [advWord componentsSeparatedByString:@","];
    }
    return _arrayAdvWordLibrary;
}
@end
