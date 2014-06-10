#import "cocos2d.h"
#import "Main.h"

@interface Game : Main
{
	CGPoint bird_pos;
	ccVertex2F bird_vel;
	ccVertex2F bird_acc;	

	float currentPlatformY;//当前平台
	int currentPlatformTag;//当前平台tag
	float currentMaxPlatformStep;//当前最大平台梯级
	int currentBonusPlatformIndex;//当前奖励平台的索引
	int currentBonusType;//当前奖励类型
	int platformCount;//平台的数量
	
	BOOL gameSuspended;//游戏悬浮
	BOOL birdLookingRight;//鸟的样子正确
    BOOL yesno;

	NSNumber *soundId;
	int score;//分数
    NSUserDefaults *Hscore;
    float fallRange;
    CCSpriteFrameCache *cache;
}

+ (CCScene *)scene;

@end
