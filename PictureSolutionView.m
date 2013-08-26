//
//  PictureSolutionView.m
//  4P1W helper
//
//  Created by Razvan Bangu on 2013-08-25.
//  Copyright (c) 2013 Razvan Bangu. All rights reserved.
//

#import "PictureSolutionView.h"
#import <QuartzCore/QuartzCore.h>

@interface PictureSolutionView ()

#define PICTURE_BOX_WIDTH 145
#define PICTURE_PADDING 5

@property (nonatomic, strong) NSArray *imageArray;
@property (nonatomic, strong) NSString *solution;

@end

@implementation PictureSolutionView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    return self;
}

- (id) initWithImageId:(NSString *)imageId solution:(NSString *)solution frame:(CGRect)frame andImageDirectory:(NSString*)imageDirectory {
    self = [self initWithFrame:frame];
    
    if(self){
        NSMutableArray *tempImageArray = [NSMutableArray array];
        self.solution = solution;
        for(int i = 1; i < 5; i++){
            NSString *imageLocation = [NSString stringWithFormat:@"%@/_%@_%d.jpg", imageDirectory, imageId, i];
            if(![[NSFileManager defaultManager] fileExistsAtPath:imageLocation]){
                NSLog(@"Could not find picture at location: %@ with solution: %@", imageLocation, self.solution);
                [tempImageArray addObject:[UIImage imageNamed:@"not-found"]];
                continue;
            }
            UIImage *image = [UIImage imageWithContentsOfFile:imageLocation];
            [tempImageArray addObject:image];
        }
        
        self.imageArray = tempImageArray;
        
        self.topLeftImageView = [[UIImageView alloc] initWithImage:[self.imageArray objectAtIndex:0]];
        self.topRightImageView = [[UIImageView alloc] initWithImage:[self.imageArray objectAtIndex:1]];
        self.bottomLeftImageView = [[UIImageView alloc] initWithImage:[self.imageArray objectAtIndex:2]];
        self.bottomRightImageView = [[UIImageView alloc] initWithImage:[self.imageArray objectAtIndex:3]];
        
        self.topLeftImageView.frame = CGRectMake(0, 0, PICTURE_BOX_WIDTH, PICTURE_BOX_WIDTH);
        self.topRightImageView.frame = CGRectMake(PICTURE_BOX_WIDTH + PICTURE_PADDING, 0, PICTURE_BOX_WIDTH, PICTURE_BOX_WIDTH);
        self.bottomLeftImageView.frame = CGRectMake(0, PICTURE_BOX_WIDTH + PICTURE_PADDING, PICTURE_BOX_WIDTH, PICTURE_BOX_WIDTH);
        self.bottomRightImageView.frame = CGRectMake(PICTURE_BOX_WIDTH + PICTURE_PADDING, PICTURE_BOX_WIDTH + PICTURE_PADDING, PICTURE_BOX_WIDTH, PICTURE_BOX_WIDTH);
        
        self.imageContainer = [[UIView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, (PICTURE_BOX_WIDTH * 2) + 5)];
        self.imageContainer.backgroundColor = [UIColor lightGrayColor];
        self.imageContainer.layer.borderWidth = 5.0f;
        self.imageContainer.layer.borderColor = [UIColor lightGrayColor].CGColor;
        
        [self.imageContainer addSubview:self.topLeftImageView];
        [self.imageContainer addSubview:self.topRightImageView];
        [self.imageContainer addSubview:self.bottomLeftImageView];
        [self.imageContainer addSubview:self.bottomRightImageView];
        
        [self addSubview:self.imageContainer];
        
        UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pictureSelected)];
        [self addGestureRecognizer:tapGestureRecognizer];
    }
    
    return self;
}

- (void) pictureSelected {
    [[[UIAlertView alloc] initWithTitle:@"Solution" message:self.solution delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
}

@end
