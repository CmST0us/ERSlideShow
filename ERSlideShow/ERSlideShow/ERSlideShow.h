//
//  ERSlideShow.h
//  ERSlideShow
//
//  Created by CmST0us on 17/4/24.
//  Copyright © 2017年 CmST0us. All rights reserved.
//


/*
    ERSlideShow 是一个支持Auto Layout的轮播组件
 */


#import <UIKit/UIKit.h>

@class ERSlideShow;
@class ERAutoLayoutScrollView;
@protocol ERSlideShowDelegate <NSObject>

@optional
//跳转下一页回调
- (void)slideShowDidSlideToPage:(NSInteger)page slideShow:(ERSlideShow *)slideShow;
@end

typedef NS_ENUM(NSUInteger, ERSlideShowMethod) {
    ERSlideShowMethodLoop, /*  Default  无限轮播*/
    ERSlideShowMethodJump, /* 播放到最后向前跳转到最前 */
//    ERSlideShowMethodSingle,
};

@interface ERSlideShow : UIView<UIScrollViewDelegate>

@property (nonatomic, readonly) ERAutoLayoutScrollView *scrollView;
@property (nonatomic, copy) NSArray *slides;
@property (nonatomic, readonly, assign) NSInteger currentPage;
@property (nonatomic, assign) NSTimeInterval autoScrollDuration;
@property (nonatomic, assign) ERSlideShowMethod slideShowMethod;
@property (nonatomic, weak) id<ERSlideShowDelegate> delegate;
@property (nonatomic, readonly) UIPageControl *pageControl;
@property (nonatomic, assign) BOOL canAutoScroll;

- (instancetype)initWithFrame:(CGRect)frame;
- (instancetype)initWithFrame:(CGRect)frame slides:(NSArray *)slides showMethod:(ERSlideShowMethod)method;
- (instancetype)initWithFrame:(CGRect)frame slides:(NSArray *)slides showMethod:(ERSlideShowMethod)method delegate:(id<ERSlideShowDelegate>)delegate;

//设置轮播试图， 并指定轮播方式，推荐之用此方法设置
- (void)setSlides:(NSArray *)slides showMethod:(ERSlideShowMethod)method;
//以duration周期开启轮播
- (void)autoScrollWithDuration:(NSTimeInterval)duration;
//开启轮播, 周期为成员变量 autoScrollDuration
- (void)autoScroll;
//停止轮播
- (void)stopAutoScroll;
@end


