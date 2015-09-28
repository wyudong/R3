//
//  UIColor+R3UIColor.m
//  R3
//
//  Created by wyudong on 15/9/24.
//  Copyright © 2015年 wyudong. All rights reserved.
//

#import "UIColor+R3UIColor.h"

@implementation UIColor (R3UIColor)


+ (UIColor *)darkNightColor
{
    static UIColor *darkNightColor = nil;
    static dispatch_once_t once;
    
    dispatch_once(&once, ^{
        darkNightColor = [UIColor colorWithRed:13/255.0 green:13/255.0 blue:15/255.0 alpha:1.0];
    });
    
    return darkNightColor;
}

+ (UIColor *)redLipsColor
{
    static UIColor *redLipsColor = nil;
    static dispatch_once_t once;
    
    dispatch_once(&once, ^{
        redLipsColor = [UIColor colorWithRed:255/255.0 green:97/255.0 blue:69/255.0 alpha:1.0];
    });
    
    return redLipsColor;
}

+ (UIColor *)orangePeelColor
{
    static UIColor *orangePeelColor = nil;
    static dispatch_once_t once;
    
    dispatch_once(&once, ^{
        orangePeelColor = [UIColor colorWithRed:243/255.0 green:151/255.0 blue:49/255.0 alpha:1.0];
    });
    
    return orangePeelColor;
}

+ (UIColor *)twinkleStarColor
{
    static UIColor *twinkleStarColor = nil;
    static dispatch_once_t once;
    
    dispatch_once(&once, ^{
        twinkleStarColor = [UIColor colorWithRed:244/255.0 green:241/255.0 blue:91/255.0 alpha:1.0];
    });
    
    return twinkleStarColor;
}

+ (UIColor *)greenLeafColor
{
    static UIColor *greenLeafColor = nil;
    static dispatch_once_t once;
    
    dispatch_once(&once, ^{
        greenLeafColor = [UIColor colorWithRed:92/255.0 green:218/255.0 blue:137/255.0 alpha:1.0];
    });
    
    return greenLeafColor;
}

+ (UIColor *)greenPearColor
{
    static UIColor *greenPearColor = nil;
    static dispatch_once_t once;
    
    dispatch_once(&once, ^{
        greenPearColor = [UIColor colorWithRed:203/255.0 green:225/255.0 blue:43/255.0 alpha:1.0];
    });
    
    return greenPearColor;
}

+ (UIColor *)blueSeaColor
{
    static UIColor *blueSeaColor = nil;
    static dispatch_once_t once;
    
    dispatch_once(&once, ^{
        blueSeaColor = [UIColor colorWithRed:95/255.0 green:202/255.0 blue:252/255.0 alpha:1.0];
    });
    
    return blueSeaColor;
}

+ (UIColor *)deepSeaColor
{
    static UIColor *deepSeaColor = nil;
    static dispatch_once_t once;
    
    dispatch_once(&once, ^{
        deepSeaColor = [UIColor colorWithRed:71/255.0 green:137/255.0 blue:235/255.0 alpha:1.0];
    });
    
    return deepSeaColor;
}

+ (UIColor *)purpleSkyColor
{
    static UIColor *purpleSkyColor = nil;
    static dispatch_once_t once;
    
    dispatch_once(&once, ^{
        purpleSkyColor = [UIColor colorWithRed:187/255.0 green:161/255.0 blue:206/255.0 alpha:1.0];
    });
    
    return purpleSkyColor;
}

+ (UIColor *)iceColor
{
    static UIColor *iceColor = nil;
    static dispatch_once_t once;
    
    dispatch_once(&once, ^{
        iceColor = [UIColor colorWithRed:227/255.0 green:246/255.0 blue:245/255.0 alpha:1.0];
    });
    
    return iceColor;
}

+ (UIColor *)randomColor
{
    UIColor *randomColor = [UIColor whiteColor];
    unsigned int colorIndex = arc4random_uniform(9);
    
    if (colorIndex == 0) {
        randomColor = [UIColor redLipsColor];
    } else if (colorIndex == 1) {
        randomColor = [UIColor orangePeelColor];
    } else if (colorIndex == 2) {
        randomColor = [UIColor twinkleStarColor];
    } else if (colorIndex == 3) {
        randomColor = [UIColor greenLeafColor];
    } else if (colorIndex == 4) {
        randomColor = [UIColor greenPearColor];
    } else if (colorIndex == 5) {
        randomColor = [UIColor blueSeaColor];
    } else if (colorIndex == 6) {
        randomColor = [UIColor deepSeaColor];
    } else if (colorIndex == 7) {
        randomColor = [UIColor purpleSkyColor];
    } else if (colorIndex == 8) {
        randomColor = [UIColor iceColor];
    }
    
    return randomColor;
}

@end
