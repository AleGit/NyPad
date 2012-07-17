//
//  NyayaNode.m
//  Nyaya
//
//  Created by Alexander Maringele on 17.07.12.
//  Copyright (c) 2012 private. All rights reserved.
//

#import "NyayaNode.h"

@interface NyayaNode () {
    NyayaBool _value;
    
}
@end

@implementation NyayaNode

@synthesize type = _type;
@synthesize symbol = _symbol;
@synthesize nodes = _nodes;

+ (NyayaNode*)constant:(NSString *)name with:(NyayaBool)value {
    NyayaNode*node=[[NyayaNode alloc] init];
    node->_symbol = name;
    node->_type = NyayaConstant;
    node->_value = value;
    return node;
}

+ (NyayaNode*)constant:(NSString*)name {
    if ([name isEqualToString:@"T"]) return [self constant:name with:NyayaTrue];
    else if ([name isEqualToString:@"1"]) return [self constant:name with:NyayaTrue];
    else if ([name isEqualToString:@"F"]) return [self constant:name with:NyayaFalse];
    else if ([name isEqualToString:@"0"]) return [self constant:name with:NyayaFalse];
    else return [self constant:name with:NyayaUndefined];
}

+ (NyayaNode*)negation:(NyayaNode *)firstNode {
    NyayaNode*node=[[NyayaNode alloc] init];
    node->_symbol = @"¬";
    node->_type = NyayaNegation;
    node->_value = NyayaUndefined;
    node->_nodes = [NSArray arrayWithObject:firstNode];
    return node;
}

+ (NyayaNode*)conjunction:(NyayaNode *)firstNode with:(NyayaNode *)secondNode {
    NyayaNode*node=[[NyayaNode alloc] init];
    node->_symbol = @"∧";
    node->_type = NyayaConjunction;
    node->_value = NyayaUndefined;
    node->_nodes = [NSArray arrayWithObjects:firstNode,secondNode, nil];
    return node;
}

+ (NyayaNode*)disjunction:(NyayaNode *)firstNode with:(NyayaNode *)secondNode {
    NyayaNode*node=[[NyayaNode alloc] init];
    node->_symbol = @"∨";
    node->_type = NyayaDisjunction;
    node->_value = NyayaUndefined;
    node->_nodes = [NSArray arrayWithObjects:firstNode,secondNode, nil];
    return node;
}

+ (NyayaNode*)implication:(NyayaNode *)firstNode with:(NyayaNode *)secondNode {
    NyayaNode*node=[[NyayaNode alloc] init];
    node->_symbol = @"→";
    node->_type = NyayaImplication;
    node->_value = NyayaUndefined;
    node->_nodes = [NSArray arrayWithObjects:firstNode,secondNode, nil];
    return node;
}

+ (NyayaNode*)function:(NSString *)name with:(NSArray *)nodes {
    NyayaNode*node=[[NyayaNode alloc] init];
    node->_symbol = name;
    node->_type = NyayaFunction;
    node->_nodes = [nodes copy];
    return node;
}

- (NyayaBool)value {
    NSUInteger count = [self.nodes count];
    NyayaNode *first = (count > 0) ? [self.nodes objectAtIndex:0] : nil;
    NyayaNode *second = (count > 1) ? [self.nodes objectAtIndex:1] : nil;
    
    switch(_type) {
        case NyayaConstant:
            return _value;
            
        case NyayaNegation:
            if ([first value] == NyayaFalse) return NyayaTrue;
            if ([first value] == NyayaTrue) return NyayaFalse;
            return NyayaUndefined;
            
        case NyayaDisjunction:
            if ([first value] == NyayaTrue || [second value] == NyayaTrue) return NyayaTrue;
            if ([first value] == NyayaFalse && [second value] == NyayaFalse) return NyayaFalse;
            return NyayaUndefined;
            
        case NyayaConjunction:
            if ([first value] == NyayaFalse || [second value] == NyayaFalse) return NyayaFalse;
            if ([first value] == NyayaTrue && [second value] == NyayaTrue) return NyayaTrue;
            return NyayaUndefined;
            
        case NyayaImplication:
            if ([first value] == NyayaFalse || [second value] == NyayaTrue) return NyayaTrue;
            if ([first value] == NyayaTrue && [second value] == NyayaFalse) return NyayaFalse;
            return NyayaUndefined;
        
        case NyayaFunction: // NIY
        default:
            return NyayaUndefined;
    }
}

- (NSString*)description {
    NSUInteger count = [self.nodes count];
    NyayaNode *first = (count > 0) ? [self.nodes objectAtIndex:0] : nil;
    NyayaNode *second = (count > 1) ? [self.nodes objectAtIndex:1] : nil;
    NSString *left = nil;
    NSString *right = nil;
    
    switch (_type) {
        case NyayaConstant:
            return _symbol;
        case NyayaNegation:
            switch(first.type) {
                case NyayaConstant:
                case NyayaNegation:
                case NyayaFunction: // NIY
                    right = [first description];
                    break;
                default:
                    right = [NSString stringWithFormat:@"%@)", [first description]];
                    break;
            }
            return [NSString stringWithFormat:@"%@%@", self.symbol, right];
            
        case NyayaConjunction:
            switch(first.type) {
                case NyayaConstant:
                case NyayaNegation:
                case NyayaFunction: // NIY
                case NyayaConjunction: // left associative
                    left = [first description];
                    break;
                default:
                    left = [NSString stringWithFormat:@"(%@)", [first description]];
                    break;
            }
            
            switch(second.type) {
                case NyayaConstant:
                case NyayaNegation:
                case NyayaFunction: // NIY
                    right = [second description];
                    break;
                default:
                    right = [NSString stringWithFormat:@"(%@)", [second description]];
                    break;
            }
            
            
            return [NSString stringWithFormat:@"%@ %@ %@", left, self.symbol, right];
            
        case NyayaDisjunction:
            switch(first.type) {
                case NyayaConstant:
                case NyayaNegation:
                case NyayaFunction: // NIY
                case NyayaDisjunction:  // left associative
                    left = [first description];
                    break;
                default:
                    left = [NSString stringWithFormat:@"(%@)", [first description]];
                    break;
            }
            
            switch(second.type) {
                case NyayaConstant:
                case NyayaNegation:
                case NyayaFunction: // NIY
                    right = [second description];
                    break;
                default:
                    right = [NSString stringWithFormat:@"(%@)", [second description]];
                    break;
            }
            
            
            return [NSString stringWithFormat:@"%@ %@ %@", left, self.symbol, right];

        
        case NyayaImplication:
            switch(first.type) {
                case NyayaConstant:
                case NyayaNegation:
                case NyayaFunction: // NIY
                case NyayaConjunction:
                case NyayaDisjunction:
                    left = [first description];
                    break;
                default:
                    left = [NSString stringWithFormat:@"(%@)", [first description]];
                    break;
            }
            
            switch(second.type) {
                case NyayaConstant:
                case NyayaNegation:
                case NyayaFunction: // NIY
                case NyayaConjunction:
                case NyayaDisjunction:
                case NyayaImplication:  // right associative
                    right = [second description];
                    break;
                default:
                    right = [NSString stringWithFormat:@"(%@)", [second description]];
                    break;
            }
            return [NSString stringWithFormat:@"%@ %@ %@", left, self.symbol, right];
            
        case NyayaFunction:
            right = [[self.nodes valueForKey:@"description"] componentsJoinedByString:@","];
            return [NSString stringWithFormat:@"%@(%@)", self.symbol, right]; 
            
        default:
            return @"NIY";
    }
}


@end
