//
//  Level.m
//  ShotGame
//
//  Created by Jacob on 13-4-2.
//
//

#import "Level.h"

@implementation Level

- (id)initWithLevelNum:(int)levelNum secsPerSpawn:(float)secsPerSpawn backgroundColor:(ccColor4B)backgroundColor
{
    if ((self = [super init]))
    {
        self.levelNum = levelNum;
        self.secsPerSpawn = secsPerSpawn;
        self.backgroundColor = backgroundColor;
    }
    return self;
}

@end
