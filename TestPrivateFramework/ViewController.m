//
//  ViewController.m
//  TestPrivateFramework
//
//  Created by Li Jun on 2018/8/23.
//  Copyright © 2018 Nextop.CN. All rights reserved.
//

#import "ViewController.h"
#import "Extensions.h"
#import <objc/runtime.h>

@interface ViewController () {
    IBOutlet UITextView *txtvContent;
    IBOutlet UIButton *btnDetect;
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [btnDetect addRoundCorner:2.0f];
    [btnDetect addBorderWithColor:UIColor.blueColor];
    [self startDetect];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)startDetect {
    NSBundle *b = [NSBundle bundleWithPath:@"/System/Library/PrivateFrameworks/FTServices.framework"];
    if (![b load]) {
        txtvContent.attributedText = [[NSAttributedString alloc] initWithString:@"Cannot Detect!!!"];
        return;
    }
    
    Class FTDeviceSupport = NSClassFromString(@"FTDeviceSupport");
    //Class superFTDeviceSupport = class_getSuperclass(FTDeviceSupport);
    id si = [FTDeviceSupport valueForKey:@"sharedInstance"];
    NSMutableAttributedString *text = [[NSMutableAttributedString alloc] init];
    
    unsigned int ivarsCnt = 0;
    //　获取类成员变量列表，ivarsCnt为类成员数量
    Ivar *ivars = class_copyIvarList(FTDeviceSupport, &ivarsCnt);
    //　遍历成员变量列表，其中每个变量都是Ivar类型的结构体
    for (const Ivar *p = ivars; p < ivars + ivarsCnt; ++p)
    {
        Ivar const ivar = *p;
        
        //　获取变量名
        NSString *key = [NSString stringWithUTF8String:ivar_getName(ivar)];
        // 若此变量未在类结构体中声明而只声明为Property，则变量名加前缀 '_'下划线
        // 比如 @property(retain) NSString *abc;则 key == _abc;
        
        //　获取变量值
        id v = [si valueForKey:key];
        
        // 取得变量类型
        // 通过type[0]可以判断其具体的内置类型
        const char *type = ivar_getTypeEncoding(ivar);
        
        NSString *value = [NSString stringWithFormat:@"%@", [v description]];
        NSString *info = [[NSString alloc] initWithFormat:@"%@: (%s)%@\n", key, type, value];
        NSMutableAttributedString *attrText = [[NSMutableAttributedString alloc] initWithString:info];
        [attrText addAttribute:NSForegroundColorAttributeName value:UIColor.greenColor range:NSMakeRange(info.length-value.length-1, value.length)];
        [text appendAttributedString:attrText];
    }
    
    unsigned int ipropsCnt = 0;
    //　获取类属性列表，ipropsCnt为类属性数量
    objc_property_t *iprops = class_copyPropertyList(FTDeviceSupport, &ipropsCnt);
    //　遍历属性列表，其中每个属性都是objc_property_t类型的结构体
    for (const objc_property_t *p = iprops; p < iprops + ipropsCnt; ++p)
    {
        objc_property_t const iprop = *p;
        
        //　获取属性名
        NSString *key = [NSString stringWithUTF8String:property_getName(iprop)];
        
        //　获取属性值
        id v = [si valueForKey:key];
        
        // 取得属性类型
        // 通过type[0]可以判断其具体的内置类型
        const char *type = property_getAttributes(iprop);
        
        NSString *value = [NSString stringWithFormat:@"%@", [v description]];
        NSString *info = [[NSString alloc] initWithFormat:@"%@: (%s)%@\n", key, type, value];
        NSMutableAttributedString *attrText = [[NSMutableAttributedString alloc] initWithString:info];
        if ([value hasPrefix:@"#"] && value.length == 7) {
            [attrText addAttribute:NSForegroundColorAttributeName value:value.RGBHexToColor range:NSMakeRange(info.length-value.length-1, value.length)];
        } else {
            [attrText addAttribute:NSForegroundColorAttributeName value:UIColor.greenColor range:NSMakeRange(info.length-value.length-1, value.length)];
        }
        [text appendAttributedString:attrText];
    }
    
    
//    {
//        NSString *value = [NSString stringWithFormat:@"%@", [[si valueForKey:@"deviceColor"] description]];
//        NSString *info = [[NSString alloc] initWithFormat:@"deviceColor: %@\n", value];
//        NSMutableAttributedString *attrText = [[NSMutableAttributedString alloc] initWithString:info];
//        [attrText addAttribute:NSForegroundColorAttributeName value:value.RGBHexToColor range:NSMakeRange(info.length-value.length-1, value.length)];
//        [text appendAttributedString:attrText];
//    }
//    {
//        NSString *value = [[si valueForKey:@"SIMInserted"] stringValue];
//        NSString *info = [[NSString alloc] initWithFormat:@"SIMInserted: %@\n", value];
//        NSMutableAttributedString *attrText = [[NSMutableAttributedString alloc] initWithString:info];
//        [attrText addAttribute:NSForegroundColorAttributeName value:UIColor.greenColor range:NSMakeRange(info.length-value.length-1, value.length)];
//        [text appendAttributedString:attrText];
//    }
    {
        NSString *value = [NSString stringWithFormat:@"%@", [[si valueForKey:@"telephonyCapabilities"] description]];
        NSString *info = [[NSString alloc] initWithFormat:@"telephonyCapabilities: %@\n", value];
        NSMutableAttributedString *attrText = [[NSMutableAttributedString alloc] initWithString:info];
        [attrText addAttribute:NSForegroundColorAttributeName value:UIColor.greenColor range:NSMakeRange(info.length-value.length-1, value.length)];
        [text appendAttributedString:attrText];
    }
    
    txtvContent.attributedText = text;
}

- (IBAction)btnDetectDidClick:(id)sender {
    [self startDetect];
}

@end
