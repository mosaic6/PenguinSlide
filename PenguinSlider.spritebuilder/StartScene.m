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

- (void)startGame{
    
    [self removeFromParent];
    CCScene *mainScene = [CCBReader loadAsScene:@"MainScene"];
    [[CCDirector sharedDirector]replaceScene:mainScene];
    [[CCDirector sharedDirector]resume];
}
@end
