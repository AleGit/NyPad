//
//  NyMasterViewController.h
//  Nyaya
//
//  Created by Alexander Maringele on 22.08.12.
//  Copyright (c) 2012 private. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "InputSaver.h"

@class NyDetailViewController;



@interface NyMasterViewController : UITableViewController
{
    @protected
    NSMutableArray *_objects;
}

@property (strong, nonatomic) NyDetailViewController *detailViewController;

- (NSString*)bundlePath:(NSString*)fileName;
- (NSString*)documentPath: (NSString*)fileName;

@end

@interface NyMasterDataViewController : NyMasterViewController <InputSaver>

@end
