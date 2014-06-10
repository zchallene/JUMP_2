//
//  AppDelegate.m
//  tweejump
//
//  Created by Yannick Loriot on 10/07/12.
//  Copyright Yannick Loriot 2012. All rights reserved.
//

#import "cocos2d.h"

#import "AppDelegate.h"
#import "GameConfig.h"
#import "RootViewController.h"
#import "Jump_Main.h"
#import "SimpleAudioEngine.h"
@implementation AppDelegate

@synthesize window;
+(BOOL)CheckLanguage{
    NSUserDefaults *page_page;
    page_page = [NSUserDefaults standardUserDefaults];
    CCLOG(@"%d,page",[page_page    boolForKey:@"fanye"]);
//    [page_page setBool:YES forKey:@"fanye"];
    return [page_page    boolForKey:@"fanye"];
}
+(BOOL)CheckHscore{
    NSUserDefaults *Hscore;
    Hscore = [NSUserDefaults standardUserDefaults];
    CCLOG(@"%d,page",[Hscore    boolForKey:@"sc"]);
    return [Hscore    boolForKey:@"sc"];

}
- (void) removeStartupFlicker
{
    UIImage *image  = [UIImage imageNamed:@"logo1.png"];
    self.logoView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, image.size.width, image.size.height)];    
    UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
    [self.logoView addSubview:imageView];
    
    
    [[SimpleAudioEngine sharedEngine] playBackgroundMusic:@"menu_bg.mp3"];
    
    //[page_page setBool:YES forKey:@"fanye"];
    //[Hscore setBool:YES forKey:@"sc"];
    
    //虫子爬序列帧
    NSMutableArray *imgworm=[[NSMutableArray alloc] init];
	UIImageView *view1=[[UIImageView alloc] init];
    UIImage*img1;
	for (int i=1; i<71; i++) {
		img1=[UIImage imageNamed:[NSString stringWithFormat:@"虫-1%04d.png",i]];
		[imgworm addObject:img1];
	}
    [view1 setFrame:CGRectMake(270, 245, img1.size.width, img1.size.height)];
	[self.logoView addSubview:view1];
	view1.animationImages=imgworm;
	view1.animationDuration=3.5f;
	view1.animationRepeatCount=0;
	[view1 startAnimating];
    
    
    UIImage *image2  = [UIImage imageNamed:@"logo2.png"];
    UIImageView *imageView2 = [[UIImageView alloc]initWithImage:image2];
    imageView2.frame = CGRectMake(10, 120, image2.size.width, image2.size.height);
    [self.logoView addSubview:imageView2];
    
    
    //大头序列帧
    NSMutableArray *imghead=[[NSMutableArray alloc] init];
	UIImageView *view2=[[UIImageView alloc] init];
    UIImage*img2;
	for (int i=1; i<37; i++) {
		img2=[UIImage imageNamed:[NSString stringWithFormat:@"头-1%04d.png",i]];
		[imghead addObject:img2];
	}
    [view2 setFrame:CGRectMake(200, 150, img2.size.width, img2.size.height)];
	[self.logoView addSubview:view2];
	view2.animationImages=imghead;
	view2.animationDuration=2.f;
	view2.animationRepeatCount=0;
	[view2 startAnimating];
    
    
    [self.window addSubview:self.logoView];
    
    
    
	// THIS CODE REMOVES THE STARTUP FLICKER
	//
	// Uncomment the following code if you Application only supports landscape mode
	//
#if GAME_AUTOROTATION == kGameAutorotationUIViewController
//	CC_ENABLE_DEFAULT_GL_STATES();
//	CCDirector *director = [CCDirector sharedDirector];
//	CGSize size = [director winSize];
//	CCSprite *sprite = [CCSprite spriteWithFile:@"logo1.png"];
//	sprite.position = ccp(size.width/2, size.height/2);
//	sprite.rotation = -90;
//	[sprite visit];
//	[[director openGLView] swapBuffers];
//	CC_ENABLE_DEFAULT_GL_STATES();

//    CCSprite *beijin = [CCSprite spriteWithFile:@"logo1.png"];
//    beijin.position = ccp(160,240);
//    [self addChild:beijin];
	
#endif // GAME_AUTOROTATION == kGameAutorotationUIViewController
}


- (void) applicationDidFinishLaunching:(UIApplication*)application
{
	// Init the window
	window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];

    
	CCDirector *director = [CCDirector sharedDirector];
	// Try to use CADisplayLink director
	// if it fails (SDK < 3.1) use the default director
	if( ! [CCDirector setDirectorType:kCCDirectorTypeDisplayLink] )
		[CCDirector setDirectorType:kCCDirectorTypeDefault];
	

	
	// Init the View Controller
	viewController = [[RootViewController alloc] initWithNibName:nil bundle:nil];
	viewController.wantsFullScreenLayout = YES;

	//
	// Create the EAGLView manually
	//  1. Create a RGB565 format. Alternative: RGBA8
	//	2. depth format of 0 bit. Use 16 or 24 bit for 3d effects, like CCPageTurnTransition
	//
	//
	EAGLView *glView = [EAGLView viewWithFrame:[window bounds]
								   pixelFormat:kEAGLColorFormatRGB565	// kEAGLColorFormatRGBA8
								   depthFormat:0						// GL_DEPTH_COMPONENT16_OES
						];
	
	// attach the openglView to the director
	[director setOpenGLView:glView];
	
//	// Enables High Res mode (Retina Display) on iPhone 4 and maintains low res on all other devices
//	if( ! [director enableRetinaDisplay:YES] )
//		CCLOG(@"Retina Display Not supported");
	
	//
	// VERY IMPORTANT:
	// If the rotation is going to be controlled by a UIViewController
	// then the device orientation should be "Portrait".
	//
	// IMPORTANT:
	// By default, this template only supports Landscape orientations.
	// Edit the RootViewController.m file to edit the supported orientations.
	//
#if GAME_AUTOROTATION == kGameAutorotationNone
	[director setDeviceOrientation:kCCDeviceOrientationPortrait];
#else
	[director setDeviceOrientation:kCCDeviceOrientationLandscapeLeft];
#endif
	
	[director setAnimationInterval:1.0/60];
	//[director setDisplayFPS:YES];
	
	
	// make the OpenGLView a child of the view controller
	[viewController setView:glView];
	
	// make the View Controller a child of the main window
	[window addSubview: viewController.view];
	
	[window makeKeyAndVisible];

    
	// Default texture format for PNG/BMP/TIFF/JPEG/GIF images
	// It can be RGBA8888, RGBA4444, RGB5_A1, RGB565
	// You can change anytime.
	[CCTexture2D setDefaultAlphaPixelFormat:kCCTexture2DPixelFormat_RGBA8888];

	
	// Removes the startup flicker
	[self removeStartupFlicker];
	
    [self performSelector:@selector(runMain) withObject:nil afterDelay:6.f];
	// Run the intro Scene
}

-(void)runMain{
    [[CCDirector sharedDirector] runWithScene: [Jump_Main node]];
    [self.logoView removeFromSuperview];

}

- (void)applicationWillResignActive:(UIApplication *)application {
	[[CCDirector sharedDirector] pause];
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
	[[CCDirector sharedDirector] resume];
}

- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application {
	[[CCDirector sharedDirector] purgeCachedData];
}

-(void) applicationDidEnterBackground:(UIApplication*)application {
	[[CCDirector sharedDirector] stopAnimation];
}

-(void) applicationWillEnterForeground:(UIApplication*)application {
	[[CCDirector sharedDirector] startAnimation];
}

- (void)applicationWillTerminate:(UIApplication *)application {
	CCDirector *director = [CCDirector sharedDirector];
	
	[[director openGLView] removeFromSuperview];
	
	[viewController release];
	
	[window release];
	
	[director end];	
}

- (void)applicationSignificantTimeChange:(UIApplication *)application {
	[[CCDirector sharedDirector] setNextDeltaTimeZero:YES];
}

- (void)dealloc {
	[[CCDirector sharedDirector] end];
	[window release];
	[super dealloc];
}

@end
