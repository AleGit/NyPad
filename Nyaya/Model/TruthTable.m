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

@interface TruthTable () {
    NSUInteger _colsCount;
    NSUInteger _cellCount;
    NSArray *_sortedNames;
    NSUInteger _titleColumnIdx;
    
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

- (id)initWithNode:(NyayaNode *)node {
    return [self initWithNode:node expanded:NO];
}

- (id)initWithNode:(NyayaNode *)node expanded:(BOOL)expanded {
    self = [super init];
    if (self) {
        _formula = node;
        _title = [node description];
        _variables = [[node setOfVariables] allObjects];
        if (expanded)
            _headers = [[node setOfSubformulas] allObjects];
        else
            _headers = [[_variables valueForKeyPath:@"description"] arrayByAddingObject:_title];
            
        
        [self sortVariablesAndHeaders];
        
        
        
        _rowsCount = 1 << [_variables count];
        _colsCount = [_headers count];
        _cellCount = _rowsCount * _colsCount;
        
        long size = _cellCount * sizeof(BOOL);
        if (size > 30*1000*1000)
            NSLog(@"calloc(%u,%lu) = %lu", _cellCount, sizeof(BOOL), size);
        
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
    
    _titleColumnIdx = [_headers indexOfObject:_title];
}

#pragma mark - output

- (BOOL)evalAtRow:(NSUInteger)rowIndex forColumn:(NSUInteger)colIndex {
    return *(_evals + rowIndex *_colsCount + colIndex);
}

- (BOOL)evalAtRow:(NSUInteger)rowIdx {
    
    return [self evalAtRow:rowIdx forColumn:_titleColumnIdx];
    
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
    
    return sameVariables && [_trueIndices isEqualToIndexSet:truthTable->_trueIndices];
    // return [[self cnfSet] isEqualToSet:[truthTable cnfSet]];
}



#pragma mark - normal forms

- (NSSet*)cnfSet {
    NSMutableSet* conjunction = nil;
    if ([_falseIndices count] == 0) { // valid, tautology, top, T
        conjunction = [NSSet set];         // ∧{} = T
    }
    else if ([_trueIndices count] == 0) { // not satisfiable, contradiction, bottom, F
        conjunction = [NSSet setWithObject:[NSSet set]]; // ∧{∨{}} = ∧{F} = F
    }
    else if ([_trueIndices count] == 1) { // conjunction of literals: { {x} {¬y} {z} }
        NSMutableSet *c = [NSMutableSet setWithCapacity:[_sortedNames count]];
        NSUInteger idx = [_trueIndices firstIndex];
        for (NSString *name in _sortedNames) {
            BOOL eval = [self evalAtRow:idx forHeader:name];
            NSSet *d = [NSSet setWithArray:@[eval ? name : [name complementaryString]]];
            [c addObject: d];
        }
        conjunction = c;
    }
    else { // conjunction of "negated 0-rows"
        //              = "negated conjunction of literals"
        //              = "disjunction of negated literals"
        //              = "disjunction of complementary literals"
        NSMutableSet *c = [NSMutableSet setWithCapacity:[_falseIndices count]];
        [_falseIndices enumerateIndexesWithOptions:0 usingBlock:^(NSUInteger idx, BOOL *stop) { // must not be concurrent
            NSMutableSet *d = [NSMutableSet setWithCapacity:[_sortedNames count]];
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

- (NSSet*)dnfSet {
    NSMutableSet* disjunction = nil;
    if ([_falseIndices count] == 0) { // valid, tautology, top, T
        disjunction = [NSSet setWithObject:[NSSet set]];         // ∨{∧{}} = ∨{T} = T
    }
    else if ([_trueIndices count] == 0) { // not satisfiable, contradiction, bottom, F
        disjunction = [NSSet set]; // ∨{} = F
    }
    else if ([_falseIndices count] == 1) { // disjunction of complementary literals
        NSMutableSet *d = [NSMutableSet setWithCapacity:[_sortedNames count]];
        NSUInteger idx = [_falseIndices firstIndex];
        for (NSString *name in _sortedNames) {
            BOOL eval = [self evalAtRow:idx forHeader:name];
            NSSet *c = [NSSet setWithArray:@[!eval ? name : [name complementaryString]]];
            [d addObject: c];
        }
        disjunction = d;
        
    }
    else { // disjunction of "1-rows"
        //              = "conjunction of literals"
        NSMutableSet *d = [NSMutableSet setWithCapacity:[_trueIndices count]];
        [_trueIndices enumerateIndexesWithOptions:0 usingBlock:^(NSUInteger idx, BOOL *stop) { // must not be concurrent
            NSMutableSet *c = [NSMutableSet setWithCapacity:[_sortedNames count]];
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

- (NSString*)descriptionFromSet:(NSSet*)set outer:(NSString*)co inner:(NSString*)ci {
    if ([self isContradiction]) return @"F";
    if ([self isTautology]) return @"T";

    NSMutableArray *outerArray = [NSMutableArray arrayWithCapacity:[set count]];
    for (NSSet *innerSet in set) {
        if ([innerSet count] == 1)
            [outerArray addObject:[innerSet anyObject]];
        else {
            NSString *innerString = [[innerSet allObjects] componentsJoinedByString:ci];
            [outerArray addObject:[NSString stringWithFormat:@"(%@)", innerString]];
        }
    }
    return [outerArray componentsJoinedByString:co];
}

- (NSString *)cnfDescription {
    NSSet *set = [self cnfSet];
    NSLog(@"%@",set);
    
    return [self descriptionFromSet:set outer:@" ∧ " inner: @" ∨ "];
}

- (NSString *)dnfDescription {
    NSSet *set = [self dnfSet];
    NSLog(@"%@",set);
    return [self descriptionFromSet:set outer:@" ∨ " inner: @" ∧ "];
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
