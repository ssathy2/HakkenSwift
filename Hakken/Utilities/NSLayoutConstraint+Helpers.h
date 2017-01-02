//
//  NSLayoutConstraint+Helpers.h
//  Mobile Apps
//
//  Created by Siddharth Sathyam on 11/21/16.
//  Copyright © 2016 Foot Locker. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NSLayoutConstraint (Helpers)
+ (NSArray<NSLayoutConstraint *> *)fl_layoutConstraintsFromView:(UIView *)fromView toView:(UIView *)toView edges:(UIRectEdge)edges;
+ (NSArray<NSLayoutConstraint *> *)fl_heightAndWidthConstraintsForView:(UIView *)view withHeight:(CGFloat)height withWidth:(CGFloat)width;
+ (NSArray<NSLayoutConstraint *> *)fl_midXandMidYConstraintsFromView:(UIView *)fromView toView:(UIView *)toView;

+ (NSLayoutConstraint *)fl_midXConstraintFromView:(UIView *)view toView:(UIView *)toView;
+ (NSLayoutConstraint *)fl_midYConstraintFromView:(UIView *)view toView:(UIView *)toView;

+ (NSLayoutConstraint *)fl_heightConstraintForView:(UIView *)view withHeight:(CGFloat)height;
+ (NSLayoutConstraint *)fl_widthConstraintForView:(UIView *)view withWidth:(CGFloat)width;
@end
