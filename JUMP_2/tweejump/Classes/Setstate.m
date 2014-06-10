//
//  Setstate.m
//  tweejump
//
//  Created by 孙  源 on 12-11-13.
//  Copyright 2012年 Symetrix. All rights reserved.
//

#import "Setstate.h"
#import "SimpleAudioEngine.h"
#import "Game.h"
#import "Jump_Main.h"
@implementation Setstate
+(CCScene *) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	Setstate *layer = [Setstate node];
	
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
                CCSprite *beijin = [CCSprite spriteWithFile:@"zanting.png"];
                beijin.position = ccp(160,240);
                //        beijin.anchorPoint = ccp(0.f, 0.f);
                //        beijin.position = ccp(0, 0);
        [self addChild:beijin];
//=====================================================================================================
//↓↓↓

        //隐藏层
        self.Start = [CCMenuItemImage itemFromNormalImage:@"Exit.png" selectedImage:@"Exit.png" target:self selector:@selector(Visible_scene)];
        self.Start.position = ccp(273,90);
        self.Start.visible = NO;
       play = YES;
        //开关
        self.Start1 = [CCSprite spriteWithFile:@"Open_BackgroundMusic.png"];
        self.Start1.position = ccp(210,300);
        self.Start1.tag =51;
        [self addChild:self.Start1];
        
        //返回菜单
        self.Start2 = [CCMenuItemImage itemFromNormalImage:@"zanting3.png" selectedImage:@"zanting3.png" target:self selector:@selector(Back_Jump_Main)];
        self.Start2.position = ccp(160,145);
        
        CCMenu *menu2 = [CCMenu menuWithItems:self.Start,self.Start2, nil];
        menu2.position = CGPointZero;
        [self addChild:menu2 z:2];
//=====================================================================================================

    }
    return self;
}

//继续游戏
-(void)Visible_scene{
    self.visible = NO;
    [[CCDirector sharedDirector] resume];
}
//关闭音乐
-(void)Close_BackgroundMusic{
    if (play==YES) {
        play=NO;
        
        CCTexture2D * texture =[[CCTextureCache sharedTextureCache] addImage: @"Close_BackgroundMusic.png"];//新建贴图
        [self.Start1 setTexture:texture];
        
        [[SimpleAudioEngine sharedEngine] pauseBackgroundMusic];
   
    }
    else{
        play=YES;
        
        CCTexture2D * texture =[[CCTextureCache sharedTextureCache] addImage: @"Open_BackgroundMusic.png"];//新建贴图
        [self.Start1 setTexture:texture];
        
        [[SimpleAudioEngine sharedEngine] resumeBackgroundMusic];
                
    }
}
//开启音乐
//-(void)Open_BackgroundMusic{
//     [[SimpleAudioEngine sharedEngine] resumeBackgroundMusic];
//}
//返回菜单
- (void)Back_Jump_Main{
    if ([[CCDirector sharedDirector] isPaused]) {
        [[CCDirector sharedDirector]resume];
        [[SimpleAudioEngine sharedEngine] playBackgroundMusic:@"menu_bg.mp3"];
    }
    [[SimpleAudioEngine sharedEngine] playBackgroundMusic:@"menu_bg.mp3"];
    [[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:0.5f scene:[Jump_Main node] withColor:ccWHITE]];
}
//检测self的parent是否为Game，和  从主菜单直接进入set页面区分
- (void)checkParent_GameClass{
    self.visible = YES;
    
    if ([self.parent isMemberOfClass:[Game class]]) {
        self.Start.visible = YES;
        
    }
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
    
    CCSprite *Start1 = (CCSprite *)[self getChildByTag:51];
    
    if (CGRectContainsPoint(Start1.boundingBox, location)) {
        [self Close_BackgroundMusic];
    }
}

@end
