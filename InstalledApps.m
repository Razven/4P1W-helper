//
//  InstalledApps.m
//  4P1W helper
//
//  Created by Razvan Bangu on 2013-08-24.
//  Copyright (c) 2013 Razvan Bangu. All rights reserved.
//

#import "InstalledApps.h"

static NSString* const installedAppListPath = @"/private/var/mobile/Library/Caches/com.apple.mobile.installation.plist";

@implementation InstalledApps

+ (NSArray *)getInstalledApps
{
    BOOL isDir = NO;
    if([[NSFileManager defaultManager] fileExistsAtPath: installedAppListPath isDirectory: &isDir] && !isDir)
    {
        NSMutableDictionary *cacheDict = [NSDictionary dictionaryWithContentsOfFile: installedAppListPath];
//        NSDictionary *system = [cacheDict objectForKey: @"System"];
        NSMutableArray *installedApps = [NSMutableArray array];
        
        NSDictionary *user = [cacheDict objectForKey: @"User"];
        [installedApps addObject:user];
        
        return installedApps;
    }
    
    NSLog(@"can not find installed app plist");
    return nil;
}

@end
