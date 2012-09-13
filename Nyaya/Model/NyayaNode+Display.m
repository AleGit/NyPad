//
//  NyayaNode+Display.m
//  Nyaya
//
//  Created by Alexander Maringele on 04.09.12.
//  Copyright (c) 2012 private. All rights reserved.
//

#import "NyayaNode+Display.h"
#import "NyayaNode_Cluster.h"
#import "NyayaStore.h"

@implementation NyayaNode (Display)
- (NyayaBool)displayValue {
    _displayValue = [[NyayaStore sharedInstance] displayValueForName:self.symbol];
    return _displayValue;
}
@end

@implementation NyayaNodeVariable (Display)

- (void)setDisplayValue:(NyayaBool)displayValue {
    [[NyayaStore sharedInstance] setDisplayValue:displayValue forName:self.symbol];
    
}
@end

@implementation NyayaNodeConstant (Display)
- (NyayaBool)displayValue { return _displayValue; }
@end

@implementation NyayaNodeUnary (Display)
- (NyayaBool)firstValue {
    return [[self firstNode] displayValue];
}
@end

@implementation NyayaNodeNegation (Display)

- (NyayaBool)displayValue {
    NyayaBool firstValue = [self firstValue];
    
    if (firstValue == NyayaFalse) _displayValue = NyayaTrue;
    else if (firstValue == NyayaTrue) _displayValue = NyayaFalse;
    else return _displayValue = NyayaUndefined;
    
    return _displayValue;
}
@end

@implementation NyayaNodeBinary  (Display)
- (NyayaBool)secondValue {
    return [[self secondNode] displayValue];
}
@end

@implementation NyayaNodeJunction (Display)
@end

@implementation NyayaNodeDisjunction (Display)

- (NyayaBool)displayValue {
    NyayaBool firstValue = [self firstValue];
    NyayaBool secondValue = [self secondValue];
    
    if (firstValue == NyayaTrue || secondValue == NyayaTrue) _displayValue = NyayaTrue;
    else if (firstValue == NyayaFalse && secondValue == NyayaFalse) _displayValue = NyayaFalse;
    else _displayValue = NyayaUndefined;
    
    return _displayValue;
}
@end

@implementation NyayaNodeSequence (Display)
@end

@implementation NyayaNodeConjunction (Display)

- (NyayaBool)displayValue {
    NyayaBool firstValue = [self firstValue];
    NyayaBool secondValue = [self secondValue];
    
    if (firstValue == NyayaFalse || secondValue == NyayaFalse) _displayValue = NyayaFalse;
    else if (firstValue == NyayaTrue && secondValue == NyayaTrue) _displayValue = NyayaTrue;
    else _displayValue = NyayaUndefined;
    
    return _displayValue;
}
@end

@implementation NyayaNodeExpandable (Display)
@end

@implementation NyayaNodeXdisjunction (Display)

- (NyayaBool)displayValue {
    NyayaBool firstValue = [self firstValue];
    NyayaBool secondValue = [self secondValue];
    
    if (firstValue == NyayaUndefined || secondValue == NyayaUndefined) _displayValue = NyayaUndefined;
    else if (firstValue == secondValue) _displayValue = NyayaFalse;
    else _displayValue = NyayaTrue;
    
    return _displayValue;
}
@end

@implementation NyayaNodeImplication (Display)

- (NyayaBool)displayValue {
    NyayaBool firstValue = [self firstValue];
    NyayaBool secondValue = [self secondValue];
    
    if (firstValue == NyayaFalse || secondValue == NyayaTrue) _displayValue = NyayaTrue;
    else if (firstValue == NyayaTrue && secondValue == NyayaFalse) _displayValue = NyayaFalse;
    else _displayValue = NyayaUndefined;
    
    return _displayValue;
}
@end

@implementation NyayaNodeEntailment (Display)
@end

@implementation NyayaNodeBicondition (Display)
- (NyayaBool)displayValue {
    NyayaBool firstValue = [self firstValue];
    NyayaBool secondValue = [self secondValue];
    
    if (firstValue == NyayaUndefined || secondValue == NyayaUndefined) _displayValue = NyayaUndefined;
    else if (firstValue == secondValue) _displayValue = NyayaTrue;
    else _displayValue = NyayaFalse;
    
    return _displayValue;
}
@end

@implementation NyayaNodeFunction (Display)
@end

