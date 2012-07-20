//
//  NyayaStore.m
//  Nyaya
//
//  Created by Alexander Maringele on 20.07.12.
//  Copyright (c) 2012 private. All rights reserved.
//

#import "NyayaStore.h"
#import "NyayaNode.h"

@interface NyayaStore () {
    NSMutableDictionary *_store;
}
@end

@implementation NyayaStore

+ (NyayaStore*)sharedInstance
{
    static dispatch_once_t pred = 0;
    __strong static NyayaStore* _sharedObject = nil;
    dispatch_once(&pred, ^{
        _sharedObject = [[self alloc] init];
        _sharedObject->_store = [NSMutableDictionary dictionary];
    });
    return _sharedObject;
}

- (NyayaNode*)nodeForName:(NSString*)name {
    return [_store objectForKey:name];
}

- (void)setNode:(NyayaNode*)node forName:(NSString*)name {
    [_store setObject:node forKey:name];
}

- (void)removeNodeForName:(NSString*)name {
    [_store removeObjectForKey:name];
}

- (void)removeAllNodes {
    [_store removeAllObjects];
}



@end
