//
//  NyayaTruthTable.m
//  Nyaya
//
//  Created by Alexander Maringele on 24.07.12.
//  Copyright (c) 2012 private. All rights reserved.
//

#import "NyayaTruthTable.h"
#import "NyayaNode.h"

@interface NyayaTruthTable () {
    NSUInteger _rowsCount;
    NSUInteger _colsCount;
    NSUInteger _cellCount;
    BOOL *_evals;
}
@end

@implementation NyayaTruthTable

@synthesize formula = _formula;
@synthesize title = _title;
@synthesize variables = _variables;
@synthesize headers = _headers;

- (id)initWithFormula:(NyayaNode *)formula {
    self = [super init];
    if (self) {
        _formula = formula;
        _title = [formula description];
        _variables = [[[formula setOfVariables] allObjects] sortedArrayUsingComparator:^NSComparisonResult(NyayaNode *obj1, NyayaNode *obj2) {
            return [obj1.symbol compare: obj2.symbol];
            
        } ];
        _headers = [[formula setOfSubformulas] allObjects];
        
        _rowsCount = 1 << [_variables count];
        _colsCount = [_headers count];
        _cellCount = _rowsCount * _colsCount;
        
        _evals = calloc(_cellCount, sizeof(BOOL));
    }
    
    return self;
    
    
    
}



- (void)setEval:(BOOL)eval atRow:(NSUInteger)rowIndex forColumn:(NSUInteger)colIndex {
    *(_evals + rowIndex *_colsCount + colIndex) = eval;
}

- (void)setEval:(BOOL)eval atRow:(NSUInteger)rowIndex forHeader:(NSString*)header {
    [self setEval:eval atRow:rowIndex forColumn:[_headers indexOfObject:header]];
}

- (BOOL)evaluateRow:(NSUInteger)rowIndex {
    NSMutableDictionary *headersAndEvals = [NSMutableDictionary dictionaryWithCapacity:[_headers count]];
    
    [_variables enumerateObjectsUsingBlock:^(NyayaNodeVariable *variable, NSUInteger idx, BOOL *stop) {
        BOOL eval = (rowIndex & (1 << idx)) > 0 ? TRUE : FALSE;
        variable.evaluationValue = eval;
        [headersAndEvals setValue:[NSNumber numberWithBool:eval] forKey:[variable description]];
    }];
    
    BOOL rowEval = [_formula evaluationValue];
    
    // formula fil
    
    [_formula fillHeadersAndEvals:headersAndEvals];
    
    for (NSString *header in _headers) {
        [self setEval:[(NSNumber*)[headersAndEvals objectForKey:header] boolValue]  atRow:rowIndex forHeader:header];
    }
    
    return rowEval;
    
}

- (void)evaluateTable {
    for (NSUInteger rowIndex=0; rowIndex < _rowsCount; rowIndex++) {
        [self evaluateRow:rowIndex];
    }
}


- (BOOL)evalAtRow:(NSUInteger)rowIndex forColumn:(NSUInteger)colIndex {
    return *(_evals + rowIndex *_colsCount + colIndex);
}

- (BOOL)evalAtRow:(NSUInteger)rowIndex forHeader:(NSString*)header {
    
    return [self evalAtRow:rowIndex forColumn:[_headers indexOfObject:header]];
    
}

- (NSString*)description {
    NSMutableString *description = [NSMutableString stringWithString:@"|"];
    
    NSArray *sortedHeaders = [_headers sortedArrayUsingComparator:^NSComparisonResult(NSString *obj1, NSString *obj2) {
        if ([obj1 length] < [obj2 length]) return -1;
        else if ([obj1 length] > [obj2 length]) return 1;
        else return [obj1 compare:obj2];
    }];
    
    for (NSString *header in sortedHeaders) {
        [description appendFormat:@" %@ |", header]; 
    }
    
    
    
    for (NSUInteger rowIndex = 0; rowIndex < _rowsCount; rowIndex++) {
        [description appendString:@"\n|"];
        for (NSString* header in sortedHeaders) {
            BOOL eval = [self evalAtRow:rowIndex forHeader:header];
            if (eval) [description appendString: @" T"];
            else [description appendString:@" F"];
            for (int i=0; i<[header length]; i++) {
                [description appendString:@" "];
            }
            [description appendString:@"|"];
        }
    }
    
    return description;
}

- (void)dealloc {
    free(_evals);
}

@end
