//
//  NyTuMasterViewController.m
//  NyTutorial
//
//  Created by Alexander Maringele on 22.08.12.
//  Copyright (c) 2012 Alexander Maringele. All rights reserved.
//

#import "NyTuMasterViewController.h"

@interface NyTuMasterViewController ()

@property (nonatomic, strong) NSArray *tutorialSections;

@end

@implementation NyTuMasterViewController

- (NyTuDetailViewController*)tutorialViewController {
    return (NyTuDetailViewController*)super.detailViewController;
}

- (BOOL)tableViewIsEditable {
    return NO;
}

- (void)readTutorials {
    if (!self.tutorialSections) {
        NSString *filePath = [[NSBundle mainBundle] pathForResource:@"Tutorials" ofType:@"plist"]; 
        self.tutorialSections = [NSArray arrayWithContentsOfFile:filePath];
        
    }
}

// **********************************
// !!! OVERRIDDEN FROM SUPERCLASS !!!
// **********************************
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    [self readTutorials];
    return [self.tutorialSections count] -1;
    // the first elment of the array is a string
}

// **********************************
// !!! OVERRIDDEN FROM SUPERCLASS !!!
// **********************************
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSDictionary *tutorialSection = [self.tutorialSections objectAtIndex:section +1];
    return [tutorialSection count] - 1;
    // the first elment of the array is a string (name of section)
}

// **********************************
// !!! OVERRIDDEN FROM SUPERCLASS !!!
// **********************************
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    
    NSArray *tutorial = [[self.tutorialSections objectAtIndex:indexPath.section +1] objectAtIndex:indexPath.row +1];
    NSString *tutorialTitle = [tutorial objectAtIndex:0];
    cell.textLabel.text = tutorialTitle;
    return cell;
}


- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    NSArray *tutorialSection = [self.tutorialSections objectAtIndex:section +1];
    NSString *sectionTitle = [tutorialSection objectAtIndex:0];
    return sectionTitle;
    
}

// **********************************
// !!! OVERRIDDEN FROM SUPERCLASS !!!
// **********************************
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray *tutorialSection = [self.tutorialSections objectAtIndex:indexPath.section+1];
    NSString *sectionTitle = [tutorialSection objectAtIndex:0];
    NSArray *tutorial = [tutorialSection objectAtIndex:indexPath.row +1];
    self.detailViewController.detailItem = @[sectionTitle, tutorial];
    
}

@end
