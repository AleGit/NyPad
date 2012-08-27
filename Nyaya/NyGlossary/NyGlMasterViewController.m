//
//  NyGlMasterViewController.m
//  Nyaya
//
//  Created by Alexander Maringele on 22.08.12.
//  Copyright (c) 2012 private. All rights reserved.
//

#import "NyGlMasterViewController.h"
#import "NyGlossaryEntry.h"

@interface NyGlMasterViewController ()
@end

@implementation NyGlMasterViewController

- (NyGlDetailViewController*)glossaryViewController {
    return (NyGlDetailViewController*)super.detailViewController;
}

- (BOOL)tableViewIsEditable {
    return NO;
}

- (void)readMasterData {
    if (!_objects) {
        NSMutableArray *lines = [NSMutableArray array];
        NSURL *url = [[NSBundle mainBundle] URLForResource:@"glossary" withExtension:@"html"];
        NSString *input = [NSString stringWithContentsOfURL:url encoding:NSUTF8StringEncoding error:nil];
        
        NSError *error = NULL;
        NSRegularExpression *regex = [NSRegularExpression
                                      regularExpressionWithPattern: @" id=[^<]*</"
                                      options:NSRegularExpressionCaseInsensitive
                                      error:&error];
        
        [regex enumerateMatchesInString:input
                                options:0
                                  range:NSMakeRange(0, [input length])
                             usingBlock:^(NSTextCheckingResult *match, NSMatchingFlags flags, BOOL *stop) {
                                 
                                 NSString *s = [input substringWithRange:[match range]];
                                 [lines addObject:[NyGlossaryEntry entryWithString:s]];
                             }];
        
        
        
        [lines sortUsingComparator:^NSComparisonResult(NyGlossaryEntry *obj1, NyGlossaryEntry *obj2) {
            return [obj1.entryTitle compare:obj2.entryTitle options:NSCaseInsensitiveSearch | NSNumericSearch];
        }];
        _objects = lines;
    }
}

@end
