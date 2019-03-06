//
//  NyGlossaryEntry.m
//  Nyaya
//
//  Created by Alexander Maringele on 27.08.12.
//  Copyright (c) 2012 private. All rights reserved.
//

#import "NyGlossaryEntry.h"
#import "NSString+NyayaToken.h"

@implementation NyGlossaryEntry

- (NSString *)description {
    return self.entryTitle;
}

- (NSString *)debugDescription {
    return [NSString stringWithFormat:@"%@ %@", self.entryTitle, self.entryId];
}



- (id)initWithString:(NSString *)string {
    @autoreleasepool {
        self = [super init];
        if (self) {
            NSArray *components = [string componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"<>=\""]];
            
            [components enumerateObjectsWithOptions:0 usingBlock:^(NSString *obj, NSUInteger idx, BOOL *stop) {
                
                if ([obj hasSuffix:@" id"]) {
                    self->_entryId = [components objectAtIndex:idx+2];
                }
                
                else if ([obj isEqual:@"/"]) {
                    self->_entryTitle = [[components objectAtIndex:idx-1] capitalizedHtmlEntityFreeString];
                }
            }];
            
        }
    }
    return self;
    
}

+ (id)entryWithString:(NSString *)string {
    return [[self alloc] initWithString:string];
}

@end
