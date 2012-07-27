//
//  NyayaTruthTable.h
//  Nyaya
//
//  Created by Alexander Maringele on 24.07.12.
//  Copyright (c) 2012 private. All rights reserved.
//

#import <Foundation/Foundation.h>
@class NyayaNode;

@interface NyayaTruthTable : NSObject

@property (nonatomic, readonly) NyayaNode *formula;
@property (nonatomic, readonly) NSString *title;
@property (nonatomic, readonly) NSArray *variables;
@property (nonatomic, readonly) NSArray *headers;

- (id)initWithFormula:(NyayaNode*)formula;
- (void)evaluateTable;

- (void)setOrder: (NSArray*)variableNames;

@end
