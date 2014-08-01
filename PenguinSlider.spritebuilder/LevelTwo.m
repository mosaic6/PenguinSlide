//
//  LevelTwo.m
//  PenguinSlider
//
//  Created by Joshua Walsh on 7/17/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "LevelTwo.h"
#import "StarNode.h"
#import "SharkNode.h"
#import "AppDelegate.h"
#import "BearNode.h"

static const CGFloat firstStarPosition = 500.f;
static const CGFloat distanceBetweenStars = 195.f;

static const CGFloat firstSharkPosition = 1500.f;
static const CGFloat distanceBetweenSharks = 532.f;

static const CGFloat firstBearPosition = 1500.f;
static const CGFloat distanceBetweenBears = 1832.f;

typedef NS_ENUM(NSInteger, DrawingOrder) {
    DrawingOrderStars,
    DrawingOrderGround,
    DrawingOrderPenguin,
    DrawingOrderShark,
    DrawingOrderBear
};

@implementation LevelTwo
@synthesize _points;

- (void)didLoadFromCCB {
    
    _gameCenterEnabled = NO;
    _leaderboardIdentifier = @"";
    _points = 50;
    
    _grounds = @[_ground3, _ground4];
    self.userInteractionEnabled = YES;
    _physicsNode.collisionDelegate = self;
    
    for (CCNode *ground in _grounds){
        ground.physicsBody.collisionType = @"level";
        ground.zOrder = DrawingOrderGround;
    }
    _penguin.physicsBody.collisionType = @"penguin";
    _penguin.zOrder = DrawingOrderPenguin;
    
    _stars = [NSMutableArray array];
    [self createNewStar];
    [self createNewStar];
    [self createNewStar];
    
    _sharks = [NSMutableArray array];
    [self createNewShark];
    [self createNewShark];
    [self createNewShark];
    
    _bears = [NSMutableArray array];
    [self createNewBear];
    [self createNewBear];
    
    scrollSpeed = 10.f;
}

// If the penguin hits the ground the game is over
- (BOOL)ccPhysicsCollisionBegin:(CCPhysicsCollisionPair *)pair penguin:(CCNode *)penguin level:(CCNode *)level{
    [self gameOver];
    OALSimpleAudio *crashAudio = [OALSimpleAudio sharedInstance];
    [crashAudio playEffect:@"crash.wav" volume:1 pitch:1.0 pan:0.0 loop:NO];
    return YES;
}

- (BOOL)ccPhysicsCollisionBegin:(CCPhysicsCollisionPair *)pair penguin:(CCNode *)penguin shark:(CCNode *)shark{
    [shark removeFromParent];
    _points--;
    _points--;
    _points--;
    
    _pointLabel.string = [NSString stringWithFormat:@"%ld", (long)_points];
    scrollSpeed = scrollSpeed / 1.2f;
    
    if (_points <= 0) {
        [self gameOver];
    }
    
    [self bounce];
    return YES;
}

- (BOOL)ccPhysicsCollisionBegin:(CCPhysicsCollisionPair *)pair penguin:(CCNode *)penguin bear:(CCNode *)bear{
    [bear removeFromParent];
    _points--;
    _points--;
    _points--;
    _points--;
    _pointLabel.string = [NSString stringWithFormat:@"%ld", (long)_points];
    scrollSpeed = scrollSpeed / 1.2f;
    
    if (_points <= 0) {
        [self gameOver];
    }
    
    [self bounce];
    return YES;
}
// Each star hit adds to the point total
- (BOOL)ccPhysicsCollisionBegin:(CCPhysicsCollisionPair *)pair penguin:(CCNode *)penguin points:(CCNode *)points{
    CCParticleSystem *hitStar = (CCParticleSystem *)[CCBReader load:@"HitStar"];
    hitStar.autoRemoveOnFinish = YES;
    hitStar.position = points.position;
    [points.parent addChild:hitStar];
    [points removeFromParent];
    _points++;
    _pointLabel.string = [NSString stringWithFormat:@"%ld", (long)_points];
    NSLog(@"%ld", (long)_points);
    
    // Each 5 points collected increased the scroll speed by 1.2f the previous scroll speed
    if (_points == 55) {
        scrollSpeed = scrollSpeed * 1.2f;
    }
    
    if (_points == 60) {
        scrollSpeed = scrollSpeed * 1.2f;
    }
    if (_points == 65) {
        scrollSpeed = scrollSpeed * 1.2f;
    }
    if (_points == 70) {
        scrollSpeed = scrollSpeed * 1.2f;
    }
    if (_points == 75) {
        scrollSpeed = scrollSpeed * 1.2f;
        GKAchievement *seventyFive = [[GKAchievement alloc]initWithIdentifier:@"PenguinSlider75PointAchievement"];
        [self sendAchievement:seventyFive];
        _achieveLabel.string = @"Hey nice work!";
        _achieveLabel.visible = YES;
    }
    if (_points == 76) {
        _achieveLabel.visible = NO;
    }
    if (_points == 80) {
        scrollSpeed = scrollSpeed * 1.2f;
    }
    if (_points == 85) {
        scrollSpeed = scrollSpeed * 1.2f;
    }
    if (_points == 90) {
        scrollSpeed = scrollSpeed * 1.2f;
    }
    if (_points == 95) {
        scrollSpeed = scrollSpeed * 1.2f;
    }
    if (_points == 100) {
        scrollSpeed = scrollSpeed * 1.2f;
        [self winGame];
        GKAchievement *hundred = [[GKAchievement alloc]initWithIdentifier:@"PenguinSlider100PointAchievement"];
        [self sendAchievement:hundred];
        _achieveLabel.string = @"Holy moly you did it!";
        _achieveLabel.visible = YES;
    }
    
    NSLog(@"%f", scrollSpeed);
    OALSimpleAudio *audio = [OALSimpleAudio sharedInstance];
    [audio playEffect:@"star.wav" volume:0.4 pitch:1.0 pan:0.0 loop:NO];
    
    return YES;
}

- (void)createNewStar{
    CCNode *previousStar = [_stars lastObject];
    CGFloat previousStarXPosition = previousStar.position.x;
    if (!previousStar) {
        previousStarXPosition = firstStarPosition;
    }
    StarNode *star = (StarNode *)[CCBReader load:@"Star"];
    star.position = ccp(previousStarXPosition + distanceBetweenStars, 0);
    [star setRandomPosition];
    [_physicsNode addChild:star];
    [_stars addObject:star];
    star.zOrder = DrawingOrderStars;
}

- (void)createNewShark{
    CCNode *previousShark = [_sharks lastObject];
    CGFloat previousSharkXPosition = previousShark.position.x;
    if (!previousShark) {
        previousSharkXPosition = firstSharkPosition;
    }
    SharkNode *shark = (SharkNode *)[CCBReader load:@"Shark"];
    shark.position = ccp(previousSharkXPosition + distanceBetweenSharks, 0);
    [shark setRandomPosition];
    [_physicsNode addChild:shark];
    [_sharks addObject:shark];
    shark.zOrder = DrawingOrderShark;
}

- (void)createNewBear{
    CCNode *previousBear = [_bears lastObject];
    CGFloat previousBearXPosition = previousBear.position.x;
    if (!previousBear) {
        previousBearXPosition = firstBearPosition;
    }
    BearNode *bear = (BearNode *)[CCBReader load:@"BearNode"];
    bear.position = ccp(previousBearXPosition + distanceBetweenBears, 0);
    [bear setRandomPosition];
    [_physicsNode addChild:bear];
    [_bears addObject:bear];
    bear.zOrder = DrawingOrderBear;
}
                        
- (void)launchPenguin:(id)sender{
    
    OALSimpleAudio *audio = [OALSimpleAudio sharedInstance];
    [audio playEffect:@"pressSound.wav" volume:0.1 pitch:1.0 pan:0.0 loop:NO];
    
    if (!_gameOver) {
        [_penguin.physicsBody applyImpulse:ccp(0, 1500.f)];
        [_penguin.physicsBody applyAngularImpulse:50000.f];
        _sinceTouch = 0.f;
    }
    
}

-(void)update:(CCTime)delta{
    _penguin.position = ccp(_penguin.position.x + delta * scrollSpeed, _penguin.position.y);
    _physicsNode.position = ccp(_physicsNode.position.x - (scrollSpeed *delta), _physicsNode.position.y);
    
    for (CCNode *ground in _grounds) {
        CGPoint groundWorldPosition = [_physicsNode convertToWorldSpace:ground.position];
        CGPoint groundSpeedPosition = [self convertToNodeSpace:groundWorldPosition];
        if (groundSpeedPosition.x <= (-1 * ground.contentSize.width)) {
            ground.position = ccp(ground.position.x + 2 * ground.contentSize.width, ground.position.y);
        }
    }
    
    float yVelocity = clampf(_penguin.physicsBody.velocity.y, -1 * MAXFLOAT, 550.f);
    _penguin.physicsBody.velocity = ccp(0, yVelocity);
    
    _sinceTouch += delta;
    _penguin.rotation = clampf(_penguin.rotation, -10.f, 30.f);
    if (_penguin.physicsBody.allowsRotation) {
        float angularVelocity = clampf(_penguin.physicsBody.angularVelocity, -2.f, 1.f);
        _penguin.physicsBody.angularVelocity = angularVelocity;
    }
    if ((_sinceTouch > 0.2f)) {
        [_penguin.physicsBody applyAngularImpulse:-10000.f*delta];
    }
    
    // Once a star is out of view another is added
    NSMutableArray *outOfViewStars = nil;
    for (CCNode *star in _stars) {
        CGPoint starWorldPosition = [_physicsNode convertToWorldSpace:star.position];
        CGPoint starScreenPosition = [self convertToNodeSpace:starWorldPosition];
        if (starScreenPosition.x < -star.contentSize.width) {
            if (!outOfViewStars) {
                outOfViewStars = [NSMutableArray array];
            }
            [outOfViewStars addObject:star];
        }
    }
    for (CCNode *starToRemove in outOfViewStars) {
        [starToRemove removeFromParent];
        [_stars removeObject:starToRemove];
        [self createNewStar];
    }
    
    NSMutableArray *outOfViewBears = nil;
    for (CCNode *bear in _bears) {
        CGPoint bearWorldPosition = [_physicsNode convertToWorldSpace:bear.position];
        CGPoint bearScreenPosition = [self convertToNodeSpace:bearWorldPosition];
        if (bearScreenPosition.x < -bear.contentSize.width) {
            if (!outOfViewBears) {
                outOfViewBears = [NSMutableArray array];
            }
            [outOfViewBears addObject:bear];
        }
    }
    for (CCNode *bearToRemove in outOfViewBears){
        [bearToRemove removeFromParent];
        [_bears removeObject:bearToRemove];
        [self createNewBear];
    }
    
    NSMutableArray *outOfViewSharks = nil;
    for (CCNode *shark in _sharks) {
        CGPoint sharkWorldPosition = [_physicsNode convertToWorldSpace:shark.position];
        CGPoint sharkScreenPosition = [self convertToNodeSpace:sharkWorldPosition];
        if (sharkScreenPosition.x < -shark.contentSize.width) {
            if (!outOfViewSharks) {
                outOfViewSharks = [NSMutableArray array];
            }
            [outOfViewSharks addObject:shark];
        }
    }
    for (CCNode *sharkToRemove in outOfViewSharks){
        [sharkToRemove removeFromParent];
        [_sharks removeObject:sharkToRemove];
        [self createNewShark];
    }
}

// Restarts the game
- (void)restart{
    CCScene *scene = [CCBReader loadAsScene:@"MainScene"];
    [[CCDirector sharedDirector]replaceScene:scene];
}
// Report your score for the leaderboard
- (void)reportScore{
    [self reportHighScore];
    [self showLeaderboardAndAchievements:YES];
}
// Pause screen for game
- (void)pauseGame{
    NSLog(@"Game Paused");
    CCScene *pauseScreen = [CCBReader loadAsScene:@"PauseScreen"];
    [self addChild:pauseScreen];
    [[CCDirector sharedDirector]pause];
    [bgAudio stopAllEffects];
}
//Show Win Screen if game is won
- (void)winGame{
    CCScene *winScreen = [CCBReader loadAsScene:@"WinScreen"];
    [self addChild:winScreen];
    [bgAudio stopAllEffects];
    // Stops the penguin from falling
    _penguin.physicsBody.type = CCPhysicsBodyTypeStatic;
    _launchBtn.enabled = NO;
    // Stops the penguin from collecting more stars
    scrollSpeed = 0.f;
}
//Add comment for git commit...
// If the penguin object hits the ground object, the game will end and all functions will stop
- (void)gameOver{
    if (!_gameOver) {
        scrollSpeed = 0.f;
        _gameOver = YES;
        _loseLabel.visible = YES;
        _restartBtn.visible = YES;
        _reportScoreBtn.visible = YES;
        _penguin.rotation = 90.f;
        _penguin.physicsBody.allowsRotation = NO;
        [bgAudio stopAllEffects];
        [_penguin stopAllActions];
        _launchBtn.userInteractionEnabled = NO;
        [self reportHighScore];
        [self bounce];
        
    }
}
// Bounce action on contact with enemy or ground
- (void)bounce{
    CCActionMoveBy *mb = [CCActionMoveBy actionWithDuration:0.1f position:ccp(-4, 4)];
    CCActionInterval *reverseMove = [mb reverse];
    CCActionSequence *as = [CCActionSequence actionWithArray:@[mb, reverseMove]];
    CCActionEaseBounce *bounce = [CCActionEaseBounce actionWithAction:as];
    [self runAction: bounce];
}
// Report the score to the Game Center
-(void)reportHighScore{
    GKScore *score = [[GKScore alloc] initWithLeaderboardIdentifier:@"PenguinSliderLeaderboard"];
    score.value = _points;
    
    [GKScore reportScores:@[score] withCompletionHandler:^(NSError *error) {
        if (error != nil) {
            NSLog(@"%@", [error localizedDescription]);
        }
    }];
}

// Show the Game Center Leaderboard
- (void)showLeaderboardAndAchievements:(BOOL)shouldShowLeaderboard{
    // Init the following view controller object.
    GKGameCenterViewController *gcViewController = [[GKGameCenterViewController alloc] init];
    
    // Set self as its delegate.
    gcViewController.gameCenterDelegate = self;
    
    // Depending on the parameter, show either the leaderboard or the achievements.
    if (shouldShowLeaderboard) {
        gcViewController.viewState = GKGameCenterViewControllerStateLeaderboards;
        gcViewController.leaderboardIdentifier = _leaderboardIdentifier;
    }
    else{
        gcViewController.viewState = GKGameCenterViewControllerStateAchievements;
    }
    
    // Finally present the view controller.
    [[CCDirector sharedDirector]presentViewController:gcViewController animated:YES completion:nil];
}

- (void)sendAchievement:(GKAchievement *)achievement{
    achievement.percentComplete = 100.0;
    achievement.showsCompletionBanner = YES;
    
    [achievement reportAchievementWithCompletionHandler:^(NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^(void){
            if (error  == nil) {
                NSLog(@"Success! Achievement Sent");
            } else {
                NSLog(@"Failed! Achievment not sent");
            }
        });
    }];
}


@end
