//
//  MainScene.m
//  PROJECTNAME
//
//  Created by Viktor on 10/10/13.
//  Copyright (c) 2013 Apportable. All rights reserved.
//

#import "MainScene.h"
#import "StarNode.h"
#import "AppDelegate.h"
//static const CGFloat scrollSpeed = 90.f;
static const CGFloat firstStarPosition = 500.f;
static const CGFloat distanceBetweenStars = 195.f;

typedef NS_ENUM(NSInteger, DrawingOrder) {
    DrawingOrderStars,
    DrawingOrderGround,
    DrawingOrderPenguin
};

@implementation MainScene 


- (void)didLoadFromCCB {
    
    bgAudio = [OALSimpleAudio sharedInstance];
    [bgAudio playEffect:@"background_music.wav" volume:0.6 pitch:1.0 pan:0.0 loop:YES];
    
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
    
    scrollSpeed = 100.f;
}
- (void)ccPhysicsCollisionPostSolve:(CCPhysicsCollisionPair *)pair penguin:(CCNode *)penguin star:(CCNode *)star{
    [star removeFromParent];
}
- (BOOL)ccPhysicsCollisionBegin:(CCPhysicsCollisionPair *)pair penguin:(CCNode *)penguin level:(CCNode *)level{
    [self gameOver];
    OALSimpleAudio *crashAudio = [OALSimpleAudio sharedInstance];
    [crashAudio playEffect:@"crash.wav"];
    return YES;
}
- (BOOL)ccPhysicsCollisionBegin:(CCPhysicsCollisionPair *)pair penguin:(CCNode *)penguin points:(CCNode *)points{
    [points removeFromParent];
    _points++;
    _pointLabel.string = [NSString stringWithFormat:@"%ld", (long)_points];
    NSLog(@"%ld", (long)_points);
    
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
    }
    if (_points == 55) {
        scrollSpeed = scrollSpeed * 1.2f;
    }
    if (_points == 60) {
        scrollSpeed = scrollSpeed * 1.2f;
    }
    if (_points == 80) {
        scrollSpeed = scrollSpeed * 1.2f;
    }
    if (_points == 100) {
        scrollSpeed = scrollSpeed * 1.2f;
    }
    
    NSLog(@"%f", scrollSpeed);
    OALSimpleAudio *audio = [OALSimpleAudio sharedInstance];
    [audio playEffect:@"star.wav"];
    
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

- (void)launchPenguin:(id)sender{
    
    OALSimpleAudio *audio = [OALSimpleAudio sharedInstance];
    [audio playEffect:@"pressSound.wav" volume:0.3 pitch:1.0 pan:0.0 loop:NO];
    
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
    if ((_sinceTouch > 0.5f)) {
        [_penguin.physicsBody applyAngularImpulse:-10000.f*delta];
    }
    
    
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
}
- (void)restart{
    CCScene *scene = [CCBReader loadAsScene:@"MainScene"];
    [[CCDirector sharedDirector]replaceScene:scene];
}
- (void)gameOver{
    if (!_gameOver) {
        scrollSpeed = 0.f;
        _gameOver = YES;
        _restartBtn.visible = YES;
        _penguin.rotation = 90.f;
        _penguin.physicsBody.allowsRotation = NO;
        [bgAudio stopAllEffects];
        [_penguin stopAllActions];
        CCActionMoveBy *mb = [CCActionMoveBy actionWithDuration:0.3f position:ccp(-2, 2)];
        CCActionInterval *reverseMove = [mb reverse];
        CCActionSequence *as = [CCActionSequence actionWithArray:@[mb, reverseMove]];
        CCActionEaseBounce *bounce = [CCActionEaseBounce actionWithAction:as];
        [self runAction: bounce];
    }
}
@end
