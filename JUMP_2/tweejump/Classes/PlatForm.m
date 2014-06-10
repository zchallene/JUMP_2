//
//  PlatForm.m
//  tweejump
//
//  Created by 孙  源 on 12-11-14.
//  Copyright 2012年 Symetrix. All rights reserved.
//

#import "PlatForm.h"


@implementation PlatForm
@synthesize type = _type;

-(int)type{
    return _type;
}

-(void)setType:(int)type{
    _type = type;
    self.isTimeReading = NO;
    self.isBreaked = NO;
}

-(void)stratReadingTime{
    self.isTimeReading = YES;
    [self unschedule:@selector(update:)];
    self.readTime = 3.9f;
    [self schedule:@selector(update:) interval:1.f];

}

-(void)update:(ccTime )dt{
    self.readTime-=1;
    if (self.readTime <=0) {
        [self unschedule:@selector(update:)];
    }
}
@end
