//
//  NyayaNode+Display.h
//  Nyaya
//
//  Created by Alexander Maringele on 04.09.12.
//  Copyright (c) 2012 private. All rights reserved.
//

#import "NyayaNode.h"

@interface NyayaNode (Display)

- (NyayaBool) displayValue;

@end

@interface NyayaNodeVariable (Display)

- (void)setDisplayValue:(NyayaBool)displayValue;

@end
