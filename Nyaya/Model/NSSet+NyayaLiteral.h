//
//  NSSet+NyayaLiteral.h
//  Nyaya
//
//  Created by Alexander Maringele on 18.07.12.
//  Copyright (c) 2012 private. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSSet (NyayaLiteral)

- (BOOL)containsContemplementOf:(NSString*)string;
- (BOOL)containsContemplementaryStrings;

@end
