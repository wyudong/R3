//
//  ViewController.m
//  R3
//
//  Created by wyudong on 15/9/18.
//  Copyright © 2015年 wyudong. All rights reserved.
//

#import "ViewController.h"
@import SceneKit;
@import CoreMotion;

@interface ViewController ()

@property (nonatomic, strong) UITapGestureRecognizer *tapGesture;
@property (nonatomic, strong) CMMotionManager *motionManager;
@property (nonatomic, strong) SCNView *sceneView;
@property (nonatomic, strong) SCNNode *cameraNode;
@property (nonatomic, strong) SCNNode *currentDrawingNode;
@property (nonatomic, strong) CAShapeLayer *currentDrawingLayer;

@end

@implementation ViewController

static CGFloat initialAttitudeRoll;
static CGFloat initialAttitudePitch;
const CGFloat kCameraDistance = 2.0;
const CGFloat kCurrentDrawingLayerSize = 512.0;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Double tap
    self.tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clear)];
    self.tapGesture.numberOfTapsRequired = 2;
    [self.view addGestureRecognizer:self.tapGesture];
    
    // Scene initialization
    self.sceneView = [[SCNView alloc] initWithFrame:self.view.frame];
    //SceneKitView.backgroundColor = [UIColor blackColor];
    self.sceneView.scene = [SCNScene scene];
    [self.view addSubview:self.sceneView];
    
    SCNNode *centerNode = [SCNNode node];
    centerNode.position = SCNVector3Zero;
    [self.sceneView.scene.rootNode addChildNode:centerNode];
    
    // Camera
    SCNCamera *camera = [SCNCamera camera];
    camera.xFov = 20.0;
    camera.yFov = 20.0;
    
    self.cameraNode = [SCNNode node];
    self.cameraNode.camera = camera;
    [self.sceneView.scene.rootNode addChildNode:self.cameraNode];
    
    self.cameraNode.constraints = @[[SCNLookAtConstraint lookAtConstraintWithTarget:centerNode]];
    self.cameraNode.pivot = SCNMatrix4MakeTranslation(0, 0, -kCameraDistance);
    
    // Motion manager
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    self.motionManager = [[CMMotionManager alloc] init];
    
    
    if (self.motionManager.deviceMotionAvailable) {
        self.motionManager.deviceMotionUpdateInterval = 1.0 / 30.0;
        [self.motionManager startDeviceMotionUpdatesToQueue:queue
                                                withHandler:^(CMDeviceMotion * _Nullable deviceMotion, NSError * _Nullable error) {
            // Motion process
            static dispatch_once_t once;
            dispatch_once(&once, ^{
                initialAttitudeRoll = deviceMotion.attitude.roll;
                initialAttitudePitch = deviceMotion.attitude.pitch;
            });
            
            CGFloat deltaRoll = initialAttitudeRoll - deviceMotion.attitude.roll;
            CGFloat deltaPitch = (initialAttitudePitch - deviceMotion.attitude.pitch);
                                                    
            [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                // Update UI
                self.cameraNode.eulerAngles = SCNVector3Make(deltaPitch, deltaRoll, 0);
                //NSLog(@"camera(x, y, z): (%.2f, %.2f, %.2f)", self.cameraNode.eulerAngles.x, self.cameraNode.eulerAngles.y, self.cameraNode.eulerAngles.z);
            }];
        }];
    }
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
    
    self.currentDrawingNode = [SCNNode nodeWithGeometry:[SCNBox boxWithWidth:1.0 height:1.0 length:0 chamferRadius:0]];
    self.currentDrawingLayer = [CAShapeLayer layer];
    
    SCNNode *currentDrawingNode = self.currentDrawingNode;
    CAShapeLayer *currentDrawingLayer = self.currentDrawingLayer;
    
    if (currentDrawingLayer && currentDrawingNode) {
        NSLog(@"began");
        currentDrawingNode.position = SCNVector3Zero;
        currentDrawingNode.eulerAngles = self.cameraNode.eulerAngles;
        [self.sceneView.scene.rootNode addChildNode:currentDrawingNode];
        
        currentDrawingLayer.strokeColor = [UIColor grayColor].CGColor;
        currentDrawingLayer.fillColor = nil;
        currentDrawingLayer.lineWidth = 5.0;
        currentDrawingLayer.lineJoin = kCALineJoinRound;
        currentDrawingLayer.lineCap = kCALineCapRound;
        currentDrawingLayer.frame = CGRectMake(0, 0, kCurrentDrawingLayerSize, kCurrentDrawingLayerSize);
        
        SCNMaterial *material = [SCNMaterial material];
        material.diffuse.contents = currentDrawingLayer;
        material.lightingModelName = SCNLightingModelConstant;
        
        currentDrawingNode.geometry.materials = @[material];
    }
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [super touchesMoved:touches withEvent:event];
    
    CGPoint locationInView = [[touches anyObject] locationInView:self.view];
    NSArray *hitTestResultArray = [self.sceneView hitTest:locationInView options:nil];
    CAShapeLayer *currentDrawingLayer = self.currentDrawingLayer;
    
    // Filter
    NSPredicate *drawingNode = [NSPredicate predicateWithBlock:^BOOL(id  _Nonnull evaluatedObject, NSDictionary<NSString *,id> * _Nullable bindings) {
        if ([evaluatedObject isKindOfClass:[SCNHitTestResult class]]) {
            SCNNode *node = ((SCNHitTestResult *)evaluatedObject).node;
            return (node == self.currentDrawingNode);
        } else {
            return nil;
        }
    }];
    SCNHitTestResult *hitTestResult = [hitTestResultArray filteredArrayUsingPredicate:drawingNode].firstObject;
    
    if (hitTestResult && currentDrawingLayer) {
        if (currentDrawingLayer.path == nil) {
            CGFloat newX = (hitTestResult.localCoordinates.x + 0.5) * kCurrentDrawingLayerSize;
            CGFloat newY = (hitTestResult.localCoordinates.y + 0.5) * kCurrentDrawingLayerSize;
            currentDrawingLayer.path = [UIBezierPath bezierPathWithRect:CGRectMake(newX, newY, 0, 0)].CGPath;
        }
        
        UIBezierPath *drawingPath = [UIBezierPath bezierPathWithCGPath:currentDrawingLayer.path];
        CGFloat newX = (hitTestResult.localCoordinates.x + 0.5) * kCurrentDrawingLayerSize;
        CGFloat newY = (hitTestResult.localCoordinates.y + 0.5) * kCurrentDrawingLayerSize;
        [drawingPath addLineToPoint:CGPointMake(newX, newY)];
        currentDrawingLayer.path = drawingPath.CGPath;
    }
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [super touchesEnded:touches withEvent:event];
    
    self.currentDrawingNode = nil;
    self.currentDrawingLayer = nil;
}

- (void)clear
{
    [self.sceneView.scene.rootNode enumerateChildNodesUsingBlock:^(SCNNode * _Nonnull child, BOOL * _Nonnull stop) {
        if (child.geometry != nil) {
            [child removeFromParentNode];
        }
    }];
}

@end
