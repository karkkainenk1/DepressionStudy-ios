//
//  EntityLocationVisit+CoreDataProperties.h
//  AWARE
//
//  Created by Yuuki Nishiyama on 6/22/16.
//  Copyright © 2016 Yuuki NISHIYAMA. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "EntityLocationVisit.h"

NS_ASSUME_NONNULL_BEGIN

@interface EntityLocationVisit (CoreDataProperties)

@property (nullable, nonatomic, retain) NSNumber *accuracy;
@property (nullable, nonatomic, retain) NSString *device_id;
@property (nullable, nonatomic, retain) NSNumber *double_latitude;
@property (nullable, nonatomic, retain) NSNumber *double_longitude;
@property (nullable, nonatomic, retain) NSString *label;
@property (nullable, nonatomic, retain) NSString *provider;
@property (nullable, nonatomic, retain) NSNumber *timestamp;
@property (nullable, nonatomic, retain) NSString *name;
@property (nullable, nonatomic, retain) NSString *address;
@property (nullable, nonatomic, retain) NSNumber *double_departure;
@property (nullable, nonatomic, retain) NSNumber *double_arrival;

@end

NS_ASSUME_NONNULL_END
