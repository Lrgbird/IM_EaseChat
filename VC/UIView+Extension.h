//
//  UIView+Extension.h
//  简化viewXY宽高等的设置
//
//  Created by DianZhi on 15/8/7.
//  Copyright (c) 2015年 DianZhi. All rights reserved.
//

#import <UIKit/UIKit.h>



#define YBColor(r,g,b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1.0]
#define YBColorFromRGB(rgbValue)    [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]
#define ScreenWidth [UIScreen mainScreen].bounds.size.width
#define ScreenHeight [UIScreen mainScreen].bounds.size.height

@interface UIView (Extension)
/** frame的X */
@property (assign, nonatomic) CGFloat x;

/** frame的Y */
@property (assign, nonatomic) CGFloat y;

/** frame的width */
@property (assign, nonatomic) CGFloat width;

/** frame的height */
@property (assign, nonatomic) CGFloat height;

/** 中点的X */
@property (assign, nonatomic) CGFloat centerX;

/** 中点的Y */
@property (assign, nonatomic) CGFloat centerY;

/** frame的origin */
@property (assign, nonatomic) CGPoint origin;

/** frame的size */
@property (assign, nonatomic) CGSize size;

/** frame的MaxX */
@property (assign, nonatomic,readonly) CGFloat maxX;

/** frame的MaxY */
@property (assign, nonatomic,readonly) CGFloat maxY;

//颜色转图片
+(UIImage*)createImageWithColor:(UIColor*)color;
//显示提示
//显示提示
+ (void)showMessage:(NSString *)message withShowTime:(double)second;
@end
