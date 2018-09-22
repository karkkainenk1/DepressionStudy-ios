//
//  Gyroscope.h
//  AWARE
//
//  Created by Yuuki Nishiyama on 11/20/15.
//  Copyright © 2015 Yuuki NISHIYAMA. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreMotion/CoreMotion.h>
#import "../../Core/AWARESensor.h"
#import "../../Core/AWAREKeys.h"

extern NSString* const AWARE_PREFERENCES_STATUS_GYROSCOPE;
extern NSString* const AWARE_PREFERENCES_FREQUENCY_GYROSCOPE;
extern NSString* const AWARE_PREFERENCES_FREQUENCY_HZ_GYROSCOPE;

@interface Gyroscope : AWARESensor <AWARESensorDelegate>

- (BOOL) startSensor;
- (BOOL) startSensorWithInterval:(double)interval;
- (BOOL) startSensorWithInterval:(double)interval bufferSize:(int)buffer;
- (BOOL) startSensorWithInterval:(double)interval bufferSize:(int)buffer fetchLimit:(int)fetchLimit;

@end
