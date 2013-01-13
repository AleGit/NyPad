//
//  InputSaver.h
//  Nyaya
//
//  Created by Alexander Maringele on 13.01.13.
//  Copyright (c) 2013 private. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol InputSaver<NSObject>
// - (void)readMasterData;
- (void)writeMasterData;
- (BOOL)save:(NSDate*)date input:(NSString*)input;
@end
