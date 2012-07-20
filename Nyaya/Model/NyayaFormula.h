//
//  NyayaFormula.h
//  Nyaya
//
//  Created by Alexander Maringele on 20.07.12.
//  Copyright (c) 2012 private. All rights reserved.
//

#import <Foundation/Foundation.h>

@class NyayaParser;
@class NyayaNode;

@interface NyayaFormula : NSObject

@property (readonly) NyayaParser *parser;
@property (readonly) NyayaNode *ast;

@property (readonly) NyayaNode *imf;
@property (readonly) NyayaNode *nnf;
@property (readonly) NyayaNode *cnf;
@property (readonly) NyayaNode *dnf;

@property (readonly) NyayaNode *nast;
@property (readonly) NyayaNode *nimf;
@property (readonly) NyayaNode *nnnf;
@property (readonly) NyayaNode *ncnf;
@property (readonly) NyayaNode *ndnf;

+ (NyayaFormula *)formulaWithString:(NSString*)input;
- (id)initWithString:(NSString*)input;


@end
