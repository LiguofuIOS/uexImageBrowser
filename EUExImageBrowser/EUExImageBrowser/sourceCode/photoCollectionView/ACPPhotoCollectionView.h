//
//  ACPPhotoCollectionView.h
//  EUExImageBrowser
//
//  Created by liguofu on 15/7/17.
//  Copyright (c) 2015年 xll. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EUExImageBrowser.h"
#import "ACPPhotoCollectionViewCell.h"
#import "UIImageView+WebCache.h"

@interface ACPPhotoCollectionView : UICollectionView<UICollectionViewDataSource,UICollectionViewDelegate>

@property (nonatomic, assign) EUExImageBrowser *euexImageBrowserObj;
@property (nonatomic, retain) UICollectionView *photoCollectionview;
@property (nonatomic, retain) UIView *titleView;
@property (nonatomic, retain) UILabel *titleLabel;
@property (nonatomic, retain) NSString *photoIndex;
@property (nonatomic, retain) NSMutableArray *imageSetArr;

-(void)openPhotoCollectionViewWithSet:(NSMutableArray *)imageSet startIndex:(int)sIndex;
@end
