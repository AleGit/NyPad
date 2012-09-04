//
//  NyayaNode.h
//  Nyaya
//
//  Created by Alexander Maringele on 17.07.12.
//  Copyright (c) 2012 private. All rights reserved.
//

#import <Foundation/Foundation.h>

#pragma mark - enums

enum { NyayaUndefined=0, NyayaFalse, NyayaTrue };
typedef NSUInteger NyayaBool;

enum { // NyayaUndefined=0
    NyayaConstant=1, NyayaVariable,
    NyayaNegation,
    NyayaConjunction, NyayaDisjunction, NyayaXdisjunction, NyayaImplication, NyayaBicondition,
    NyayaFunction
    , NyayaSequence     // a conjunction with lower precedence than everything but eintailment
    , NyayaEntailment   // an implication with lowest precedence
};
typedef NSUInteger NyayaNodeType;


@interface NyayaNode : NSObject <NSCopying> {
@protected
    NSString *_descriptionCache;
    NSString *_symbol;
    NyayaBool _displayValue;
    BOOL _evaluationValue;
    NSArray *_nodes;
}

@property (nonatomic, readonly) NyayaNodeType type; 
@property (nonatomic, readonly) NSString *symbol;       // atoms (a,b,c,...) or connectives (¬,∨,∧,→,↔)
@property (nonatomic, readonly) NSArray *nodes;
@property (nonatomic, weak) NyayaNode *parent;

@end


