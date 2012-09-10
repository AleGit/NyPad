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

#pragma mark -
@interface NSArray (BddNode)
- (BddNode*)nodeWithLeftBranch:(BddNode*)lb rightBranch:(BddNode*)rb;
@end

@implementation NSArray (BddNode)

- (BddNode*) nodeWithLeftBranch:(BddNode*)lb rightBranch:(BddNode*)rb {
    for (BddNode* node in self) {
        if (node.leftBranch.id == lb.id && node.rightBranch.id == rb.id)
            return node;
    }
    return nil;
}

@end

@interface NSString (BddNode)
- (NSString*)conjunct;
- (NSString*)disjunct;
@end

@implementation NSString (BddNode)

- (NSString*)conjunct {
    NSString *s = [[self stringByReplacingOccurrencesOfString:@":1" withString:@""]
            stringByReplacingOccurrencesOfString:@":" withString:@" ∧ "];
    
    return s;
    
}
- (NSString*)disjunct {
    NSString *s = [[self stringByReplacingOccurrencesOfString:@":0" withString:@""]
                   stringByReplacingOccurrencesOfString:@":" withString:@" ∨ ¬"];
    s = [@"¬" stringByAppendingString:s];
    s = [s stringByReplacingOccurrencesOfString:@"¬¬" withString:@""];
    
    return s;
}

@end
#pragma mark -

@interface BddNode ()
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



+ (BddNode *)bddWithTruthTable:(TruthTable *)truthTable reduce:(BOOL)reduced {
    BddNode *bdd = nil;
    NSMutableArray *levels = [NSMutableArray arrayWithCapacity:[truthTable.variables count]];
    
    BddNode *top = [BddNode top];
    BddNode *bottom = [BddNode bottom];
    
    if (reduced) {
        if (truthTable.isContradiction) {
            bottom.levels = @[@[bottom]];
            return bottom;
        }
        else if (truthTable.isTautology) {
            top.levels = @[@[top]];
            return top;
        }
    }
    
    NSAssert(bottom.id == 0, @"bottom should be zero");
    NSAssert(top.id == 1, @"top should be one");
    
    NSUInteger rowsCount = truthTable.rowsCount;
    NSUInteger varsCount = [truthTable.variables count];
    
    NSMutableArray *allNodes = [NSMutableArray arrayWithCapacity:rowsCount];
    if (reduced) {
        [allNodes addObject:bottom];    // idx == 0
        [allNodes addObject:top];       // idx == 1
    }
    
    NSMutableArray *lowerLevelArray = [NSMutableArray arrayWithCapacity:rowsCount];
    
    for (NSUInteger rowIdx = 0; rowIdx < rowsCount; rowIdx++) {
        BddNode *node = nil;
        BOOL eval = [truthTable evalAtRow:rowIdx];
        if (reduced) { // reuse nodes
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
            
            if (reduced) {
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
    bdd.levels = levels;
    return bdd;
}

- (NSArray*)cPaths1 {
    if (![self isLeaf]) {
        NSArray *lefts = [self.leftBranch cPaths1];
        NSArray *rights = [self.rightBranch cPaths1];
        
        // both can't be null !!! otherwise it would be a leaf 0 (no paths lead to 1)
        // the can't be equal ??? otherwise it would be leaf 1 (the same paths lead to 1)
        
        NSMutableArray *paths = [NSMutableArray array];
        
        if (!lefts) {
            // the variable must true to lead to 1
            for (NSString *path in rights) {
                [paths addObject:[NSString stringWithFormat:@"%@ ∧ %@", self.name, path]];
            }
            
        }
        else if (!rights) {
            // the variable must be negated to lead to 1
            for (NSString *path in lefts) {
                [paths addObject:[NSString stringWithFormat:@"¬%@ ∧ %@", self.name, path]];
            }
            
        }
        else {
            for (NSString *path in rights) {
                // or she is true and other variables
                [paths addObject:[NSString stringWithFormat:@"%@ ∧ %@", self.name, path]];
            }
            
            for (NSString *path in lefts) {
                [paths addObject:[NSString stringWithFormat:@"¬%@ ∧ %@", self.name, path]];
                // [paths addObject:[NSString stringWithFormat:@"%@", path]];
                
            }
            
        }
        
        return paths;
        
        
    }
    else if (self.id==1) return @[@"1"];
    else return nil; 
}

-(NSString*)dnfDescription {
    if (self.isLeaf) return self.name;
    
    NSString *s = [NSString stringWithFormat:@"(%@)", [[self cPaths1] componentsJoinedByString:@") ∨ ("]];
    return [s stringByReplacingOccurrencesOfString:@" ∧ 1" withString:@""];
    
}


- (NSArray*)dPaths0 {
    if (![self isLeaf]) {
        NSArray *lefts = [self.leftBranch dPaths0];
        NSArray *rights = [self.rightBranch dPaths0];
        
        NSMutableArray *paths = [NSMutableArray array];
        
        if (!rights) {
            for (NSString *path in lefts) {
                [paths addObject:[NSString stringWithFormat:@"%@ ∨ %@", self.name, path]];
            }
        }
        else if (!lefts) {
            // the variable must true to lead to 1
            for (NSString *path in rights) {
                [paths addObject:[NSString stringWithFormat:@"¬%@ ∨ %@", self.name, path]];
            }
            
        }
        else {
            for (NSString *path in lefts) {
                [paths addObject:[NSString stringWithFormat:@"%@ ∨ %@", self.name, path]];
                // the variable is false and other variables
                // [paths addObject:[NSString stringWithFormat:@"%@", path]];
            }
            for (NSString *path in rights) {
                // or she is true and other variables
                [paths addObject:[NSString stringWithFormat:@"¬%@ ∨ %@", self.name, path]];
                // [paths addObject:[NSString stringWithFormat:@"%@",path]];
            }
        }
        return paths;
        
    }
    else if (self.id==0) return @[@"¬0"];
    else return nil;
}

-(NSString*)cnfDescription {
    if (self.isLeaf) return self.name;
    
    NSString *s = [NSString stringWithFormat:@"(%@)", [[self dPaths0] componentsJoinedByString:@") ∧ ("]];
    return  [s stringByReplacingOccurrencesOfString:@" ∨ ¬0" withString:@""];
}

- (NSUInteger)levelCount {
    if (self.isLeaf) return 1;
    
    NSUInteger leftLevelCount = [self.leftBranch levelCount];
    NSUInteger rightLevelCount = [self.rightBranch levelCount];
    
    return 1 + (leftLevelCount > rightLevelCount ? leftLevelCount : rightLevelCount);
}

- (NSUInteger)nodeCount {
    // if (self.isLeaf) return 0;
    return 1 + [self.leftBranch nodeCount] + [self.rightBranch nodeCount];
}


#pragma mark - protocol NSObject
/*
 - (BOOL)isEqualToLeaf:(BddLeaf*)leaf {
 return self.id == leaf.id;
 }
 
 - (BOOL)isEqual:(id)object {
 if (self == object)
 return YES;
 else if ([object isKindOfClass:[self class]])
 return [self isEqualToLeaf:object];
 else
 return NO;
 }
 
 - (NSUInteger)hash {
 return self.id;
 }
 */

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
