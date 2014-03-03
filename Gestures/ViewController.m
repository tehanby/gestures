//
//  ViewController.m
//  Gestures
//
//  Created by Tim Hanby on 2/27/14.
//  Copyright (c) 2014 Timothy Hanby. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
@property(weak,nonatomic)UIView *movingView;
@property(weak,nonatomic)UIView *nonMovingView;
@property(nonatomic)CGPoint constantVelocity;
@end

@implementation ViewController


- (IBAction)handlePanGesture:(UIPanGestureRecognizer *)sender
{
    if(sender.state == UIGestureRecognizerStateEnded)
    {
        //All fingers are lifted.
        self.movingView = nil;
    }else{
        if(!self.movingView){
            NSArray *subViews = [self.view subviews];
            for (int i = 0; i < subViews.count; i++) {
                if([subViews[i] isMemberOfClass:[UIView class]]){
                    UIView *view = subViews[i];
                    if([self isViewBeingTouched:view withSender:sender]){
                        self.movingView = view;
                        self.constantVelocity = [sender velocityInView:view];
                    }else{
                        self.nonMovingView = view;
                    }
                }
            }
        }
        CGPoint translation = [self getTranslationFromView:self.movingView withSender:sender];
        CGPoint velocity = [sender velocityInView:self.movingView];

        [self doGesture:self.movingView withSender:sender withTranslation:translation];
        if( [self isMovingViewOverlappingOnScreenView:self.movingView withViewOnScreen:self.nonMovingView withTranslation:translation] &&
           ![self doesPanChangeDirections:velocity withConstantVelocity:self.constantVelocity]){
            
            [self doGesture:self.nonMovingView withSender:sender withTranslation:translation];
            
        }
        self.constantVelocity = velocity;
    }
}

- (BOOL)doesPanChangeDirections:(CGPoint)currentVelocity withConstantVelocity:(CGPoint)constantVelocity
{
    if((currentVelocity.x < 0 && constantVelocity.x > 0) || (currentVelocity.x > 0 && constantVelocity.x < 0)){
        return YES;
    }
    
    if((currentVelocity.y < 0 && constantVelocity.y > 0) || (currentVelocity.y > 0 && constantVelocity.y < 0)){
        return YES;
    }
    
    return NO;
}

- (BOOL)isMovementInBounds:(CGPoint)translation movingView:(UIView *)view
{
    CGFloat checkOriginX = view.frame.origin.x + translation.x;
    CGFloat checkOriginY = view.frame.origin.y + translation.y;
    
    CGRect rectToCheckBounds = CGRectMake(checkOriginX, checkOriginY, view.frame.size.width, view.frame.size.height);
    return CGRectContainsRect(self.view.frame, rectToCheckBounds);
}

- (void)doGesture:(UIView *)view withSender:(UIPanGestureRecognizer *)sender withTranslation:(CGPoint)translation
{
    view.center = CGPointMake(view.center.x + translation.x, view.center.y + translation.y);
    [sender setTranslation:CGPointMake(0, 0) inView:self.view];
}

- (CGPoint)getTranslationFromView:(UIView *)view withSender:(UIPanGestureRecognizer *)sender
{
    return [sender translationInView:view];
}

- (BOOL)isViewBeingTouched:(UIView *)view withSender:(UIPanGestureRecognizer *)sender
{
    BOOL isXAxisMatching = NO;
    BOOL isYAxisMatching = NO;
    
    if((view.frame.origin.x) < [sender locationInView:self.view].x && (view.frame.origin.x + 120) > [sender locationInView:self.view].x){
        isXAxisMatching = YES;
    }
    
    if((view.frame.origin.y) < [sender locationInView:self.view].y && (view.frame.origin.y + 120) > [sender locationInView:self.view].y){
        isYAxisMatching = YES;
    }
    
    return (isXAxisMatching && isYAxisMatching);
}

- (BOOL)isMovingViewOverlappingOnScreenView:(UIView *)currentView withViewOnScreen:(UIView *)viewOnScreen withTranslation:(CGPoint)translation
{
    CGRect currentViewFrame = [currentView frame];
    CGRect viewOnScreenFrame = [viewOnScreen frame];
    
    return CGRectIntersectsRect(currentViewFrame,viewOnScreenFrame);
}

@end
