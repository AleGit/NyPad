//
//  NyGlossaryEntry.m
//  Nyaya
//
//  Created by Alexander Maringele on 27.08.12.
//  Copyright (c) 2012 private. All rights reserved.
//

#import "NyGlossaryEntry.h"

@implementation NyGlossaryEntry

- (NSString *)description {
    return self.entryTitle;
}

- (NSString *)debugDescription {
    return [NSString stringWithFormat:@"%@ %@", self.entryTitle, self.entryId];
}

- (NSString*)cleanString:(NSMutableString*)input {
    [input replaceOccurrencesOfString:@"&amp;" withString:@"&" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [input length])];
    [input replaceOccurrencesOfString:@"&gt;" withString:@">" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [input length])];
    [input replaceOccurrencesOfString:@"&lt;" withString:@"<" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [input length])];
    return [input capitalizedString];
    
}

- (id)initWithString:(NSString *)string {
    self = [super init];
    if (self) {
        NSArray *components = [string componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"<>="]];
        // _entryTitle = [components componentsJoinedByString:@"@"];
        
        [components enumerateObjectsUsingBlock:^(NSString *obj, NSUInteger idx, BOOL *stop) {
            
            if ([obj hasSuffix:@" id"]) {
                NSString *e = [components objectAtIndex:idx+1];
                NSRange range = [e rangeOfString:@"\"" options:0 range:NSMakeRange(1, [e length] - 1)];
                _entryId = [e substringWithRange:NSMakeRange(1, range.location -1)];
            }
            
            if ([obj isEqual:@"/"]) {
                // _entryTitle = [NSString stringWithFormat:@"%@ %@", [components objectAtIndex:idx-1], _entryId];
                _entryTitle = [self cleanString:[[components objectAtIndex:idx-1] mutableCopy]];
                
            }
        }];
        
    }
    NSLog(@"IN: %@ *** OUT: %@ #%@", string, _entryTitle, _entryId);
    return self;
    
}

+ (id)entryWithString:(NSString *)string {
    return [[self alloc] initWithString:string];
}

@end
