//
//  NyayaTruthTable.h
//  Nyaya
//
//  Created by Alexander Maringele on 24.07.12.
//  Copyright (c) 2012 private. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NyayaNode.h"

@interface NyayaTruthTable : NSObject


@property NyayaNode *formula;
@property NSString *title;
@property NSArray *variables;
@property NSArray *headers;

- (id)initWithFormula:(NyayaNode*)formula;
- (void)evaluateTable;

@end
