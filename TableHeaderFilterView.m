//
//  TableHeaderFilterView.m
//  4P1W helper
//
//  Created by Razvan Bangu on 2013-08-25.
//  Copyright (c) 2013 Razvan Bangu. All rights reserved.
//

#import "TableHeaderFilterView.h"
#import <QuartzCore/QuartzCore.h>

@interface TableHeaderFilterView()

@property (nonatomic, strong) UIButton *filterByWordLengthButton, *filterByLetterChoicesButton;

@end

@implementation TableHeaderFilterView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    return self;
}

- (id) initWithFrame:(CGRect)frame andTarget:(id)target {
    self = [self initWithFrame:frame];
    
    if(self){
        self.filterByWordLengthButton = [[UIButton alloc] initWithFrame:CGRectMake(frame.origin.x, frame.origin.y, frame.size.width / 2, frame.size.height)];
        self.filterByLetterChoicesButton = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.filterByWordLengthButton.frame), frame.origin.y, frame.size.width / 2, frame.size.height)];
        
        [self.filterByWordLengthButton setTitle:@"# of letters" forState:UIControlStateNormal];
        [self.filterByWordLengthButton setTitle:@"# of letters" forState:UIControlStateHighlighted];
        [self.filterByLetterChoicesButton setTitle:@"all possible letters" forState:UIControlStateNormal];
        [self.filterByLetterChoicesButton setTitle:@"all possible letters" forState:UIControlStateHighlighted];
        
        [self.filterByWordLengthButton.titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:16.0f]];
        [self.filterByLetterChoicesButton.titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:16.0f]];
        
        self.filterByWordLengthButton.layer.borderWidth = 2.0f;
        self.filterByWordLengthButton.layer.borderColor = [UIColor lightGrayColor].CGColor;
        self.filterByLetterChoicesButton.layer.borderWidth = 2.0f;
        self.filterByLetterChoicesButton.layer.borderColor = [UIColor lightGrayColor].CGColor;
        
        [self.filterByWordLengthButton addTarget:target action:@selector(filterByWordLength) forControlEvents:UIControlEventTouchUpInside];
        [self.filterByLetterChoicesButton addTarget:target action:@selector(filterByLetterChoices) forControlEvents:UIControlEventTouchUpInside];
        
        [self addSubview:self.filterByWordLengthButton];
        [self addSubview:self.filterByLetterChoicesButton];
        
        self.backgroundColor = [UIColor darkGrayColor];
    }
    
    return self;
}

@end
