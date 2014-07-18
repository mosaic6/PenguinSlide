//
//  PauseScreen.m
//  PenguinSlider
//
//  Created by Joshua T Walsh on 6/17/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "PauseScreen.h"
#import "MainScene.h"
@implementation PauseScreen

// Removes pause view from view and resumes main scene
- (void)play{
    
    bgAudio = [OALSimpleAudio sharedInstance];
    [bgAudio playEffect:@"music.wav" volume:0.6 pitch:1.0 pan:0.0 loop:YES];
    
    [self removeFromParent];
    
    [[CCDirector sharedDirector]resume];

}
- (void)restartGame{
    [self removeFromParent];
    CCScene *scene = [CCBReader loadAsScene:@"MainScene"];
    [[CCDirector sharedDirector]replaceScene:scene];
    [[CCDirector sharedDirector]resume];
}
- (void)showHighScores{
    [self showLeaderboardAndAchievements:YES];
}

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
    [[CCDirector sharedDirector]addChildViewController:gcViewController];
}

#pragma mark - GKGameCenterControllerDelegate method implementation

-(void)gameCenterViewControllerDidFinish:(GKGameCenterViewController *)gameCenterViewController
{
    [gameCenterViewController dismissViewControllerAnimated:YES completion:nil];
}
@end
