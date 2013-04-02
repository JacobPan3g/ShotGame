//
//  LevelManager.h
//  ShotGame
//
//  Created by Jacob on 13-4-2.
//
//

#import <Foundation/Foundation.h>
#import "Level.h"

@interface LevelManager : NSObject

+ (LevelManager *)sharedInstance;
- (Level *)curLevel;
- (void)nextLevel;
- (void)reset;

@end
