//
//  PictureListViewController.h
//  4P1W helper
//
//  Created by Razvan Bangu on 2013-08-24.
//  Copyright (c) 2013 Razvan Bangu. All rights reserved.
//

#import "RazRootViewController.h"

@interface PictureListViewController : RazRootViewController <UITableViewDelegate, UITableViewDataSource, UIAlertViewDelegate>

- (id) initWithApplicationPath:(NSString*)applicationPath;

@end
