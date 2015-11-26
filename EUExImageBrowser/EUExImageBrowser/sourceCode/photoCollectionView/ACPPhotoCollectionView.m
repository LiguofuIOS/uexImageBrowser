//
//  ACPPhotoCollectionView.m
//  EUExImageBrowser
//
//  Created by appcan on 15/7/17.
//  Copyright (c) 2015年 xll. All rights reserved.
//

#import "ACPPhotoCollectionView.h"

#define KUEX_SCREEN_WIDTH ([UIScreen mainScreen].bounds.size.width)
#define KUEX_SCREEN_HEIGHT ([UIScreen mainScreen].bounds.size.height)
#define KUEX_LEFTBTNTAG   10011024
#define KUEX_RIGHTBTNTAG  10021024

@implementation ACPPhotoCollectionView


-(void)openPhotoCollectionViewWithSet:(NSMutableArray *)imageSet startIndex:(int)sIndex {
    
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];
    
    self.imageSetArr = imageSet;
    UICollectionViewFlowLayout *flowlay = [[UICollectionViewFlowLayout alloc]init];
    _photoCollectionview = [[UICollectionView alloc] initWithFrame:CGRectMake(0 ,0, KUEX_SCREEN_WIDTH, KUEX_SCREEN_HEIGHT) collectionViewLayout:flowlay];
    _photoCollectionview.contentSize = CGSizeMake(KUEX_SCREEN_WIDTH*(_imageSetArr.count), KUEX_SCREEN_HEIGHT);
    
    
    _photoCollectionview.contentOffset = CGPointMake(KUEX_SCREEN_WIDTH*sIndex, 0);
    [flowlay setScrollDirection:UICollectionViewScrollDirectionHorizontal];
    [flowlay release];
    
    _photoCollectionview.delegate = self;
    _photoCollectionview.dataSource = self;
    _photoCollectionview.scrollEnabled = YES;
    _photoCollectionview.pagingEnabled = YES;
    _photoCollectionview.showsVerticalScrollIndicator = NO;
    _photoCollectionview.showsHorizontalScrollIndicator = NO;
    //_photoCollectionview.layer.borderColor = [UIColor greenColor].CGColor;
    //_photoCollectionview.layer.borderWidth = 1;
    
    [self createTitleView:sIndex];
    [self.view addSubview:_photoCollectionview];
    [self.view addSubview:_titleView];
    [self.view addSubview:_bottomToobar];
    
    [EUtility brwView:_euexImageBrowserObj.meBrwView presentModalViewController:self animated:YES];
    //    [EUtility brwView:_euexImageBrowserObj.meBrwView addSubview:_photoCollectionview];
    //    [EUtility brwView:_euexImageBrowserObj.meBrwView addSubview:_titleView];
    //    [EUtility brwView:_euexImageBrowserObj.meBrwView addSubview:_bottomToobar];
    
    [_photoCollectionview registerClass:[ACPPhotoCollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
    
}

#pragma mark -- UICollectionViewDataSource

//定义展示的UICollectionViewCell的个数
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {

    return 1;
    
}

//定义展示的Section的个数
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {

    return _imageSetArr.count;
}

//每个UICollectionView展示的内容
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *cellIdentifier = @"cell";
    ACPPhotoCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
     
    cell.delegate = self;
    //[cell sizeToFit];
    NSString *imagePath = [_euexImageBrowserObj absPath:[_imageSetArr objectAtIndex:indexPath.row+indexPath.section]];
    UIImage *placeholderImg = [UIImage imageNamed:@"uexImageBrowser/photoDefault"];
    
    if([imagePath hasPrefix:@"http://"]) {
        if ([self respondsToSelector:@selector(sd_setImageWithURL:placeholderImage:)]) {
            
            [cell.imgView sd_setImageWithURL:[NSURL URLWithString:imagePath] placeholderImage:placeholderImg];
            
        } else {
            
            [cell.imgView setImageWithURL:[NSURL URLWithString:imagePath] placeholderImage:placeholderImg];
            
        }
        
    } else {
        
        UIImage *imageview = [UIImage imageWithData:[self getImageDataByPath:imagePath]];
        
        if (imageview) {
            
            [cell.imgView setImage:imageview];
            
        } else {
            
            [cell.imgView setImage:placeholderImg];
            
        }
   
    }
    
    return cell;
}

#pragma mark --UICollectionViewDelegateFlowLayout

//定义每个UICollectionView 的大小

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    return CGSizeMake(KUEX_SCREEN_WIDTH, KUEX_SCREEN_HEIGHT);
}

//定义每个UICollectionView 的 margin

-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    
     return UIEdgeInsetsMake(0, 0, 0, 0);
}

-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    
    return 0;
}

#pragma mark --UICollectionViewDelegate
//UICollectionView被选中时调用的方法

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    NSLog(@"你点击了第%ld个图片",(long)(indexPath.section+indexPath.row));
    
}

//返回这个UICollectionView是否可以被选择

-(BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    return YES;
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    
    _currentIndex = scrollView.contentOffset.x/KUEX_SCREEN_WIDTH;
    if (_currentIndex <= 0) {
        
        _leftBtn.enabled = NO;
        
    } else {
        
        _leftBtn.enabled = YES;
        
    }
    
    if (_currentIndex >= _imageSetArr.count - 1) {
        
        _rightBtn.enabled = NO;
        
    } else {
        
        _rightBtn.enabled = YES;
        
    }
    
    _photoIndexStr = [NSString stringWithFormat:@"%ld/%ld",(long)(_currentIndex+1),(long)_imageSetArr.count];
    
    _titleLabel.text = _photoIndexStr;
    
    if (_titleView.hidden == NO) {
        
        [self showView];
        
    }
    
}

- (void)createTitleView:(int)sIndex {
    
    _currentIndex = sIndex;
    
    _titleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, KUEX_SCREEN_WIDTH, 60)];
    _titleView.backgroundColor = [UIColor blackColor];
    _titleLabel.alpha = 0.7;
    
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    
    backBtn.frame = CGRectMake(5, 20, 40, 40);
    [backBtn setTitle:@"返回" forState:UIControlStateNormal];
    
    [backBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(backBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(KUEX_SCREEN_WIDTH/2-50, 20, 100, 40)];
    _photoIndexStr = [NSString stringWithFormat:@"%d/%ld",sIndex+1,(long)_imageSetArr.count];
    [_titleLabel setBackgroundColor:[UIColor clearColor]];
    [_titleLabel setTextColor:[UIColor whiteColor]];
    _titleLabel.textAlignment=NSTextAlignmentCenter;
    _titleLabel.text = _photoIndexStr;
    
    [_titleView addSubview:backBtn];
    [_titleView addSubview:_titleLabel];
    
    _bottomToobar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, KUEX_SCREEN_HEIGHT - 60, KUEX_SCREEN_WIDTH, 60)];
    
    [_bottomToobar setBarStyle:UIBarStyleBlack];
    
    _leftBtn = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"uexImageBrowser/previousIcon"] style:UIBarButtonItemStylePlain target:self action:@selector(bottomToobarBtnClick:)];
    _leftBtn.tag = KUEX_LEFTBTNTAG;
    
    UIBarButtonItem *flexibleSpace = [[UIBarButtonItem alloc]
                                      initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    
    
    _rightBtn = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"uexImageBrowser/nextIcon"] style:UIBarButtonItemStylePlain target:self action:@selector(bottomToobarBtnClick:)];
    
    _rightBtn.tag = KUEX_RIGHTBTNTAG;
    
    [_bottomToobar setItems:[NSArray arrayWithObjects:flexibleSpace, _leftBtn, flexibleSpace, _rightBtn,flexibleSpace, nil]];
    
    if (_currentIndex + 1 == _imageSetArr.count) {
        
        _rightBtn.enabled = NO;
        //return;
    }
    if (_currentIndex == 0) {
        
        _leftBtn.enabled = NO;
        
    }

    
}

- (void)bottomToobarBtnClick:(UIButton *)btn {
    
    if (_rightBtn.enabled == NO) {
        
        _rightBtn.enabled = YES;
        
    }
    
    if (btn.tag == KUEX_LEFTBTNTAG) {
        
        if (_currentIndex - 1 <= 0) {
            
            _leftBtn.enabled = NO;
            //return;
            
        }
        _currentIndex = _currentIndex - 1;
        
        [_photoCollectionview setContentOffset:CGPointMake(KUEX_SCREEN_WIDTH * _currentIndex, 0) animated:YES];
        
        
    }
    
    if (btn.tag == KUEX_RIGHTBTNTAG) {
        
        if (_leftBtn.enabled == NO) {
            
            _leftBtn.enabled =YES;
            
        }
        
        if (_currentIndex + 1 >= _imageSetArr.count - 1) {
            
            _rightBtn.enabled = NO;
            //return;
        }
        _currentIndex = _currentIndex + 1;
        
        [_photoCollectionview setContentOffset:CGPointMake(KUEX_SCREEN_WIDTH * _currentIndex, 0) animated:YES];
        
    }
    
    
    _photoIndexStr = [NSString stringWithFormat:@"%ld/%ld",(long)(_currentIndex+1),(long)_imageSetArr.count];
    _titleLabel.text = _photoIndexStr;
    
}

- (NSData *)getImageDataByPath:(NSString *)imagePath {
    
    NSData *imageData = nil;
    
    if ([imagePath hasPrefix:@"http://"]) {
        
        NSURL *imagePathURL = [NSURL URLWithString:imagePath];
        imageData = [NSData dataWithContentsOfURL:imagePathURL];
        
    } else {
        
        imageData = [NSData dataWithContentsOfFile:imagePath];
        
    }
    
    return imageData;
    
}

- (void)backBtnClick:(id)sender {
    
    [self dismissViewControllerAnimated:YES completion:^{
        
        [_photoCollectionview removeFromSuperview];
        [_titleView removeFromSuperview];
        [_bottomToobar removeFromSuperview];
        
    }];
    
}


- (void)showView {
    
    BOOL isShowStatus = _titleView.hidden;
    
        if (isShowStatus) {
    
            [ UIView animateWithDuration:0.5 animations:^{
    
                [_titleView setHidden:NO];
                [_bottomToobar setHidden:NO];
                
                [[UIApplication sharedApplication] setStatusBarHidden:NO];

    
            }];
    
    
        } else {
    
            [ UIView animateWithDuration:0.5 animations:^{
    
                [_titleView setHidden:YES];
                [_bottomToobar setHidden:YES];
                
                [[UIApplication sharedApplication] setStatusBarHidden:YES];

                
            }];
            
        }
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation

{
    
    return (toInterfaceOrientation == UIInterfaceOrientationPortrait);
    
}

- (BOOL)shouldAutorotate

{
    
    return NO;
    
}

- (NSUInteger)supportedInterfaceOrientations

{
    
    return UIInterfaceOrientationMaskPortrait;//只支持这一个方向(正常的方向)
    
}
- (void)dealloc {
    
    if (_imageSetArr) {
        [_imageSetArr removeAllObjects];
    }
    
    if (_photoCollectionview) {
        _photoCollectionview.dataSource = nil;
        _photoCollectionview.delegate = nil;
        [_photoCollectionview release];
    }
    
    if (_titleLabel) {
        [_titleLabel release];
        _titleLabel = nil;
    }
    
    if (_titleView) {
        [_titleView release];
        _titleView = nil;
    }
    
    if (_bottomToobar) {
        
        [_bottomToobar release];
        _bottomToobar = nil;
    }
    
    [super dealloc];
}

@end
