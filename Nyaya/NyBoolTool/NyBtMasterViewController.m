//
//  NyBtMasterViewController.m
//  Nyaya
//
//  Created by Alexander Maringele on 22.08.12.
//  Copyright (c) 2012 private. All rights reserved.
//

#import "NyBtMasterViewController.h"
#import "NyBoolToolEntry.h"

@interface NyBtMasterViewController () <InputSaver> {
    
}
@end

@implementation NyBtMasterViewController

- (NyBtDetailViewController*)booltoolViewController {
    return (NyBtDetailViewController*)super.detailViewController;
}

- (BOOL)tableViewIsAddable {
    return NO;
}

- (BOOL)save:(NSString *)name input:(NSString *)input {
    if ([name length] == 0) return NO;
    
    BOOL newEntryWasSaved = NO;
    NSUInteger idx = [_objects indexOfObjectPassingTest:^BOOL(NyBoolToolEntry *obj, NSUInteger idx, BOOL *stop) {
        if ([obj.title isEqualToString:name]) {
            obj.input = input;
            *stop = YES;
            return YES;
        }
        return NO;
    }];
    
    if (idx == NSNotFound) {
        
        [_objects addObject:[NyBoolToolEntry entryWithTitle:name input:input]];
        newEntryWasSaved = YES; // a new entry was created
    }
    
    [self.tableView reloadData];
    
    [self writeMasterData];
    
    return newEntryWasSaved;
    
}



- (void)readMasterData {
    self.booltoolViewController.inputSaver = self;
    
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
            [entries addObject:[NyBoolToolEntry entryWithTitle:[entry objectAtIndex:0] input:[entry objectAtIndex:1]]];
        }
    }
    
    if ([entries count] > 0) {
        _objects = entries;
        //self.detailViewController.detailItem = [_objects objectAtIndex:0];
    }  
}

- (void)writeMasterData {
    NSString *path = [self documentPath:@"BoolToolData"];
    NSMutableArray *array = [NSMutableArray arrayWithCapacity:[_objects count]];
    for (NyBoolToolEntry *entry in _objects) {
        [array addObject:@[entry.title, entry.input]];
    }
    [array writeToFile:path atomically:YES];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    
    NyBoolToolEntry *object = [_objects objectAtIndex:indexPath.row];
    cell.textLabel.text = object.title;
    cell.detailTextLabel.text = object.input;
    return cell;
}


@end
