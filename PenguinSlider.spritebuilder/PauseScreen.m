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
    [self retrieveTopTenScores];
    leaderboardVC = [[GKLeaderboardViewController alloc]init];
    leaderboardVC.delegate = NULL;
    if(leaderboardVC != NULL){
        leaderboardVC.category = self.leaderboardIdentifier;
        leaderboardVC.timeScope = GKLeaderboardTimeScopeAllTime;
        [[CCDirector sharedDirector]presentViewController:leaderboardVC animated:YES completion:nil];
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
    [[CCDirector sharedDirector]addChildViewController:gcViewController];
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
            
            NSArray *playerIDs = [scores valueForKey:@"playerID"];
            [GKPlayer loadPlayersForIdentifiers:playerIDs withCompletionHandler:^(NSArray *players, NSError *error) {
                NSLog(@"About to parse the leaderboardPointsID: Contains %@", leaderboardPointsID);
                for (NSString *playerIDFromLB in leaderboardPointsID) {
                    for (GKScore *player in scores) {
                        NSString *_value = [NSString stringWithFormat:@"%@", player.formattedValue];
                        _playerScore.string = _value;
                        if ([playerIDFromLB isEqualToString:player.playerID]) {
                            [leaderboardPointsSaved addObject:[NSString stringWithFormat:@"%lld", player.value]];
                            [leaderboardPointsSaved addObject:[NSString stringWithFormat:@"%@", player]];
                            NSLog(@"done: added player to array for: %@", player.playerID);
                            NSLog(@"%@", playerIDFromLB);
                            
                            
                        }
                    }
                    for (GKLeaderboard *board in scores) {
                        board.playerScope = GKLeaderboardPlayerScopeGlobal;
                        board.timeScope = GKLeaderboardTimeScopeAllTime;
                        NSRange range = {.location = 1, .length = 1};
                        board.range = range;
                        [board loadScoresWithCompletionHandler:^(NSArray *scores, NSError *error) {
                            NSLog(@"Your score is %lld", board.localPlayerScore.value);
                        }];
                    }
                }
            }];
            if (error != nil)
            {
                NSLog(@"get leaderboard score") ;
                return ;
            }
            if (scores != nil)
            {
                NSLog(@"%@", leaderboardRequest.scores);
                NSLog(@"%@", leaderboardRequest.identifier);
                NSLog(@"%@", alias);
                NSLog(@"%@", name);
                GKScore *sc = [[GKScore alloc]init];
                NSString *_value = [NSString stringWithFormat:@"%@", sc.formattedValue];
                _playerScore.string = _value;
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
//    [gameCenterViewController removeFromParentViewController];
}


@end
