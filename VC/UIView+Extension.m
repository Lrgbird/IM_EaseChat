//
//  UIView+Extension.m
//  
//
//  Created by DianZhi on 15/8/7.
//  Copyright (c) 2015年 DianZhi. All rights reserved.
//

#import "UIView+Extension.h"
#import "MBProgressHUD.h"
@implementation UIView (Extension)

/**
 *  frame的X
 */
- (CGFloat)x
{
    return self.frame.origin.x;
}

/**
 *  设置frame的X
 */
- (void)setX:(CGFloat)x
{
    CGRect frame = self.frame;
    frame.origin.x = x;
    self.frame = frame;
}

/**
 *  frame的Y
 */
- (CGFloat)y
{
    return self.frame.origin.y;
}

/**
 *  设置frame的Y
 */
- (void)setY:(CGFloat)y
{
    CGRect frame = self.frame;
    frame.origin.y = y;
    self.frame = frame;
}

/**
 *  frame的width
 */
- (CGFloat)width
{
    return self.frame.size.width;
}

/**
 *  设置frame的width
 */
- (void)setWidth:(CGFloat)width
{
    CGRect frame = self.frame;
    frame.size.width = width;
    self.frame = frame;
}

/**
 *  frame的height
 */
- (CGFloat)height
{
    return self.frame.size.height;
}

/**
 *  设置frame的height
 */
- (void)setHeight:(CGFloat)height
{
    CGRect frame = self.frame;
    frame.size.height = height;
    self.frame = frame;
}

/**
 *  中点X
 */
- (CGFloat)centerX {
    return self.center.x;
}

/**
 *  设置中点X
 */
- (void)setCenterX:(CGFloat)centerX {
    CGPoint center = self.center;
    center.x = centerX;
    self.center = center;
}

/**
 *  中点Y
 */
- (CGFloat)centerY {
    return self.center.y;
}

/**
 *  设置中点Y
 */
- (void)setCenterY:(CGFloat)centerY {
    CGPoint center = self.center;
    center.y = centerY;
    self.center = center;
}

/**
 *  frame的origin
 */
- (CGPoint)origin {
    return self.frame.origin;
}


/**
 *  设置frame的origin
 */
- (void)setOrigin:(CGPoint)origin {
    CGRect frame = self.frame;
    frame.origin = origin;
    self.frame = frame;
}

/**
 *  frame的size
 */
- (CGSize)size {
    return self.frame.size;
}

/**
 *  设置frame的size
 */
- (void)setSize:(CGSize)size {
    CGRect frame = self.frame;
    frame.size = size;
    self.frame = frame;
}


/**  获取view的maxX **/
-(CGFloat)maxX{
    return CGRectGetMaxX(self.frame);
}

/** 获取view的maxY **/
-(CGFloat)maxY{
    return CGRectGetMaxY(self.frame);
}

//通过颜色创早图片
+(UIImage*)createImageWithColor:(UIColor*)color{
    
    CGRect rect=CGRectMake(0.0f,0.0f,1.0f,1.0f);
    UIGraphicsBeginImageContext(rect.size);
    
    CGContextRef context=UIGraphicsGetCurrentContext();CGContextSetFillColorWithColor(context, [color CGColor]);
    
    CGContextFillRect(context, rect);
    
    UIImage* theImage=UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return theImage;
}

//显示提示
+ (void)showMessage:(NSString *)message withShowTime:(double)second;
{
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    MBProgressHUD *hub = [MBProgressHUD showHUDAddedTo:window animated:YES];
    
    hub.labelText = message;
    
    
    
    hub.removeFromSuperViewOnHide = YES;
    
    hub.backgroundColor = [UIColor clearColor];
    [hub hide:YES afterDelay:second];
}
@end
