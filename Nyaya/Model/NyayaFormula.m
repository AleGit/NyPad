//
//  NyayaFormula.m
//  Nyaya
//
//  Created by Alexander Maringele on 20.07.12.
//  Copyright (c) 2012 private. All rights reserved.
//

#import "NyayaFormula.h"
#import "NyayaParser.h"
#import "NyayaNode.h"

@implementation NyayaFormula

@synthesize parser = _parser;

@synthesize ast = _ast;
@synthesize imf = _imf;
@synthesize nnf = _nnf;
@synthesize cnf = _cnf;
@synthesize dnf = _dnf;

@synthesize nast = _nast;
@synthesize nimf = _nimf;
@synthesize nnnf = _nnnf;
@synthesize ncnf = _ncnf;
@synthesize ndnf = _ndnf;

+ (id)formulaWithString:(NSString*)input {
    return [[NyayaFormula alloc] initWithString:input];
}

- (id)initWithString:(NSString*)input {
    self = [super init];
    if (self) {
        _parser = [NyayaParser parserWithString:input];
    }
    return self;
}

#pragma mark - formula
- (NyayaNode*)ast {
    if (!_ast) {
        @synchronized(self) {
            if (!_ast) {
                _ast = [_parser parseFormula];
            }
        }
    }
    return _ast;
}

- (NyayaNode*)imf {
    if (!_imf) {
        @synchronized(self) {
            if (!_imf) {
                _imf = [self.ast imf];
            }
        }
    }
    return _imf;    
}

- (NyayaNode*)nnf {
    if (!_nnf) {
        @synchronized(self) {
            if (!_nnf) {
                _nnf = [self.imf nnf];
            }
        }
    }
    return _nnf;    
}


- (NyayaNode*)cnf {
    if (!_cnf) {
        @synchronized(self) {
            if (!_cnf) {
                _cnf = [self.nnf cnf];
            }
        }
    }
    return _cnf;    
}


- (NyayaNode*)dnf {
    if (!_dnf) {
        @synchronized(self) {
            if (!_dnf) {
                _dnf = [self.nnf dnf];
            }
        }
    }
    return _dnf;    
}

#pragma mark - negation of formula
- (NyayaNode*)nast {
    if (!_nast) {
        @synchronized(self) {
            if (!_nast) {
                NyayaNode *ast = self.ast;
                if(self.ast.type == NyayaNegation && [ast.nodes count] > 0) {
                    _nast = [ast.nodes objectAtIndex:0];
                }
                else if (ast) {
                    _nast = [NyayaNode negation:ast];
                }
            }
        }
    }
    return _nast;
}

- (NyayaNode*)nimf {
    if (!_nimf) {
        @synchronized(self) {
            if (!_nimf) {
                _nimf = [self.nast imf];
            }
        }
    }
    return _nimf;    
}

- (NyayaNode*)nnnf {
    if (!_nnnf) {
        @synchronized(self) {
            if (!_nnnf) {
                _nnnf = [self.nimf nnf];
            }
        }
    }
    return _nnnf;    
}


- (NyayaNode*)ncnf {
    if (!_ncnf) {
        @synchronized(self) {
            if (!_ncnf) {
                _ncnf = [self.nnnf cnf];
            }
        }
    }
    return _ncnf;    
}


- (NyayaNode*)ndnf {
    if (!_ndnf) {
        @synchronized(self) {
            if (!_ndnf) {
                _ndnf = [self.nnnf dnf];
            }
        }
    }
    return _ndnf;    
}


@end
