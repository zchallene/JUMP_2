//
//  MSetstate.m
//  tweejump
//
//  Created by 孙  源 on 12-11-21.
//  Copyright 2012年 Symetrix. All rights reserved.
//

#import "MSetstate.h"
#import "SimpleAudioEngine.h"
#import "Jump_Main.h"
#import "AppDelegate.h"
@implementation MSetstate{
}
//@synthesize delegate;
+(CCScene *) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	MSetstate *layer = [MSetstate node];
	
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
        play = YES;
        CCSprite *beijin = [CCSprite spriteWithFile:@"setBG.png"];
        beijin.position = ccp(160,240);
        [self addChild:beijin];

        //BACK
        Startt = [CCSprite spriteWithFile:@"Exit.png"];
        Startt.position = ccp(303,19);
        Startt.tag =55;
        [self addChild:Startt];
        
        //
        if ([AppDelegate CheckLanguage]) {

            Startt1 = [CCSprite spriteWithFile:@"Open_BackgroundMusic.png"];
            Startt1.position = ccp(220,282);
            Startt1.tag =56;
            [self addChild:Startt1];
        }else{
            Startt1 = [CCSprite spriteWithFile:@"Close_BackgroundMusic.png"];
            Startt1.position = ccp(220,282);
            Startt1.tag =56;
            [self addChild:Startt1];
         }
        page_page = [NSUserDefaults standardUserDefaults];

        
    }
    return self;
}
//关闭音乐
-(void)Close_BackgroundMusic{
    if ([AppDelegate CheckLanguage]) {
        [page_page setBool:NO forKey:@"fanye"];
        CCTexture2D * texture =[[CCTextureCache sharedTextureCache] addImage: @"Close_BackgroundMusic.png"];//新建贴图
        [Startt1 setTexture:texture];
        
        [[SimpleAudioEngine sharedEngine] pauseBackgroundMusic];
        
    }else{
        [page_page setBool:YES forKey:@"fanye"];
        CCTexture2D * texture =[[CCTextureCache sharedTextureCache] addImage: @"Open_BackgroundMusic.png"];//新建贴图
        [Startt1 setTexture:texture];
        
        [[SimpleAudioEngine sharedEngine] resumeBackgroundMusic];
        
    }
}
-(void)BACK_Main{
    [[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:1.f scene:[Jump_Main node]]];
//    self.visible = NO;
//    [self.delegate  touch:play];
}

- (void)onEnter {
    [[CCTouchDispatcher sharedDispatcher] addTargetedDelegate:self priority:1 swallowsTouches:YES];
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
    
    CCSprite *Startt3 = (CCSprite *)[self getChildByTag:55];
    CCSprite *Startt4 = (CCSprite *)[self getChildByTag:56];

    if (CGRectContainsPoint(Startt3.boundingBox, location)) {
        [self BACK_Main];
    }
    if (CGRectContainsPoint(Startt4.boundingBox, location)) {
        [self Close_BackgroundMusic];
    }
}

@end
