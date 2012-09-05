//
//  NyayaNode+Description.h
//  Nyaya
//
//  Created by Alexander Maringele on 04.09.12.
//  Copyright (c) 2012 private. All rights reserved.
//

#import "NyayaNode.h"

@interface NyayaNode (Description)

- (NSString*)treeDescription;
- (NSString*)description:(NyayaNode*)subformula;

@end
