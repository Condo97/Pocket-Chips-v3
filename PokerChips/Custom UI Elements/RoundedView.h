//
//  RoundedView.h
//  EReceipts
//
//  Created by Alex Coundouriotis on 3/1/18.
//  Copyright © 2018 Alex Coundouriotis. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RoundedView : UIView

@property (nonatomic) IBInspectable UIColor *shadowColor;
@property (nonatomic) IBInspectable CGFloat shadowRadius;
@property (nonatomic) IBInspectable CGSize shadowOffset;
@property (nonatomic) IBInspectable CGFloat shadowOpacity;

@property (nonatomic) IBInspectable CGFloat cornerRadius;
@property (nonatomic) IBInspectable UIColor *theBackgroundColor;
@property (nonatomic) IBInspectable UIImage *image;

@property (nonatomic) IBInspectable BOOL useBorder;
@property (nonatomic) IBInspectable CGFloat theBorderWidth;
@property (nonatomic) IBInspectable UIColor *theBorderColor;

@property (nonatomic) IBInspectable BOOL useBlur;

@property (strong, nonatomic) UIImageView *imageView;

@property (strong, nonatomic) UIView *roundedView;

- (id)initWithFrame:(CGRect)frame backgroundColor:(UIColor *)backgroundColor cornerRadius:(int)cornerRadius;
- (void)setTheBackgroundColorLater:(UIColor *)theBackgroundColor;
- (void)setTheBorderColorLater:(UIColor *)theBorderColor;
- (void)setImageLater:(UIImage *)image;

@end
