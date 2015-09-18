//
//  ViewController.m
//  R3
//
//  Created by wyudong on 15/9/18.
//  Copyright © 2015年 wyudong. All rights reserved.
//

#import "ViewController.h"
@import CoreMotion;

@interface ViewController ()

@property (nonatomic, strong) CMMotionManager *motionManager;

@end

@implementation ViewController

static double initialAttitudeRoll;
static double initialAttitudePitch;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
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
