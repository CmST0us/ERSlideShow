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
    ERSlideShow *_slideShow;
}
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
    
    NSArray *ar = @[lb1, lb2, lb3, lb4];
    _slideShow = [[ERSlideShow alloc]initWithFrame:CGRectMake(0, 0, 200, 100) slides:ar];
    [_slideShow setDelegate:self];
    [_slideShow setAutoScrollDuration:2.0];
//    [_slideShow setSlideShowMethod:ERSlideShowMethodJump];
    [_slideShow setFrame:[UIScreen mainScreen].bounds];
    [self.view addSubview:_slideShow];
    [_slideShow autoScrollWithDuration:2.0];
    // Do any additional setup after loading the view, typically from a nib.
}


- (void)slideShowDidSlideToPage:(NSInteger)page slideShow:(ERSlideShow *)slideShow {
    NSLog(@"slide to page %d", page);
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
