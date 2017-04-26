//
//  ERSlideShow.m
//  ERSlideShow
//
//  Created by CmST0us on 17/4/24.
//  Copyright © 2017年 CmST0us. All rights reserved.
//

#import "ERSlideShow.h"

@interface ERSlideShow () {
    NSTimer *_autoScrollTimer;
}

@end

@implementation ERSlideShow

- (void)reloadFakeSlides {
    CGRect slideShowFrame = [self frame];
    NSInteger slidesCount = [_slides count];
    //添加最左最右的slide
    //从_slide深拷贝对象
    UIView *firstView = [NSKeyedUnarchiver unarchiveObjectWithData:[NSKeyedArchiver archivedDataWithRootObject:[_slides firstObject]]];
    UIView *lastView = [NSKeyedUnarchiver unarchiveObjectWithData:[NSKeyedArchiver archivedDataWithRootObject:[_slides lastObject]]];
    //放置
    CGRect leftViewFrame = CGRectMake(- slideShowFrame.size.width, 0, slideShowFrame.size.width, slideShowFrame.size.height);
    [lastView setFrame:leftViewFrame];
    [_scrollView addSubview:lastView];
    
    CGRect rightViewFrame = CGRectMake(slidesCount * slideShowFrame.size.width, 0, slideShowFrame.size.width, slideShowFrame.size.height);
    [firstView setFrame:rightViewFrame];
    [_scrollView addSubview:firstView];
    
    //设置移动范围
    [_scrollView setContentSize:CGSizeMake(slidesCount * slideShowFrame.size.width, slideShowFrame.size.height)];
    [_scrollView setContentInset:UIEdgeInsetsMake(0, slideShowFrame.size.width, 0, slideShowFrame.size.width)];
}

- (void)reloadSlides {
    CGRect slideShowFrame = [self frame];
    NSInteger slidesCount = [_slides count];
    //去除所有子视图
    [[_scrollView subviews]enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj removeFromSuperview];
    }];
    
    //重新由slides添加
    for (UIView *v in _slides) {
        [_scrollView addSubview:v];
    }
    //排列
    [_scrollView.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        CGRect objFrame = [obj frame];
        objFrame.size.height = slideShowFrame.size.height;
        objFrame.size.width = slideShowFrame.size.width;
        objFrame.origin.y = 0;
        objFrame.origin.x = idx * slideShowFrame.size.width;
        [obj setFrame:objFrame];
    }];
    //设置移动范围
    [_scrollView setContentSize:CGSizeMake(slidesCount * slideShowFrame.size.width, slideShowFrame.size.height)];
    [_scrollView setContentInset:UIEdgeInsetsMake(0, 0, 0, 0)];
    
    if (_slideShowMethod == ERSlideShowMethodLoop) {
        [self reloadFakeSlides];
    }
    
}

- (void)nextPage {
    __weak typeof(self) weakSelf = self;
    _currentPage = [_scrollView contentOffset].x / [weakSelf frame].size.width;
    CGRect slideShowFrame = [weakSelf frame];
    NSInteger slideCount = [_slides count];
    NSInteger nextPage = _currentPage;
    
    if (_slideShowMethod == ERSlideShowMethodLoop) {
        nextPage++;
        [_scrollView setContentOffset:CGPointMake(nextPage * slideShowFrame.size.width, 0) animated:YES];
        [_delegate slideShowDidSlideToPage:nextPage == slideCount ? 0 : nextPage slideShow:weakSelf];
    }else if (_slideShowMethod == ERSlideShowMethodJump) {
        nextPage + 1 >= [_slides count] ? nextPage = 0 : nextPage++;
        [_scrollView setContentOffset:CGPointMake(nextPage * slideShowFrame.size.width, 0) animated:YES];
        [_delegate slideShowDidSlideToPage:nextPage slideShow:weakSelf];
    }
    
}

- (void)autoScroll {
    [self autoScrollWithDuration:_autoScrollDuration];
}
- (void)autoScrollWithDuration:(NSTimeInterval)duration {
    __weak typeof(self) weakSelf = self;
    _autoScrollDuration = duration;
    _autoScrollTimer = [NSTimer scheduledTimerWithTimeInterval:_autoScrollDuration target:weakSelf selector:@selector(nextPage) userInfo:NULL repeats:YES];
}
- (instancetype)initWithFrame:(CGRect)frame slides:(NSArray *)slides delegate:(id<ERSlideShowDelegate>)delegate{
    self = [super initWithFrame:frame];
    if (self) {
        _slides = [slides copy];
        _currentPage = 0;
        _slideShowMethod = ERSlideShowMethodLoop;
        _delegate = delegate;
        _autoScrollDuration = 2;
        
        _scrollView = [[UIScrollView alloc]initWithFrame:frame];
        [_scrollView setShowsHorizontalScrollIndicator:NO];
        [_scrollView setShowsVerticalScrollIndicator:NO];
        [_scrollView setAlwaysBounceHorizontal:YES];
        [_scrollView setAlwaysBounceVertical:NO];
        [_scrollView setBounces:NO];
        [_scrollView setDelegate:self];
        [_scrollView setPagingEnabled:YES];
        [self addSubview:_scrollView];
        //TODO
        _pageControl = [[UIPageControl alloc]initWithFrame:CGRectMake(frame.size.width / 2, frame.size.height / 2, 50, 10)];
        [_pageControl setNumberOfPages:[slides count]];
        [self addSubview:_pageControl];
        
        [self reloadSlides];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame slides:(NSArray *)slides {
    return [self initWithFrame:frame slides:slides delegate:NULL];
}
- (instancetype)initWithFrame:(CGRect)frame {
    return [self initWithFrame:frame slides:[NSArray array] delegate:NULL];
}

- (instancetype)init {
    return [self initWithFrame:CGRectZero];
}

- (void)setFrame:(CGRect)frame {
    [super setFrame:frame];
    
    [_scrollView setFrame:frame];
    [_pageControl setFrame:CGRectMake(frame.size.width / 2, frame.size.height / 2, 50, 10)];
    [self reloadSlides];
}

- (void)setSlides:(NSArray *)slides {
    _slides = [slides copy];
    [self reloadSlides];
    [_pageControl setNumberOfPages:[slides count]];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [_autoScrollTimer invalidate];
    _autoScrollTimer = NULL;
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    _currentPage = [scrollView contentOffset].x / [self frame].size.width;
    [_pageControl setCurrentPage:_currentPage];
    if (_currentPage == [_slides count]) {
        _currentPage = 0;
        [_scrollView setContentOffset:CGPointMake(0, 0) animated:NO];
    } else if (_currentPage == -1) {
        _currentPage = [_slides count] - 1;
        [_scrollView setContentOffset:CGPointMake([self frame].size.width * ([_slides count] - 1), 0) animated:NO];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    [_delegate slideShowDidSlideToPage:_currentPage slideShow:self];
    __weak typeof(self) weakSelf = self;
    _autoScrollTimer = [NSTimer scheduledTimerWithTimeInterval:_autoScrollDuration target:weakSelf selector:@selector(nextPage) userInfo:NULL repeats:YES];
    
    
}
@end
