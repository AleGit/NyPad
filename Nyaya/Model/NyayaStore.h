//
//  NyayaStore.h
//  Nyaya
//
//  Created by Alexander Maringele on 20.07.12.
//  Copyright (c) 2012 private. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NyayaNode.h"
#import "NyayaNode+Type.h"

@interface NyayaStore : NSObject

+ (NyayaStore*)sharedInstance;

/*
- (NyayaNode*)nodeForName:(NSString*)name;
- (void)setNode:(NyayaNode*)node forName:(NSString*)name;
- (void)removeNodeForName:(NSString*)name;
- (void)removeAllNodes;
 */

- (BOOL)evaluationValueForName:(NSString*)name;
- (void)setEvaluationValue:(BOOL)eval forName:(NSString*)name;

- (NyayaBool)displayValueForName:(NSString*)name;
- (void)setDisplayValue:(NyayaBool)dval forName:(NSString*)name;

- (void)clear;

@end
