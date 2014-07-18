//
//  LevelTwo.h
//  PenguinSlider
//
//  Created by Joshua Walsh on 7/17/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "CCNode.h"
#import <GameKit/GameKit.h>
@interface LevelTwo : CCNode <CCPhysicsCollisionDelegate, GKGameCenterControllerDelegate>
{
    OALSimpleAudio *bgAudio;
    
    CCPhysicsNode *_physicsNode;
    CCSprite *_penguin;    
    CCNode *_ground3;
    CCNode *_ground4;
    
    CGFloat scrollSpeed;
    
    NSArray *_grounds;
    NSMutableArray *_stars;
    NSMutableArray *_sharks;
    NSMutableArray *_bears;
    NSTimeInterval _sinceTouch;
    
    int64_t _points;
    CCLabelTTF *_pointLabel;
    
    CCButton *_launchBtn;
    CCLabelTTF *_loseLabel;
    CCButton *_restartBtn;
    CCButton *_reportScoreBtn;
    BOOL _gameOver;
    
    CCButton *_pauseBtn;
}

@property (nonatomic) BOOL gameCenterEnabled;
@property (nonatomic) int64_t _points;
@property (nonatomic, strong) NSString *leaderboardIdentifier;
- (void)reportScore;
@end
