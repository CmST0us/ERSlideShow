//
//  ViewController.m
//  ERSlideShow
//
//  Created by CmST0us on 17/4/24.
//  Copyright © 2017年 CmST0us. All rights reserved.
//
#import "ViewController.h"
#import "ERSlideShow/ERSlideShow.h"
@interface ViewController (){
    ERSlideShow *_slideShow2;
    ERSlideShow *_slideShow3;
}
@property (strong, nonatomic) IBOutlet ERSlideShow *slideShow;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UILabel *lb1 = [[UILabel alloc]initWithFrame:CGRectZero];
    [lb1 setBackgroundColor:[UIColor brownColor]];
    UILabel *lb2 = [[UILabel alloc]initWithFrame:CGRectZero];
    [lb2 setBackgroundColor:[UIColor redColor]];
    UILabel *lb3 = [[UILabel alloc]initWithFrame:CGRectZero];
    [lb3 setBackgroundColor:[UIColor grayColor]];
    UILabel *lb4 = [[UILabel alloc]initWithFrame:CGRectZero];
    [lb4 setBackgroundColor:[UIColor greenColor]];
    
    UILabel *lb11 = [[UILabel alloc]initWithFrame:CGRectZero];
    [lb11 setBackgroundColor:[UIColor brownColor]];
    UILabel *lb12 = [[UILabel alloc]initWithFrame:CGRectZero];
    [lb12 setBackgroundColor:[UIColor redColor]];
    UILabel *lb13 = [[UILabel alloc]initWithFrame:CGRectZero];
    [lb13 setBackgroundColor:[UIColor grayColor]];
    UILabel *lb14 = [[UILabel alloc]initWithFrame:CGRectZero];
    [lb14 setBackgroundColor:[UIColor greenColor]];
    
    UILabel *lb21 = [[UILabel alloc]initWithFrame:CGRectZero];
    [lb21 setBackgroundColor:[UIColor brownColor]];
    UILabel *lb22 = [[UILabel alloc]initWithFrame:CGRectZero];
    [lb22 setBackgroundColor:[UIColor redColor]];
    UILabel *lb23 = [[UILabel alloc]initWithFrame:CGRectZero];
    [lb23 setBackgroundColor:[UIColor grayColor]];
    UILabel *lb24 = [[UILabel alloc]initWithFrame:CGRectZero];
    [lb24 setBackgroundColor:[UIColor greenColor]];
    
    //从StoryBoard创建
    [_slideShow setSlideShowMethod:ERSlideShowMethodLoop];
    [_slideShow setSlides:@[lb1, lb2, lb3, lb4]];
    [_slideShow setDelegate:self];
    [_slideShow autoScrollWithDuration:2.0];
    
    //代码构建
    _slideShow2 = [[ERSlideShow alloc]initWithFrame:CGRectMake(0, 400, 200, 100)];
    [_slideShow2 setSlides:@[lb11, lb12, lb13, lb14]];
    [_slideShow2 setDelegate:self];
    [_slideShow2 setSlideShowMethod:ERSlideShowMethodLoop];
    [_slideShow2 autoScrollWithDuration:2.0];
    [self.view addSubview:_slideShow2];
    
    _slideShow3 = [[ERSlideShow alloc]init];
    [_slideShow3 setSlides:@[lb21, lb22, lb23, lb24] showMethod:ERSlideShowMethodJump];
    [_slideShow3 setDelegate:self];
    [_slideShow3 autoScrollWithDuration:2.0];
    [_slideShow3 setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.view addSubview:_slideShow3];
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[_slideShow3(==100)]-(8)-|" options:NSLayoutFormatAlignAllLeading metrics:nil views:NSDictionaryOfVariableBindings(_slideShow3)]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(8)-[_slideShow3(==200)]" options:NSLayoutFormatAlignAllLeading metrics:nil views:NSDictionaryOfVariableBindings(_slideShow3)]];
    
    // Do any additional setup after loading the view, typically from a nib.
}


- (void)slideShowDidSlideToPage:(NSInteger)page slideShow:(ERSlideShow *)slideShow {
    NSLog(@"slide to page %ld", (long)page);
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
