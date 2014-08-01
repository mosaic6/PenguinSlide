//
//  MainScene.h
//  PROJECTNAME
//
//  Created by Viktor on 10/10/13.
//  Copyright (c) 2013 Apportable. All rights reserved.
//

#import "CCNode.h"
#import <GameKit/GameKit.h>
@interface MainScene : CCNode <CCPhysicsCollisionDelegate, GKGameCenterControllerDelegate>
{
    OALSimpleAudio *bgAudio;
    
    CCPhysicsNode *_physicsNode;
    CCSprite *_penguin;
    CCSprite *_slide;
    
    CCNode *_ground1;
    CCNode *_ground2;
    
    CGFloat scrollSpeed;
    
    NSArray *_grounds;
    NSMutableArray *_stars;
    NSMutableArray *_sharks;
    NSTimeInterval _sinceTouch;
    
    int64_t _points;
    CCLabelTTF *_pointLabel;
    CCLabelTTF *_halfwayLabel;
    
    CCButton *_launchBtn;
    CCLabelTTF *_loseLabel;
    CCButton *_restartBtn;
    CCButton *_reportScoreBtn;
    BOOL _gameOver;
    BOOL userAuthenticated;
    
    CCButton *_pauseBtn;
}
@property (nonatomic) BOOL gameCenterEnabled;
@property (nonatomic) int64_t _points;
@property (nonatomic, strong) NSString *leaderboardIdentifier;
- (void)reportScore;

@end
