//
//  WinScreen.m
//  PenguinSlider
//
//  Created by Joshua T Walsh on 6/18/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "WinScreen.h"
#import "MainScene.h"
@implementation WinScreen

// Restarts the game
- (void)playAgain{
    
    CCScene *scene = [CCBReader loadAsScene:@"MainScene"];
    [[CCDirector sharedDirector]replaceScene:scene];
    
    [self removeFromParent];    
}
@end
