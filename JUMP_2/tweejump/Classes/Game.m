#import "Game.h"
#import "Main.h"
#import "Highscores.h"
#import "SimpleAudioEngine.h"
#import "Setstate.h"
#import "PlatForm.h"
#import "AppDelegate.h"
@interface Game (Private)
- (void)initPlatforms;
- (void)initPlatform;
- (void)startGame;
- (void)resetPlatforms;
- (void)resetPlatform;
- (void)resetBird;
- (void)resetBonus;
- (void)step:(ccTime)dt;
- (void)jump;
- (void)showHighscores;
@end


@implementation Game

+ (CCScene *)scene
{
    CCScene *game = [CCScene node];
    
    Game *layer = [Game node];
    [game addChild:layer];
    
    return game;
}
- (void)playSound:(NSString *)fileName{
    if (soundId) {
        if (yesno==YES) {
        }else if(yesno==NO){
            [[SimpleAudioEngine sharedEngine] stopEffect:(ALuint)soundId];

        }
    }
    if (fileName) {
        soundId = (NSNumber *)[[SimpleAudioEngine sharedEngine] playEffect:fileName];
    }
}
- (id)init {
//	NSLog(@"Game::init");
	
	if(![super init]) return nil;

	gameSuspended = YES;
    yesno=NO;
    cache = [CCSpriteFrameCache sharedSpriteFrameCache];
    [cache addSpriteFramesWithFile:@"allPlatForms.plist" textureFile:@"allPlatForms.png"];
    
	//CCSpriteBatchNode *batchNode = (CCSpriteBatchNode *)[self getChildByTag:kSpriteManager];
   	[self initPlatforms];
	
//	CCSprite *bird= [CCSprite spriteWithTexture:[batchNode texture] rect:CGRectMake(608,16,44,32)];
//	[batchNode addChild:bird z:4 tag:kBird];
    CCSprite *Baby = [CCSprite spriteWithFile:@"Baby.png"];
    Baby.position = ccp(160, 240);
    [self addChild:Baby z:4 tag:kBird];
    
    
	CCSprite *bonus;

	for(int i=0; i<kNumBonuses; i++) {
		//bonus = [CCSprite spriteWithTexture:[batchNode texture] rect:CGRectMake(608+i*32,256,25,25)];
        NSString *imagName = [NSString stringWithFormat:@"bonus%ld.png",random()%3+1];
                UIImage *image = [UIImage imageNamed:imagName];
                CCTexture2D *texture = [[CCTextureCache sharedTextureCache] addImage:imagName];
                CCSpriteFrame *frame = [CCSpriteFrame frameWithTexture:texture rect:CGRectMake(0, 0, image.size.width, image.size.height)];
                bonus = [CCSprite spriteWithSpriteFrame:frame];
		[self addChild:bonus z:4 tag:kBonusStartTag+i];
		bonus.visible = NO;
	}
    

//	LabelAtlas *scoreLabel = [LabelAtlas labelAtlasWithString:@"0" charMapFile:@"charmap.png" itemWidth:24 itemHeight:32 startCharMap:' '];
//	[self addChild:scoreLabel z:5 tag:kScoreLabel];
	
	CCLabelBMFont *scoreLabel = [CCLabelBMFont labelWithString:@"0" fntFile:@"bitmapFont.fnt"];
	[self addChild:scoreLabel z:5 tag:kScoreLabel];
	scoreLabel.position = ccp(160,440);
    
    
    
    
//    if (![[SimpleAudioEngine sharedEngine]isBackgroundMusicPlaying]) {
//        [self play];
//    }
    [[SimpleAudioEngine sharedEngine] playBackgroundMusic:@"main_bg.mp3"];

    
	[self schedule:@selector(step:)];
	
//	self.isTouchEnabled = NO;//屏幕不可点击
	self.isAccelerometerEnabled = YES;//启用加速剂
    
	[[UIAccelerometer sharedAccelerometer] setUpdateInterval:(1.0 / kFPS)];
    //每秒更新加速剂60次
    
	[self startGame];
    
    
    CCMenuItemImage *Start1 = [CCMenuItemImage itemFromNormalImage:@"suspend button.png" selectedImage:@"suspend button.png" target:self selector:@selector(call_GamePause)];
    Start1.position = ccp(300,460);
    CCMenu *menu1 = [CCMenu menuWithItems:Start1, nil];
    menu1.position = CGPointZero;
    [self addChild:menu1 z:21];
    Hscore = [NSUserDefaults standardUserDefaults];

    [self EnterSetstate];
	return self;
}
-(void)call_GamePause{
    [[CCDirector sharedDirector] pause];

    [setStateLayer checkParent_GameClass];
}
- (void)dealloc {
//	NSLog(@"Game::dealloc");
	[super dealloc];
}

- (void)initPlatforms {
//	NSLog(@"initPlatforms");
	
	currentPlatformTag = kPlatformsStartTag;
	while(currentPlatformTag < kPlatformsStartTag + kNumPlatforms) {
		[self initPlatform];
		currentPlatformTag++;
	}
	
	[self resetPlatforms];
}

- (void)initPlatform {

//	CGRect rect;
//	switch(random()%2) {
//		case 0: rect = CGRectMake(608,64,102,36); break;
//		case 1: rect = CGRectMake(608,128,90,32); break;
//	}
//    
//	CCSpriteBatchNode *batchNode = (CCSpriteBatchNode*)[self getChildByTag:kSpriteManager];
	
//    NSString *imagName = [NSString stringWithFormat:@"platForm%ld.png",random()%5+1];
//    UIImage *image = [UIImage imageNamed:imagName];
//    CCTexture2D *texture = [[CCTextureCache sharedTextureCache] addImage:imagName];
//    CCSpriteFrame *frame = [CCSpriteFrame frameWithTexture:texture rect:CGRectMake(0, 0, image.size.width, image.size.height)];
//    PlatForm *platform = [PlatForm spriteWithSpriteFrame:frame];
    
    
    PlatForm *platForm = [PlatForm spriteWithSpriteFrameName:[NSString stringWithFormat:@"platForm%d.png",arc4random()%5+1]];
    [self addChild:platForm z:3 tag:currentPlatformTag];
    

}

- (void)startGame {
//	NSLog(@"startGame");

	score = 0;
	
	[self resetClouds];//重设云
	[self resetPlatforms];//重设台阶
	[self resetBird];//重设鸟
	[self resetBonus];//重设奖励
	
	[[UIApplication sharedApplication] setIdleTimerDisabled:YES];
	gameSuspended = NO;//开始
}
//重设台阶
- (void)resetPlatforms {
//	NSLog(@"resetPlatforms");
	
	currentPlatformY = -1;
	currentPlatformTag = kPlatformsStartTag;
	currentMaxPlatformStep = 60.0f;
	currentBonusPlatformIndex = 0;
	currentBonusType = 0;
	platformCount = 0;

	while(currentPlatformTag < kPlatformsStartTag + kNumPlatforms) {
		[self resetPlatform];
		currentPlatformTag++;
	}
}
//重设台阶
- (void)resetPlatform {
	
	if(currentPlatformY < 0) {
		currentPlatformY = kMinPlatformStep;
	} else {
		currentPlatformY += random() % (int)(currentMaxPlatformStep - kMinPlatformStep) + kMinPlatformStep;
		if(currentMaxPlatformStep < kMaxPlatformStep) {
			currentMaxPlatformStep += 0.5f;
		}
	}
	
	//CCSpriteBatchNode *batchNode = (CCSpriteBatchNode*)[self getChildByTag:kSpriteManager];
	PlatForm *platform = (PlatForm *)[self getChildByTag:currentPlatformTag];
    if (!platform.visible) {
        platform.visible = YES;
    }
    if (platform.numberOfRunningActions !=0) {
        [platform stopAllActions];
    }
	if(random()%2==1) platform.scaleX = -1.0f;
    
    if (random()%13==1) {
        platform.type = PlatFormTypeWorm;
        //换成有虫图片
    }
    else{
        platform.type = PlatFormTypeNormal;
        NSString *imagName = [NSString stringWithFormat:@"platForm%ld.png",random()%5+1];


        [platform setDisplayFrame:[cache spriteFrameByName:imagName]];

        //设置普通图片
    }
	
	float x;
	CGSize size = platform.contentSize; 
	if(currentPlatformY == kMinPlatformStep) {
		x = 160.0f;
	} else {
		x = random() % (320-(int)size.width) + size.width/2;
	}
	
	platform.position = ccp(x,currentPlatformY);
	platformCount++;
//	NSLog(@"platformCount = %d",platformCount);
	
	if(platformCount == currentBonusPlatformIndex) {
//		NSLog(@"platformCount == currentBonusPlatformIndex");
		CCSprite *bonus = (CCSprite*)[self getChildByTag:kBonusStartTag+currentBonusType];
		bonus.position = ccp(x,currentPlatformY+110                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                 );
		bonus.visible = YES;
	}
}
//重设鸟位置
- (void)resetBird {
//	NSLog(@"resetBird");

	//CCSpriteBatchNode *batchNode = (CCSpriteBatchNode*)[self getChildByTag:kSpriteManager];
	CCSprite *baby = (CCSprite*)[self getChildByTag:kBird];
	
	bird_pos.x = 160;
	bird_pos.y = 160;
	baby.position = bird_pos;
	
	bird_vel.x = 0;
	bird_vel.y = 0;
	
	bird_acc.x = 0;
	bird_acc.y = -550.0f;
	
	birdLookingRight = YES;
	baby.scaleX = 1.f;
}  
//重设奖励
- (void)resetBonus {
//	NSLog(@"resetBonus");
	
	//CCSpriteBatchNode *batchNode = (CCSpriteBatchNode*)[self getChildByTag:kSpriteManager];
	CCSprite *bonus = (CCSprite*)[self getChildByTag:kBonusStartTag+currentBonusType];
	bonus.visible = NO;
	currentBonusPlatformIndex += random() % (kMaxBonusStep - kMinBonusStep) + kMinBonusStep;
	if(score < 10000) {
		currentBonusType = 1;
	} else if(score < 50000) {
		currentBonusType = random() % 2;
	} else if(score < 100000) {
		currentBonusType = random() % 3;
	} else {
		currentBonusType = random() % 2 + 2;
	}
}

- (void)step:(ccTime)dt {
//	NSLog(@"Game::step");
    
	[super step:dt];
	if(gameSuspended) return;

	//CCSpriteBatchNode *batchNode = (CCSpriteBatchNode*)[self getChildByTag:kSpriteManager];
	CCSprite *bird = (CCSprite*)[self getChildByTag:kBird];
    
	bird_pos.x += bird_vel.x * dt;
	//判断鸟是否有位置偏移
	if(bird_vel.x < -30.0f && birdLookingRight) {
		birdLookingRight = NO;
		bird.scaleX = 1.0f;
	} else if (bird_vel.x > 30.0f && !birdLookingRight) {
		birdLookingRight = YES;
		bird.scaleX = -1.0f;
	}

	CGSize bird_size = bird.contentSize;
	float max_x = 320-bird_size.width/2;
	float min_x = 0+bird_size.width/2;
	
	if(bird_pos.x>max_x) bird_pos.x = max_x;
	if(bird_pos.x<min_x) bird_pos.x = min_x;
	
	bird_vel.y += bird_acc.y * dt;
	bird_pos.y += bird_vel.y * dt;
	
	CCSprite *bonus = (CCSprite*)[self getChildByTag:kBonusStartTag+currentBonusType];
	
    if(bonus.visible) {
		CGPoint bonus_pos = bonus.position;
		float range = 20.0f;
		if(bird_pos.x > bonus_pos.x - range &&
		   bird_pos.x < bonus_pos.x + range &&
		   bird_pos.y > bonus_pos.y - range &&
		   bird_pos.y < bonus_pos.y + range ) {
            [self Eat];
			switch(currentBonusType) {
				case kBonus5:   score += 5000;   break;
				case kBonus10:  score += 10000;  break;
				case kBonus50:  score += 50000;  break;
				//case kBonus100: score += 100000; break;
			}
           
			NSString *scoreStr = [NSString stringWithFormat:@"%d",score];
			CCLabelBMFont *scoreLabel = (CCLabelBMFont*)[self getChildByTag:kScoreLabel];
			[scoreLabel setString:scoreStr];
			id a1 = [CCScaleTo actionWithDuration:0.2f scaleX:1.5f scaleY:0.8f];
			id a2 = [CCScaleTo actionWithDuration:0.2f scaleX:1.0f scaleY:1.0f];
			id a3 = [CCSequence actions:a1,a2,a1,a2,a1,a2,nil];
			[scoreLabel runAction:a3];
			[self resetBonus];
            
		} 
	}
	
	int t;
	if(bird_vel.y < 0) {//鸟的Y轴速度小于0
		
		//t = kPlatformsStartTag;
		for(t=kPlatformsStartTag; t < kPlatformsStartTag + kNumPlatforms; t++) {
			PlatForm *platform = (PlatForm*)[self getChildByTag:t];

            
			CGSize platform_size = platform.contentSize;
			CGPoint platform_pos = platform.position;
			
			max_x = platform_pos.x - platform_size.width/2 - 10;
			min_x = platform_pos.x + platform_size.width/2 + 10;
			float min_y = platform_pos.y + (platform_size.height+bird_size.height)/2 - kPlatformTopPadding;
            
            if(bird_pos.x > max_x &&
               bird_pos.x < min_x &&
               bird_pos.y > platform_pos.y +90&&
               bird_pos.y < min_y) {
                NSLog(@"jumpTest:%d",platform.type);
                NSLog(@"%f, iiiiiiiii",platform.readTime);
                if (platform.type == PlatFormTypeNormal) {
                    [self jump];
                }   
                else
                {
                    if (platform.readTime <=0 ) {
                        if (!platform.isBreaked) {
                            platform.isBreaked = YES;
                            [self breakage];
                            NSMutableArray *animFrame = [NSMutableArray array];
                            for (int i=1; i<19; i++) {
                                NSString *framename = [NSString stringWithFormat:@"breakage_1%04d.png",i];
                                CCSpriteFrame *fram = [cache spriteFrameByName:framename];
                                [animFrame addObject:fram];
                            }
                            CCAnimation *anima = [CCAnimation animationWithFrames:animFrame delay:0.05f];
                            [platform runAction:[CCSequence actions:[CCRepeat actionWithAction:[CCAnimate actionWithAnimation:anima] times:1],[CCHide action], nil]];
                        }
                        //播放碎裂动画
                    }
                    else{
                        [self jump];
                    }
                }
            }
		}
		//如果鸟移除屏幕就显示排行榜页面
		if(bird_pos.y < bird_size.height/2) {
			//[self showHighscores];
		}
	}
    if(bird_pos.y > 240) {//鸟的Y轴坐标大于240
		
		float delta = bird_pos.y - 240;
		bird_pos.y = 240;
//        if (fallRange<=0) {
//            currentPlatformY -= delta;
//        }

		currentPlatformY -= delta;
		//判断云层是否移除屏幕
		//t = kCloudsStartTag;
		for(t=kCloudsStartTag; t < kCloudsStartTag + kNumClouds; t++) {
			CCSprite *cloud = (CCSprite*)[self getChildByTag:t];
			CGPoint pos = cloud.position;
			pos.y -= delta * cloud.scaleY * 0.8f;
			if(pos.y < -cloud.contentSize.height/2) {
				currentCloudTag = t;
				[self resetCloud];//重置云位置
			} else {
				cloud.position = pos;
			}
		}
		//判断台阶是否移除屏幕
		//t = kPlatformsStartTag;
		for(t=kPlatformsStartTag; t < kPlatformsStartTag + kNumPlatforms; t++) {
			PlatForm *platform = (PlatForm*)[self getChildByTag:t];
			CGPoint pos = platform.position;
			pos = ccp(pos.x,pos.y-delta);
            if (fallRange>0) {
                fallRange-=delta;
            }
            if (fallRange<=0) {
                if(pos.y < -platform.contentSize.height/2-300) {
                    currentPlatformTag = t;
                    [self resetPlatform];//重置台阶位置
                } else {
                    platform.position = pos;
                    if (pos.y<480 &&!platform.isTimeReading&&platform.type ==PlatFormTypeWorm) {
                        [platform stratReadingTime];
                        
                        //
                        NSMutableArray *animFrame = [NSMutableArray array];
                        CCSpriteFrame *fram1 = [cache spriteFrameByName:@"worm_10039.png"];
                        
                        [platform setDisplayFrame:fram1];
                        
                        for (int i=1; i<=39; i++) {
                            NSString *framename = [NSString stringWithFormat:@"worm_1%04d.png",i];
                            CCSpriteFrame *fram = [cache spriteFrameByName:framename];
                            [animFrame addObject:fram];
                        }
                        CCAnimation *anima = [CCAnimation animationWithFrames:animFrame delay:0.1f];
                        [platform runAction:[CCRepeat actionWithAction:[CCAnimate actionWithAnimation:anima] times:1]];

                    }
                }

            }
		}
		//判断金币是否移除屏幕
		if(bonus.visible) {
			CGPoint pos = bonus.position;
			pos.y -= delta;
			if(pos.y < -bonus.contentSize.height/2-300) {
				[self resetBonus];//重置金币位置
			} else {
				bonus.position = pos;
			}
		}
		
		score += (int)delta;
		NSString *scoreStr = [NSString stringWithFormat:@"%d",score];

		CCLabelBMFont *scoreLabel = (CCLabelBMFont*)[self getChildByTag:kScoreLabel];
		[scoreLabel setString:scoreStr];
	}
    else if(bird_pos.y <= 100) {//
		float delta = -bird_pos.y + 100;

//		float delta = 5;
		bird_pos.y = 100;
        fallRange +=delta;
		currentPlatformY += delta;
		//判断云层是否移除屏幕
		//t = kCloudsStartTag;
		for(t=kCloudsStartTag; t < kCloudsStartTag + kNumClouds; t++) {
			CCSprite *cloud = (CCSprite*)[self getChildByTag:t];
			CGPoint pos = cloud.position;
			pos.y += delta * cloud.scaleY * 0.8f;
			if(pos.y < -cloud.contentSize.height/2) {
//				currentCloudTag = t;
//				[self resetCloud];//重置云位置
			} else {
				cloud.position = pos;
			}
        
        }
		//判断台阶是否移除屏幕
		//t = kPlatformsStartTag;
        
        float minY = 960;
		for(t=kPlatformsStartTag; t < kPlatformsStartTag + kNumPlatforms; t++) {
			PlatForm *platform = (PlatForm*)[self getChildByTag:t];
			CGPoint pos = platform.position;
			pos = ccp(pos.x,pos.y+delta);
				platform.position = pos;
            if (minY>platform.position.y) {
                minY = platform.position.y;
            }
		}
        if (minY>100) {
            [bird runAction:[CCMoveBy actionWithDuration:1.5f position:ccp(0, -200)]];
            [self showHighscores];
        }
        
		//判断金币是否移除屏幕
		if(bonus.visible) {
			CGPoint pos = bonus.position;
			pos.y += delta;
			if(pos.y < -bonus.contentSize.height/2-300) {
//				[self resetBonus];//重置金币位置
			} else {
				bonus.position = pos;
			}
		}
		
		score -= (int)delta;
		NSString *scoreStr = [NSString stringWithFormat:@"%d",score];
        
		CCLabelBMFont *scoreLabel = (CCLabelBMFont*)[self getChildByTag:kScoreLabel];
		[scoreLabel setString:scoreStr];
	}
	bird.position = bird_pos;
}
- (void)Eat {
     yesno=YES;
     [self playSound:@"gold.wav"];
}
static Setstate *setStateLayer;
- (void)EnterSetstate{
    setStateLayer = [[[Setstate alloc] init] autorelease];
    setStateLayer.visible = NO;
    [self addChild:setStateLayer z:5];
}
-(void)breakage{
    [self playSound:@"breakage.mp3"];
}
- (void)jump {
	bird_vel.y = 290.0f + fabsf(bird_vel.x);
    [self playSound:@"jump.caf"];
}
- (void)showHighscores {
//	NSLog(@"showHighscores");
    [self playSound:@"pada.mp3"];
	gameSuspended = YES;
	[[UIApplication sharedApplication] setIdleTimerDisabled:NO];
	
//	NSLog(@"score = %d",score);
    if (![AppDelegate CheckHscore])
    [Hscore setBool:YES forKey:@"sc"];
	[[CCDirector sharedDirector] replaceScene:
     [CCTransitionFade transitionWithDuration:2.5 scene:[Highscores sceneWithScore:score] withColor:ccWHITE]];
}

//- (BOOL)ccTouchesEnded:(NSSet*)touches withEvent:(UIEvent*)event {
//	NSLog(@"ccTouchesEnded");
//
////	[self showHighscores];
//
////	AtlasSpriteManager *spriteManager = (AtlasSpriteManager*)[self getChildByTag:kSpriteManager];
////	AtlasSprite *bonus = (AtlasSprite*)[spriteManager getChildByTag:kBonus];
////	bonus.position = ccp(160,30);
////	bonus.visible = !bonus.visible;
//
////	BitmapFontAtlas *scoreLabel = (BitmapFontAtlas*)[self getChildByTag:kScoreLabel];
////	id a1 = [ScaleTo actionWithDuration:0.2f scaleX:1.5f scaleY:0.8f];
////	id a2 = [ScaleTo actionWithDuration:0.2f scaleX:1.0f scaleY:1.0f];
////	id a3 = [Sequence actions:a1,a2,a1,a2,a1,a2,nil];
////	[scoreLabel runAction:a3];
//
//	AtlasSpriteManager *spriteManager = (AtlasSpriteManager*)[self getChildByTag:kSpriteManager];
//	AtlasSprite *platform = (AtlasSprite*)[spriteManager getChildByTag:kPlatformsStartTag+5];
//	id a1 = [MoveBy actionWithDuration:2 position:ccp(100,0)];
//	id a2 = [MoveBy actionWithDuration:2 position:ccp(-200,0)];
//	id a3 = [Sequence actions:a1,a2,a1,nil];
//	id a4 = [RepeatForever actionWithAction:a3];
//	[platform runAction:a4];
//	
//	return kEventHandled;
//}

- (void)accelerometer:(UIAccelerometer*)accelerometer didAccelerate:(UIAcceleration*)acceleration {
	if(gameSuspended) return;
	float accel_filter = 0.1f;
	bird_vel.x = bird_vel.x * accel_filter + acceleration.x * (1.0f - accel_filter) * 500.0f;
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
//	NSLog(@"alertView:clickedButtonAtIndex: %i",buttonIndex);

	if(buttonIndex == 0) {
		[self startGame];
	} else {
		[self startGame];
	}
}

@end
