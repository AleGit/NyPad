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
    static dispatch_once_t pred = 0;
    __strong static BddNode* _top = nil;
    dispatch_once(&pred, ^{ _top = [[BddNode alloc] initWithName:@"1" id:1]; });
    return _top;
}

+ (id)bottom {
    static dispatch_once_t pred = 0;
    __strong static BddNode* _bottom = nil;
    dispatch_once(&pred, ^{ _bottom = [[BddNode alloc] initWithName:@"0" id:0];});
    return _bottom;
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

+ (BddNode *)diagramWithTruthTable:(TruthTable *)truthTable {
    if (truthTable.isTautology) return [self top];
    if (truthTable.isContradiction) return [self bottom];
    
    NSMutableArray *allNodes = [NSMutableArray arrayWithCapacity:truthTable.rowsCount];
    // maximum capacity needed is rowCount/2 + rowCount/4 + rowCount/8
    
    [allNodes addObject:[self bottom]]; // object at index 0 has id 0
    [allNodes addObject:[self top]];    // object at index 1 has id 1
    
   
    NSMutableArray *lastArray = nil;
    NSMutableArray *thisArray = nil;
    NSUInteger count = [truthTable.variables count];
    
    for (NSUInteger idx = count-1; idx < count; idx--) { // (NSUInteger)-1 == NSUIntegerMax
        NyayaNode *variable = [truthTable.variables objectAtIndex:idx];
        
        if (!lastArray) {
            thisArray = [NSMutableArray arrayWithCapacity:truthTable.rowsCount/2];
            
            for (NSUInteger rowIdx = 0; rowIdx < truthTable.rowsCount; rowIdx += 2) {
                
                BddNode * leftBranch = [truthTable evalAtRow:rowIdx] ? [BddNode top] : [BddNode bottom];
                BddNode * rightBranch = [truthTable evalAtRow:rowIdx+1] ? [BddNode top] : [BddNode bottom];
                
                if (leftBranch == rightBranch) [thisArray addObject:leftBranch];
                else {
                    BddNode *node = [thisArray nodeWithLeftBranch:leftBranch rightBranch:rightBranch];
                    if (!node) {
                        node = [[BddNode alloc] initWithName:variable.symbol
                                                          id:[allNodes count]
                                                  leftBranch:leftBranch
                                                 rightBranch:rightBranch];
                        [allNodes addObject:node];                        
                    }
                    [thisArray addObject:node];
                }  
            }
            
        }
        else {
            thisArray = [NSMutableArray arrayWithCapacity:[lastArray count]/2];
            
            for (NSUInteger idx =0; idx < [lastArray count]; idx += 2) {
                
                BddNode * leftBranch = [lastArray objectAtIndex:idx];
                BddNode * rightBranch = [lastArray objectAtIndex:idx+1];
                
                if (leftBranch == rightBranch) [thisArray addObject:leftBranch];
                else {
                    BddNode *node = [thisArray nodeWithLeftBranch:leftBranch rightBranch:rightBranch];
                    if (!node) {
                        node = [[BddNode alloc] initWithName:variable.symbol
                                                          id:[allNodes count]
                                                  leftBranch:leftBranch
                                                 rightBranch:rightBranch];
                        [allNodes addObject:node];
                    }
                    [thisArray addObject:node];
                }
                
            }
            
            
        }
        
        lastArray = thisArray;
        thisArray = nil;
    }
    
    NSAssert([lastArray count] == 1, @"should be one");
    
    return [lastArray objectAtIndex:0];
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


@end
