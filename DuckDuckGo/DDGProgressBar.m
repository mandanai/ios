//
//  DDGProgressBar.m
//  DuckDuckGo
//
//  Created by Sean Reilly on 07/07/2015.
//
//


#import "DDGProgressBar.h"
#import "UIColor+DDG.h"

@interface DDGProgressBar ()
{
    NSUInteger _percentCompleted;
}

@property (nonatomic, strong) UIView* completedView;

@end

@implementation DDGProgressBar


- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (void)commonInit {
    _percentCompleted = 100;
    self.backgroundColor = [UIColor duckProgressBarBackground];
    [self addSubview:self.completedView];
    [self updateProgress];
    //[self setNeedsLayout];
}

-(void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    [self updateProgress];
}

-(void)updateProgress
{
    [self updateProgressWithDuration:0.25];
}

-(void)updateProgressWithDuration:(NSTimeInterval)duration
{
    NSUInteger progress = MIN(MAX(0, _percentCompleted), 100);
    CGRect frame = self.frame;
    frame.origin.x = 0;
    frame.origin.y = 0;
    frame.size.width = (progress/100.0) * frame.size.width;
    
    if(self.completedView==nil) {
        self.completedView = [[UIView alloc] initWithFrame:frame];
        self.completedView.backgroundColor = [UIColor duckProgressBarForeground];
    }
    if(duration!=0) {
        [UIView animateWithDuration:duration animations:^{
            [self.completedView setFrame:frame];
        }];
    } else {
        [self.completedView setFrame:frame];
    }
    [self setNeedsDisplay];
}

-(void)setPercentCompleted:(NSUInteger)percentCompleted
{
    if(_percentCompleted!=percentCompleted) {
        BOOL didIncrease = percentCompleted > _percentCompleted;
        _percentCompleted = percentCompleted;
        [self updateProgressWithDuration: didIncrease ? 0.25 : 0];
    }
}

-(NSUInteger)percentCompleted
{
    return _percentCompleted;
}


/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */



@end
