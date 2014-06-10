#import "Highscores.h"
#import "Main.h"
#import "Game.h"
#import "Jump_Main.h"
#import "SimpleAudioEngine.h"
#import "AppDelegate.h"
@interface Highscores (Private)
- (void)loadCurrentPlayer;
- (void)loadHighscores;
- (void)updateHighscores;
- (void)saveCurrentPlayer;
- (void)saveHighscores;
- (void)button1Callback:(id)sender;
- (void)button2Callback:(id)sender;
@end


@implementation Highscores

+ (CCScene *)sceneWithScore:(int)lastScore
{
    CCScene *game = [CCScene node];
    
    Highscores *layer = [[[Highscores alloc] initWithScore:lastScore] autorelease];
    [game addChild:layer];
    
    return game;
}

- (id)initWithScore:(int)lastScore {
//	NSLog(@"Highscores::init");
	
	if(![super init]) return nil;

//	NSLog(@"lastScore = %d",lastScore);

	//[[SimpleAudioEngine sharedEngine] playBackgroundMusic:@"menu_bg.mp3"];
	currentScore = lastScore;

//	NSLog(@"currentScore = %d",currentScore);
	
	[self loadCurrentPlayer];
	[self loadHighscores];
	[self updateHighscores];
	if(currentScorePosition >= 0) {
		[self saveHighscores];
	}
	
	//CCSpriteBatchNode *batchNode = (CCSpriteBatchNode*)[self getChildByTag:kSpriteManager];
	
//	CCSprite *title = [CCSprite spriteWithTexture:[batchNode texture] rect:CGRectMake(608,192,225,57)];
//	[batchNode addChild:title z:5];
//	title.position = ccp(160,420);
    CCSprite *score = [CCSprite spriteWithFile:@"scoreBG.png"];
    score.position = ccp(160, 240);
    [self addChild:score];
    
	float start_y = 380.0f;
	float step = 27.0f;
	int count = 0;
	for(NSMutableArray *highscore in highscores) {
		NSString *player = [highscore objectAtIndex:0];
		int score = [[highscore objectAtIndex:1] intValue];
		
//		CCLabelTTF *label1 = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"%d",(count+1)] dimensions:CGSizeMake(30,40) alignment:UITextAlignmentRight fontName:@"Arial" fontSize:14];
        
        CCLabelTTF *label1 =[CCLabelTTF labelWithString:[NSString stringWithFormat:@"%d",(count+1)] dimensions:CGSizeMake(30, 40) alignment:UITextLayoutDirectionRight fontName:@"Arial" fontSize:14];
//		CCLabelAtlas
        [self addChild:label1 z:5];
		[label1 setColor:ccBLACK];
		[label1 setOpacity:200];
		label1.position = ccp(10,start_y-count*step-2.0f);
		
        //UITextAlignmentLeft
		CCLabelTTF *label2 = [CCLabelTTF labelWithString:player dimensions:CGSizeMake(240,40) alignment:UITextWritingDirectionLeftToRight fontName:@"Arial" fontSize:16];
		[self addChild:label2 z:5];
        
		[label2 setColor:ccBLACK];
		label2.position = ccp(160,start_y-count*step);

		CCLabelTTF *label3 = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"%d",score] dimensions:CGSizeMake(260,40) alignment:UITextLayoutDirectionRight fontName:@"Arial" fontSize:16];
		[self addChild:label3 z:5];
		[label3 setColor:ccBLACK];
		[label3 setOpacity:200];
		label3.position = ccp(160,start_y-count*step);
		
		count++;
		if(count == 10) break;
	}

	CCMenuItem *button1 = [CCMenuItemImage itemFromNormalImage:@"playAgainButton.png" selectedImage:@"playAgainButton.png" target:self selector:@selector(button1Callback:)];
	CCMenuItem *button2 = [CCMenuItemImage itemFromNormalImage:@"changePlayerButton.png" selectedImage:@"changePlayerButton.png" target:self selector:@selector(button2Callback:)];
	
	CCMenu *menu = [CCMenu menuWithItems: button1, button2,nil];

	[menu alignItemsVerticallyWithPadding:9];
	menu.position = ccp(160,78);
	
	[self addChild:menu];


    CCMenuItem *button3 = [CCMenuItemImage itemFromNormalImage:@"Exit.png" selectedImage:@"Exit.png" target:self selector:@selector(back_Main)];
    CCMenu *menu2 = [CCMenu menuWithItems: button3,nil];
    [menu2 alignItemsVerticallyWithPadding:10];
	menu2.position = ccp(303,19);
    [self addChild:menu2];
    
    
    if ([AppDelegate CheckHscore]) {
        
    }else{
        
        menu.visible=NO;
    }

    Hscore = [NSUserDefaults standardUserDefaults];
    
	return self;
}
-(void)back_Main{
    [[SimpleAudioEngine sharedEngine] playBackgroundMusic:@"menu_bg.mp3"];

    [[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:1. scene:[Jump_Main node] withColor:ccWHITE]];

}
- (void)dealloc {
//	NSLog(@"Highscores::dealloc");
	[highscores release];
	[super dealloc];
}

- (void)loadCurrentPlayer {
//	NSLog(@"loadCurrentPlayer");
	
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	
	currentPlayer = nil;
	currentPlayer = [defaults objectForKey:@"player"];
	if(!currentPlayer) {
		currentPlayer = @"恭喜：请改名 ↓↓↓ ";
	}

//	NSLog(@"currentPlayer = %@",currentPlayer);
}

- (void)loadHighscores {
//	NSLog(@"loadHighscores");
	
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	
	highscores = nil;
	highscores = [[NSMutableArray alloc] initWithArray: [defaults objectForKey:@"highscores"]];
#ifdef RESET_DEFAULTS	
	[highscores removeAllObjects];
#endif
	if([highscores count] == 0) {
		[highscores addObject:[NSArray arrayWithObjects:@"喂小宝",[NSNumber numberWithInt:1000000],nil]];
		[highscores addObject:[NSArray arrayWithObjects:@"喂小宝",[NSNumber numberWithInt:750000],nil]];
		[highscores addObject:[NSArray arrayWithObjects:@"喂小宝",[NSNumber numberWithInt:500000],nil]];
		[highscores addObject:[NSArray arrayWithObjects:@"喂小宝",[NSNumber numberWithInt:250000],nil]];
		[highscores addObject:[NSArray arrayWithObjects:@"喂小宝",[NSNumber numberWithInt:100000],nil]];
		[highscores addObject:[NSArray arrayWithObjects:@"喂小宝",[NSNumber numberWithInt:50000],nil]];
		[highscores addObject:[NSArray arrayWithObjects:@"喂小宝",[NSNumber numberWithInt:20000],nil]];
		[highscores addObject:[NSArray arrayWithObjects:@"喂小宝",[NSNumber numberWithInt:10000],nil]];
		[highscores addObject:[NSArray arrayWithObjects:@"喂小宝",[NSNumber numberWithInt:5000],nil]];
		[highscores addObject:[NSArray arrayWithObjects:@"喂小宝",[NSNumber numberWithInt:1000],nil]];
	}
#ifdef RESET_DEFAULTS	
	[self saveHighscores];
#endif
}

- (void)updateHighscores {
//	NSLog(@"updateHighscores");
	
	currentScorePosition = -1;
	int count = 0;
	for(NSMutableArray *highscore in highscores) {
		int score = [[highscore objectAtIndex:1] intValue];
		
		if(currentScore >= score) {
			currentScorePosition = count;
			break;
		}
		count++;
	}
	
	if(currentScorePosition >= 0) {
		[highscores insertObject:[NSArray arrayWithObjects:currentPlayer,[NSNumber numberWithInt:currentScore],nil] atIndex:currentScorePosition];
		[highscores removeLastObject];
	}
}
//保存用户名
- (void)saveCurrentPlayer {
//	NSLog(@"saveCurrentPlayer");
//	NSLog(@"currentPlayer = %@",currentPlayer);
	
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	
	[defaults setObject:currentPlayer forKey:@"player"];
}
//保存高分
- (void)saveHighscores {
//	NSLog(@"saveHighscores");
	
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	
	[defaults setObject:highscores forKey:@"highscores"];
}
//按钮回调接口，返回游戏开始页面
- (void)button1Callback:(id)sender {
//	NSLog(@"button1Callback");

	CCTransitionScene *ts = [CCTransitionFade transitionWithDuration:0.5f scene:[Game scene] withColor:ccWHITE];
	[[CCDirector sharedDirector] replaceScene:ts];
}
//按钮回调接口，修改用户名
- (void)button2Callback:(id)sender {
//	NSLog(@"button2Callback");
	
	changePlayerAlert = [UIAlertView new];
	changePlayerAlert.title = @"新纪录创造者";
	changePlayerAlert.message = @"\n";
	changePlayerAlert.delegate = self;
	[changePlayerAlert addButtonWithTitle:@"保存"];
	[changePlayerAlert addButtonWithTitle:@"取消"];

	changePlayerTextField = [[UITextField alloc] initWithFrame:CGRectMake(20, 45, 245, 27)];
	changePlayerTextField.borderStyle = UITextBorderStyleRoundedRect;
	[changePlayerAlert addSubview:changePlayerTextField];
//	changePlayerTextField.placeholder = @"Enter your name";
//	changePlayerTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
	changePlayerTextField.keyboardType = UIKeyboardTypeDefault;
	changePlayerTextField.returnKeyType = UIReturnKeyDone;
	changePlayerTextField.autocorrectionType = UITextAutocorrectionTypeNo;
	changePlayerTextField.autocapitalizationType = UITextAutocapitalizationTypeNone;
	changePlayerTextField.delegate = self;
	[changePlayerTextField becomeFirstResponder];

	[changePlayerAlert show];
}

- (void)draw {
	[super draw];
	
	if(currentScorePosition < 0) return;

	glColor4f(0.0f, 0.0f, 0.0f, 0.2f);

	float w = 320.0f;
	float h = 27.0f;
	float x = (320.0f - w) / 2.0f;
	float y = 359.0f - currentScorePosition * h;

	GLfloat vertices[4][2];	
	GLubyte indices[4] = { 0, 1, 3, 2 };

	vertices[0][0] = x;		vertices[0][1] = y;
	vertices[1][0] = x+w;	vertices[1][1] = y;
	vertices[2][0] = x+w;	vertices[2][1] = y+h;
	vertices[3][0] = x;		vertices[3][1] = y+h;
	
	glDisable(GL_TEXTURE_2D);
	glDisableClientState(GL_TEXTURE_COORD_ARRAY);
	glDisableClientState(GL_COLOR_ARRAY);
	
	glVertexPointer(2, GL_FLOAT, 0, vertices);
	glDrawElements(GL_TRIANGLE_STRIP, 4, GL_UNSIGNED_BYTE, indices);

	glEnableClientState(GL_COLOR_ARRAY);
	glEnableClientState(GL_TEXTURE_COORD_ARRAY);
	glEnable(GL_TEXTURE_2D);
	
	glColor4f(1.0f, 1.0f, 1.0f, 1.0f);
}
//调用更改用户与分数的方法
- (void)changePlayerDone {
	currentPlayer = [changePlayerTextField.text retain];
	[self saveCurrentPlayer];
	if(currentScorePosition >= 0) {
		[highscores removeObjectAtIndex:currentScorePosition];
		[highscores addObject:[NSArray arrayWithObjects:@"喂小宝",[NSNumber numberWithInt:0],nil]];
		[self saveHighscores];
		[[CCDirector sharedDirector] replaceScene:
         [CCTransitionFade transitionWithDuration:1 scene:[Highscores sceneWithScore:currentScore] withColor:ccWHITE]];
	}
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
//	NSLog(@"alertView:clickedButtonAtIndex: %i",buttonIndex);
	
	if(buttonIndex == 0) {
		[self changePlayerDone];
	} else {
		// nothing
	}
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
//	NSLog(@"textFieldShouldReturn");
	[changePlayerAlert dismissWithClickedButtonIndex:0 animated:YES];
	[self changePlayerDone];
	return YES;
}

@end
