//
//  CBMessage.m
//  ChatBot
//
//  Created by Александр on 26.10.2017.
//  Copyright © 2017 Александр Баранов. All rights reserved.
//

#import "CBMessage.h"
#import <CoreData/NSManagedObject.h>
#import "AppDelegate.h"

static NSString * const kDate = @"date";
static NSString * const kLatitudeLocation = @"latitudeLocation";
static NSString * const kLongitudeLocation = @"longitudeLocation";
static NSString * const kName = @"name";
static NSString * const kText = @"text";

@implementation CBMessage
{
    NSManagedObject *_entity;
    NSManagedObjectContext *_managedObjectContext;
}

- (instancetype)initWithEntity:(nonnull NSManagedObject *)entity
{
    if(self = [super init])
    {
        _entity = entity;
    }
    
    return self;
}

- (void)setup
{
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    _managedObjectContext = appDelegate.persistentContainer.viewContext;
}

+ (CBMessage *)makeFromEntity:(nonnull NSManagedObject *)entity;
{
    CBMessage *message = [[CBMessage alloc] initWithEntity:entity];
    return message;
}

- (NSDate *)date
{
    return [_entity valueForKey:kDate];
}

- (void)setDate:(NSDate *)date
{
    [_entity setValue:date forKey:kDate];
}

- (NSNumber *)latitudeLocation
{
    NSNumber *latitudeLocation = [_entity valueForKey:kLatitudeLocation];
    return latitudeLocation;
}

- (void)setLatitudeLocation:(NSNumber *)latitudeLocation
{
    if([[_entity.entity propertiesByName] objectForKey:kLatitudeLocation] != nil)
    {
        [_entity setValue:latitudeLocation forKey:kLatitudeLocation];
    }
}

- (NSNumber *)longitudeLocation
{
    NSNumber *longitudeLocation = [_entity valueForKey:kLongitudeLocation];
    return longitudeLocation;
}

- (void)setLongitudeLocation:(NSNumber *)longitudeLocation
{
    if([[_entity.entity propertiesByName] objectForKey:kLongitudeLocation] != nil)
    {
        [_entity setValue:longitudeLocation forKey:kLongitudeLocation];
    }
}

- (NSString *)name
{
    return [_entity valueForKey:kName];
}

- (void)setName:(NSString *)name
{
    [_entity setValue:name forKey:kName];
}

- (NSString *)text
{
    return [_entity valueForKey:kText];
}

- (void)setText:(NSString *)text
{
    [_entity setValue:text forKey:kText];
}

- (void)saveChanges
{
    NSError *error;
    [_managedObjectContext save:&error];
    
    if(error)
    {
        NSLog(@"Error save context: %@", error);
    }
}

@end
