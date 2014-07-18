//
//  PauseScreen.h
//  PenguinSlider
//
//  Created by Joshua T Walsh on 6/17/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "CCNode.h"
#import <GameKit/GameKit.h>
@interface PauseScreen : CCNode <GKGameCenterControllerDelegate>
{
    CCButton *_playBtn;
    
    OALSimpleAudio *bgAudio;
}
@property (nonatomic) BOOL gameCenterEnabled;
@property (nonatomic) int64_t _points;
@property (nonatomic, strong) NSString *leaderboardIdentifier;
@end
