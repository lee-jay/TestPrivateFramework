//
//  Extensions.h
//  TestPrivateFramework
//
//  Created by Li Jun on 2018/8/24.
//  Copyright © 2018 Nextop.CN. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@interface NSString(Conversion)
+ (NSString *)fromBool:(BOOL)b;
- (NSInteger)hexToInt;
- (UIColor *)RGBHexToColor;
- (UIColor *)RGBAHexToColor;
@end

@interface UIColor(Conversion)
+ (UIColor *)colorWithRGBHex:(NSInteger)hex;
+ (UIColor *)colorWithRGBAHex:(NSInteger)hex;
@end

@interface UIView(Style)
- (void)addRoundCorner:(CGFloat)corner;
- (void)addBorderWithColor:(UIColor *)color;
@end
