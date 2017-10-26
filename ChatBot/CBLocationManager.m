//
//  CBLocationManager.m
//  ChatBot
//
//  Created by Александр on 26.10.2017.
//  Copyright © 2017 Александр Баранов. All rights reserved.
//

#import "CBLocationManager.h"

@interface CBLocationManager() < CLLocationManagerDelegate >
{
    CLLocationManager *_locationManager;
}

@end

@implementation CBLocationManager

- (void)loadLocationForCompletionBlock:(CompletionBlock)completionBlock
{
    _completionBlock = completionBlock;
    
    [self loadLocation];
}

- (void)loadLocation
{
    _locationManager = [[CLLocationManager alloc] init];
    [_locationManager setDelegate:self];
    [_locationManager setDesiredAccuracy:kCLLocationAccuracyBest];
    
    if([CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorizedWhenInUse)
    {
        [_locationManager startUpdatingLocation];
    }
    else
    {
        [_locationManager requestWhenInUseAuthorization];
    }
}

#pragma mark - CLLocationManagerDelegate methods

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    CLLocationCoordinate2D loc = [newLocation coordinate];

    if(_completionBlock)
    {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            _completionBlock(loc);
        });

        [_locationManager stopUpdatingLocation];
    }
}

-(void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status
{
    switch (status) {
        case kCLAuthorizationStatusNotDetermined:
        case kCLAuthorizationStatusRestricted:
        case kCLAuthorizationStatusDenied:
            break;
        default:{
            [_locationManager startUpdatingLocation];
        }
            break;
    }
}

@end
