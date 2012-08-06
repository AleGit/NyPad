//
//  NyayaStore.m
//  Nyaya
//
//  Created by Alexander Maringele on 20.07.12.
//  Copyright (c) 2012 private. All rights reserved.
//

#import "NyayaStore.h"
#import "NyayaNode.h"
#import "NSString+NyayaToken.h"





@interface NyayaStore () {
    NSMutableDictionary *_evalStore;
    NSMutableDictionary *_dvalStore;
}
@end

@implementation NyayaStore

+ (NyayaStore*)sharedInstance
{
    static dispatch_once_t pred = 0;
    __strong static NyayaStore* _sharedObject = nil;
    dispatch_once(&pred, ^{
        _sharedObject = [[self alloc] init];
        _sharedObject->_evalStore = [NSMutableDictionary dictionary];
        _sharedObject->_dvalStore = [NSMutableDictionary dictionary];
    });
    return _sharedObject;
}

/*
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
 */

- (BOOL)evaluationValueForName:(NSString *)name {
    if ([name isTrueToken]) return TRUE;
    if ([name isFalseToken]) return FALSE;
    else return [[_evalStore objectForKey:name] boolValue];
}

- (void)setEvaluationValue:(BOOL)eval forName:(NSString *)name {
    [_evalStore setObject:@(eval) forKey:name];
}

- (NyayaBool)displayValueForName:(NSString *)name {
    if ([name isTrueToken]) return NyayaTrue;
    if ([name isFalseToken]) return NyayaFalse;
    else return [[_dvalStore objectForKey:name] integerValue];
    
}

- (void)setDisplayValue:(NyayaBool)dval forName:(NSString *)name {
    [_dvalStore setObject:@(dval) forKey:name];
}

- (void)clear {
    
    [_dvalStore removeAllObjects];
    [_evalStore removeAllObjects];
    
}



@end
