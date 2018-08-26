//
//  CoreTelephonyTest.m
//  TestPrivateFramework
//
//  Created by litjerk on 26/08/2018.
//  Copyright © 2018 ZDQK. All rights reserved.
//

#import "CoreTelephonyTest.h"
#import <CoreTelephony/CTTelephonyNetworkInfo.h>
#import <CoreTelephony/CTCarrier.h>
#import <CoreTelephony/CTTelephonyNetworkInfo.h>
#import "Extensions.h"
#import <dlfcn.h>

extern NSString *CTSettingCopyMyPhoneNumber();

@interface CoreTelephonyTest () {
    IBOutlet UITextView *txtvContent;
    IBOutlet UIButton *btnDetect;
    CTTelephonyNetworkInfo *networkInfo;
}

@end

@implementation CoreTelephonyTest

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [btnDetect addRoundCorner:2.0f];
    [btnDetect addBorderWithColor:UIColor.blueColor];
    
    networkInfo = [[CTTelephonyNetworkInfo alloc] init];
    
    //当sim卡更换时弹出此窗口
    networkInfo.subscriberCellularProviderDidUpdateNotifier = ^(CTCarrier *carrier){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                                                        message:@"Sim card changed"
                                                       delegate:nil
                                              cancelButtonTitle:@"Dismiss"
                                              otherButtonTitles:nil];
        
        [alert show];
        
        //CTSettingCopyMyPhoneNumber
    };
    
    [self startDetect];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)btnDetectDidClick:(id)sender {
    [self startDetect];
}

- (void)startDetect {
    
    NSMutableAttributedString *text = [[NSMutableAttributedString alloc] init];
    CTCarrier *carrier = networkInfo.subscriberCellularProvider;
    {
        NSString *value = carrier.carrierName;
        NSString *info = [[NSString alloc] initWithFormat:@"carrierName: %@\n", value];
        NSMutableAttributedString *attrText = [[NSMutableAttributedString alloc] initWithString:info];
        [attrText addAttribute:NSForegroundColorAttributeName value:UIColor.greenColor range:NSMakeRange(info.length-value.length-1, value.length)];
        [text appendAttributedString:attrText];
    }
    {
        NSString *value = carrier.mobileCountryCode;
        NSString *info = [[NSString alloc] initWithFormat:@"mobileCountryCode: %@\n", value];
        NSMutableAttributedString *attrText = [[NSMutableAttributedString alloc] initWithString:info];
        [attrText addAttribute:NSForegroundColorAttributeName value:UIColor.greenColor range:NSMakeRange(info.length-value.length-1, value.length)];
        [text appendAttributedString:attrText];
    }
    {
        NSString *value = carrier.mobileNetworkCode;
        NSString *info = [[NSString alloc] initWithFormat:@"mobileNetworkCode: %@\n", value];
        NSMutableAttributedString *attrText = [[NSMutableAttributedString alloc] initWithString:info];
        [attrText addAttribute:NSForegroundColorAttributeName value:UIColor.greenColor range:NSMakeRange(info.length-value.length-1, value.length)];
        [text appendAttributedString:attrText];
    }
    {
        NSString *value = carrier.isoCountryCode;
        NSString *info = [[NSString alloc] initWithFormat:@"isoCountryCode: %@\n", value];
        NSMutableAttributedString *attrText = [[NSMutableAttributedString alloc] initWithString:info];
        [attrText addAttribute:NSForegroundColorAttributeName value:UIColor.greenColor range:NSMakeRange(info.length-value.length-1, value.length)];
        [text appendAttributedString:attrText];
    }
    {
        NSString *value = [NSString fromBool:carrier.allowsVOIP];
        NSString *info = [[NSString alloc] initWithFormat:@"allowsVOIP: %@\n", value];
        NSMutableAttributedString *attrText = [[NSMutableAttributedString alloc] initWithString:info];
        [attrText addAttribute:NSForegroundColorAttributeName value:UIColor.greenColor range:NSMakeRange(info.length-value.length-1, value.length)];
        [text appendAttributedString:attrText];
    }
    {
        NSString *value = self.getMyNumber;
        NSString *info = [[NSString alloc] initWithFormat:@"phoneNumber: %@\n", value];
        NSMutableAttributedString *attrText = [[NSMutableAttributedString alloc] initWithString:info];
        [attrText addAttribute:NSForegroundColorAttributeName value:UIColor.greenColor range:NSMakeRange(info.length-value.length-1, value.length)];
        [text appendAttributedString:attrText];
    }
    
    txtvContent.attributedText = text;
}

- (NSString*)getMyNumber {
    NSLog(@"Open CoreTelephony");
    void *lib = dlopen("/Symbols/System/Library/Framework/CoreTelephony.framework/CoreTelephony", RTLD_LAZY);
    NSLog(@"Get CTSettingCopyMyPhoneNumber from CoreTelephony");
    NSString* (*pCTSettingCopyMyPhoneNumber)() = dlsym(lib, "CTSettingCopyMyPhoneNumber");
    NSLog(@"Get CTSettingCopyMyPhoneNumber from CoreTelephony");
    
    if (pCTSettingCopyMyPhoneNumber == nil) {
        NSLog(@"pCTSettingCopyMyPhoneNumber is nil");
        return nil;
    }
    NSString* ownPhoneNumber = pCTSettingCopyMyPhoneNumber();
    dlclose(lib);
    return ownPhoneNumber;
}

@end
