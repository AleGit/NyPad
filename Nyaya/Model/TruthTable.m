//
//  NyayaTruthTable.m
//  Nyaya
//
//  Created by Alexander Maringele on 24.07.12.
//  Copyright (c) 2012 private. All rights reserved.
//

#import "TruthTable.h"
#import "NyayaNode.h"
#import "NSString+NyayaToken.h"
#import "NyayaNode+Valuation.h"
#import "NyayaNode_Cluster.h"
#include <objc/runtime.h>

@interface TruthTable () {
@protected
    NSUInteger _colsCount;
    NSUInteger _cellCount;
    NSUInteger _rowsCount;
    NSArray *_sortedNames;
    NSUInteger _titleColumnIdx;
    
    BOOL *_evals;
    
    NSMutableIndexSet *_trueIndices;
    
    NSArray *_variables;
    NSArray *_headers;
    NyayaNode *_formula;
}
@end

@implementation TruthTable

#pragma mark - input

- (BOOL)compact { return YES; }

- (void)sortVariablesAndHeaders {
    
    _variables = [_variables sortedArrayUsingComparator:^NSComparisonResult(NyayaNode *obj1, NyayaNode *obj2) {
        if (_sortedNames) {
            NSUInteger idx1 = [_sortedNames indexOfObject:obj1.symbol];
            NSUInteger idx2 = [_sortedNames indexOfObject:obj2.symbol];
            
            if (idx1 != NSNotFound && idx2 != NSNotFound) {
                if (idx1 < idx2) return -1;
                else if (idx1 > idx2) return 1;
                else return 0;
            }
            else if (idx1 != NSNotFound) return -1;
            else if (idx2 != NSNotFound) return 1;
        }
        
        return [obj1.symbol compare:obj2.symbol options:NSNumericSearch]; // x1 < x2 < x10
    }];
    
    if (!_sortedNames || [_sortedNames count] < [_variables count]) _sortedNames = [_variables valueForKey:@"symbol"];
    
    _headers = [_headers sortedArrayUsingComparator:^NSComparisonResult(NSString *obj1, NSString* obj2) {
        
        NSUInteger idx1 = [_sortedNames indexOfObject:obj1];
        NSUInteger idx2 = [_sortedNames indexOfObject:obj2];
        
        if (idx1 != NSNotFound && idx2 != NSNotFound) {
            if (idx1 < idx2) return -1;
            else if (idx1 > idx2) return 1;
            else return 0;
        }
        else if (idx1 != NSNotFound) return -1;
        else if (idx2 != NSNotFound) return 1;
        
        
        else if ([obj1 length] < [obj2 length]) return -1;
        else if ([obj1 length] > [obj2 length]) return 1;
        else return [obj1 compare:obj2 options:NSNumericSearch]; // x1 < x2 < x10
    }];
}

- (id)initWithNode:(NyayaNode *)node {
    return [self initWithNode:node compact:YES];
}

- (NSArray*)makeHeaders {
    return @[_title];
}

- (void)reserveMemory {
    _evals = NULL; // no extra memory needed the truth values are stored in an index set
}

- (id)initWithNode:(NyayaNode *)node compact:(BOOL)compact {
    self = [super init];
    if (self) {
        if (!compact) {
            // self->isa = [ExpandedTruthTable class]; is deprecated
            object_setClass(self,[ExpandedTruthTable class]);
        }        
        _formula = node;
        _title = [node description];
        _variables = [[node setOfVariables] allObjects];
        _headers = [self makeHeaders];
        [self sortVariablesAndHeaders];
        
        _rowsCount = 1 << [_variables count];   // 2^#(variables)
        _colsCount = [_headers count];          // 1 or #(subformulas)
        _cellCount = _rowsCount * _colsCount;
        
        [self reserveMemory];
        
        _trueIndices = [NSMutableIndexSet indexSet];
        // _falseIndices = [NSMutableIndexSet indexSet];
    }
    
    return self;
}

#pragma mark - calculation

- (void)setOrder:(NSArray *)variableNames {
    _sortedNames = variableNames;
    [self sortVariablesAndHeaders];
    
}



- (BOOL)evaluateRow:(NSUInteger)rowIndex {
    NSUInteger count = _rowsCount >> 1;
    
    [_variables enumerateObjectsUsingBlock:^(NyayaNodeVariable *variable, NSUInteger idx, BOOL *stop) {
        BOOL eval = (rowIndex & (count >> idx)) > 0 ? TRUE : FALSE;
        variable.evaluationValue = eval;
        /*  idx     0   1
         0  0000 & 01  10
         1  0001 & 01  10
         2  0010 & 01  10
         3  0011 & 01  10 */
    }];
    
    BOOL rowEval = [_formula evaluationValue];
    // *(_evals + rowIndex) = rowEval;
    return rowEval;
    
}

- (void)evaluateTable {
    [_trueIndices removeAllIndexes];
    // [_falseIndices removeAllIndexes];
    
    
    for (NSUInteger rowIndex=0; rowIndex < _rowsCount; rowIndex++) {
        BOOL rowEval = [self evaluateRow:rowIndex];
        
        if (rowEval) [_trueIndices addIndex:rowIndex];
        
    }
    
    _titleColumnIdx = [_headers indexOfObject:_title];
}

//- (void)setEval:(BOOL)eval atRow:(NSUInteger)rowIdx {
//    // *(_evals + rowIdx) = eval;
//}

#pragma mark - output

- (BOOL)evalAtRow:(NSUInteger)rowIdx {
    if ([_trueIndices containsIndex:rowIdx]) return YES;
    else return FALSE;
}

- (NSString*)description {
    NSArray *headers = [[_variables valueForKeyPath:@"symbol"] arrayByAddingObject:_title];
    
    NSMutableString *description = [NSMutableString stringWithString:@"|"];
    
    for (NSString *header in headers) {
        [description appendFormat:@" %@ |", header];
    }
    
    NSUInteger count = _rowsCount >> 1;
    
    for (NSUInteger rowIndex = 0; rowIndex < _rowsCount; rowIndex++) {
        [description appendString:@"\n|"];
        
        [_variables enumerateObjectsUsingBlock:^(NyayaNodeVariable *variable, NSUInteger idx, BOOL *stop) {
            BOOL eval = (rowIndex & (count >> idx)) > 0 ? TRUE : FALSE;
            /*  idx     0   1
             0  0000 & 01  10
             1  0001 & 01  10
             2  0010 & 01  10
             3  0011 & 01  10 */
            if (eval) [description appendString: @" T"];
            else [description appendString:@" F"];
            
            NSString *header = [headers objectAtIndex:idx];
            for (int i=1; i<[header length]; i++) {
                [description appendString:@" "];
            }
            [description appendString:@" |"];
            
            
            
        }];
        
        BOOL eval = [self evalAtRow:rowIndex];
        
        if (eval) [description appendString: @" T"];
        else [description appendString:@" F"];
        NSString *header = [headers lastObject];
        for (int i=1; i<[header length]; i++) {
            [description appendString:@" "];
        }
        [description appendString:@" |"];
    }
    
    return description;
    
}



#pragma mark - comparisons

- (BOOL)isTautology {
    return [_trueIndices count] == _rowsCount;
    
}

- (BOOL)isContradiction {
    return [_trueIndices count] == 0;
}

- (BOOL)isSatisfiable {
    return [_trueIndices count] > 0;
    
}

- (NSUInteger)truthCount {
    return [_trueIndices count];
    
}
- (NSUInteger)falseCount {
    return _rowsCount - [_trueIndices count];
    
}

- (BOOL)isEqualToTruthTable:(TruthTable*)truthTable {
    if (self->_rowsCount != truthTable->_rowsCount) return NO;
    
    __block BOOL sameVariables = YES;
    
    [self.variables enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        id b = [truthTable.variables objectAtIndex:idx];
        if (![obj isEqual: b]) {
            sameVariables = NO;
            *stop = YES;
        }
    }];
    
    return sameVariables && [_trueIndices isEqualToIndexSet:truthTable->_trueIndices];
    // return [[self cnfSet] isEqualToSet:[truthTable cnfSet]];
}



#pragma mark - normal forms (deprecated see BddNode)


#pragma mark - protocol NSObject

- (BOOL)isEqual:(id)object {
    if (object == self)
        return YES;
    else if (!object || ![object isKindOfClass:[self class]])
        return NO;
    return [self isEqualToTruthTable:object];
}

- (NSUInteger)hash {
    NSUInteger hash = 0;
    
    for (NSUInteger rowIdx = 0; rowIdx < _rowsCount; rowIdx++) {
        BOOL a = [self evalAtRow:rowIdx];
        if (a) hash+=1;
        hash = hash << 1;
    }
    return hash;
}

#pragma mark - memory management

- (void)dealloc {
    if (_evals) free(_evals);
}

@end

@implementation ExpandedTruthTable

- (BOOL)compact { return NO; }

- (NSArray*)makeHeaders {
    return [[self.formula setOfSubformulas] allObjects];
}

- (void)reserveMemory {
    long size = _cellCount * sizeof(BOOL); // aver ineffizient way to store a truth table
    
    if (size > 1*1000*1000)
        NSLog(@"\ncols: %u rows: %u calloc(%u,%lu) = %lu", _colsCount, _rowsCount, _cellCount, sizeof(BOOL), size);
    
    _evals = calloc(_cellCount, sizeof(BOOL));
    
}

#pragma mark - calculation

- (void)setEval:(BOOL)eval atRow:(NSUInteger)rowIndex forColumn:(NSUInteger)colIndex {
    *(_evals + rowIndex *_colsCount + colIndex) = eval;
}

- (void)setEval:(BOOL)eval atRow:(NSUInteger)rowIndex forHeader:(NSString*)header {
    [self setEval:eval atRow:rowIndex forColumn:[_headers indexOfObject:header]];
}

- (BOOL)evaluateRow:(NSUInteger)rowIndex {
    NSMutableDictionary *headersAndEvals = [NSMutableDictionary dictionaryWithCapacity:[_headers count]];
    NSUInteger count = _rowsCount >> 1;
    
    [_variables enumerateObjectsUsingBlock:^(NyayaNodeVariable *variable, NSUInteger idx, BOOL *stop) {
        BOOL eval = (rowIndex & (count >> idx)) > 0 ? TRUE : FALSE;
        variable.evaluationValue = eval;
        [headersAndEvals setValue:[NSNumber numberWithBool:eval] forKey:[variable description]];
        /*  idx     0   1
         0  0000 & 01  10
         1  0001 & 01  10
         2  0010 & 01  10
         3  0011 & 01  10 */
    }];
    
    BOOL rowEval = [_formula evaluationValue];
    // formula fil
    [_formula fillHeadersAndEvals:headersAndEvals];
    
    for (NSString *header in _headers) {
        [self setEval:[(NSNumber*)[headersAndEvals objectForKey:header] boolValue]  atRow:rowIndex forHeader:header];
    }
    
    return rowEval;
    
}

#pragma mark - output

- (BOOL)evalAtRow:(NSUInteger)rowIdx {
    return [self evalAtRow:rowIdx forColumn:_titleColumnIdx];
}

- (BOOL)evalAtRow:(NSUInteger)rowIndex forColumn:(NSUInteger)colIndex {
    return *(_evals + rowIndex *_colsCount + colIndex);
}

- (BOOL)evalAtRow:(NSUInteger)rowIndex forHeader:(NSString*)header {
    return [self evalAtRow:rowIndex forColumn:[_headers indexOfObject:header]];
}

- (NSString*)description {
    
    NSMutableString *description = [NSMutableString stringWithString:@"|"];
    
    for (NSString *header in self.headers) {
        [description appendFormat:@" %@ |", header];
    }
    
    for (NSUInteger rowIndex = 0; rowIndex < _rowsCount; rowIndex++) {
        [description appendString:@"\n|"];
        for (NSString* header in self.headers) {
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




@end
