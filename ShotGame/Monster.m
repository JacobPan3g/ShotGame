//
//  Monster.m
//  ShotGame
//
//  Created by Jacob on 13-4-2.
//  Copyright 2013年 __MyCompanyName__. All rights reserved.
//

#import "Monster.h"


@implementation Monster

- (id)initWithFile:(NSString *)file hp:(int)hp minMoveDuration:(int)minMoveDuration maxMoveDuration:(int)maxMoveDuration
{
    if ((self = [super initWithFile:file]))
    {
        self.hp = hp;
        self.minMoveDuration = minMoveDuration;
        self.maxMoveDuration = maxMoveDuration;
    }
    return self;
}

@end

@implementation WeakAndFastMonster

- (id)init
{
    if ((self = [super initWithFile:@"monster.png" hp:1 minMoveDuration:3 maxMoveDuration:5]))
    {
    }
    return self;
}

@end

@implementation StrongAndSlowMonster

- (id)init
{
    if ((self = [super initWithFile:@"monster2.png" hp:3 minMoveDuration:6 maxMoveDuration:12]))
    {
    }
    return self;
}

@end
