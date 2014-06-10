//
//  Setstate.h
//  tweejump
//
//  Created by 孙  源 on 12-11-13.
//  Copyright 2012年 Symetrix. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
//@protocol Setstate_Delete;
@interface Setstate : CCLayer {
    BOOL *music;
    BOOL play;
//    id<Setstate_Delete> delete;
}
@property (nonatomic,retain) CCMenuItemImage *Start;
@property (nonatomic,retain) CCMenuItemImage *Start11;
@property (nonatomic,retain) CCMenuItemImage *Start2;
@property (nonatomic,retain) CCSprite *Start1;

- (void)checkParent_GameClass;
@end
