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

@property (nonatomic, strong) CMMotionManager *motionManager;

@end

@implementation ViewController

static CGFloat initialAttitudeRoll;
static CGFloat initialAttitudePitch;
const CGFloat cameraDistance = 2.0;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Scene initialization
    SCNView *sceneView = [[SCNView alloc] initWithFrame:self.view.frame];
    //SceneKitView.backgroundColor = [UIColor blackColor];
    sceneView.scene = [SCNScene scene];
    [self.view addSubview:sceneView];
    
    SCNNode *centerNode = [SCNNode node];
    centerNode.position = SCNVector3Zero;
    [sceneView.scene.rootNode addChildNode:centerNode];
    
    // Camera
    SCNCamera *camera = [SCNCamera camera];
    camera.xFov = 20.0;
    camera.yFov = 20.0;
    
    SCNNode *cameraNode = [SCNNode node];
    cameraNode.camera = camera;
    [sceneView.scene.rootNode addChildNode:cameraNode];
    
    cameraNode.constraints = @[[SCNLookAtConstraint lookAtConstraintWithTarget:centerNode]];
    cameraNode.pivot = SCNMatrix4MakeTranslation(0, 0, -cameraDistance);
    
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
                                                    
            [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                // Update UI
            }];
        }];
    }
}

@end
