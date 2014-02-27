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
@end

@implementation ViewController


- (IBAction)handlePanGesture:(UIPanGestureRecognizer *)sender
{
    if(sender.state == UIGestureRecognizerStateEnded)
    {
        //All fingers are lifted.
        self.movingView = nil;
    }else{
        if(self.movingView){
            [self doGesture:self.movingView withSender:sender];
        }else{
            NSArray *subViews = [self.view subviews];
            for (int i = 0; i < subViews.count; i++) {
                UIView *view = subViews[i];
                if([self isViewBeingTouched:view withSender:sender]){
                    self.movingView = view;
                    [self doGesture:view withSender:sender];
                    break;
                }
            }
        }
    }
}

- (void)doGesture:(UIView *)view withSender:(UIPanGestureRecognizer *)sender
{
    CGPoint translation = [sender translationInView:view];
    
    
    CGFloat checkOriginX = view.frame.origin.x + translation.x;
    CGFloat checkOriginY = view.frame.origin.y + translation.y;
    
    CGRect rectToCheckBounds = CGRectMake(checkOriginX, checkOriginY, view.frame.size.width, view.frame.size.height);
    
    if (CGRectContainsRect(self.view.frame, rectToCheckBounds)){
        view.center = CGPointMake(view.center.x + translation.x,
                                  view.center.y + translation.y);
        [sender setTranslation:CGPointMake(0, 0) inView:self.view];
    }
}

- (BOOL)isViewBeingTouched:(UIView *)view withSender:(UIPanGestureRecognizer *)sender
{
    
    NSLog(@"Sender x = %f and y = %f", [sender locationInView:self.view].x, [sender locationInView:self.view].y);
    NSLog(@"Current view x = %f and y = %f", view.frame.origin.x, view.frame.origin.y);
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

@end
