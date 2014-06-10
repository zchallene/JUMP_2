//
//  PlatForm.h
//  tweejump
//
//  Created by 孙  源 on 12-11-14.
//  Copyright 2012年 Symetrix. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

enum{
    PlatFormTypeNormal,
    PlatFormTypeWorm,
};

@interface PlatForm : CCSprite {
    
}
@property (nonatomic,assign) int type;
@property (nonatomic,assign) float readTime;
@property (nonatomic,assign) BOOL isTimeReading;
@property (nonatomic,assign) BOOL isBreaked;
-(void)stratReadingTime;

@end
