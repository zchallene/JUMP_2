//
//  MSetstate.h
//  tweejump
//
//  Created by 孙  源 on 12-11-21.
//  Copyright 2012年 Symetrix. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
@interface MSetstate : CCLayer <CCTargetedTouchDelegate>{
    BOOL play;
    CCSprite *Startt;
    CCSprite *Startt1;
    NSUserDefaults *page_page;
}
@end
