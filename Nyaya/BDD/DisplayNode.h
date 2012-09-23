//
//  AbstractNode.h
//  Nyaya
//
//  Created by Alexander Maringele on 23.09.12.
//  Copyright (c) 2012 private. All rights reserved.
//

#import <Foundation/Foundation.h>

enum { NyayaUndefined=0, NyayaFalse, NyayaTrue };
typedef NSUInteger NyayaBool;

@protocol DisplayNode <NSObject>

- (NyayaBool) displayValue;
- (NSString*) symbol;
- (NSUInteger) width;
- (NSUInteger) height;
- (NSArray*) nodes;

- (NSString*)headLabelText;

@end

@protocol MutableDisplayNode <NSObject>

- (void)setDisplayValue:(NyayaBool)displayValue;

@end
