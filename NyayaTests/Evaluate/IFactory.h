//
//  IFactory.h
//  Nyaya
//
//  Created by Alexander Maringele on 21.07.12.
//  Copyright (c) 2012 private. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol IFactory <NSObject>

@property (readonly) NSString* name;

+ (id)factoryWithName:(NSString*)name;
- (id)initWithName:(NSString*)name;
- (NSString*)greeting;

@end
