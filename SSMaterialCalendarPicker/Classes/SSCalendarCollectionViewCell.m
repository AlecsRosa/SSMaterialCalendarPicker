//
//  SSCalendarCollectionViewCell.m
//
//
//  Created by Iuri Chiba on 7/16/15.
//
//

#import "SSCalendarCollectionViewCell.h"
#import <QuartzCore/QuartzCore.h>

@implementation SSCalendarCollectionViewCell

static NSArray *colors;
static int count;

- (void)layoutSubviews {
    [super layoutSubviews];
    if (colors == nil) colors = @[[UIColor blueColor], [UIColor redColor], [UIColor greenColor],
                                  [UIColor blueColor], [UIColor redColor], [UIColor greenColor]];
    [self setupRippleButton];
    self.backgroundColor = [colors objectAtIndex:count++];
}

- (void)setupRippleButton {
    CGFloat size = CGRectGetWidth(self.frame) * 0.8f;
    CGFloat x = (CGRectGetWidth(self.frame) * 0.2f)/2;
    CGFloat y = (CGRectGetWidth(self.frame) * 0.2f)/2;
    CGRect buttonFrame = CGRectMake(x, y, size, size);
    
    self.button = [[SSRippleButton alloc] initWithFrame:buttonFrame];
    [self.button setTitle:@"X" forState:UIControlStateNormal];
    [self.button setContentHorizontalAlignment:UIControlContentHorizontalAlignmentCenter];
    [self.button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self addSubview:self.button];
}

- (UIView *) hitTest:(CGPoint) point withEvent:(UIEvent *)event {
    if ([self pointInside:point withEvent:event]) {
        return self.button;
    } return nil;
}

@end

@implementation SSRippleButton

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupRipple];
        [self setBackgroundColor:[UIColor clearColor]];
        [self.layer setCornerRadius:CGRectGetWidth(self.frame)/2];
        [self setClipsToBounds:YES];
    } return self;
}

- (void)setupRipple {
    [self setupRippleView];
    [self setupRippleBackgroundView];
}

- (void)setupRippleView {
    if (self.rippleView == nil) {
        CGFloat size = CGRectGetWidth(self.frame) * 0.6f;
        CGFloat x = CGRectGetWidth(self.frame)/2 - size/2;
        CGFloat y = CGRectGetHeight(self.frame)/2 - size/2;
        CGFloat corner = size/2;
        
        self.rippleView = [[UIView alloc] init];
        self.rippleView.backgroundColor = [UIColor lightGrayColor];
        self.rippleView.frame = CGRectMake(x, y, size, size);
        self.rippleView.layer.cornerRadius = corner;
    }
}

- (void)setupRippleBackgroundView {
    if (self.rippleBackgroundView == nil) {
        CGFloat size = CGRectGetWidth(self.frame);
        
        self.rippleBackgroundView = [[UIView alloc] init];
        self.rippleBackgroundView.backgroundColor = [UIColor redColor];
        self.rippleBackgroundView.frame = CGRectMake(0.0f, 0.0f, size, size);
        self.rippleBackgroundView.layer.cornerRadius = CGRectGetWidth(self.rippleBackgroundView.frame)/2;
        [self.layer addSublayer:self.rippleBackgroundView.layer];
        [self.rippleBackgroundView.layer addSublayer:self.rippleView.layer];
        [self.rippleBackgroundView setAlpha:0.0f];
    }
}

- (BOOL)beginTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event {
    self.rippleView.center = [touch locationInView:self];
    
    [UIView animateWithDuration:0.1f animations:^{
        self.rippleBackgroundView.alpha = 1.0f;
    }];
    
    self.rippleView.transform = CGAffineTransformMakeScale(0.5f, 0.5f);
    
    [UIView animateWithDuration:0.7f delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        self.rippleView.transform = CGAffineTransformIdentity;
    } completion:nil];
    
    return [super beginTrackingWithTouch:touch withEvent:event];
}

- (void)cancelTrackingWithEvent:(UIEvent *)event {
    [super cancelTrackingWithEvent:event];
    [self animateToNormal];
}

- (void)endTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event {
    [super endTrackingWithTouch:touch withEvent:event];
    [self animateToNormal];
}

- (void)animateToNormal {
    [UIView animateWithDuration:0.1f animations:^{
        self.rippleBackgroundView.alpha = 1.0f;
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.6f animations:^{
            self.rippleBackgroundView.alpha = 0.0f;
        }];
    }];
    
    [UIView animateWithDuration:0.7f delay:0.0f options:UIViewAnimationOptionCurveEaseOut | UIViewAnimationOptionBeginFromCurrentState animations:^{
        self.rippleView.transform = CGAffineTransformIdentity;
    } completion:nil];
}

@end