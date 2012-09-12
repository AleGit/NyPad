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

+ (id)formulaWithString:(NSString*)input;
- (TruthTable*)truthTable:(BOOL)compact;
- (BddNode*)OBDD:(BOOL)reduced;

@end
