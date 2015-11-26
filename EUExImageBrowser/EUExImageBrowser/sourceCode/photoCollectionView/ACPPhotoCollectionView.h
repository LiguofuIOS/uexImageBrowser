//
//  ACPPhotoCollectionView.h
//  EUExImageBrowser
//
//  Created by appcan on 15/7/17.
//  Copyright (c) 2015年 xll. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EUExImageBrowser.h"
#import "ACPPhotoCollectionViewCell.h"
#import "UIImageView+WebCache.h"


@interface ACPPhotoCollectionView : UIViewController<UICollectionViewDataSource, UICollectionViewDelegate, ShowViewDelegate>

@property (nonatomic, assign) EUExImageBrowser *euexImageBrowserObj;

@property (nonatomic, retain) UICollectionView *photoCollectionview;

@property (nonatomic, retain) UIView *titleView;

@property (nonatomic, retain) UILabel *titleLabel;

@property (nonatomic, retain) NSString *photoIndexStr;

@property (nonatomic, assign) int currentIndex;

@property (nonatomic, retain) NSMutableArray *imageSetArr;

@property (nonatomic, retain) UIView *bottomView;

@property (nonatomic, retain) UIToolbar *bottomToobar;

@property (nonatomic, retain) UIBarButtonItem *leftBtn;

@property (nonatomic, retain) UIBarButtonItem *rightBtn;

-(void)openPhotoCollectionViewWithSet:(NSMutableArray *)imageSet startIndex:(int)sIndex;

@end
