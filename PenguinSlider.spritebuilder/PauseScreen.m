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
{
    GKLeaderboardViewController *leaderboardVC;
}
- (void)didLoadFromCCB {
    _leaderboardIdentifier = @"";
    [self retrieveTopTenScores];
}
// Removes pause view from view and resumes main scene
- (void)play{
    
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
    [self retrieveTopTenScores];
    
    leaderboardVC = [[GKLeaderboardViewController alloc]init];
    if(leaderboardVC != nil){
        leaderboardVC.category = self.leaderboardIdentifier;
        leaderboardVC.timeScope = GKLeaderboardTimeScopeAllTime;
        [self showLeaderboardAndAchievements:YES];
        [[CCDirector sharedDirector] pause];
        
    }
    
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
    [[CCDirector sharedDirector]presentViewController:gcViewController animated:YES completion:nil];
}


- (void) retrieveTopTenScores
{
    leaderboardPointsID = [[NSMutableArray alloc]init];
    leaderboardPointsSaved = [[NSMutableArray alloc]init];
    GKLeaderboard *leaderboardRequest = [[GKLeaderboard alloc] init];
    NSString *alias = [GKLocalPlayer localPlayer].alias;
    NSString *name = [GKLocalPlayer localPlayer].displayName;
    if (leaderboardRequest != nil)
    {
        leaderboardRequest.playerScope = GKLeaderboardPlayerScopeGlobal;
        leaderboardRequest.timeScope = GKLeaderboardTimeScopeToday;
        leaderboardRequest.identifier = @"PenguinSliderLeaderboard";
        leaderboardRequest.range = NSMakeRange(1,10);
        
        [leaderboardRequest loadScoresWithCompletionHandler: ^(NSArray *scores, NSError *error) {
            
            if (error != nil)
            {
                NSLog(@"Can't get leaderboard score") ;
                return;
            }
            
            if (scores != nil)
            {
                
                NSLog(@"%@", leaderboardRequest.scores);
                NSLog(@"%@", leaderboardRequest.identifier);
                NSLog(@"%@", alias);
                NSLog(@"%@", name);
                NSLog(@"%@", scores);
                GKScore *myScore = leaderboardRequest.localPlayerScore;


                _playerScore.string = [NSString stringWithFormat:@"%ld",myScore.rank];
                _playerNames.string = name;
                
                
            }
        }];
    }
}


#pragma mark - GKGameCenterControllerDelegate method implementation
// Dismiss the Game Center
-(void)gameCenterViewControllerDidFinish:(GKGameCenterViewController *)gameCenterViewController
{
    [gameCenterViewController dismissViewControllerAnimated:YES completion:nil];
    [[CCDirector sharedDirector]pause];

}


@end

