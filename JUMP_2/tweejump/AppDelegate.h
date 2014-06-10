//
//  AppDelegate.h
//  tweejump
//
//  Created by Yannick Loriot on 10/07/12.
//  Copyright Yannick Loriot 2012. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface AppDelegate : NSObject <UIApplicationDelegate> {
	UIWindow			*window;
	UIViewController	*viewController;
    NSUserDefaults *page_page;
    NSUserDefaults *Hscore;


}

@property (nonatomic, retain) UIWindow *window;
@property (nonatomic,retain) UIView *logoView;
+(BOOL)CheckLanguage;
+(BOOL)CheckHscore;

@end
