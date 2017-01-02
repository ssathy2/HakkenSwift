//
//  NSLayoutConstraint+Helpers.m
//  Mobile Apps
//
//  Created by Siddharth Sathyam on 11/21/16.
//  Copyright © 2016 Foot Locker. All rights reserved.
//

#import "NSLayoutConstraint+Helpers.h"

@implementation NSLayoutConstraint (Helpers)
+ (NSArray<NSNumber *> *)layoutAttributesForEdges:(UIRectEdge)edge
{
    NSMutableArray *constraints = [NSMutableArray array];
    if (edge == UIRectEdgeAll)
        return @[@(NSLayoutAttributeLeading), @(NSLayoutAttributeTrailing), @(NSLayoutAttributeTop), @(NSLayoutAttributeBottom)];
    
    if (edge & UIRectEdgeLeft)
        [constraints addObject: @(NSLayoutAttributeLeading)];
    
    if (edge & UIRectEdgeRight)
        [constraints addObject: @(NSLayoutAttributeTrailing)];
    
    if (edge & UIRectEdgeTop)
        [constraints addObject: @(NSLayoutAttributeTop)];
    
    if (edge & UIRectEdgeBottom)
        [constraints addObject: @(NSLayoutAttributeBottom)];
    
    return constraints;
}

+ (NSArray<NSLayoutConstraint *> *)fl_layoutConstraintsFromView:(UIView *)fromView toView:(UIView *)toView edges:(UIRectEdge)edges
{
    NSArray<NSNumber *> *layoutAttributes = [self layoutAttributesForEdges:edges];
    NSMutableArray<NSLayoutConstraint *> *constraints = [NSMutableArray array];
    for (NSNumber *layoutAttributeWrapped in layoutAttributes)
    {
        NSLayoutAttribute attribute = layoutAttributeWrapped.integerValue;
        [constraints addObject:[NSLayoutConstraint constraintWithItem:fromView attribute:attribute relatedBy:NSLayoutRelationEqual toItem:toView attribute:attribute multiplier:1.f constant:0.f]];
    }
    return constraints;
}

+ (NSArray<NSLayoutConstraint *> *)fl_heightAndWidthConstraintsForView:(UIView *)view withHeight:(CGFloat)height withWidth:(CGFloat)width
{
    return @[[self fl_heightConstraintForView:view withHeight:height],
             [self fl_widthConstraintForView:view withWidth:width]];
}

+ (NSArray<NSLayoutConstraint *> *)fl_midXandMidYConstraintsFromView:(UIView *)fromView toView:(UIView *)toView
{
    return @[[self fl_midXConstraintFromView:fromView toView:toView],
             [self fl_midYConstraintFromView:fromView toView:toView]];
}

+ (NSLayoutConstraint *)fl_heightConstraintForView:(UIView *)view withHeight:(CGFloat)height
{
    return [self fl_unaryConstraintForView:view attribute:NSLayoutAttributeHeight constant:height];
}

+ (NSLayoutConstraint *)fl_widthConstraintForView:(UIView *)view withWidth:(CGFloat)width
{
    return [self fl_unaryConstraintForView:view attribute:NSLayoutAttributeWidth constant:width];
}

+ (NSLayoutConstraint *)fl_midXConstraintFromView:(UIView *)fromView toView:(UIView *)toView
{
    if (!fromView || !toView)
        return nil;
    
    return [NSLayoutConstraint constraintWithItem:fromView
                                        attribute:NSLayoutAttributeCenterX
                                        relatedBy:NSLayoutRelationEqual
                                           toItem:toView
                                        attribute:NSLayoutAttributeCenterX
                                       multiplier:1.0
                                         constant:0.0];
}

+ (NSLayoutConstraint *)fl_midYConstraintFromView:(UIView *)fromView toView:(UIView *)toView
{
    if (!fromView || !toView)
        return nil;
    
    return [NSLayoutConstraint constraintWithItem:fromView
                                        attribute:NSLayoutAttributeCenterY
                                        relatedBy:NSLayoutRelationEqual
                                           toItem:toView
                                        attribute:NSLayoutAttributeCenterY
                                       multiplier:1.0
                                         constant:0.0];
}

+ (NSLayoutConstraint *)fl_unaryConstraintForView:(UIView *)view attribute:(NSLayoutAttribute)attribute constant:(CGFloat)constant
{
    if (!view)
        return nil;
    
    NSLayoutConstraint *layoutConstraint = [NSLayoutConstraint constraintWithItem:view
                                                                        attribute:attribute
                                                                        relatedBy:NSLayoutRelationEqual
                                                                           toItem:nil
                                                                        attribute:NSLayoutAttributeNotAnAttribute
                                                                       multiplier:1.0
                                                                         constant:constant];
    return layoutConstraint;
}
@end
