//
//  ACPPhotoCollectionViewCell.h
//  EUExImageBrowser
//
//  Created by appcan on 15/7/17.
//  Copyright (c) 2015年 xll. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ShowViewDelegate <NSObject>

- (void)showView;

@end

@interface ACPPhotoCollectionViewCell : UICollectionViewCell

@property (nonatomic, assign) id <ShowViewDelegate>delegate;

@property (nonatomic, retain) UIImageView *imgView;

@end
