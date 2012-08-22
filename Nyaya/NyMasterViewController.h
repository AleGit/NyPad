//
//  NyMasterViewController.h
//  Nyaya
//
//  Created by Alexander Maringele on 22.08.12.
//  Copyright (c) 2012 private. All rights reserved.
//

#import <UIKit/UIKit.h>

@class NyDetailViewController;

@interface NyMasterViewController : UITableViewController
{
    @protected
    NSMutableArray *_objects;
}

@property (strong, nonatomic) NyDetailViewController *detailViewController;

@end
