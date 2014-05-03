#import <UIKit/UIKit.h>

@protocol ISScrollable;

typedef NS_ENUM(NSInteger, ISRefreshingState) {
    ISRefreshingStateNormal,
    ISRefreshingStateRefreshing,
    ISRefreshingStateRefreshed,
};

@interface ISAlternativeRefreshControl : UIControl

@property (nonatomic, readonly, getter=isRefreshing) BOOL refreshing;
@property (nonatomic, readonly) ISRefreshingState refreshingState;
@property (nonatomic, readonly) CGFloat progress;
@property (nonatomic) CGFloat threshold;
@property (nonatomic) BOOL firesOnRelease;
@property (nonatomic) BOOL stayOnTop;
@property (nonatomic, weak) id<ISScrollable> scrollTarget;

#pragma mark - actions

- (void)beginRefreshing;
- (void)endRefreshing;

#pragma mark - events

- (void)willChangeProgress:(CGFloat)progress;
- (void)didChangeProgress;

- (void)willChangeRefreshingState:(ISRefreshingState)refreshingState;
- (void)didChangeRefreshingState;

@end
