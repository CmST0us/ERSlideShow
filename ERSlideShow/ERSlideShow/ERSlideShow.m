//
//  ERSlideShow.m
//  ERSlideShow
//
//  Created by CmST0us on 17/4/24.
//  Copyright © 2017年 CmST0us. All rights reserved.
//

#import "ERSlideShow.h"

@interface ERAutoLayoutScrollView : UIScrollView
@property (nonatomic, readonly) UIView *contentView;
@end

@implementation ERAutoLayoutScrollView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _contentView = [[UIView alloc]init];
        [_contentView setTranslatesAutoresizingMaskIntoConstraints:NO];
        [self addSubview:_contentView];
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_contentView]|" options:NSLayoutFormatAlignAllTop metrics:nil views:NSDictionaryOfVariableBindings(_contentView)]];
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_contentView]|" options:NSLayoutFormatAlignAllTop metrics:nil views:NSDictionaryOfVariableBindings(_contentView)]];
        
        [self addSubview:_contentView];
    }
    return self;
}

- (instancetype)init {
    return [self initWithFrame:CGRectZero];
}

- (void)addSubview:(UIView *)view {
    if (view != _contentView) {
        [_contentView addSubview:view];
    } else {
        [super addSubview:view];
    }
}

@end

@interface ERSlideShow () {
    NSTimer *_autoScrollTimer;
}

@end

@implementation ERSlideShow

- (void)updateSlides {
    NSInteger slidesCount = [_slides count];
    //去除所有子视图
    [[_scrollView.contentView subviews]enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj removeFromSuperview];
    }];
    //去除contentView约束
    [[_scrollView constraints]enumerateObjectsUsingBlock:^(__kindof NSLayoutConstraint * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj firstItem] == _scrollView.contentView && [obj firstAttribute] == NSLayoutAttributeWidth) {
            [_scrollView removeConstraint:obj];
            *stop = YES;
        }
    }];
    //枚举添加slide试图, autolayout宽高
    UIView *cV;
    UIView *pV;
    if (_slides == NULL || [_slides count] == 0) {
        return;
    }
    cV = [_slides objectAtIndex:0];
    [cV setTranslatesAutoresizingMaskIntoConstraints:NO];
    [_scrollView addSubview:cV];
    [_scrollView addConstraint:[NSLayoutConstraint constraintWithItem:cV attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:_scrollView attribute:NSLayoutAttributeWidth multiplier:1 constant:0]];
    [_scrollView addConstraint:[NSLayoutConstraint constraintWithItem:cV attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:_scrollView attribute:NSLayoutAttributeHeight multiplier:1 constant:0]];
    [_scrollView addConstraint:[NSLayoutConstraint constraintWithItem:cV attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:_scrollView.contentView attribute:NSLayoutAttributeLeft multiplier:1 constant:0]];
    [_scrollView.contentView addConstraint:[NSLayoutConstraint constraintWithItem:cV attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:_scrollView.contentView attribute:NSLayoutAttributeTop multiplier:1 constant:0]];
    [_scrollView addConstraint:[NSLayoutConstraint constraintWithItem:_scrollView.contentView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:_scrollView attribute:NSLayoutAttributeWidth multiplier:slidesCount constant:0]];
    
    for (NSInteger i = 1; i < [_slides count]; ++i) {
        cV = [_slides objectAtIndex:i];
        pV = [_slides objectAtIndex:i - 1];
        if (cV == NULL) {
            break;
        }
        
        [cV setTranslatesAutoresizingMaskIntoConstraints:NO];
        [pV setTranslatesAutoresizingMaskIntoConstraints:NO];
        [_scrollView addSubview:cV];
        
        [_scrollView addConstraint:[NSLayoutConstraint constraintWithItem:cV attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:_scrollView attribute:NSLayoutAttributeWidth multiplier:1 constant:0]];
        [_scrollView addConstraint:[NSLayoutConstraint constraintWithItem:cV attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:_scrollView attribute:NSLayoutAttributeHeight multiplier:1 constant:0]];
        [_scrollView.contentView addConstraint:[NSLayoutConstraint constraintWithItem:cV attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:_scrollView.contentView attribute:NSLayoutAttributeTop multiplier:1 constant:0]];
        [_scrollView.contentView addConstraint:[NSLayoutConstraint constraintWithItem:cV attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:pV attribute:NSLayoutAttributeRight multiplier:1 constant:0]];
    }
    if (_slideShowMethod == ERSlideShowMethodLoop) {
        UIView *firstView = [NSKeyedUnarchiver unarchiveObjectWithData:[NSKeyedArchiver archivedDataWithRootObject:[_slides firstObject]]];
        UIView *lastView = [NSKeyedUnarchiver unarchiveObjectWithData:[NSKeyedArchiver archivedDataWithRootObject:[_slides lastObject]]];
        
        [firstView setTranslatesAutoresizingMaskIntoConstraints:NO];
        [lastView setTranslatesAutoresizingMaskIntoConstraints:NO];
        [_scrollView addSubview:firstView];
        [_scrollView addSubview:lastView];
        
        [_scrollView addConstraint:[NSLayoutConstraint constraintWithItem:firstView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:_scrollView attribute:NSLayoutAttributeWidth multiplier:1 constant:0]];
        [_scrollView addConstraint:[NSLayoutConstraint constraintWithItem:firstView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:_scrollView attribute:NSLayoutAttributeHeight multiplier:1 constant:0]];
        [_scrollView.contentView addConstraint:[NSLayoutConstraint constraintWithItem:firstView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:_scrollView.contentView attribute:NSLayoutAttributeTop multiplier:1 constant:0]];
        [_scrollView addConstraint:[NSLayoutConstraint constraintWithItem:lastView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:_scrollView attribute:NSLayoutAttributeWidth multiplier:1 constant:0]];
        [_scrollView addConstraint:[NSLayoutConstraint constraintWithItem:lastView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:_scrollView attribute:NSLayoutAttributeHeight multiplier:1 constant:0]];
        [_scrollView.contentView addConstraint:[NSLayoutConstraint constraintWithItem:lastView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:_scrollView.contentView attribute:NSLayoutAttributeTop multiplier:1 constant:0]];
        
        [_scrollView.contentView addConstraint:[NSLayoutConstraint constraintWithItem:lastView attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:_scrollView.contentView attribute:NSLayoutAttributeLeft multiplier:1 constant:0]];
        [_scrollView.contentView addConstraint:[NSLayoutConstraint constraintWithItem:firstView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:_scrollView.contentView attribute:NSLayoutAttributeRight multiplier:1 constant:0]];
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
    _canAutoScroll = YES;
    _autoScrollDuration = duration;
    _autoScrollTimer = [NSTimer scheduledTimerWithTimeInterval:_autoScrollDuration target:weakSelf selector:@selector(nextPage) userInfo:NULL repeats:YES];
}

- (void)stopAutoScroll {
    _canAutoScroll = NO;
    [_autoScrollTimer invalidate];
    _autoScrollTimer = NULL;
}

- (void)setupSlidesWithSlides:(NSArray *)slides showMethod:(ERSlideShowMethod)method{
    _slideShowMethod = method;
    if (slides == NULL) {
        _slides = [NSArray array];
    } else {
        _slides = [slides copy];
    }
}
- (void)setupMember {
    _slideShowMethod = ERSlideShowMethodLoop;
    _currentPage = 0;
    _autoScrollDuration = 2;
    _canAutoScroll = NO;
}
- (void)setupView {
    [self setLayoutMargins:UIEdgeInsetsMake(0, 0, 0, 0)];
}
- (void)setupScrollViewWithFram:(CGRect)frame {
    _scrollView = [[ERAutoLayoutScrollView alloc]initWithFrame:frame];
    [_scrollView setShowsHorizontalScrollIndicator:NO];
    [_scrollView setShowsVerticalScrollIndicator:NO];
    [_scrollView setAlwaysBounceHorizontal:YES];
    [_scrollView setAlwaysBounceVertical:NO];
    [_scrollView setBounces:NO];
    [_scrollView setDelegate:self];
    [_scrollView setPagingEnabled:YES];
    [_scrollView setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self addSubview:_scrollView];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_scrollView]|" options:NSLayoutFormatAlignAllLeading metrics:nil views:NSDictionaryOfVariableBindings(_scrollView)]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_scrollView]|" options:NSLayoutFormatAlignAllLeading metrics:nil views:NSDictionaryOfVariableBindings(_scrollView)]];

}

- (void)setupPageControl {
    _pageControl = [[UIPageControl alloc]init];
    [_pageControl setTranslatesAutoresizingMaskIntoConstraints:NO];
    [_pageControl setNumberOfPages:[_slides count]];
    [self addSubview:_pageControl];
    
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[_pageControl]-|" options:NSLayoutFormatAlignAllCenterX metrics:nil views:NSDictionaryOfVariableBindings(_pageControl)]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_pageControl attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterX multiplier:1 constant:0]];
}
- (instancetype)initWithFrame:(CGRect)frame slides:(NSArray *)slides showMethod:(ERSlideShowMethod)method delegate:(id<ERSlideShowDelegate>)delegate{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupMember];
        _delegate = delegate;
        [self setupSlidesWithSlides:slides showMethod:method];
        [self setupView];
        [self setupScrollViewWithFram:frame];
        [self setupPageControl];
        [self updateSlides];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame slides:(NSArray *)slides showMethod:(ERSlideShowMethod)method{
    return [self initWithFrame:frame slides:slides showMethod:method delegate:NULL];
}

- (instancetype)initWithFrame:(CGRect)frame {
    return [self initWithFrame:frame slides:NULL showMethod:ERSlideShowMethodLoop delegate:NULL];
}

- (instancetype)init {
    return [self initWithFrame:CGRectZero];
}
- (void)awakeFromNib {
    [self setupMember];
    [self setupSlidesWithSlides:NULL showMethod:ERSlideShowMethodLoop];
    [self setupView];
    [self setupScrollViewWithFram:CGRectZero];
    [self setupPageControl];
}
- (void)setSlides:(NSArray *)slides {
    _slides = [slides copy];
    [self updateSlides];
    [_pageControl setNumberOfPages:[slides count]];
}
- (void)setSlides:(NSArray *)slides showMethod:(ERSlideShowMethod)method {
    _slideShowMethod = method;
    [self setSlides:slides];
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
    __weak typeof(self) weakSelf = self;
    [_delegate slideShowDidSlideToPage:_currentPage slideShow:weakSelf];
    
    if (_canAutoScroll == YES) {
        _autoScrollTimer = [NSTimer scheduledTimerWithTimeInterval:_autoScrollDuration target:weakSelf selector:@selector(nextPage) userInfo:NULL repeats:YES];
        [[NSRunLoop mainRunLoop]addTimer:_autoScrollTimer forMode:NSRunLoopCommonModes];
    }
    
}

- (void)drawRect:(CGRect)rect {
    if (_slideShowMethod == ERSlideShowMethodJump) {
        [_scrollView setContentInset:UIEdgeInsetsMake(0, 0, 0, 0)];
    } else if (_slideShowMethod == ERSlideShowMethodLoop) {
        [_scrollView setContentInset:UIEdgeInsetsMake(0, [self frame].size.width, 0, [self frame].size.width)];
    }
    
}
@end
