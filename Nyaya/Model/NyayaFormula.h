//
//  NyayaFormula.h
//  Nyaya
//
//  Created by Alexander Maringele on 12.09.12.
//  Copyright (c) 2012 private. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TruthTable.h"
#import "BddNode.h"

@interface NyayaFormula : NSObject

@property (nonatomic, readonly) NSString *slfDescription;
@property (nonatomic, readonly) NSString *rdcDescription;
@property (nonatomic, readonly) NSString *imfDescription;
@property (nonatomic, readonly) NSString *nnfDescription;
@property (nonatomic, readonly) NSString *cnfDescription;
@property (nonatomic, readonly) NSString *dnfDescription;
@property (nonatomic, readonly, getter=isWellFormed) BOOL wellFormed;
@property (nonatomic, readonly) NSSet* subNodesSet;

+ (instancetype)formulaWithString:(NSString*)input;
- (NyayaNode*)syntaxTree:(BOOL)optimized;
- (TruthTable*)truthTable:(BOOL)compact;
- (BddNode*)OBDD:(BOOL)reduced;

- (void)makeDescriptions;
- (void)optimizeDescriptions;

@end
