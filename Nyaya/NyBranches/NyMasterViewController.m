//
//  NyMasterViewController.m
//  Nyaya
//
//  Created by Alexander Maringele on 22.08.12.
//  Copyright (c) 2012 private. All rights reserved.
//

#import "NyDetailViewController.h"
#import "NyMasterViewController.h"
#import "NyBoolToolEntry.h"

@interface NyMasterViewController ()

@end

@implementation NyMasterViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)awakeFromNib
{
    self.clearsSelectionOnViewWillAppear = NO;
    self.contentSizeForViewInPopover = CGSizeMake(320.0, 600.0);
    [super awakeFromNib];
}

// ****************************
// !!! OVERRIDE IN SUBCLASS !!!
// ****************************
- (BOOL)tableViewIsEditable {
    return YES;
}

// ****************************
// !!! OVERRIDE IN SUBCLASS !!!
// ****************************
- (BOOL)tableViewIsAddable {
    return [self tableViewIsEditable];
}

// ****************************
// !!! OVERRIDE IN SUBCLASS !!!
// ****************************
- (void)readMasterData {
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    if ([self tableViewIsEditable]) {
        
        self.navigationItem.leftBarButtonItem = self.editButtonItem;
        
        
    }
    if ([self tableViewIsAddable]) {
        UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(insertNewObject:)];
        self.navigationItem.rightBarButtonItem = addButton;
    }
    
    
    self.detailViewController = (NyDetailViewController*)[[self.splitViewController.viewControllers lastObject] topViewController];
    
    [self readMasterData];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

// ****************************
// !!! OVERRIDE IN SUBCLASS !!!
// ****************************
- (void)insertNewObject:(id)sender
{
    if (!_objects) {
        _objects = [[NSMutableArray alloc] init];
    }
    [_objects insertObject:[NSDate date] atIndex:0];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    [self.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
}


#pragma mark - Table View

// ****************************
// !!! OVERRIDE IN SUBCLASS !!!
// ****************************
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

// ****************************
// !!! OVERRIDE IN SUBCLASS !!!
// ****************************
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _objects.count;
}

// ****************************
// !!! OVERRIDE IN SUBCLASS !!!
// ****************************
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    
    NSDate *object = [_objects objectAtIndex:indexPath.row];
    cell.textLabel.text = [object description];
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return [self tableViewIsEditable];
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [_objects removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
    }
}

/*
 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
 {
 }
 */

/*
 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
 }
 */

// ****************************
// !!! OVERRIDE IN SUBCLASS !!!
// ****************************
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.detailViewController.detailItem = [_objects objectAtIndex:indexPath.row];
}

- (NSString*)bundlePath:(NSString*)fileName {
    return [[NSBundle mainBundle] pathForResource:fileName ofType:@"plist"];
}

- (NSString*)documentPath:(NSString*)fileName {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);NSString *documentsDirectory = [paths objectAtIndex:0];
    return[[documentsDirectory stringByAppendingPathComponent:@"BoolToolData"] stringByAppendingPathExtension:@"plist"];
}

@end

@implementation NyMasterDataViewController

- (BOOL)tableViewIsAddable {
    return NO;
}

- (BOOL)save:(NSDate *)date input:(NSString *)input {
    if ([input length] == 0) return NO;
    
    BOOL newEntryWasSaved = NO;
    NSUInteger idx = [_objects indexOfObjectPassingTest:^BOOL(NyBoolToolEntry *obj, NSUInteger idx, BOOL *stop) {
        if ([obj.input isEqualToString:input]) {
            obj.date = date;
            *stop = YES;
            return YES;
        }
        return NO;
    }];
    
    if (idx == NSNotFound) {
        
        [_objects insertObject:[NyBoolToolEntry entryWithDate:date input:input] atIndex:0];
        newEntryWasSaved = YES; // a new entry was created
    }
    else {
        NyBoolToolEntry *entry = [_objects objectAtIndex:idx];
        [_objects removeObjectAtIndex:idx];
        [_objects insertObject:entry atIndex:0];
    }
    
    
    [self.tableView reloadData];
    
    [self writeMasterData];
    
    return newEntryWasSaved;
    
}
- (void)readMasterData {
 
    [(id)self.detailViewController setInputSaver:self];
    
    NSArray *array = [NSArray arrayWithContentsOfFile:[self documentPath:@"BoolToolData"]];
    
    if ([array count] == 0 || [[array objectAtIndex:0] count] < 2) {
        array = [NSArray arrayWithContentsOfFile:[self bundlePath:@"BoolToolData"]];
    }
    
    if ([array count] == 0 || [[array objectAtIndex:0] count] != 2) {
        array = @[@[@"P",@"p ∨ q ∧ r"]];
    }
    
    NSMutableArray *entries = [NSMutableArray arrayWithCapacity:[array count]];
    for (NSArray *entry in array) {
        if ([entry count] == 2) {
            [entries addObject:[NyBoolToolEntry entryWithDate:[entry objectAtIndex:0] input:[entry objectAtIndex:1]]];
        }
    }
    
    if ([entries count] > 0) {
        _objects = entries;
    }
}

- (void)writeMasterData {
    NSString *path = [self documentPath:@"BoolToolData"];
    NSMutableArray *array = [NSMutableArray arrayWithCapacity:[_objects count]];
    for (NyBoolToolEntry *entry in _objects) {
        [array addObject:@[entry.date, entry.input]];
    }
    [array writeToFile:path atomically:YES];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    
    NyBoolToolEntry *object = [_objects objectAtIndex:indexPath.row];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@",object.date];
    cell.textLabel.text = object.input;
    return cell;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [_objects removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        [self writeMasterData];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
    }
}


@end
