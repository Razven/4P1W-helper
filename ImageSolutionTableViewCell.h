//
//  ImageSolutionTableViewCell.h
//  4P1W helper
//
//  Created by Razvan Bangu on 2013-08-25.
//  Copyright (c) 2013 Razvan Bangu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PictureSolutionView.h"

@interface ImageSolutionTableViewCell : UITableViewCell

@property (nonatomic, strong) PictureSolutionView *psv;

- (void) initPictureSolutionViewWithImageId:(NSString*)imageId solution:(NSString*)solution andImageDirectoryPath:(NSString*)imageDirectoryPath;

@end
