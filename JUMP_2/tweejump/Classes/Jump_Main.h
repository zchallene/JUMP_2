//
//  Jump_Main.h
//  tweejump
//
//  Created by 孙  源 on 12-11-13.
//  Copyright 2012年 Symetrix. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import <StoreKit/StoreKit.h>
//插
#import "GMInterstitialAD.h"
#import "GuomobAdSDK.h"
@class RootViewController;
@interface Jump_Main : CCLayer <CCTargetedTouchDelegate,GuomobAdSDKDelegate,UIWebViewDelegate,GMInterstitialDelegate,SKStoreProductViewControllerDelegate>{
    int sco;
    NSUserDefaults *page_page;
    NSUserDefaults *Hscore;
    //插屏广告
    GMInterstitialAD *interstitialAD;
    //横幅(Banner)广告
    GuomobAdSDK *bannerAD;
    UIView *bootview;
}
@end

