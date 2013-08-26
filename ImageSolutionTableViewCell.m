//
//  ImageSolutionTableViewCell.m
//  4P1W helper
//
//  Created by Razvan Bangu on 2013-08-25.
//  Copyright (c) 2013 Razvan Bangu. All rights reserved.
//

#import "ImageSolutionTableViewCell.h"

@implementation ImageSolutionTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

- (void)initPictureSolutionViewWithImageId:(NSString *)imageId solution:(NSString *)solution andImageDirectoryPath:(NSString *)imageDirectoryPath {
    if(self.psv){
        [self.psv removeFromSuperview];
    }
    self.psv = [[PictureSolutionView alloc] initWithImageId:imageId solution:solution frame:CGRectMake(0, 0, 295, self.frame.size.height) andImageDirectory:imageDirectoryPath];
    self.psv.center = CGPointMake(self.center.x, self.psv.center.y);
    [self addSubview:self.psv];
}

@end
