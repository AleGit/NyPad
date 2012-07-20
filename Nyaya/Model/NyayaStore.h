//
//  NyayaStore.h
//  Nyaya
//
//  Created by Alexander Maringele on 20.07.12.
//  Copyright (c) 2012 private. All rights reserved.
//

#import <Foundation/Foundation.h>
@class NyayaNode;

@interface NyayaStore : NSObject

+ (NyayaStore*)sharedInstance;

- (NyayaNode*)nodeForName:(NSString*)name;
- (void)setNode:(NyayaNode*)node forName:(NSString*)name;
- (void)removeNodeForName:(NSString*)name;
- (void)removeAllNodes;

@end
