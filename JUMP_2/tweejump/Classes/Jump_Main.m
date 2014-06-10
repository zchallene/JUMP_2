//
//  Jump_Main.m
//  tweejump
//
//  Created by 孙  源 on 12-11-13.
//  Copyright 2012年 Symetrix. All rights reserved.
//

#import "Jump_Main.h"
#import "Game.h"
#import "MSetstate.h"
#import "Highscores.h"
#import "Help.h"
#import "SimpleAudioEngine.h"
#import "AppDelegate.h"

@implementation Jump_Main{
}
+(CCScene *) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	Jump_Main *layer = [Jump_Main node];
	
	// add layer as a child to scene
	[scene addChild: layer];
	
	// return the scene
	return scene;
}

-(id) init{
	// always call "super" init
	// Apple recommends to re-assign "self" with the "super's" return value
	if( (self=[super init]) ) {
        [[SimpleAudioEngine sharedEngine] resumeBackgroundMusic];
        self.isTouchEnabled = YES;
//        [[CCTouchDispatcher sharedDispatcher] addTargetedDelegate:self priority:-1 swallowsTouches:YES];
        page_page = [NSUserDefaults standardUserDefaults];
        Hscore = [NSUserDefaults standardUserDefaults];
        //[[SimpleAudioEngine sharedEngine] playBackgroundMusic:@"menu_bg.mp3"];
        
        CCLOG(@"%d,[AppDelegate CheckLanguage]",[AppDelegate CheckLanguage]);
        if ([AppDelegate CheckLanguage]) {
            [[SimpleAudioEngine sharedEngine] resumeBackgroundMusic];
        }
        else{
            [[SimpleAudioEngine sharedEngine] pauseBackgroundMusic];
        }
        
       
        
        CCSprite *beijin = [CCSprite spriteWithFile:@"beijing.png"];
        beijin.position = ccp(160,240);
        [self addChild:beijin];
//=====================================================================================================
//↓↓↓
        
//        MSetstate * setlayer = [[[MSetstate alloc] init]autorelease];
//        setlayer.delegate = self;
        
        //游戏进入
        CCMenuItemImage *Start = [CCSprite spriteWithFile:@"start.png"];
        Start.position = ccp(150,260);
        Start.tag=101;
        [self addChild:Start];
        //游戏设置
        CCMenuItemImage *Setstate = [CCSprite spriteWithFile:@"set.png"];
        Setstate.position = ccp(100,150);
        Setstate.tag=102;
        [self addChild:Setstate];
        //进入帮助
        CCMenuItemImage *help = [CCSprite spriteWithFile:@"help.png"];
        help.position = ccp(145,75);
        help.tag=103;
        [self addChild:help];
        //进入排行榜
        CCMenuItemImage *scores = [CCSprite spriteWithFile:@"scores.png"];
        scores.position = ccp(215,160);
        scores.tag=104;
        [self addChild:scores];
        
        self.isTouchEnabled = YES;
        
        interstitialAD =[[GMInterstitialAD alloc]initWithId:@"ps17udt4fa9939" ];
        interstitialAD.delegate=self; 
        [self OninterstitialAD];
//  =====================================================================================================
    }
    return self;
}


//插屏广告
- (void)OninterstitialAD
{
    //加载广告 参数YES表示您的app是否允许旋转,NO表示禁止旋转
    //再次加载 只需要loadInterstitialAd  不再需要再次创建实列并initWithId
    //但要先判断 并把此广告视图移除  类似viewDidUnload 中所示
    [interstitialAD loadInterstitialAd:YES];
    if([interstitialAD superview])
    {
        [interstitialAD removeFromSuperview];
    }
    bootview = [[CCDirector sharedDirector]openGLView];
    [bootview addSubview:interstitialAD];
}

//插屏广告加载成功回调  success为yes
-(void)loadInterstitialAdSuccess:(BOOL)success
{
    NSLog(@"loadInterstitialAdSuccess====%d",success);
}



-(void)Enter{//游戏进入
    [[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:1. scene:[Game node] withColor:ccWHITE]];
}
-(void)Enterstate{
    [[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:1.f scene:[MSetstate node]]];
//    [setlayer BACK_Main];
}
//-(void)tpuch{
//    self.isTouchEnabled = YES;
//}
-(void)Enterhelp{//游戏帮助
    [[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:1. scene:[Help node] withColor:ccWHITE]];
}
-(void)Enterscores{//游戏排行榜

    if ([AppDelegate CheckHscore]) 
         [Hscore setBool:NO forKey:@"sc"];
        [[CCDirector sharedDirector] replaceScene:
         [CCTransitionFade transitionWithDuration:1. scene:[Highscores sceneWithScore:sco] withColor:ccWHITE]];

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
   
    CCSprite * start = (CCSprite *)[self getChildByTag:101];
    CCSprite * Setstate = (CCSprite *)[self getChildByTag:102];
    CCSprite * help = (CCSprite *)[self getChildByTag:103];
    CCSprite * scores = (CCSprite *)[self getChildByTag:104];

    
    if (CGRectContainsPoint(start.boundingBox, location)) {
        [self Enter];
    }
    else if (CGRectContainsPoint(Setstate.boundingBox, location)) {
        [self Enterstate];        
    }
    else if (CGRectContainsPoint(help.boundingBox, location)) {
        [self Enterhelp];
        
    }
    else if (CGRectContainsPoint(scores.boundingBox, location)) {
        [self Enterscores];
        
    }

}

@end
