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

@property (nonatomic, readonly) NyayaParser *parser;
@property (nonatomic, readonly) NyayaNode *ast;

@property (nonatomic, readonly) NyayaNode *imf;
@property (nonatomic, readonly) NyayaNode *nnf;
@property (nonatomic, readonly) NyayaNode *cnf;
@property (nonatomic, readonly) NyayaNode *dnf;

@property (nonatomic, readonly) NyayaNode *nast;
@property (nonatomic, readonly) NyayaNode *nimf;
@property (nonatomic, readonly) NyayaNode *nnnf;
@property (nonatomic, readonly) NyayaNode *ncnf;
@property (nonatomic, readonly) NyayaNode *ndnf;

+ (NyayaFormula *)formulaWithString:(NSString*)input;
- (id)initWithString:(NSString*)input;


@end
