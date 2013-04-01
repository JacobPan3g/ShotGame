//
//  HelloWorldLayer.m
//  ShotGame
//
//  Created by Jacob on 13-4-1.
//  Copyright __MyCompanyName__ 2013年. All rights reserved.
//


// Import the interfaces
#import "HelloWorldLayer.h"

// Needed to obtain the Navigation Controller
#import "AppDelegate.h"

// add music
#import "SimpleAudioEngine.h"

#pragma mark - HelloWorldLayer

// HelloWorldLayer implementation
@implementation HelloWorldLayer

// Helper class method that creates a Scene with the HelloWorldLayer as the only child.
+(CCScene *) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	HelloWorldLayer *layer = [HelloWorldLayer node];
	
	// add layer as a child to scene
	[scene addChild: layer];
	
	// return the scene
	return scene;
}

// on "init" you need to initialize your instance
-(id) init
{
	// always call "super" init
	// Apple recommends to re-assign "self" with the "super's" return value
	if( (self=[super initWithColor:ccc4(255, 255, 255, 255)]) ) {
        [self setIsTouchEnabled:YES];
        
        _monsters = [[NSMutableArray alloc] init];
        _projectiles = [[NSMutableArray alloc] init];
        
        // start the music
        [[SimpleAudioEngine sharedEngine] playBackgroundMusic:@"background-music-aac.caf"];
        
		CGSize winSize = [CCDirector sharedDirector].winSize;
        CCSprite *player = [CCSprite spriteWithFile:@"player.png"];
        player.position = ccp(player.contentSize.width/2, winSize.height/2);
        [self addChild:player];
        
        [self schedule:@selector(gameLogic:) interval:1.0];
        [self schedule:@selector(update:)];
	}
	return self;
}

// on "dealloc" you need to release all your retained objects
- (void) dealloc
{
	// in case you have something to dealloc, do it in this method
	// in this particular example nothing needs to be released.
	// cocos2d will automatically release all the children (Label)
	[_monsters release];
    _monsters = nil;
    [_projectiles release];
    _projectiles = nil;
    
	// don't forget to call "super dealloc"
	[super dealloc];
}

// add some monsters
- (void) addMonster
{
    CCSprite *monster = [CCSprite spriteWithFile:@"monster.png"];
    monster.tag = 1;
    [_monsters addObject:monster];
    
    // Random the position of monsters
    CGSize winSize = [CCDirector sharedDirector].winSize;
    int minY = monster.contentSize.height / 2;
    int maxY = winSize.height - monster.contentSize.height/2;
    int rangeY = maxY - minY;
    int actualY = (arc4random() % rangeY) + minY;

    monster.position = ccp(winSize.width + monster.contentSize.width/2, actualY);
    [self addChild:monster];
    
    int minDuration = 2.0;
    int maxDuration = 4.0;
    int rangeDuration = maxDuration - minDuration;
    int actualDuration = (arc4random() % rangeDuration) + minDuration;
    
    CCMoveTo *actionMove = [CCMoveTo actionWithDuration:actualDuration position:ccp(-monster.contentSize.width/2, actualY)];
    CCCallBlock *actionMoveDone = [CCCallBlockN actionWithBlock:^(CCNode *node) {
        [_monsters removeObject:node];
    }];
    [monster runAction:[CCSequence actions:actionMove, actionMoveDone, nil]];
}

- (void) gameLogic:(ccTime)dt
{
    [self addMonster];
}

// callback on touch events
- (void)ccTouchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    // start the effect music
    [[SimpleAudioEngine sharedEngine] playEffect:@"pew-pew-lei.caf"];
    
    // get the touch location
    UITouch *touch = [touches anyObject];
    CGPoint location = [self convertTouchToNodeSpace:touch];
    
    // the initial location of projectile
    CGSize winSize = [[CCDirector sharedDirector] winSize];
    CCSprite *projectile = [CCSprite spriteWithFile:@"projectile.png"];
    projectile.position = ccp(20, winSize.height/2);
    projectile.tag = 2;
    [_projectiles addObject:projectile];
    
    CGPoint offset = ccpSub(location, projectile.position);
    if (offset.x <= 0) return;
    [self addChild:projectile];
    
    // slove out the realDest Point
    int realX = winSize.width + (projectile.contentSize.width/2);
    float ratio = (float)offset.y / (float)offset.x;
    int realY = (realX * ratio) + projectile.position.y;
    CGPoint realDest = ccp(realX, realY);
    
    // slove the distance and duration
    int offRealX = realX - projectile.position.x;
    int offRealY = realY - projectile.position.y;
    float length = sqrtf((offRealX*offRealX)+(offRealY*offRealY));
    float velocity = 480/1; //480pixels/1sec
    float realMoveDuration = length/velocity;
    
    [projectile runAction:[CCSequence actions:
        [CCMoveTo actionWithDuration:realMoveDuration position:realDest],
        [CCCallBlockN actionWithBlock:^(CCNode *node) {
            [_projectiles removeObject:node];
    }],
        nil]];
}

// for collision detection
- (void) update:(ccTime)dt
{
    NSMutableArray *projectilesToDelete = [[NSMutableArray alloc] init];
    for (CCSprite *projectile in _projectiles)
    {
        NSMutableArray *monstersToDelete = [[NSMutableArray alloc] init];
        for ( CCSprite *monster in _monsters )
        {
            if ( CGRectIntersectsRect(projectile.boundingBox, monster.boundingBox) )
            {
                [monstersToDelete addObject:monster];
            }
        }
        for ( CCSprite *monster in monstersToDelete )
        {
            [_monsters removeObject:monster];
            [self removeChild:monster cleanup:YES];
        }
        
        if (monstersToDelete.count > 0)
        {
            [projectilesToDelete addObject:projectile];
        }
        [monstersToDelete release];
    }
    
    for (CCSprite *projectile in projectilesToDelete)
    {
        [_projectiles removeObject:projectile];
        [self removeChild:projectile cleanup:YES];
    }
    [projectilesToDelete release];
}

@end
