#import "ISAlternativeRefreshControl.h"
#import "ISScrollable.h"

@interface ISAlternativeRefreshControl ()

@property (nonatomic) ISRefreshingState refreshingState;
@property (nonatomic) CGFloat progress;
@property (nonatomic) BOOL didOverThreshold;

@end

@implementation ISAlternativeRefreshControl

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.threshold = -90.f;
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        self.threshold = -90.f;
    }
    return self;
}

#pragma mark - accessors

- (BOOL)isRefreshing
{
    return self.refreshingState == ISRefreshingStateRefreshing;
}

- (void)setScrollTarget:(id<ISScrollable>)scrollTarget {
    [(id)self.scrollTarget removeObserver:self forKeyPath:@"contentOffset"];

    _scrollTarget = scrollTarget;

    [(id)self.scrollTarget addObserver:self forKeyPath:@"contentOffset" options:0 context:NULL];
}

#pragma mark - UIView events

- (void)willMoveToSuperview:(UIView *)newSuperview
{
    if ([self.superview isKindOfClass:[UIScrollView class]]) {
        self.scrollTarget = nil;
    }
}

- (void)didMoveToSuperview
{
    if ([self.superview isKindOfClass:[UIScrollView class]]) {
        self.scrollTarget = (id)self.superview;
    }
}

#pragma mark - KVO

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if (object == self.scrollTarget && [keyPath isEqualToString:@"contentOffset"]) {
        [self.superview bringSubviewToFront:self];
        [self keepOnTop];
        [self updateRefreshingState];
        [self updateProgress];
    } else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

#pragma mark - contentOffset actions

- (void)keepOnTop
{
    if (!self.scrollTarget || !self.stayOnTop) {
        return;
    }

    CGFloat offset = self.scrollTarget.contentOffset.y;
    if (offset < -self.frame.size.height) {
        self.frame = CGRectMake(0.f, offset, self.frame.size.width, self.frame.size.height);
    } else {
        self.frame = CGRectMake(0.f, -self.frame.size.height, self.frame.size.width, self.frame.size.height);
    }
}

- (void)updateProgress
{
    if (!self.scrollTarget) {
        return;
    }
    
    CGFloat progress = self.scrollTarget.contentOffset.y / self.threshold;
    [self willChangeProgress:progress];
    [self setProgress:progress];
    [self didChangeProgress];
}

- (void)updateRefreshingState
{
    if (!self.scrollTarget) {
        return;
    }

    CGFloat offset = self.scrollTarget.contentOffset.y;
    
    switch (self.refreshingState) {
        case ISRefreshingStateNormal:
            if (self.firesOnRelease) {
                if (self.scrollTarget.isTracking) {
                    self.didOverThreshold = offset < self.threshold;
                } else {
                    if (self.didOverThreshold) {
                        self.didOverThreshold = NO;
                        [self beginRefreshing];
                        [self sendActionsForControlEvents:UIControlEventValueChanged];
                    }
                }
            } else {
                if (offset < self.threshold) {
                    [self beginRefreshing];
                    [self sendActionsForControlEvents:UIControlEventValueChanged];
                }
            }
            break;
            
        case ISRefreshingStateRefreshed:
            if (offset >= 0.f && !self.scrollTarget.isTracking) {
                [self resetRefreshingState];
            }
            break;
            
        default: break;
    }
}

#pragma mark -

// ISRefreshingStateNormal -> ISRefreshingStateRefreshing,
- (void)beginRefreshing
{
    if (!self.scrollTarget) {
        return;
    }

    [self willChangeRefreshingState:ISRefreshingStateRefreshing];
    self.refreshingState = ISRefreshingStateRefreshing;
    
    UIEdgeInsets inset = self.scrollTarget.contentInset;
    inset.top += self.frame.size.height;
    
    [UIView animateWithDuration:.3f
                     animations:^{
                         self.scrollTarget.contentInset = inset;
                     }
                     completion:^(BOOL finished) {
                         [self didChangeRefreshingState];
                     }];
}

// ISRefreshingStateRefreshing -> ISRefreshingStateRefreshed,
- (void)endRefreshing
{
    if (!self.scrollTarget) {
        return;
    }
    
    [self willChangeRefreshingState:ISRefreshingStateRefreshed];
    
    CGFloat offset = self.scrollTarget.contentOffset.y;
    UIEdgeInsets inset = self.scrollTarget.contentInset;
    inset.top -= self.frame.size.height;
    
    [UIView animateWithDuration:.3f
                     animations:^{
                         self.scrollTarget.contentInset = inset;
                     }
                     completion:^(BOOL finished) {
                         self.refreshingState = ISRefreshingStateRefreshed;
                         [self didChangeRefreshingState];
                         
                         if (offset <= 0.f) {
                             [self didChangeRefreshingState];
                             [self resetRefreshingState];
                         }
                     }];
}

// ISRefreshingStateRefreshed -> ISRefreshingStateNormal
- (void)resetRefreshingState
{
    [self willChangeRefreshingState:ISRefreshingStateNormal];
    self.refreshingState = ISRefreshingStateNormal;
    [self didChangeRefreshingState];
}

#pragma mark - ISAlternativeRefreshControl events

- (void)willChangeProgress:(CGFloat)progress
{
}

- (void)didChangeProgress
{
}

- (void)willChangeRefreshingState:(ISRefreshingState)refreshingState
{
}

- (void)didChangeRefreshingState
{
}

@end
