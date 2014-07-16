//
//  StartScene.m
//  PenguinSlider
//
//  Created by Joshua Walsh on 6/25/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "StartScene.h"
#import "MainScene.h"
@implementation StartScene

- (void)didLoadFromCCB {
    
    bgAudio = [OALSimpleAudio sharedInstance];
    [bgAudio playEffect:@"music.wav" volume:0.4 pitch:1.0 pan:0.0 loop:YES];
    
}
- (void)startGame{
    
    [self removeFromParent];
    CCScene *mainScene = [CCBReader loadAsScene:@"MainScene"];
    [[CCDirector sharedDirector]replaceScene:mainScene];
    [[CCDirector sharedDirector]resume];
}
- (void)showCredits{
    CCScene *creditScene = [CCBReader loadAsScene:@"CreditScene"];
    [self addChild:creditScene];
    
}

@end
