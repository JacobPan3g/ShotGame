//
//  Monster.h
//  ShotGame
//
//  Created by Jacob on 13-4-2.
//  Copyright 2013年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface Monster : CCSprite {
    
}

@property (nonatomic, assign) int hp;
@property (nonatomic, assign) int minMoveDuration;
@property (nonatomic, assign) int maxMoveDuration;

- (id)initWithFile:(NSString *)file hp:(int)hp minMoveDuration:(int)minMoveDuration maxMoveDuration:(int)maxMoveDuration;

@end

@interface WeakAndFastMonster : Monster
@end

@interface StrongAndSlowMonster : Monster
@end