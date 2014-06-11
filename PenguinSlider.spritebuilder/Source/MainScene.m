//
//  MainScene.m
//  PROJECTNAME
//
//  Created by Viktor on 10/10/13.
//  Copyright (c) 2013 Apportable. All rights reserved.
//

#import "MainScene.h"
#import "StarNode.h"
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
    _grounds = @[_ground1, _ground2];
    self.userInteractionEnabled = TRUE;
    
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
- (BOOL)ccPhysicsCollisionBegin:(CCPhysicsCollisionPair *)pair penguin:(CCNode *)penguin level:(CCNode *)level{
    NSLog(@"POINT");
    return TRUE;
}
- (BOOL)ccPhysicsCollisionBegin:(CCPhysicsCollisionPair *)pair penguin:(CCNode *)penguin point:(CCNode *)point{
    NSLog(@"POINT");
    [point removeFromParent];
    _points++;
    _pointLabel.string = [NSString stringWithFormat:@"%ld", (long)_points];
    return  TRUE;
}
- (void)createNewStar{
    CCNode *previousStar = [_stars lastObject];
    CGFloat previousStarXPosition = previousStar.position.x;
    if (!previousStar) {
        previousStarXPosition = firstStarPosition;
    }
    StarNode *star = (StarNode *)[CCBReader load:@"Star"];
    star.position = ccp(previousStarXPosition + distanceBetweenStars, 0);
    [_physicsNode addChild:star];
    [_stars addObject:star];
    star.zOrder = DrawingOrderStars;
}

- (void)launchPenguin:(id)sender{
    
    OALSimpleAudio *audio = [OALSimpleAudio sharedInstance];
    [audio playEffect:@"pressSound.wav"];
    
    [_penguin.physicsBody applyImpulse:ccp(0, 700.f)];
    [_penguin.physicsBody applyAngularImpulse:500000.f];
    _sinceTouch = 0.f;
    
    
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
    
    float yVelocity = clampf(_penguin.physicsBody.velocity.y, -1 * MAXFLOAT, 100.f);
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
@end