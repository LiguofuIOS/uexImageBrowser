//
//  ACPPhotoCollectionViewCell.m
//  EUExImageBrowser
//
//  Created by liguofu on 15/7/17.
//  Copyright (c) 2015年 xll. All rights reserved.
//

#import "ACPPhotoCollectionViewCell.h"

@implementation ACPPhotoCollectionViewCell {
    CGFloat  lastScale;
}

- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    
    if (self) {
        
       _imgView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 25,CGRectGetWidth(self.frame), CGRectGetHeight(self.frame))];
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
        
#if 0
        self.layer.borderWidth = 2;
        self.layer.borderColor = [UIColor redColor].CGColor;
        _imgView.layer.borderWidth = 2;
        _imgView.layer.borderColor = [UIColor yellowColor].CGColor;
#endif
        [self.contentView addSubview:_imgView];
    }
    
    return self;
}

- (void) handlePinch:(UIPinchGestureRecognizer*) recognizer {

}

- (void)dealloc {
    
    if (_imgView) {
        [_imgView release];
        _imgView = nil;
    }
    
    [super dealloc];
}

@end
