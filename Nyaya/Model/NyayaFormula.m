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
#import "NyayaNode+Derivations.h"
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
    
    dispatch_once_t _firstRun;
    dispatch_once_t _secondRun;
}
@end

@implementation NyayaFormula

- (id)initNode:(NyayaNode*)node {
    self = [super init];
    if (self) {
        _slfNode = node;
        _firstRun = 0;
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
    dispatch_once(&_firstRun, ^{
        
        if (!_slfDescription) _slfDescription = [_slfNode description];
        
        if ([_slfNode isImplicationFree]) _imfDescription = _slfDescription;
        if ([_slfNode isNegationNormalForm]) _nnfDescription = _slfDescription;
        if ([_slfNode isConjunctiveNormalForm]) _cnfDescription = _slfDescription;
        if ([_slfNode isDisjunctiveNormalForm]) _dnfDescription = _slfDescription;
        
        if (!_cnfDescription) _cnfDescription = [self OBDD:YES].cnfDescription;
        if (!_dnfDescription) _dnfDescription = [self OBDD:YES].dnfDescription;
       
        NSString* nf = [_cnfDescription length] < [_dnfDescription length] ? _cnfDescription : _dnfDescription;
                
        if (!_imfDescription || [nf length] < [_imfDescription length]) _imfDescription = nf;
        if (!_nnfDescription || [nf length] < [_nnfDescription length]) _nnfDescription = nf;
        
    });
}

- (NyayaNode*)shortestNode {
    NSString *sd = nil;
    for (NSString *description in @[_slfDescription, _imfDescription, _nnfDescription, _cnfDescription, _dnfDescription]) {
        if (!sd || (description && [description length] < [sd length])) {
            sd = description;
        }
    }
    NyayaParser *p = [[NyayaParser alloc] initWithString:sd];
    return [p parseFormula];
}

- (void)optimizeDescriptions {
    dispatch_once(&_secondRun, ^{
        [self makeDescriptions];
        
        NyayaNode *rNode = [_slfNode reduce:NSIntegerMax];        
        NyayaNode *sNode = [[self shortestNode] reduce:NSIntegerMax];
        NSString *description = nil;
        
        for (NyayaNode *rdcNode in @[rNode, sNode]) {
            if (!rdcNode) break;
            
            description = [rdcNode description];
            if (!_rdcDescription || [description length] < [_rdcDescription length]) {
                _rdcDescription = description;
            }
        
            NyayaNode *imfNode = [rdcNode isImplicationFree] ? rdcNode : [rdcNode deriveImf:[_imfDescription length]];
            description = [imfNode description];
            if (imfNode && [description length] < [_imfDescription length]) {
                _imfDescription = description;
            }
            
            NyayaNode *nnfNode = [imfNode isNegationNormalForm] ? imfNode : [imfNode deriveNnf:[_nnfDescription length]];
            description = [nnfNode description];
            if (nnfNode && [description length] < [_nnfDescription length]) {
                _nnfDescription = description;
            }
            
            NyayaNode *cnfNode = [nnfNode isConjunctiveNormalForm] ? nnfNode : [nnfNode deriveCnf:[_cnfDescription length]];
            description = [cnfNode description];
            if (cnfNode && [description length] < [_cnfDescription length]) {
                _cnfDescription = description;
            }
            if ([cnfNode isDisjunctiveNormalForm] && [description length] < [_dnfDescription length]) {
                _dnfDescription = description;
            }
            
            NyayaNode *dnfNode = [nnfNode isDisjunctiveNormalForm] ? nnfNode : [nnfNode deriveDnf:[_dnfDescription length]];
            description = [dnfNode description];
            if (dnfNode && [description length] < [_dnfDescription length]) {
                _dnfDescription = description;
            }
            
            if ([dnfNode isConjunctiveNormalForm] && [description length] < [_cnfDescription length]) {
                _cnfDescription = description;
            }
        }
    });
}

- (NSString*)description {
    if (!_slfDescription) _slfDescription = [_slfNode description];
    return _slfDescription;
}


- (NSString*)slfDescription {
    [self makeDescriptions];
    return _slfDescription;
}

- (NSString*)rdcDescription {
    [self makeDescriptions];
    return _rdcDescription;
}

- (NSString*)imfDescription {
    [self makeDescriptions];
    return _imfDescription;
}

- (NSString*)nnfDescription {
    [self makeDescriptions];
    return _nnfDescription;
}

- (NSString*)cnfDescription {
    [self makeDescriptions];
    return _cnfDescription;
}

- (NSString*)dnfDescription {
    [self makeDescriptions];
    return _dnfDescription;
}

@end
