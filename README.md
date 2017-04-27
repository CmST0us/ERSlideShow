# ERSlideShow

ERSlideShow 是一款iOS平台能支持Auto Layout的轮播组件

## 特性
1. 支持使用Interface Builder可视化Auto Layout创建实例
2. 支持使用传统`initWithFrame:`创建实例
3. 支持使用`addConstraints:`添加约束

## 示例

```
//从StoryBoard创建
    [_slideShow setSlides:@[lb1, lb2, lb3, lb4]];
    [_slideShow setDelegate:self];
    [_slideShow setSlideShowMethod:ERSlideShowMethodLoop];
    [_slideShow autoScrollWithDuration:2.0];
```

```
//代码构建
    _slideShow2 = [[ERSlideShow alloc]initWithFrame:CGRectMake(0, 400, 200, 100)];
    [_slideShow2 setSlides:@[lb11, lb12, lb13, lb14]];
    [_slideShow2 setDelegate:self];
    [_slideShow2 setSlideShowMethod:ERSlideShowMethodLoop];
    [_slideShow2 autoScrollWithDuration:2.0];
    [self.view addSubview:_slideShow2];
```

```    
    _slideShow3 = [[ERSlideShow alloc]init];
    [_slideShow3 setSlides:@[lb21, lb22, lb23, lb24] showMethod:ERSlideShowMethodJump];
    [_slideShow3 setDelegate:self];
    [_slideShow3 autoScrollWithDuration:2.0];
    [_slideShow3 setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.view addSubview:_slideShow3];
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[_slideShow3(==100)]-(8)-|" options:NSLayoutFormatAlignAllLeading metrics:nil views:NSDictionaryOfVariableBindings(_slideShow3)]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(8)-[_slideShow3(==200)]" options:NSLayoutFormatAlignAllLeading metrics:nil views:NSDictionaryOfVariableBindings(_slideShow3)]];
```

----------------
欢迎指出问题

`CmST0us`
