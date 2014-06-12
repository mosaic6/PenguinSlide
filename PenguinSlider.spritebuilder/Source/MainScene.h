//
//  MainScene.h
//  PROJECTNAME
//
//  Created by Viktor on 10/10/13.
//  Copyright (c) 2013 Apportable. All rights reserved.
//

#import "CCNode.h"

@interface MainScene : CCNode <CCPhysicsCollisionDelegate>
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
    NSTimeInterval _sinceTouch;
    
    NSInteger _points;
    CCLabelTTF *_pointLabel;
    
    CCButton *_restartBtn;
    BOOL _gameOver;
}
@end
