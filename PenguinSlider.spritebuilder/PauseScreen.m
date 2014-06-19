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

- (void)play{
    
    bgAudio = [OALSimpleAudio sharedInstance];
    [bgAudio playEffect:@"background_music.wav" volume:0.6 pitch:1.0 pan:0.0 loop:YES];
    
    [self removeFromParent];
    
    [[CCDirector sharedDirector]resume];

}
@end
