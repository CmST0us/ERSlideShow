//
//  ERSlideShow.h
//  ERSlideShow
//
//  Created by CmST0us on 17/4/24.
//  Copyright © 2017年 CmST0us. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ERSlideShow;
@protocol ERSlideShowDelegate <NSObject>

@optional
- (void)slideShowDidSlideToPage:(NSInteger)page slideShow:(ERSlideShow *)slideShow;

@end

typedef NS_ENUM(NSUInteger, ERSlideShowMethod) {
    ERSlideShowMethodLoop, /*  Default  */
    ERSlideShowMethodJump,
    ERSlideShowMethodSingle,
};

@interface ERSlideShow : UIView<UIScrollViewDelegate>

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, copy) NSArray *slides;
@property (nonatomic, readonly, assign) NSInteger currentPage;
@property (nonatomic, assign) NSTimeInterval autoScrollDuration;
@property (nonatomic, assign) ERSlideShowMethod slideShowMethod;
@property (nonatomic, weak) id<ERSlideShowDelegate> delegate;
@property (nonatomic, strong) UIPageControl *pageControl;

- (instancetype)initWithFrame:(CGRect)frame;
- (instancetype)initWithFrame:(CGRect)frame slides:(NSArray *)slides;
- (instancetype)initWithFrame:(CGRect)frame slides:(NSArray *)slides delegate:(id<ERSlideShowDelegate>)delegate;

- (void)autoScrollWithDuration:(NSTimeInterval)duration;
- (void)autoScroll;
@end


