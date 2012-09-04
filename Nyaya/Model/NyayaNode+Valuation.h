//
//  NyayaNode+Valuation.h
//  Nyaya
//
//  Created by Alexander Maringele on 04.09.12.
//  Copyright (c) 2012 private. All rights reserved.
//

#import "NyayaNode.h"
#import "NyayaNode_Cluster.h"

@interface NyayaNode (Valuation)

- (BOOL)evaluationValue;

- (NSSet*)setOfSubformulas;     // set of subformulas (strings)
- (NSSet*)setOfVariables;       // set of variables (nodes)
- (void)fillHeadersAndEvals:(NSMutableDictionary*)headersAndEvals;

@end

@interface NyayaNodeVariable (Valuation)

- (void)setEvaluationValue:(BOOL)evaluationValue;

@end

