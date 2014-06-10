//
//  Help.m
//  tweejump
//
//  Created by 孙  源 on 12-11-20.
//  Copyright 2012年 Symetrix. All rights reserved.
//

#import "Help.h"
#import "Jump_Main.h"

@implementation Help
+(CCScene *) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	Help *layer = [Help node];
	
	// add layer as a child to scene
	[scene addChild: layer];
	
	// return the scene
	return scene;
}
-(id) init{
	// always call "super" init
	// Apple recommends to re-assign "self" with the "super's" return value
	if( (self=[super init]) ) {
        self.isTouchEnabled = YES;
        CCSprite *beijin = [CCSprite spriteWithFile:@"helpbeijing.png"];
        beijin.position = ccp(160,240);
        //        beijin.anchorPoint = ccp(0.f, 0.f);
        //        beijin.position = ccp(0, 0);
        [self addChild:beijin];
        
        
        
        CCSprite *backbtn = [CCSprite spriteWithFile:@"Exit.png"];
        backbtn.position = ccp(303,19);
        backbtn.tag = 21;
        [self addChild:backbtn z:2];
    }
    return self;
}

-(void)Enter_Main{
    [[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:1. scene:[Jump_Main node] withColor:ccWHITE]];

}

- (void)onEnter {
    [[CCTouchDispatcher sharedDispatcher] addTargetedDelegate:self priority:0 swallowsTouches:YES];
    self.isTouchEnabled = YES;
    [super onEnter];
}

- (void)onExit{
    [[CCTouchDispatcher sharedDispatcher] removeDelegate:self];
    [super onExit];
}

-(BOOL) ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event{
    return YES;
}
-(void)ccTouchMoved:(UITouch *)touch withEvent:(UIEvent *)event{
    //    CGPoint location = [touch locationInView: [touch view]];
    //    location = [[CCDirector sharedDirector] convertToGL:location];
}
- (void) ccTouchEnded:(UITouch *)touch withEvent:(UIEvent *)event {
    
    CGPoint location = [touch locationInView: [touch view]];
    location = [[CCDirector sharedDirector] convertToGL:location];
    CCLOG(@"{%f,%f} =============,",location.x,location.y);
    CCSprite *backbtn = (CCSprite *)[self getChildByTag:21];
    
    if (CGRectContainsPoint(backbtn.boundingBox, location)) {
        [self Enter_Main];
    }

    

}
@end
