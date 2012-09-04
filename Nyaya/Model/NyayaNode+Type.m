//
//  NyayaNode+Type.m
//  Nyaya
//
//  Created by Alexander Maringele on 04.09.12.
//  Copyright (c) 2012 private. All rights reserved.
//

#import "NyayaNode+Type.h"
#import "NyayaNode_Cluster.h"

@implementation NyayaNode (Type)
//- (NyayaNodeType)type {
//    return NyayaUndefined; // NyayaNode.m
//}
@end

@implementation NyayaNodeVariable (Type)
- (NyayaNodeType)type {
    return NyayaVariable;
}
@end

@implementation NyayaNodeConstant (Type)
- (NyayaNodeType)type {
    return NyayaConstant;
}
@end

@implementation NyayaNodeUnary (Type)
@end

@implementation NyayaNodeNegation (Type)
- (NyayaNodeType)type {
    return NyayaNegation;
}
@end

@implementation NyayaNodeBinary (Type)
@end

@implementation NyayaNodeJunction (Type)
@end

@implementation NyayaNodeDisjunction (Type)
- (NyayaNodeType)type {
    return NyayaDisjunction;
}
@end

@implementation NyayaNodeSequence (Type)
- (NyayaNodeType)type {
    return NyayaSequence;
}
@end

@implementation NyayaNodeConjunction (Type)
- (NyayaNodeType)type {
    return NyayaConjunction;
}
@end

@implementation NyayaNodeExpandable (Type)
@end

@implementation NyayaNodeXdisjunction (Type)
- (NyayaNodeType)type {
    return NyayaXdisjunction;
}
@end

@implementation NyayaNodeImplication (Type)
- (NyayaNodeType)type {
    return NyayaImplication;
}
@end

@implementation NyayaNodeEntailment (Type)
- (NyayaNodeType)type {
    return NyayaEntailment;
}
@end

@implementation NyayaNodeBicondition (Type)
- (NyayaNodeType)type {
    return NyayaBicondition;
}
@end

@implementation NyayaNodeFunction (Type)
- (NyayaNodeType)type { return NyayaFunction; }
@end
