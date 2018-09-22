//
//  AWARESensors.h
//  AWARE
//
//  Created by Yuuki Nishiyama on 10/10/16.
//  Copyright © 2016 Yuuki NISHIYAMA. All rights reserved.
//

#import <Foundation/Foundation.h>

/// Sensors
#import "../Sensors/Accelerometer/Accelerometer.h"
//#import "Accelerometer.h"
#import "../Sensors/AmbientLight/AmbientLight.h"
#import "../Sensors/Barometer/Barometer.h"
#import "../Sensors/Battery/Battery.h"
#import "../Sensors/Battery/BatteryCharge.h"
#import "../Sensors/Battery/BatteryDischarge.h"
#import "../Sensors/Bluetooth/Bluetooth.h"
#import "../Sensors/Calls/Calls.h"
#import "../Sensors/Gravity/Gravity.h"
#import "../Sensors/Debug/Debug.h"
#import "../Sensors/Gravity/Gravity.h"
#import "../Sensors/Gyroscope/Gyroscope.h"
#import "../Sensors/IBeacon/IBeacon.h"
#import "../Sensors/LinearAccelerometer/LinearAccelerometer.h"
#import "../Sensors/Location/Locations.h"
#import "../Sensors/Location/VisitLocations.h"
#import "../Sensors/Magnetometer/Magnetometer.h"
#import "../Sensors/Network/Network.h"
#import "../Sensors/Orientation/Orientation.h"
#import "../Sensors/Pedometer/Pedometer.h"
#import "../Sensors/Processor/Processor.h"
#import "../Sensors/Proximity/Proximity.h"
#import "../Sensors/Rotation/Rotation.h"
#import "../Sensors/Screen/Screen.h"
#import "../Sensors/Timezone/Timezone.h"
#import "../Sensors/Timezone/Timezone.h"
#import "../ESM/ESM.h"

/// Plugins
#import "../Plugins/ActivityRecognition/ActivityRecognition.h"
#import "../Plugins/AmbientNoise/AmbientNoise.h"
#import "../Plugins/BalacnedCampusScheduler/BalacnedCampusESMScheduler.h"
#import "../Plugins/BLEHeartRate/BLEHeartRate.h"
#import "../Plugins/DeviceUsage/DeviceUsage.h"
#import "../Plugins/FusedLocations/FusedLocations.h"
#import "../Plugins/GoogleCalPull/GoogleCalPull.h"
#import "../Plugins/GoogleCalPush/GoogleCalPush.h"
#import "../Plugins/HealthKit/AWAREHealthKit.h"
#import "../Plugins/Labels/Labels.h"
#import "../Plugins/Memory/Memory.h"
//#import "../Plugins/MSBand/MSBand.h"
//#import "../Plugins/MSBand/MSBandHR.h"
//#import "../Plugins/MSBand/MSBandUV.h"
//#import "../Plugins/MSBand/MSBandGSR.h"
//#import "../Plugins/MSBand/MSBandCalorie.h"
//#import "../Plugins/MSBand/MSBandDistance.h"
//#import "../Plugins/MSBand/MSBandSkinTemp.h"
//#import "../Plugins/MSBand/MSBandPedometer.h"
#import "../Plugins/NTPTime/NTPTime.h"
#import "../Plugins/Observer/Observer.h"
#import "../Plugins/OpenWeather/OpenWeather.h"
#import "../Plugins/PushNotification/PushNotification.h"
#import "../Plugins/SensorTag/SensorTag.h"
#import "../Plugins/ISOESM/IOSESM.h"
#import "../Plugins/Meal/Meal.h"
#import "../Plugins/IOSActivityRecognition/IOSActivityRecognition.h"
#import "../Plugins/Contacts/Contacts.h"
#import "../Plugins/Fitbit/Fitbit.h"

@interface AWARESensors : NSObject

@end
