//
//  ACPPhotoCollectionViewCell.m
//  EUExImageBrowser
//
//  Created by appcan on 15/7/17.
//  Copyright (c) 2015年 xll. All rights reserved.
//

#import "ACPPhotoCollectionViewCell.h"
#import "ACPPhotoCollectionView.h"

@implementation ACPPhotoCollectionViewCell {
    
    BOOL isShow;
    
}

- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    
    if (self) {
        
       _imgView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0,CGRectGetWidth(self.frame), CGRectGetHeight(self.frame))];
        /*
         UIViewContentModeScaleToFill,
         UIViewContentModeScaleAspectFit,
         UIViewContentModeScaleAspectFill,
         */
        _imgView.userInteractionEnabled = YES;
        _imgView.contentMode = UIViewContentModeScaleAspectFit;
        UIPinchGestureRecognizer *pinchGestureRecognizer = [[UIPinchGestureRecognizer alloc]
                                                            initWithTarget:self
                                                            action:@selector(handlePinch:)];
        
        [_imgView addGestureRecognizer:pinchGestureRecognizer];
        
        UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                             action:@selector(hidden:)];
        
        [_imgView addGestureRecognizer:tapRecognizer];
        
        isShow = YES;
#if 0
        //self.layer.borderWidth = 4;
        //self.layer.borderColor = [UIColor redColor].CGColor;
        _imgView.layer.borderWidth = 4;
        _imgView.layer.borderColor = [UIColor yellowColor].CGColor;
#endif
        [self.contentView addSubview:_imgView];
    }
    
    return self;
}

- (void) handlePinch:(UIPinchGestureRecognizer*) recognizer {

}

- (void)hidden:(UIGestureRecognizer *)tap {
    
    if (_delegate && [_delegate performSelector:@selector(showView)]) {
        
        [_delegate showView];
        
    }
   
    
}

- (void)showView{
    
}
- (void)dealloc {
    
    if (_imgView) {
        [_imgView release];
        _imgView = nil;
    }
    
    [super dealloc];
}

@end
