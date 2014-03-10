//
//  MyScene.m
//  SpriteKitDemo2
//
//  Created by Marcus Smith on 3/9/14.
//  Copyright (c) 2014 Marcus Smith. All rights reserved.
//

#import "MyScene.h"

@interface MyScene () <SKPhysicsContactDelegate>
{
    SKSpriteNode *box;
}

@end

@implementation MyScene

//18. Category bit masks
static const uint32_t boxCategory = 0x1 << 0;
static const uint32_t edgeCategory = 0x1 << 1;
static const uint32_t ballCategory = 0x1 << 2;
static const uint32_t triangleCategory = 0x1 << 3;

-(id)initWithSize:(CGSize)size {    
    if (self = [super initWithSize:size]) {
        /* Setup your scene here */
        NSLog(@"Size: %@", NSStringFromCGSize(size));
        
        self.backgroundColor = [SKColor colorWithRed:0.15 green:0.15 blue:0.3 alpha:1.0];
        
        //1. Making a sprite node
        box = [SKSpriteNode spriteNodeWithColor:[UIColor brownColor] size:CGSizeMake(100.0, 100.0)];
        
        [self addChild:box];
        
        [box setPosition:CGPointMake(300.0, 500.0)];
        
        //2. Give it a physics body
        
        [box setPhysicsBody:[SKPhysicsBody bodyWithRectangleOfSize:box.size]];
        
        //3. Let's make that not happen....
        
        [self setPhysicsBody:[SKPhysicsBody bodyWithEdgeLoopFromRect:self.frame]];
        
        //4. Changing gravity
        
        [self.physicsWorld setGravity:CGVectorMake(0, 9.8)];
        
        //5. Again
        
        [self.physicsWorld setGravity:CGVectorMake(1, -9.8)];
        
        //6. Make it slippery
        
        [box.physicsBody setFriction:0];
        
        //7. Make it bouncy
        
        [box.physicsBody setRestitution:0.8];
        
        //8. Make it unrealistically bouncy
        
        [box.physicsBody setRestitution:1.1];
        
        //9. Make it unreasonably bouncy
        
        [box.physicsBody setRestitution:2.0];
        
        //10. Reset a little
        
        [box.physicsBody setRestitution:0.8];
        
        [self.physicsWorld setGravity:CGVectorMake(0.0, -7)];
        
        [box setPosition:CGPointMake(300.0, 700.0)];
        
        //11. Convenience Method
        
        [box setColor:[UIColor redColor]];
        [box setColorBlendFactor:1.0];
        
        [self makeABoxWithName:@"newBox" AtPoint:CGPointMake(600.0, 700.0)];
        
        //12. Finding a named node
        
        SKSpriteNode *newBox = (SKSpriteNode *)[self childNodeWithName:@"newBox"];
        
        //13. Damping
        
        [newBox.physicsBody setLinearDamping:0.9];
        
        //19. Give the world edge a category
        
        [self.physicsBody setCategoryBitMask:edgeCategory];
        
        //26. Contact
//        [self.physicsWorld setContactDelegate:self];
        
        self.physicsWorld.contactDelegate = self;
        
        //27. Make it stop crashing FUUUUUUUU
        
        [box.physicsBody setCategoryBitMask:boxCategory];

    }
    return self;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    //14. Touches
    
    UITouch *touch = [touches anyObject];
    
    CGPoint touchPoint = [touch locationInNode:self];
    
//    [self makeABoxWithName:@"box" AtPoint:touchPoint];
    
    //19. Make a ball
    
//    [self makeABallAtPoint:touchPoint];
    
    //23. Make a triangle
    
//    [self makeATriangleAtPoint:touchPoint];
    
    //25. Make a random thing
    
    NSUInteger r = arc4random_uniform(3);
    
    if (r == 0) {
        [self makeABoxWithName:@"box" AtPoint:touchPoint];
    }
    else if (r == 1) {
        [self makeABallAtPoint:touchPoint];
    }
    else if (r == 2){
        [self makeATriangleAtPoint:touchPoint];
    }
    
}

-(void)update:(CFTimeInterval)currentTime {
    /* Called before each frame is rendered */
}

-(void)makeABoxWithName:(NSString *)name AtPoint:(CGPoint)point
{
    SKSpriteNode *newBox = [SKSpriteNode spriteNodeWithColor:[UIColor brownColor] size:CGSizeMake(100.0, 100.0)];
    
    [newBox setName:name];
    
    [newBox setPhysicsBody:[SKPhysicsBody bodyWithRectangleOfSize:newBox.size]];
    
    [newBox.physicsBody setRestitution:0.8];
    
    [self addChild:newBox];
    
    [newBox setPosition:point];
    
//    //15. Turn off rotation
//    
//    [newBox.physicsBody setAllowsRotation:NO];
//    
//    //16. Affected by Gravity
//    
//    [newBox.physicsBody setAffectedByGravity:NO];
    
    //17. Density!!
    
    [newBox.physicsBody setDensity:200];
    
    //18. Category Bit masks
    
    [newBox.physicsBody setCategoryBitMask:boxCategory];
    
    [newBox.physicsBody setCollisionBitMask:boxCategory];
    
    //20. Lets try that again
    
    [newBox.physicsBody setCollisionBitMask:boxCategory | edgeCategory];

}

//19. Shape Nodes
-(void)makeABallAtPoint:(CGPoint)point
{
    SKShapeNode *newBall = [SKShapeNode node];
    
    [newBall setPath:[UIBezierPath bezierPathWithOvalInRect:CGRectMake(0.0, 0.0, 100.0, 100.0)].CGPath];
    
    [newBall setStrokeColor:[UIColor clearColor]];
    
    [newBall setFillColor:[UIColor blueColor]];
    
    [self addChild:newBall];
    
    [newBall setPosition:point];
    
    [newBall setPhysicsBody:[SKPhysicsBody bodyWithCircleOfRadius:50.0]];
    
    //20. Let's fix that
    [newBall setPath:[UIBezierPath bezierPathWithOvalInRect:CGRectMake(-50.0, -50.0, 100.0, 100.0)].CGPath];
    
    //21. And make it bouncier!
    [newBall.physicsBody setRestitution:0.9];
    
    //22. Category
    [newBall.physicsBody setCategoryBitMask:ballCategory];
    
    [newBall.physicsBody setCollisionBitMask:boxCategory | edgeCategory];
    
    //26. Contact
    [newBall.physicsBody setContactTestBitMask:triangleCategory];
}

//23. Other shapes
-(void)makeATriangleAtPoint:(CGPoint)point
{
    SKShapeNode *newTriangle = [SKShapeNode node];
    
    //Make a CGPath for a triangle
    CGMutablePathRef trianglePath = CGPathCreateMutable();
    CGPathMoveToPoint(trianglePath, nil, -20, -20);
    CGPathAddLineToPoint(trianglePath, nil, 20, -20);
    CGPathAddLineToPoint(trianglePath, nil, 0, 20);
    CGPathAddLineToPoint(trianglePath, nil, -20, -20);
    
    //Set shape and physics body for triangle using this path
    [newTriangle setPath:trianglePath];
    
    [newTriangle setPhysicsBody:[SKPhysicsBody bodyWithPolygonFromPath:trianglePath]];
    
    //Finish setting up node
    [newTriangle setFillColor:[UIColor yellowColor]];
    
    [newTriangle setStrokeColor:[UIColor greenColor]];
    
    [self addChild:newTriangle];
    
    [newTriangle setPosition:point];
    
    //24. Category
    
    [newTriangle.physicsBody setCategoryBitMask:triangleCategory];
    
    [newTriangle.physicsBody setCollisionBitMask:boxCategory | edgeCategory | triangleCategory];
    
    //26. Contact
    
    [newTriangle.physicsBody setContactTestBitMask:ballCategory];
}

//26. Contact
#pragma mark - SKPhysicsContactDelegate

-(void)didBeginContact:(SKPhysicsContact *)contact
{
    SKShapeNode *oneNode = (SKShapeNode *)contact.bodyA.node;
    SKShapeNode *theOtherNode = (SKShapeNode *)contact.bodyB.node;
    
    [oneNode setFillColor:[UIColor orangeColor]];
    [theOtherNode setStrokeColor:[UIColor whiteColor]];
}

-(void)didEndContact:(SKPhysicsContact *)contact
{
    
}

@end


