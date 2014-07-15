//
//  MainScene.m
//  PROJECTNAME
//
//  Created by Viktor on 10/10/13.
//  Copyright (c) 2013 Apportable. All rights reserved.
//

#import "MainScene.h"
#import "StarNode.h"
#import "SharkNode.h"
#import "AppDelegate.h"

static const CGFloat firstStarPosition = 500.f;
static const CGFloat distanceBetweenStars = 195.f;

static const CGFloat firstSharkPosition = 1500.f;
static const CGFloat distanceBetweenSharks = 532.f;

typedef NS_ENUM(NSInteger, DrawingOrder) {
    DrawingOrderStars,
    DrawingOrderGround,
    DrawingOrderPenguin,
    DrawingOrderShark
};

@implementation MainScene 


- (void)didLoadFromCCB {
    _grounds = @[_ground1, _ground2];
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
    
    
    scrollSpeed = 100.f;
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
    if (_points == 5) {
        scrollSpeed = scrollSpeed * 1.2f;
    }

    if (_points == 10) {
        scrollSpeed = scrollSpeed * 1.2f;
    }
    if (_points == 15) {
        scrollSpeed = scrollSpeed * 1.2f;
    }
    if (_points == 20) {
        scrollSpeed = scrollSpeed * 1.2f;
    }
    if (_points == 25) {
        scrollSpeed = scrollSpeed * 1.2f;
    }
    if (_points == 30) {
        scrollSpeed = scrollSpeed * 1.2f;
    }
    if (_points == 35) {
        scrollSpeed = scrollSpeed * 1.2f;
    }
    if (_points == 40) {
        scrollSpeed = scrollSpeed * 1.2f;
    }
    if (_points == 45) {
        scrollSpeed = scrollSpeed * 1.2f;
    }
    if (_points == 50) {
        scrollSpeed = scrollSpeed * 1.2f;
        [self winGame];
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

- (void)launchPenguin:(id)sender{
    
    OALSimpleAudio *audio = [OALSimpleAudio sharedInstance];
    [audio playEffect:@"pressSound.wav" volume:0.1 pitch:1.0 pan:0.0 loop:NO];
    
    if (!_gameOver) {
        [_penguin.physicsBody applyImpulse:ccp(0, 1000.f)];
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
    
    float yVelocity = clampf(_penguin.physicsBody.velocity.y, -1 * MAXFLOAT, 250.f);
    _penguin.physicsBody.velocity = ccp(0, yVelocity);
    
    _sinceTouch += delta;
    _penguin.rotation = clampf(_penguin.rotation, -10.f, 20.f);
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
        _penguin.rotation = 90.f;
        _penguin.physicsBody.allowsRotation = NO;
        [bgAudio stopAllEffects];
        [_penguin stopAllActions];
        _launchBtn.userInteractionEnabled = NO;
        CCActionMoveBy *mb = [CCActionMoveBy actionWithDuration:0.3f position:ccp(-2, 2)];
        CCActionInterval *reverseMove = [mb reverse];
        CCActionSequence *as = [CCActionSequence actionWithArray:@[mb, reverseMove]];
        CCActionEaseBounce *bounce = [CCActionEaseBounce actionWithAction:as];
        [self runAction: bounce];
    }
}
@end
