//
//  FactoryTests.m
//  Nyaya
//
//  Created by Alexander Maringele on 21.07.12.
//  Copyright (c) 2012 private. All rights reserved.
//

#import "FactoryTests.h"
#import "SimpleFactory.h"

@implementation FactoryTests

- (void)testIFactory {
    id ifactory = [SimpleFactory class];
    id ifab2 = NSClassFromString(@"StarFactory");
    
    Protocol *protocol = @protocol(IFactory);
    
    STAssertTrue([ifactory conformsToProtocol:NSProtocolFromString(@"IFactory")],  nil);
    STAssertTrue([ifab2 conformsToProtocol:protocol],  nil);
    STAssertEqualObjects([ifactory description], @"SimpleFactory", nil);
     
     
    id<IFactory> factory = [ifactory factoryWithName: @"Procter"];
    STAssertTrue([factory conformsToProtocol:NSProtocolFromString(@"IFactory")],  nil);
    
    STAssertEqualObjects(factory.name, @"Procter", nil);
    STAssertEqualObjects([factory greeting], @"Hello, I'm Simple Procter", nil);
    
    factory = [ifab2 factoryWithName: @"Procter"];
    
    STAssertEqualObjects(factory.name, @"Procter", nil);
    STAssertEqualObjects([factory greeting], @"Hello, I'm Star Procter", nil);
    
    
}

@end
