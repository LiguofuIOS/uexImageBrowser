//
//  ACPPhotoCollectionView.m
//  EUExImageBrowser
//
//  Created by liguofu on 15/7/17.
//  Copyright (c) 2015年 xll. All rights reserved.
//

#import "ACPPhotoCollectionView.h"
#define KUEX_SCREEN_WIDTH ([UIScreen mainScreen].bounds.size.width)
#define KUEX_SCREEN_HEIGHT ([UIScreen mainScreen].bounds.size.height)

@implementation ACPPhotoCollectionView

-(void)openPhotoCollectionViewWithSet:(NSMutableArray *)imageSet startIndex:(int)sIndex {
    
    // [[UIApplication sharedApplication] setStatusBarHidden:YES];
    self.imageSetArr = imageSet;
    UICollectionViewFlowLayout *flowlay = [[UICollectionViewFlowLayout alloc]init];
    _photoCollectionview = [[UICollectionView alloc] initWithFrame:CGRectMake(0 ,50, KUEX_SCREEN_WIDTH, KUEX_SCREEN_HEIGHT-50) collectionViewLayout:flowlay];
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
//        _photoCollectionview.layer.borderColor = [UIColor greenColor].CGColor;
//        _photoCollectionview.layer.borderWidth = 1;
    //
    [self createTitleView:sIndex];
    
    [EUtility brwView:_euexImageBrowserObj.meBrwView addSubview:_titleView];
    [EUtility brwView:_euexImageBrowserObj.meBrwView addSubview:_photoCollectionview];
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
    [cell sizeToFit];
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
    
    NSInteger page = scrollView.contentOffset.x/KUEX_SCREEN_WIDTH;
    _photoIndex = [NSString stringWithFormat:@"(%ld/%ld)",(long)(page+1),(long)_imageSetArr.count];
    _titleLabel.text = _photoIndex;
}

- (void)createTitleView:(int)sIndex {
    
    _titleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, KUEX_SCREEN_WIDTH, 60)];
    _titleView.backgroundColor = [UIColor blackColor];
    
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    
    backBtn.frame = CGRectMake(5, 20, 30, 35);
    [backBtn setTitle:@"返回" forState:UIControlStateNormal];
    [backBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(backBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(KUEX_SCREEN_WIDTH/2-50, 20, 100, 35)];
    _photoIndex = [NSString stringWithFormat:@"(%d/%ld)",sIndex+1,(long)_imageSetArr.count];
    [_titleLabel setBackgroundColor:[UIColor clearColor]];
    [_titleLabel setTextColor:[UIColor whiteColor]];
    _titleLabel.textAlignment=NSTextAlignmentCenter;
    _titleLabel.text = _photoIndex;
    
    [_titleView addSubview:backBtn];
    [_titleView addSubview:_titleLabel];
}

-(NSData *)getImageDataByPath:(NSString *)imagePath {
    
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
    
    [_photoCollectionview removeFromSuperview];
    [_titleView removeFromSuperview];
    
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
    
    [super dealloc];
}

@end
