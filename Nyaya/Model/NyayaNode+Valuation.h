//
//  NyayaNode+Valuation.h
//  Nyaya
//
//  Created by Alexander Maringele on 04.09.12.
//  Copyright (c) 2012 private. All rights reserved.
//

#import "NyayaNode.h"

@interface NyayaNode (Valuation)

- (BOOL)evaluationValue;

@end

@interface NyayaNodeVariable (Valuation)

- (void)setEvaluationValue:(BOOL)evaluationValue;

@end

