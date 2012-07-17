//
//  NyayaNode.h
//  Nyaya
//
//  Created by Alexander Maringele on 17.07.12.
//  Copyright (c) 2012 private. All rights reserved.
//

#import <Foundation/Foundation.h>

enum { NyayaUndefined=0, NyayaFalse, NyayaTrue };
typedef NSUInteger NyayaBool;

enum { NyayaConstant=1, NyayaFunction, NyayaNegation, NyayaConjunction, NyayaDisjunction, NyayaImplication };
typedef NSUInteger NyayaNodeType;

@interface NyayaNode : NSObject

@property (nonatomic, readonly) NyayaNodeType type; 
@property (nonatomic, readonly) NSString *symbol;
@property (nonatomic, readonly) NSArray *nodes;

+ (NyayaNode*)constant:(NSString*)name with:(NyayaBool)value;
+ (NyayaNode*)constant:(NSString*)name;

+ (NyayaNode*)negation:(NyayaNode*)firstNode;
+ (NyayaNode*)conjunction:(NyayaNode*)firstNode with:(NyayaNode*)secondNode;
+ (NyayaNode*)disjunction:(NyayaNode*)firstNode with:(NyayaNode*)secondNode;
+ (NyayaNode*)implication:(NyayaNode*)firstNode with:(NyayaNode*)secondNode;

+ (NyayaNode*)function:(NSString*)name with:(NSArray*)nodes;

- (NyayaBool)value;

- (NyayaNode*)imf;
- (NyayaNode*)nnf;
- (NyayaNode*)cnf;
- (NyayaNode*)dnf;





@end
