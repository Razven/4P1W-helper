//
//  PictureListViewController.m
//  4P1W helper
//
//  Created by Razvan Bangu on 2013-08-24.
//  Copyright (c) 2013 Razvan Bangu. All rights reserved.
//

#import "PictureListViewController.h"
#import "ImageSolutionTableViewCell.h"
#import "TableHeaderFilterView.h"
#import <sqlite3.h>

@interface PictureListViewController ()

@property (nonatomic, strong) NSString *applicationPath;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *pictureSolutionArray;

@property (nonatomic, strong) __block NSString *filterPossibleCharacters;
@property (nonatomic, assign) __block int filterNumberOfCharacters;

@end

@implementation PictureListViewController

- (id) initWithApplicationPath:(NSString *)applicationPath {
    self = [super init];
    
    if(self){
        self.applicationPath = applicationPath;
    }
    
    return self;
}

- (NSArray*) getPictureDataFromDatabase:(NSString*)databaseLocation {
    NSMutableArray *results = [NSMutableArray array];
    
    //TODO create a separate SQLiteManager class and throw this code in there
    sqlite3 *db;
    
    if(sqlite3_open([databaseLocation UTF8String], &db) != SQLITE_OK) {
        sqlite3_close(db);
        NSLog(@"Database failed to open");
        return nil;
    } else {
        NSLog(@"Database opened!");
        
        NSString *querySQL = [NSString stringWithFormat:
                              @"select id, solution from item"];
        const char *query_stmt = [querySQL UTF8String];
        
        sqlite3_stmt *statement = nil;
        
        if (sqlite3_prepare_v2(db, query_stmt, -1, &statement, NULL) == SQLITE_OK)
        {
            while (sqlite3_step(statement) == SQLITE_ROW) {
                NSString *pictureId = [[NSString alloc] initWithUTF8String:
                                       (const char *) sqlite3_column_text(statement, 0)];
                NSString *pictureSolution = [[NSString alloc] initWithUTF8String:
                                             (const char *) sqlite3_column_text(statement, 1)];
                
                
                [results addObject:@{pictureId : pictureSolution}];
            }            
            return results;
        } else {
            NSLog(@"SQLite3 statement failed");
            return nil;
        }
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if(self.applicationPath){
        NSString *databaseLocation = [self.applicationPath stringByAppendingPathComponent:@"4 Pics 1 Word.app/itemData.db"];
        self.pictureSolutionArray = [self getPictureDataFromDatabase:databaseLocation];
                
    } else {
        //TODO: 4P1W isn't installed. Display a message or something.
    }
    
    self.tableView = [[UITableView alloc] initWithFrame:self.view.frame];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.backgroundColor = [UIColor darkGrayColor];
    [self.tableView registerClass:[ImageSolutionTableViewCell class] forCellReuseIdentifier:@"PictureBlockCell"];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.tableView];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark UITableViewDelegate methods

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ImageSolutionTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PictureBlockCell" forIndexPath:indexPath];
    
    if(!cell){
        cell = [[ImageSolutionTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"PictureBlockCell"];
    }
    
    __block NSString *pictureId = @"0";
    __block NSString *pictureSolution = @"0";
    
    [((NSDictionary*)[self.pictureSolutionArray objectAtIndex:indexPath.row]) enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        pictureId = key;
        pictureSolution = obj;
    }];
    
    [cell initPictureSolutionViewWithImageId:pictureId solution:pictureSolution andImageDirectoryPath:[self.applicationPath stringByAppendingPathComponent:@"4 Pics 1 Word.app/"]];    
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [tableView isEqual:self.tableView] ? 1 : 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if(self.pictureSolutionArray){
        int numRows = 0;
        if(self.filterNumberOfCharacters || self.filterPossibleCharacters){
            NSIndexSet *objs = [self.pictureSolutionArray indexesOfObjectsPassingTest:^BOOL(NSString* obj, NSUInteger idx, BOOL *stop) {
                BOOL matchesFilter = NO;
                
                if(self.filterNumberOfCharacters){
                    matchesFilter = [obj length] == self.filterNumberOfCharacters;
                }
                if(self.filterPossibleCharacters){
                    NSArray *solutionLetters = [obj componentsSeparatedByString:@""];
                    for(NSString *character in solutionLetters){
                        NSRange dataRange = [self.filterPossibleCharacters rangeOfString:character options:NSCaseInsensitiveSearch];
                        if (dataRange.location == NSNotFound) {
                            matchesFilter = NO;
                            break;
                        }
                    }
                    matchesFilter = YES;
                }
                
                return matchesFilter;
            }];
        }
        
        if(numRows == 0){
            return [self.pictureSolutionArray count];
        }
    } else {
        return 0;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 305;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return section == 0 ? 40 : 0;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if(section == 0){
        TableHeaderFilterView *filterView = [[TableHeaderFilterView alloc] initWithFrame:CGRectMake(5, 5, self.tableView.frame.size.width - 10, 30) andTarget:self];
        return filterView;
    }
    else {
        return [UIView new];
    }
}

- (UIView*) tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return [UIView new];
}

#pragma mark filter selectors

- (void) filterByWordLength {
    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Filter" message:@"Enter the length of the word you're stuck on" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
    alert.alertViewStyle = UIAlertViewStylePlainTextInput;
    [alert textFieldAtIndex:0].keyboardType = UIKeyboardTypeNumberPad;
    [alert show];
}

- (void) filterByLetterChoices {
    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Filter" message:@"Enter every letter you can choose from for the word you're stuck on" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
    alert.alertViewStyle = UIAlertViewStylePlainTextInput;
    [alert textFieldAtIndex:0].keyboardType = UIKeyboardTypeAlphabet;
    [alert show];
}

#pragma mark UIAlertView delegate

- (void)alertView:(UIAlertView *)alertView willDismissWithButtonIndex:(NSInteger)buttonIndex {
    NSString *inputText = [[alertView textFieldAtIndex:0] text];
    
    BOOL valid;
    NSCharacterSet *alphaNums = [NSCharacterSet decimalDigitCharacterSet];
    NSCharacterSet *inStringSet = [NSCharacterSet characterSetWithCharactersInString:inputText];
    valid = [alphaNums isSupersetOfSet:inStringSet];
    if (!valid) {
        NSLog(@"Filtering by letters to choose from");
        self.filterPossibleCharacters = inputText;
    } else {
        NSLog(@"Filtering by word length");
        self.filterNumberOfCharacters = inputText.intValue;
    }
    
    [self.tableView reloadData];
}

@end
