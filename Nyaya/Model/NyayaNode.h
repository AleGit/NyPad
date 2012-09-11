//
//  NyayaNode.h
//  Nyaya
//
//  Created by Alexander Maringele on 17.07.12.
//  Copyright (c) 2012 private. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TruthTable.h"
#import "BddNode.h"

@interface NyayaNode : NSObject <NSCopying>

@property (nonatomic, readonly) NSString *symbol;       // atoms (a,b,c,...) or connectives (¬,∨,∧,→,↔)
@property (nonatomic, readonly) NSArray *nodes;
@property (nonatomic, weak) NyayaNode *parent;


@property (nonatomic, readonly, getter=isWellFormed) BOOL wellFormed;


#define NYAYA_MAX_INPUT_LENGTH 1367
// if input's length ist greater than NYAYA_MAX_INPUT_LENGTH
// the method will return nil 
+ (id)nodeWithFormula:(NSString*)input;

// - (NyayaNode*)reducedFormula;

- (NSUInteger)count;
- (NSComparisonResult)compare:(NyayaNode*)other;

- (TruthTable*)truthTable:(BOOL)compact;
- (BddNode*)OBDD:(BOOL)reduced;

- (NSString*)slfDescription;
- (NSString*)imfDescription;
- (NSString*)nnfDescription;
- (NSString*)cnfDescription;
- (NSString*)dnfDescription;

@end


