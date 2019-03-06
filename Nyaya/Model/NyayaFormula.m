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
#import "NyayaNode+Valuation.h"

#define NYAYA_MAX_INPUT_LENGTH 1367
#define NAYAY_MAX_DERIVATION_LENGTH 720
#define NAYAY_DERIVATION_LENGTH(length) ((!length || NAYAY_MAX_DERIVATION_LENGTH < length) ? NAYAY_MAX_DERIVATION_LENGTH : length)

@interface NyayaFormula () {
    NyayaNode *_slfNode;
    TruthTable *_truthTable;
    BddNode *_bddNode;
    NSSet *_subNodesSet;
    
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

- (instancetype)initNode:(NyayaNode*)node {
    self = [super init];
    if (self) {
        _slfNode = node;
        _firstRun = 0;
    }
    return self;
}


+ (instancetype)formulaWithNode:(NyayaNode*)node {
    return [[NyayaFormula alloc] initNode:node];
}

+ (instancetype)formulaWithString:(NSString*)input {
    NyayaFormula *formula = nil;
    
    if ([input length] < NYAYA_MAX_INPUT_LENGTH) {
        NyayaParser *parser = [[NyayaParser alloc] initWithString:input];
        NyayaNode *node = [parser parseFormula];
        formula = [NyayaFormula formulaWithNode:node];
        formula->_wellFormed = !parser.hasErrors;
        formula->_subNodesSet = parser.subNodesSet;
    }
    
    return formula;
}

- (NyayaNode*)syntaxTree:(BOOL)optimized {
    if (!optimized) return _slfNode;
    
    [self optimizeDescriptions];
    
    return [self shortestNode];
}

- (TruthTable*)truthTable:(BOOL)compact {
    if (_wellFormed && (!_truthTable || _truthTable.compact != compact)) {
        _truthTable = [[TruthTable alloc] initWithNode:_slfNode];
        [_truthTable evaluateTable];
    }
    return _truthTable;
}

- (BddNode*)OBDDx:(BOOL)reduced {
    if (_wellFormed && (!_bddNode || (_bddNode.reduced != reduced))) {
        // caculate reduced ordered binary decision diagram for compact truth table
        _bddNode = [BddNode bddWithTruthTable:[self truthTable:YES] reduce:reduced];
    }
    return _bddNode;
}

- (BddNode*)OBDD:(BOOL)reduced {
    if (_wellFormed) {
        NSArray *variables = [_slfNode.setOfVariables allObjects];
        
        
        return [BddNode obddWithNode:_slfNode order:variables reduce:reduced];
    }
    return nil;
}

- (void)makeDescriptions {
    dispatch_once(&_firstRun, ^{
        
        if (!self->_slfDescription) self->_slfDescription = [self->_slfNode description];
        
        if ([self->_slfNode isImplicationFree]) self->_imfDescription = self->_slfDescription;
        if ([self->_slfNode isNegationNormalForm]) self->_nnfDescription = self->_slfDescription;
        if ([self->_slfNode isConjunctiveNormalForm]) self->_cnfDescription = self->_slfDescription;
        if ([self->_slfNode isDisjunctiveNormalForm]) self->_dnfDescription = self->_slfDescription;
#ifdef DEBUG
//        if (!_cnfDescription) _cnfDescription = @"";
//        if (!_dnfDescription) _dnfDescription = @"";
#endif
        if (!self->_cnfDescription) self->_cnfDescription = [self OBDD:YES].cnfDescription;
        if (!self->_dnfDescription) self->_dnfDescription = [self OBDD:YES].dnfDescription;

       
        NSString* nf = [self->_cnfDescription length] < [self->_dnfDescription length] ? self->_cnfDescription : self->_dnfDescription;
                
        if (!self->_imfDescription || [nf length] < [self->_imfDescription length]) self->_imfDescription = nf;
        if (!self->_nnfDescription || [nf length] < [self->_nnfDescription length]) self->_nnfDescription = nf;
        
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
        
        NyayaNode *rNode = [self->_slfNode reduce:NSIntegerMax];
        NyayaNode *sNode = [[self shortestNode] reduce:NSIntegerMax];
        NSString *description = nil;
        NSUInteger length = 0;
        
        NSMutableArray *nodes = [NSMutableArray arrayWithCapacity:2];
        if (rNode) [nodes addObject:rNode];
        if (sNode) [nodes addObject:sNode];
        
        for (NyayaNode *rdcNode in nodes) {
            if (!rdcNode) break;
            
            description = [rdcNode description];
            if (!self->_rdcDescription || [description length] < [self->_rdcDescription length]) {
                NSLog(@"RDC \n %@\n %@", self->_rdcDescription, description);
                self->_rdcDescription = description;
            }
        
            length = [self->_imfDescription length];
            NyayaNode *imfNode = [rdcNode isImplicationFree] ? rdcNode : [rdcNode deriveImf: NAYAY_DERIVATION_LENGTH(length)];
            description = [imfNode description];
            if (imfNode && (!length || [description length] < length)) {
                NSLog(@"IMF \n %@\n %@", self->_imfDescription, description);
                self->_imfDescription = description;
            }
            
            length = [self->_nnfDescription length];
            NyayaNode *nnfNode = [imfNode isNegationNormalForm] ? imfNode : [imfNode deriveNnf: NAYAY_DERIVATION_LENGTH(length)];
            description = [nnfNode description];
            if (nnfNode && (!length || [description length] < length)) {
                NSLog(@"NNF \n %@\n %@", self->_nnfDescription, description);
                self->_nnfDescription = description;
            }
            
            length = [self->_cnfDescription length];
            NyayaNode *cnfNode = [nnfNode isConjunctiveNormalForm] ? nnfNode : [nnfNode deriveCnf: NAYAY_DERIVATION_LENGTH(length)];
            description = [cnfNode description];
            if (cnfNode && (!length || [description length] < length)) {
                NSLog(@"CNF \n %@\n %@", self->_cnfDescription, description);
                self->_cnfDescription = description;
            }
            length = [self->_dnfDescription length];
            if ([cnfNode isDisjunctiveNormalForm] && (!length || [description length] < length)) {
                NSLog(@"DNF (CNF)\n %@\n %@", self->_dnfDescription, description);
                self->_dnfDescription = description;
            }
            NyayaNode *dnfNode = [nnfNode isDisjunctiveNormalForm] ? nnfNode : [nnfNode deriveDnf: NAYAY_DERIVATION_LENGTH(length)];
            description = [dnfNode description];
            if (dnfNode && (!length || [description length] < length)) {
                NSLog(@"DNF \n %@\n %@", self->_dnfDescription, description);
                self->_dnfDescription = description;
            }
            length = [self->_cnfDescription length];
            if ([dnfNode isConjunctiveNormalForm] && (!length || [description length] < length)) {
                NSLog(@"CNF (DNF)\n %@\n %@", self->_cnfDescription, description);
                self->_cnfDescription = description;
            }
            
            // update nnf
            for (description in @[self->_cnfDescription, self->_dnfDescription]) {
                length = [self->_nnfDescription length];
                if (!length || [description length] < length) {
                    NSLog(@"NNF (UPD)\n %@\n %@", self->_nnfDescription, description);
                    self->_nnfDescription = description;
                }
            }
            // update imf
            for (description in @[self->_nnfDescription,self->_cnfDescription,self->_dnfDescription]) {
                length = [self->_imfDescription length];
                if (!length || [description length] < length) {
                    NSLog(@"IMF (UPD)\n %@\n %@", self->_imfDescription, description);
                    self->_imfDescription = description;
                }
            }
            // update rdc
            for (description in @[self->_imfDescription,self->_nnfDescription,self->_cnfDescription,self->_dnfDescription]) {
                length = [self->_rdcDescription length];
                if (!length || [description length] < length) {
                    NSLog(@"RDC (UPD)\n %@\n %@", self->_rdcDescription, description);
                    self->_rdcDescription = description;
                }
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
