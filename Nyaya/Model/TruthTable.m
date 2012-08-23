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

@interface TruthTable () {
    NSUInteger _rowsCount;
    NSUInteger _colsCount;
    NSUInteger _cellCount;
    NSArray *_sortedNames;
    
    BOOL *_evals;
    NSMutableIndexSet *_trueIndices;
    NSMutableIndexSet *_falseIndices;
}
@end

@implementation TruthTable

#pragma mark - input

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

- (id)initWithFormula:(NyayaNode *)formula {
    self = [super init];
    if (self) {
        _formula = formula;
        _title = [formula description];
        _variables = [[formula setOfVariables] allObjects];
        _headers = [[formula setOfSubformulas] allObjects];
        
        [self sortVariablesAndHeaders];
        
        _rowsCount = 1 << [_variables count];
        _colsCount = [_headers count];
        _cellCount = _rowsCount * _colsCount;
        
        _evals = calloc(_cellCount, sizeof(BOOL));
        _trueIndices = [NSMutableIndexSet indexSet];
        _falseIndices = [NSMutableIndexSet indexSet];
    }
    
    return self;
}

#pragma mark - calculation

- (void)setOrder:(NSArray *)variableNames {
    _sortedNames = variableNames;
    [self sortVariablesAndHeaders];
    
}

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

- (void)evaluateTable {
    [_trueIndices removeAllIndexes];
    [_falseIndices removeAllIndexes];
    
                        
    for (NSUInteger rowIndex=0; rowIndex < _rowsCount; rowIndex++) {
        BOOL rowEval = [self evaluateRow:rowIndex];
        
        if (rowEval) [_trueIndices addIndex:rowIndex];
        else [_falseIndices addIndex:rowIndex];
    }
}

#pragma mark - output

- (BOOL)evalAtRow:(NSUInteger)rowIndex forColumn:(NSUInteger)colIndex {
    return *(_evals + rowIndex *_colsCount + colIndex);
}

- (BOOL)evalAtRow:(NSUInteger)rowIndex forHeader:(NSString*)header {
    
    return [self evalAtRow:rowIndex forColumn:[_headers indexOfObject:header]];
    
}

- (NSString*)descriptionWithHeaders:(NSArray*)headers {
    
    NSMutableString *description = [NSMutableString stringWithString:@"|"];
    
    for (NSString *header in headers) {
        [description appendFormat:@" %@ |", header]; 
    }
    
    for (NSUInteger rowIndex = 0; rowIndex < _rowsCount; rowIndex++) {
        [description appendString:@"\n|"];
        for (NSString* header in headers) {
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

- (NSString*)description {
    return [self descriptionWithHeaders:_headers];
}

- (NSString*)minimalDescription {
    NSArray *headers = [[_variables valueForKeyPath:@"symbol"] arrayByAddingObject:_title];
    
    NSMutableString *description = [NSMutableString stringWithString:@"|"];
    
    for (NSString *header in headers) {
        [description appendFormat:@" %@ |", header]; 
    }
    
    headers = [headers arrayByAddingObject:_title];
    for (NSUInteger rowIndex = 0; rowIndex < _rowsCount; rowIndex++) {
        [description appendString:@"\n|"];
        for (NSString* header in headers) {
            BOOL eval = [self evalAtRow:rowIndex forHeader:header];
            if (eval) [description appendString: @" T"];
            else [description appendString:@" F"];
            [description appendString:@" |"];
        }
    }
    
    return description;
}

#pragma mark - comparisons

- (BOOL)isTautology {
    return [_falseIndices count] == 0;
    
}

- (BOOL)isContradiction {
    return [_trueIndices count] == 0;
}

- (BOOL)isSatisfiable {
    return [_trueIndices count] > 0;
    
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
    
    return sameVariables && [_trueIndices isEqual:truthTable->_trueIndices];
}

#pragma mark - normal forms


- (NSString*)disjRow:(NSUInteger)idx negate:(BOOL)negate {
    NSMutableArray *literals = [NSMutableArray arrayWithCapacity:[_sortedNames count]];
    for (NSString *name in _sortedNames) {
        BOOL eval = [self evalAtRow:idx forHeader:name];
        if (eval != negate) {
            [literals addObject:name];
        }
        else [literals addObject:[name complementaryString]];
        
    }
    return [literals componentsJoinedByString:@" ∨ "];
    
}

- (NSString*)conjRow:(NSUInteger)idx negate:(BOOL)negate {
    NSMutableArray *literals = [NSMutableArray arrayWithCapacity:[_sortedNames count]];
    for (NSString *name in _sortedNames) {
        BOOL eval = [self evalAtRow:idx forHeader:name];
        if (eval != negate) {
            [literals addObject:[name complementaryString]];
        }
        else [literals addObject:name];
        
    }
    return [literals componentsJoinedByString:@" ∧ "];
}



- (NSString*)snf {
    NSString *result = nil;
    if ([_trueIndices count] == 0) result = @"F";
    else if ([_falseIndices count] == 0) result = @"T";
    
    
    else if ([_trueIndices count] == 1) {
        NSUInteger idx = [_trueIndices firstIndex];
        result = [self conjRow:idx negate:YES];
        
    }
    else if ([_falseIndices count] == 1) {
        NSUInteger idx = [_falseIndices firstIndex];
        result = [self disjRow:idx negate:YES];
    }
    
    return result;
}

- (NSString*)cnfDescription {
    NSString *result = [self snf];
    if (!result) {
        NSMutableArray *clauses = [NSMutableArray arrayWithCapacity:[_falseIndices count]];
        [_falseIndices enumerateIndexesWithOptions:0 usingBlock:^(NSUInteger idx, BOOL *stop) { // must not be concurrent
            [clauses addObject:[self disjRow:idx negate:NO]];
        }];
        result = [NSString stringWithFormat:@"(%@)", [clauses componentsJoinedByString:@") ∧ ("]];
    }
    
    return result;
}

- (NSString*)dnfDescription {
    NSString *result = [self snf];
    if (!result) {
        NSMutableArray *clauses = [NSMutableArray arrayWithCapacity:[_trueIndices count]];
        [_trueIndices enumerateIndexesWithOptions:0 usingBlock:^(NSUInteger idx, BOOL *stop) { // must not be concurrent
            [clauses addObject:[self conjRow:idx negate:NO]];
        }];
        result = [NSString stringWithFormat:@"(%@)", [clauses componentsJoinedByString:@") ∨ ("]];
    }
    
    return result;
}

- (NSString*)nnfDescription {
    if ([_falseIndices count] <= [_trueIndices count]) return [self cnfDescription];
    else return [self dnfDescription];
}

#pragma mark - cnf array

- (NSArray*)cnfArray {
    NSArray* conjunction = nil;
    if ([_falseIndices count] == 0) { // valid, tautology, top, T
        conjunction = @[];         // ∧{} = T
    }
    else if ([_trueIndices count] == 0) { // not satisfiable, contradiction, bottom, F
        conjunction = @[@[]]; // ∧{∨{}} = ∧{F} = F
    }
    else if ([_trueIndices count] == 1) { // conjunction of literals: { {x} {¬y} {z} }
        NSMutableArray *c = [NSMutableArray arrayWithCapacity:[_sortedNames count]];
        NSUInteger idx = [_trueIndices firstIndex];
        for (NSString *name in _sortedNames) {
            BOOL eval = [self evalAtRow:idx forHeader:name];
            [c addObject: @[eval ? name : [name complementaryString]]];
        }
        conjunction = c;
    }
    else { // conjunction of "negated 0-rows"
        //              = "negated conjunction of literals"
        //              = "disjunction of negated literals"
        //              = "disjunction of complementary literals"
        NSMutableArray *c = [NSMutableArray arrayWithCapacity:[_falseIndices count]];
        [_falseIndices enumerateIndexesWithOptions:0 usingBlock:^(NSUInteger idx, BOOL *stop) { // must not be concurrent
            NSMutableArray *d = [NSMutableArray arrayWithCapacity:[_sortedNames count]];
            for (NSString *name in _sortedNames) {
                BOOL eval = [self evalAtRow:idx forHeader:name];
                [d addObject: !eval ? name : [name complementaryString]];
            }
            [c addObject:d];
        }];
        conjunction = c;
    }
    return conjunction;
}

- (NSArray*)dnfArray {
    NSArray* disjunction = nil;
    if ([_falseIndices count] == 0) { // valid, tautology, top, T
        disjunction = @[@[]];         // ∨{∧{}} = T
    }
    else if ([_trueIndices count] == 0) { // not satisfiable, contradiction, bottom, F
        disjunction = @[]; // ∨{} = F
    }
    else if ([_falseIndices count] == 1) { // disjunction of complementary literals
        NSMutableArray *d = [NSMutableArray arrayWithCapacity:[_sortedNames count]];
        NSUInteger idx = [_falseIndices firstIndex];
        for (NSString *name in _sortedNames) {
            BOOL eval = [self evalAtRow:idx forHeader:name];
            [d addObject: @[!eval ? name : [name complementaryString]]];
        }
        disjunction = d;
        
    }
    else { // disjunction of "1-rows"
        //              = "conjunction of literals"
        NSMutableArray *d = [NSMutableArray arrayWithCapacity:[_trueIndices count]];
        [_trueIndices enumerateIndexesWithOptions:0 usingBlock:^(NSUInteger idx, BOOL *stop) { // must not be concurrent
            NSMutableArray *c = [NSMutableArray arrayWithCapacity:[_sortedNames count]];
            for (NSString *name in _sortedNames) {
                BOOL eval = [self evalAtRow:idx forHeader:name];
                [c addObject: eval ? name : [name complementaryString]];
            }
            [d addObject:c];
        }];
        disjunction = d;
    }
    return disjunction;
}

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
        BOOL a = [self evalAtRow:rowIdx forHeader:_title];
        if (a) hash+=1;
        hash = hash << 1;
    }
    return hash;
}

#pragma mark - memory management

- (void)dealloc {
    free(_evals);
}

@end
