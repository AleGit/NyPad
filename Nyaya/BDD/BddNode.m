//
//  BDDNode.m
//  Nyaya
//
//  Created by Alexander Maringele on 06.08.12.
//  Copyright (c) 2012 private. All rights reserved.
//

#import "BddNode.h"
#import "TruthTable.h"
#include "NyayaNode.h"
#include "NSString+NyayaToken.h"

#pragma mark -
//@interface NSArray (BddNode)
//- (BddNode*)nodeWithLeftBranch:(BddNode*)lb rightBranch:(BddNode*)rb;
//@end
//
//@implementation NSArray (BddNode)
//
//- (BddNode*) nodeWithLeftBranch:(BddNode*)lb rightBranch:(BddNode*)rb {
//    for (BddNode* node in self) {
//        if (node.leftBranch.id == lb.id && node.rightBranch.id == rb.id)
//            return node;
//    }
//    return nil;
//}
//
//@end

//@interface NSString (BddNode)
//- (NSString*)conjunct;
//- (NSString*)disjunct;
//@end
//
//@implementation NSString (BddNode)
//
//- (NSString*)conjunct {
//    NSString *s = [[self stringByReplacingOccurrencesOfString:@":1" withString:@""]
//            stringByReplacingOccurrencesOfString:@":" withString:@" ∧ "];
//    
//    return s;
//    
//}
//- (NSString*)disjunct {
//    NSString *s = [[self stringByReplacingOccurrencesOfString:@":0" withString:@""]
//                   stringByReplacingOccurrencesOfString:@":" withString:@" ∨ ¬"];
//    s = [@"¬" stringByAppendingString:s];
//    s = [s stringByReplacingOccurrencesOfString:@"¬¬" withString:@""];
//    
//    return s;
//}
//
//@end
#pragma mark -

@interface BddNode () {
    NSInteger _id;
    NSString *_name;
    BddNode *_leftBranch;
    BddNode *_rightBranch;
    BOOL _reduced;
    NSArray *_levels;
    
    NSString *_cnfDescription;
    NSString *_dnfDescritpion;
}
- (id)initWithName:(NSString*)name id:(NSUInteger)id;
- (id)initWithName:(NSString*)name id:(NSUInteger)id leftBranch:(BddNode*)lb rightBranch:(BddNode*)rb;
+ (id)top;
+ (id)bottom;
@end

@implementation BddNode

+ (id)top {
    return [[BddNode alloc] initWithName:@"1" id:1];
}

+ (id)bottom {
    return [[BddNode alloc] initWithName:@"0" id:0];
}

- (id)initWithName:(NSString*)name id:(NSUInteger)id {
    return [self initWithName:name id:id leftBranch:nil rightBranch:nil];
}

- (id)initWithName:(NSString*)name id:(NSUInteger)id leftBranch:(BddNode*)lb rightBranch:(BddNode*)rb {
    self = [super init];
    if (self) {
        _name = name;
        _id = id;
        _leftBranch = lb;
        _rightBranch = rb;
    }
    return self;
}

- (BOOL)isLeaf {
    return _leftBranch == nil;
}

+ (BddNode *)bddWithTruthTable:(TruthTable *)truthTable reduce:(BOOL)reduce {
    if (!truthTable) return nil;
    
    BddNode *bdd = nil;
    NSMutableArray *levels = [NSMutableArray arrayWithCapacity:[truthTable.variables count]];
    
    BddNode *top = [BddNode top];
    BddNode *bottom = [BddNode bottom];
    
    if (reduce) {
        if (truthTable.isContradiction) {
            bottom->_levels = @[@[bottom]];
            bottom->_reduced = YES;
            return bottom;
        }
        else if (truthTable.isTautology) {
            top->_levels = @[@[top]];
            top->_reduced = YES;
            return top;
        }
    }
    
    NSAssert(bottom.id == 0, @"bottom should be zero");
    NSAssert(top.id == 1, @"top should be one");
    
    NSUInteger rowsCount = truthTable.rowsCount;
    NSUInteger varsCount = [truthTable.variables count];
    
    NSMutableArray *allNodes = [NSMutableArray arrayWithCapacity:rowsCount];
    if (reduce) {
        [allNodes addObject:bottom];    // idx == 0
        [allNodes addObject:top];       // idx == 1
    }
    
    NSMutableArray *lowerLevelArray = [NSMutableArray arrayWithCapacity:rowsCount];
    
    for (NSUInteger rowIdx = 0; rowIdx < rowsCount; rowIdx++) {
        BddNode *node = nil;
        BOOL eval = [truthTable evalAtRow:rowIdx];
        if (reduce) { // reuse nodes
            node = eval ? top : bottom;
        }
        else { // do not reuse nodes
            node = eval ? [[BddNode alloc] initWithName:@"1" id:[allNodes count]] : [[BddNode alloc] initWithName:@"0" id:[allNodes count]];
            [allNodes addObject:node];
        }
        [lowerLevelArray addObject:node];
    }
    [levels addObject:lowerLevelArray]; // the array with 0 and 1-nodes
    
    NSMutableArray *levelArray;
    for (NSUInteger varIdx = 0; varIdx < varsCount; varIdx++) {
        NyayaNode *variable = [truthTable.variables objectAtIndex:varsCount-varIdx-1];
        levelArray = [NSMutableArray arrayWithCapacity:[lowerLevelArray count]/2];
        
        for (NSUInteger idx = 0; idx < [lowerLevelArray count]; idx +=2) {
            BddNode *left = [lowerLevelArray objectAtIndex:idx];
            BddNode *right = [lowerLevelArray objectAtIndex:idx+1];
            BddNode * node = nil;
            
            if (reduce) {
                if (left == right) node = left;
                
                // try to find the node in actual level
                for (BddNode *ln in levelArray) {
                    if (ln.leftBranch == left && ln.rightBranch == right) {
                        node = ln;
                        break;  // found the same node
                    }
                }
            }
            
            if (!node) {
                node = [[BddNode alloc] initWithName:variable.symbol
                                                        id:[allNodes count]
                                                leftBranch:left
                                               rightBranch:right];
                [allNodes addObject:node];
                        
            }
            [levelArray addObject:node];
        }
        
        lowerLevelArray = levelArray;
        [levels addObject:lowerLevelArray];
    }
    
    NSAssert([lowerLevelArray count] == 1, @"lowerLevelArray should contain one element");
    bdd = [lowerLevelArray objectAtIndex:0];
    bdd->_levels = levels;
    return bdd;
}

#pragma mark - disjunctive normal form

- (NSMutableSet*)pathsTo:(NSString*)name {
    NSMutableSet *set = [NSMutableSet set];
    if ([self.name isEqual:name]) {
        [set addObject:[NSMutableArray array]]; // an empty path leads to name
    }
    else if (!self.isLeaf) {
        for (NSMutableArray *path in [self.leftBranch pathsTo:name]) {
            [path insertObject:[NSString stringWithFormat:@"¬%@", self.name] atIndex:0];
            [set addObject:path];
        }
        for (NSMutableArray *path in [self.rightBranch pathsTo:name]) {
            [path insertObject:self.name atIndex:0];
            [set addObject:path];
        }
    }
    return set;
}

- (NSMutableSet*)disjunctiveSet {
    return [self pathsTo:@"1"];
}

- (NSMutableSet*)conjunctiveSet {
    NSSet *set = [self pathsTo:@"0"];
    NSMutableSet *cset = [NSMutableSet setWithCapacity:[set count]];
    
    for (NSArray *path in set) {
        NSMutableArray *array = [NSMutableArray arrayWithCapacity:[path count]];
        for (NSString *s in path) {
            [array addObject:[s complementaryString]];
        }
        [cset addObject:array];
    }
    return cset;
}

- (NSString*)dnfDescription {
    NSSet* set = [self disjunctiveSet];                             // paths to 0
    if ([set count] == 0) return @"F";                              // no paths to 1
    
    NSSet *cs = [self conjunctiveSet];                              // paths to 0
    if ([cs count] == 0) return @"T";                               // no path to 0
    
    NSMutableArray *ccs = [NSMutableArray arrayWithCapacity:[set count]];
    for (NSArray* path in set) {
        NSString *s = [path componentsJoinedByString:@" ∧ "];
        [ccs addObject:[NSString stringWithFormat:@"(%@)", s]];
    }
    return [ccs componentsJoinedByString:@" ∨ "];
    
}

- (NSString*)cnfDescription {
    NSSet* set = [self conjunctiveSet];
    if ([set count] == 0) return @"T";                              // no path to 0
    
    NSSet *ds = [self disjunctiveSet];                              // paths to 1
    if ([ds count] == 0) return @"F";                               // no paths to 1
    
    NSMutableArray *ccs = [NSMutableArray arrayWithCapacity:[set count]];
    for (NSArray* path in set) {
        NSString *s = [path componentsJoinedByString:@" ∨ "];
        [ccs addObject:[NSString stringWithFormat:@"(%@)", s]];
    }
    return [ccs componentsJoinedByString:@" ∧ "];
}


#pragma mark - protocol NSObject

- (BOOL)isEqual:(id)object {
    if (self == object) return YES;
    
    if (![object isMemberOfClass:[self class]]) return NO;
    
    return self.id == [object id];
    
}

- (NSUInteger)hash {
    return self.id;
}

- (id)copyWithZone:(NSZone *)zone {
    return self;
}


@end
