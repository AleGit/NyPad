//
//  NyayaFormula.m
//  Nyaya
//
//  Created by Alexander Maringele on 12.09.12.
//  Copyright (c) 2012 private. All rights reserved.
//

#import "NyayaFormula.h"
#import "NyayaParser.h"
#import "NyayaNode+Attributes.h"
#import "NyayaNode+Reductions.h"
//#import "NyayaNode+Derivations.h"

#define NYAYA_MAX_INPUT_LENGTH 1367

@interface NyayaFormula () {
    NyayaNode *_slfNode;
    TruthTable *_truthTable;
    BddNode *_bddNode;
    
    NSString *_slfDescription;
    NSString *_rdcDescription;
    NSString *_imfDescription;
    NSString *_nnfDescription;
    NSString *_cnfDescription;
    NSString *_dnfDescription;
    
    dispatch_once_t _pred;
}
@end

@implementation NyayaFormula

- (id)initNode:(NyayaNode*)node {
    self = [super init];
    if (self) {
        _slfNode = node;
        _pred = 0;
    }
    return self;
}


+ (id)formulaWithNode:(NyayaNode*)node {
    return [[NyayaFormula alloc] initNode:node];
}

+ (id)formulaWithString:(NSString*)input {
    NyayaFormula *formula = nil;
    
    if ([input length] < NYAYA_MAX_INPUT_LENGTH) {
        NyayaParser *parser = [[NyayaParser alloc] initWithString:input];
        NyayaNode *node = [parser parseFormula];
        formula = [NyayaFormula formulaWithNode:node];
        formula->_wellFormed = !parser.hasErrors;
    }
    
    return formula;
}

- (TruthTable*)truthTable:(BOOL)compact {
    if (_wellFormed && (!_truthTable || _truthTable.compact != compact)) {
        _truthTable = [[TruthTable alloc] initWithNode:_slfNode];
        [_truthTable evaluateTable];
    }
    return _truthTable;
}

- (BddNode*)OBDD:(BOOL)reduced {
    if (_wellFormed && (!_bddNode || (_bddNode.reduced != reduced))) {
        _bddNode = [BddNode bddWithTruthTable:[self truthTable:YES] reduce:reduced];
    }
    return _bddNode;
}

- (void)makeDescriptions {
    dispatch_once(&_pred, ^{
        
        _slfDescription = [self description];
        NyayaNode *redNode = nil;
        NSString *redDescription = nil;
        
        if ([_slfNode isNegationNormalForm]) {
            redNode = [_slfNode reduce:800];
            redDescription = [redNode description];
            NSLog(@"RED %@ CNF=%u DNF=%u",redDescription, [redNode isConjunctiveNormalForm], [redNode isDisjunctiveNormalForm]);
        }
        
        _cnfDescription = [redNode isConjunctiveNormalForm] ? redDescription : [self OBDD:YES].cnfDescription;
        _dnfDescription = [redNode isDisjunctiveNormalForm] ? redDescription : [self OBDD:YES].dnfDescription;
        
        if ([_cnfDescription length] < [_dnfDescription length]) {
            _nnfDescription = _cnfDescription;
            _imfDescription = _imfDescription;
        }
        else {
            _nnfDescription = _dnfDescription;
            _imfDescription = _dnfDescription;
        }
        
        if ([_slfNode isImplicationFree] && [_slfDescription length] < [_imfDescription length])
            _imfDescription = _slfDescription;
        
        if ([_slfNode isNegationNormalForm] && [_slfDescription length] < [_nnfDescription length])
            _nnfDescription = _slfDescription;
        
        //        if ([self isConjunctiveNormalForm] && [_slfDescription length] < [_cnfDescription length])
        //            _cnfDescription = _slfDescription;
        //
        //        if ([self isDisjunctiveNormalForm] && [_slfDescription length] < [_dnfDescription length])
        //            _dnfDescription = _slfDescription;
    });
}


- (NSString*)cnfDescription {
    [self makeDescriptions];
    return _cnfDescription;
}

- (NSString*)dnfDescription {
    [self makeDescriptions];
    return _dnfDescription;
}

- (NSString*)nnfDescription {
    [self makeDescriptions];
    return _nnfDescription;
}

- (NSString*)imfDescription {
    [self makeDescriptions];
    return _imfDescription;
}

- (NSString*)slfDescription {
    [self makeDescriptions];
    return _slfDescription;
}

@end
