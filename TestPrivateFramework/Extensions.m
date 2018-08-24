//
//  Extensions.m
//  TestPrivateFramework
//
//  Created by Li Jun on 2018/8/24.
//  Copyright © 2018 Nextop.CN. All rights reserved.
//

#import "Extensions.h"

@implementation NSString(Conversion)
+ (NSString *)fromBool:(BOOL)b {
    return b? @"true" : @"false";
}

- (NSInteger)hexToInt {
    NSString *str = [self uppercaseString];
    NSInteger sum = 0;
    NSInteger diff = ('0' - 'A') + 10;
    for (NSInteger i=0; i<str.length; i++) {
        unichar c = [str characterAtIndex:i];
        sum = sum * 16 + c - '0'; // 0-9: start from 48
        if (c >= 'A') {                 // A-Z: start from 65, but initial value is 10，so minus 55
            sum += diff;
        }
    }
    return sum;
}

- (UIColor *)RGBHexToColor {
    NSInteger value = [[self stringByReplacingOccurrencesOfString:@"0x" withString:@""] stringByReplacingOccurrencesOfString:@"#" withString:@""].hexToInt;
    return [UIColor colorWithRGBHex:value];
}

- (UIColor *)RGBAHexToColor {
    NSInteger value = [[self stringByReplacingOccurrencesOfString:@"0x" withString:@""] stringByReplacingOccurrencesOfString:@"#" withString:@""].hexToInt;
    return [UIColor colorWithRGBAHex:value];
}
@end

@implementation UIColor(Conversion)
+ (UIColor *)colorWithRGBHex:(NSInteger)hex {
    return [UIColor colorWithRed:(hex >> 16&0xff) / 255.0 green:(hex >> 8&0xff) / 255.0 blue:(hex&0xff) / 255.0 alpha:1.0];
}

+ (UIColor *)colorWithRGBAHex:(NSInteger)hex {
    return [UIColor colorWithRed:(hex >> 24&0xff) / 255.0 green:(hex >> 16&0xff) / 255.0 blue:(hex >> 8&0xff) / 255.0 alpha:(hex&0xff) / 255.0];
}
@end

@implementation UIView(Style)
- (void)addRoundCorner:(CGFloat)corner {
    self.layer.cornerRadius = corner;
    self.clipsToBounds = true;
}
    
- (void)addBorderWithColor:(UIColor *)color {
    self.layer.borderColor = color.CGColor;
    self.layer.borderWidth = 0.5;
}
@end
