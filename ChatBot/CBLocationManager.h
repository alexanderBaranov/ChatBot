//
//  CBLocationManager.h
//  ChatBot
//
//  Created by Александр on 26.10.2017.
//  Copyright © 2017 Александр Баранов. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

typedef void(^CompletionBlock)(CLLocationCoordinate2D newLocation);

@interface CBLocationManager: NSObject

@property (nonatomic) CompletionBlock completionBlock;

- (void)loadLocation;
- (void)loadLocationForCompletionBlock:(CompletionBlock)completionBlock;

@end
