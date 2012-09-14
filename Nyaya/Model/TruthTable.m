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
#import "NyayaConstants.h"

@interface TruthTable () {
@protected
    NSUInteger _colsCount;
    NSUInteger _cellCount;
    NSUInteger _rowsCount;
    NSArray *_sortedNames;
    NSUInteger _titleColumnIdx;
    
    BOOL *_evals;
    NSMutableIndexSet *_trueIndices;
    NSMutableIndexSet *_falseIndices;
    
    
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
    long size = _cellCount * sizeof(BOOL);
    
    if (size > 1*1000*1000)
        NSLog(@"\ncols: %u rows: %u calloc(%u,%lu) = %lu", _colsCount, _rowsCount, _cellCount, sizeof(BOOL), size);
    
    _evals = calloc(_cellCount, sizeof(BOOL));
    
}

- (id)initWithNode:(NyayaNode *)node compact:(BOOL)compact {
    self = [super init];
    if (self) {
        if (!compact) self->isa = [ExpandedTruthTable class];
        
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
        _falseIndices = [NSMutableIndexSet indexSet];
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
    
    // formula fil
    *(_evals + rowIndex) = rowEval;
    
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

- (void)setEval:(BOOL)eval atRow:(NSUInteger)rowIdx {
    *(_evals + rowIdx) = eval;
}

#pragma mark - output

- (BOOL)evalAtRow:(NSUInteger)rowIdx {
    return *(_evals + rowIdx);
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

- (NSString*)htmlDescription {
    
NSString *template = @"<!DOCTYPE HTML PUBLIC \"-//W3C//DTD HTML 4.01 Transitional//EN\">"
"<html><head><meta http-equiv=\"content-type\" content=\"text/html; charset=UTF-8\">"
"<title>Nyāya :: TruthTable</title>"
// "<link rel=\"stylesheet\" type=\"text/css\" href=\"format.css\"></head>"
"    <style type=\"text/css\">"
"    body {"
"    margin-left:20px; margin-right:70px; margin-top:20px; margin-bottom:10px;"
//"    background-image:url(syntaxtree.png), -webkit-linear-gradient(top left, #F9F9F9 25%, #F9F9F9 75%);"
"    background-image:-webkit-linear-gradient(top left, #F9F9F9 25%, #F9F9F9 75%);"
"}"
"h1,h2,h3,h4,p,ul,ol,li,div,td,th,address,blockquote,nobr,b,i {"
"    font-family:Arial,Helvetica,sans-serif; color:#555555;"
"}"
"table { border:solid 1px #555555; border-collapse:collapse; float:left; margin-right:20px}"
"tr, th, td { border:solid 1px #AAAAAA; text-align:center; padding:2px 3px 2px 3px;}"
"td.green { background-color:#DDFFDD; }"
"td.red { background-color:#FFDDDD; }"
"    </style> "
"<body> "
"<table>%@</table> </body></html> <p>Φ = %@</p>";
    
    NSMutableString *description = [NSMutableString stringWithString:@"<tr>"];
    
    for (NyayaNode *variable in _variables) {
        [description appendFormat:@"<th>%@</th>", variable.symbol];
    }
    [description appendString:@"</th><th></th><th>Φ</th></tr>"];
    
    NSUInteger count = _rowsCount >> 1;
    
    NSUInteger rowCount = 0;
    BOOL lastVal = ![self evalAtRow:0];    // allways print the first line
    NSString *tdT = nil;
    NSString *tdF = nil;
    BOOL compact = TRUTH_TABLE_MAX_FULL_ROWS < _rowsCount;
    BOOL spare = TRUTH_TABLE_MAX_ROWS < _rowsCount;
    BOOL firstSpare = YES;
    
    if (compact) {
        tdT = @"<td class=\"green\"></td>";
        tdF = @"<td class=\"red\"></td>";
    }
    else {
        tdT = @"<td class=\"green\">T</td>";
        tdF = @"<td class=\"red\">F</td>";
    }
    
    for (NSUInteger rowIndex = 0; rowIndex < _rowsCount; rowIndex++) {
        [description appendString:@"<tr>"];
        
        
        
        
        BOOL eval = [self evalAtRow:rowIndex];
        
        if (TRUTH_TABLE_MAX_ROWS < rowCount) {
            rowIndex = _rowsCount -1;   // allways print the last line
        }
        
        if (!spare || lastVal != eval || rowIndex == (_rowsCount-1)) {
            firstSpare = YES;
            
            [_variables enumerateObjectsUsingBlock:^(NyayaNodeVariable *variable, NSUInteger idx, BOOL *stop) {
                BOOL eval = (rowIndex & (count >> idx)) > 0 ? TRUE : FALSE;
                
                /*  idx     0   1
                 0  0000 & 01  10
                 1  0001 & 01  10
                 
                 2  0010 & 01  10
                 3  0011 & 01  10 */
                
                if (eval) [description appendString: tdT];
                else [description appendString:tdF];
                
            }];
            [description appendString:@"<td></td>"];
            
            
            if (eval) [description appendString: tdT];
            else [description appendString:tdF];
            
            rowCount++;
        }
        else if (firstSpare) {
            firstSpare = NO;
            [description appendFormat:@"<td colspan='%u'></td><td></td>", [_variables count]];
            if (eval) [description appendString: tdT];
            else [description appendString:tdF];
            rowCount++;
        }
        
        lastVal = eval;
        
        [description appendString:@"</tr>"];
    }
    
    if (spare) {
        NSString *text = [NSString stringWithFormat:NSLocalizedString(TRUTH_TABLE_U_ROWS,nil), _rowsCount];
        [description appendFormat:@"<td colspan='%u'>%@</td>", [_variables count]+2, text];
        
    }
    return [NSString stringWithFormat:template, description, _title];
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
    free(_evals);
}

@end

@implementation ExpandedTruthTable

- (BOOL)compact { return NO; }

- (NSArray*)makeHeaders {
    return [[self.formula setOfSubformulas] allObjects];
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
