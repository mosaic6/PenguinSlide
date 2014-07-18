//
//  WinScreen.m
//  PenguinSlider
//
//  Created by Joshua T Walsh on 6/18/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "WinScreen.h"
#import "MainScene.h"
#import "LevelTwo.h"
@implementation WinScreen

// Restarts the game
- (void)playAgain{
    
    CCScene *scene = [CCBReader loadAsScene:@"MainScene"];
    [[CCDirector sharedDirector]replaceScene:scene];
    
    [self removeFromParent];    
}
- (void)nextLevel{
    CCScene *levelTwo = [CCBReader loadAsScene:@"LevelTwo"];
    [[CCDirector sharedDirector]replaceScene:levelTwo];
    
    [self removeFromParent];
}
@end
