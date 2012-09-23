//
//  NyayaNode+Display.h
//  Nyaya
//
//  Created by Alexander Maringele on 04.09.12.
//  Copyright (c) 2012 private. All rights reserved.
//

#import "NyayaNode.h"
#import "NyayaNode_Cluster.h"

@interface NyayaNode (Display) <DisplayNode>

- (NyayaBool) displayValue;
- (NSString*) headLabelText;

@end

@interface NyayaNodeVariable (Display) <MutableDisplayNode>

- (void)setDisplayValue:(NyayaBool)displayValue;

@end

@interface NyayaNodeUnary (Display)
- (NyayaBool)firstValue;
@end

@interface NyayaNodeBinary (Display)
- (NyayaBool)secondValue;
@end
