//
//  NyayaNode.m
//  Nyaya
//
//  Created by Alexander Maringele on 17.07.12.
//  Copyright (c) 2012 private. All rights reserved.
//

#import "NyayaNode.h"
#import "NyayaStore.h"
#import "NSString+NyayaToken.h"
#import "NSArray+NyayaToken.h"
#import "NyayaNode_Cluster.h"
#import "NyayaNode+Creation.h"
#import "NyayaNode+Type.h"
#import "NyayaNode+Valuation.h"
#import "NyayaNode+Display.h"
#import "NyayaNode+Derivations.h"
#import "NyayaNode+Attributes.h"

@interface NyayaNode ()
- (NyayaNode*)nodeAtIndex:(NSUInteger)index;
@end

@implementation NyayaNode

- (id)copyWithZone:(NSZone*)zone {
    
    return [self copyWith:[self valueForKeyPath:@"nodes.copy"]]; // recursive copy
}

- (NyayaNode*)nodeAtIndex:(NSUInteger)index {
    return [_nodes count] > index ? [_nodes objectAtIndex:index] : nil;
}

@end

#pragma mark - clustered subclasses -

@implementation NyayaNodeVariable

- (BOOL)isEqual:(id)object {
    if (object == self)
        return YES;
    else if (!object || ![object isKindOfClass:[self class]])
        return NO;
    return [self.symbol isEqual:((NyayaNodeVariable*)object).symbol];
}

- (NSUInteger)hash {
    return [self.symbol hash];
}
@end

@implementation NyayaNodeConstant
@end


@implementation NyayaNodeUnary
- (NyayaNode*)firstNode {
    return [self nodeAtIndex:0];
}
@end

@implementation NyayaNodeNegation
@end

@implementation NyayaNodeBinary
- (NyayaNode*)secondNode {
    return [self nodeAtIndex:1];
}
@end

@implementation NyayaNodeJunction
@end

@implementation NyayaNodeConjunction
@end

@implementation NyayaNodeSequence
@end

@implementation NyayaNodeDisjunction
@end

@implementation NyayaNodeExpandable
@end

@implementation NyayaNodeImplication
@end

@implementation NyayaNodeEntailment
@end

@implementation NyayaNodeBicondition
@end

@implementation NyayaNodeXdisjunction
@end

@implementation NyayaNodeFunction
@end


