//
//  MyScene.m
//  Explosion
//
//  Created by NickPiatt on 4/17/14.
//  Copyright (c) 2014 iPiatt. All rights reserved.
//

#import "MyScene.h"

#define SAFE_NODE_NAME @"safe"
#define PLAYFUL_NODE_NAME @"playful"
#define DANGEROUS_NODE_NAME @"dangerous"

@implementation MyScene
{
    SKSpriteNode *_startBox;
    SKSpriteNode *_dangerousBox;
    SKSpriteNode *_playfulBox;
    SKSpriteNode *_safeBox;
    SKSpriteNode *_tryAgain;
    
    SKLabelNode *_decisionNode;
    
    NSMutableArray *_boxesToAnimate;
}

-(id)initWithSize:(CGSize)size {    
    if (self = [super initWithSize:size]) {
        /* Setup your scene here */
        
        self.backgroundColor = [SKColor colorWithRed:60.0f/255.0f green:166.0f/255.0f blue:238.0f/255.0f alpha:1.0];
        
        _boxesToAnimate = [NSMutableArray new];
        
        _startBox = [SKSpriteNode spriteNodeWithImageNamed:@"newStart.png"];
        _startBox.position = CGPointMake(150, 250);
        _startBox.name = @"start";
        [self addChild:_startBox];
        
    }
    return self;
}

-(void)animateBoxes
{
    CGFloat actionSpeed = .25;
    
    for (int x = 0; x<_boxesToAnimate.count; x++) {
        SKSpriteNode *box = [_boxesToAnimate objectAtIndex:x];
        SKAction *moveAction;
        int randXMod = (arc4random()%50);
        int randYMod = (arc4random()%50)-25;
        switch (x) {
            case 0:
                moveAction = [SKAction moveByX:-(100+randXMod) y:50+randYMod duration:actionSpeed];
                break;
            case 1:
                moveAction = [SKAction moveByX:-(100+randXMod) y:100+randYMod duration:actionSpeed];
                break;
            case 2:
                moveAction = [SKAction moveByX:(100+randXMod) y:100+randYMod duration:actionSpeed];
                break;
            case 3:
                moveAction = [SKAction moveByX:(100+randXMod) y:50+randYMod duration:actionSpeed];
                break;
            case 4:
                moveAction = [SKAction moveByX:-(100+randXMod) y:-50+randYMod duration:actionSpeed];
                break;
            case 5:
                moveAction = [SKAction moveByX:-(100+randXMod) y:-100+randYMod duration:actionSpeed];
                break;
            case 6:
                moveAction = [SKAction moveByX:(100+randXMod) y:-100+randYMod duration:actionSpeed];
                break;
            case 7:
                moveAction = [SKAction moveByX:(100+randXMod) y:-50+randYMod duration:actionSpeed];
                break;
            default:
                break;
        }
        
        SKAction *scaleAction = [SKAction scaleBy:(arc4random()%3)+1 duration:actionSpeed];
        
        CGFloat randRotate = M_PI * (arc4random()%8+.5);
        
        SKAction *rotateAction = [SKAction rotateByAngle:randRotate duration:actionSpeed];
        
        SKAction *groupAction = [SKAction group:@[moveAction, scaleAction, rotateAction]];
        [box runAction:groupAction completion:^{
            [box removeFromParent];
        }];
    }
    
    [_boxesToAnimate removeAllObjects];
}

-(void)animateOptionBoxesToOriginalPosition
{
    // Animates the option boxes back to zRotation = 0
    
    SKAction *rotateAtion = [SKAction rotateToAngle:0 duration:.25];
    
    [self runActionOnOptionBoxes:rotateAtion];
}

-(void)explodeStart
{
    for (int x=0; x<8; x++) {
        SKSpriteNode *newBox = [SKSpriteNode spriteNodeWithImageNamed:[NSString stringWithFormat:@"start%d", x+1]];
        
        CGPoint boxPos;
        if (x<4) {
            boxPos.y = 250+12.5;
            boxPos.x = 100+(12.5)+(25*x);
        } else {
            boxPos.y = 250-12.5;
            boxPos.x = 100+(12.5)+(25*(x-4));
        }
        
        newBox.position = boxPos;
        
        [self addChild:newBox];
        [_boxesToAnimate addObject:newBox];
    }
    
    [_startBox removeFromParent];
    [self animateBoxes];
}

-(void)explodeTryAgain
{
    for (int x = 0; x<8; x++) {
        SKSpriteNode *newBox = [SKSpriteNode spriteNodeWithImageNamed:[NSString stringWithFormat:@"start%d", x+1]];
        
        CGPoint boxPos;
        if (x<4) {
            boxPos.y = 325+12.5;
            boxPos.x = 100+(12.5)+(25*x);
        } else {
            boxPos.y = 325-12.5;
            boxPos.x = 100+(12.5)+(25*(x-4));
        }
        
        newBox.position = boxPos;
        
        [self addChild:newBox];
        [_boxesToAnimate addObject:newBox];
    }
    
    [_tryAgain removeFromParent];
    
    [self animateBoxes];
    
    SKAction *moveAction = [SKAction moveByX:self.size.width y:0 duration:.25];
    [_decisionNode runAction:moveAction completion:^{
        [_decisionNode removeFromParent];
    }];
    
}
-(void)optionBoxSelected:(SKSpriteNode*)oBox
{
    CGFloat actionDuration = .25;
    SKAction *scaleAction = [SKAction scaleBy:1.5 duration:actionDuration];
    SKAction *waitAction = [SKAction waitForDuration:.25];
    SKAction *actionSequence = [SKAction sequence:@[waitAction, scaleAction]];
    
    SKAction *moveUpAction = [SKAction moveByX:0 y:25 duration:.25];
    SKAction *moveSequence = [SKAction sequence:@[waitAction, moveUpAction]];
    [self runActionOnOptionBoxes:moveSequence];
    
    [oBox runAction:actionSequence completion:^{
        [self spawnDecisionAtNode:oBox];
    }];
}

-(void)resetOptionBoxes
{
    
    CGFloat moveY = -25;
    CGFloat actionSpeed = .5;
    
    SKAction *moveAction = [SKAction moveByX:0 y:moveY duration:actionSpeed];
    SKAction *resizeAction = [SKAction resizeToWidth:50 height:50 duration:actionSpeed];
    
    SKAction *wiggleAction = [SKAction rotateByAngle:M_PI/32 duration:actionSpeed/2];
    SKAction *wiggleSeq = [SKAction repeatActionForever:[SKAction sequence:@[[wiggleAction reversedAction], [wiggleAction reversedAction], wiggleAction, wiggleAction]]];
    
    
    SKAction *safeGroupAction = [SKAction group:@[moveAction, resizeAction, wiggleAction]];
    SKAction *playfulGroupAction = [SKAction group:@[moveAction, resizeAction, wiggleAction]];
    SKAction *dangerousGroupAction = [SKAction group:@[moveAction, resizeAction, wiggleAction]];
    
    [_safeBox runAction:[SKAction sequence:@[safeGroupAction, [SKAction runBlock:^{
        _safeBox.name = @"optionBox";
    }], wiggleSeq]]];
    [_playfulBox runAction:[SKAction sequence:@[playfulGroupAction, [SKAction runBlock:^{
        _playfulBox.name = @"optionBox";
    }], wiggleSeq]]];
    [_dangerousBox runAction:[SKAction sequence:@[dangerousGroupAction, [SKAction runBlock:^{
        _dangerousBox.name = @"optionBox";
    }], wiggleSeq]]];
}

-(void)runActionOnOptionBoxes:(SKAction*)nodeAction
{
    [_safeBox runAction:nodeAction];
    [_playfulBox runAction:nodeAction];
    [_dangerousBox runAction:nodeAction];
}

-(void)spawnDecisionAtNode:(SKSpriteNode*)node
{
    _decisionNode = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
    
    _decisionNode.text = [NSString stringWithFormat:@"A %@ decision!", node.name];
    _decisionNode.fontSize = 1;
    _decisionNode.position = node.position;
    
    
    [self addChild:_decisionNode];
    
    
    CGFloat finalFontSize = 16;
    CGFloat actionDuration = .25;
    CGFloat elapsedTimeMod = 1 / actionDuration;
    SKAction *sizeAction = [SKAction customActionWithDuration:actionDuration actionBlock:^(SKNode *node, CGFloat elapsedTime) {
        
        _decisionNode.fontSize = 1+(elapsedTimeMod * elapsedTime * (finalFontSize-1));
        
    }];
    
    SKAction *moveXAction = [SKAction moveToX:150 duration:.25];
    SKAction *moveYAction = [SKAction moveByX:0 y:-75 duration:.25];
    
    SKAction *actionGroup = [SKAction group:@[sizeAction, moveXAction, moveYAction]];
    
    [_decisionNode runAction:actionGroup completion:^{
        [self spawnTryAgain];
    }];
    
    
}

-(void)spawnOptions
{
    CGPoint boxPos = CGPointMake(150, 250);
    CGFloat moveX = 75;
    CGFloat moveY = -50;
    CGFloat actionSpeed = .5;
//    _safeBox = [SKSpriteNode spriteNodeWithColor:[SKColor redColor] size:CGSizeZero];
    _safeBox = [SKSpriteNode spriteNodeWithImageNamed:@"safe.png"];
    _safeBox.size = CGSizeZero;
    _safeBox.position = boxPos;
    
    _playfulBox = [SKSpriteNode spriteNodeWithColor:[SKColor greenColor] size:CGSizeZero];
    _playfulBox.position = boxPos;
    
    _dangerousBox = [SKSpriteNode spriteNodeWithColor:[SKColor orangeColor] size:CGSizeZero];
    _dangerousBox.position = boxPos;
    
    [self addChild:_safeBox];
    [self addChild:_playfulBox];
    [self addChild:_dangerousBox];
    
    SKAction *moveSafeAction = [SKAction moveByX:-moveX y:moveY duration:actionSpeed];
    SKAction *movePlayfulAction = [SKAction moveByX:0 y:moveY duration:actionSpeed];
    SKAction *moveDangerousAction = [SKAction moveByX:moveX y:moveY duration:actionSpeed];
    
    SKAction *resizeAction = [SKAction resizeToWidth:50 height:50 duration:actionSpeed];
    
    SKAction *wiggleAction = [SKAction rotateByAngle:M_PI/32 duration:actionSpeed/2];
    SKAction *wiggleSeq = [SKAction repeatActionForever:[SKAction sequence:@[[wiggleAction reversedAction], [wiggleAction reversedAction], wiggleAction, wiggleAction]]];
    
    
    SKAction *safeGroupAction = [SKAction group:@[moveSafeAction, resizeAction, wiggleAction]];
    SKAction *playfulGroupAction = [SKAction group:@[movePlayfulAction, resizeAction, wiggleAction]];
    SKAction *dangerousGroupAction = [SKAction group:@[moveDangerousAction, resizeAction, wiggleAction]];
    
    [_safeBox runAction:[SKAction sequence:@[safeGroupAction, [SKAction runBlock:^{
        _safeBox.name = @"optionBox";
    }], wiggleSeq]]];
    [_playfulBox runAction:[SKAction sequence:@[playfulGroupAction, [SKAction runBlock:^{
        _playfulBox.name = @"optionBox";
    }], wiggleSeq]]];
    [_dangerousBox runAction:[SKAction sequence:@[dangerousGroupAction, [SKAction runBlock:^{
        _dangerousBox.name = @"optionBox";
    }], wiggleSeq]]];
    
    
}

-(void)spawnTryAgain
{
    _tryAgain = [SKSpriteNode spriteNodeWithImageNamed:@"newAgain.png"];
    _tryAgain.position = CGPointMake(150, 325);
    _tryAgain.name = @"tryAgain";
    [self addChild:_tryAgain];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    /* Called when a touch begins */
    
    UITouch *touch = [touches anyObject];
    CGPoint touchLocation = [touch locationInNode:self];
    
    SKSpriteNode *touchedNode = (SKSpriteNode*)[self nodeAtPoint:touchLocation];
    
    if ([touchedNode.name isEqualToString:@"start"]) {
        // draw new boxes to explode
        [self explodeStart];
        // spawn new boxes
        [self spawnOptions];
    }
    
    if ([touchedNode.name isEqualToString:@"tryAgain"]) {
        [self explodeTryAgain];
        [self resetOptionBoxes];
    }
    
    if ([touchedNode.name isEqualToString:@"optionBox"]) {
        
        [_safeBox removeAllActions];
        [_playfulBox removeAllActions];
        [_dangerousBox removeAllActions];
        
        _safeBox.name = SAFE_NODE_NAME;
        _playfulBox.name = PLAYFUL_NODE_NAME;
        _dangerousBox.name = DANGEROUS_NODE_NAME;
        
        [self animateOptionBoxesToOriginalPosition];
        [self optionBoxSelected:touchedNode];
    }
}

-(void)update:(CFTimeInterval)currentTime {
    /* Called before each frame is rendered */
}

@end
