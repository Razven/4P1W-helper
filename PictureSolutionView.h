//
//  PictureSolutionView.h
//  4P1W helper
//
//  Created by Razvan Bangu on 2013-08-25.
//  Copyright (c) 2013 Razvan Bangu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PictureSolutionView : UIView

@property (nonatomic, strong) UIImageView *topLeftImageView, *topRightImageView, *bottomLeftImageView, *bottomRightImageView;
@property (nonatomic, strong) UIView *imageContainer;

- (id) initWithImageId:(NSString*)imageId solution:(NSString*)solution frame:(CGRect)frame andImageDirectory:(NSString*)imageDirectory;

@end
