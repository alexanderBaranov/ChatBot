//
//  CBTableViewCell.m
//  ChatBot
//
//  Created by Александр on 24.10.2017.
//  Copyright © 2017 Александр Баранов. All rights reserved.
//

#import "CBTableViewCell.h"
#import <CoreData/NSManagedObject.h>
#import "CBLocationManager.h"
#import "CBMessage.h"

@interface CBTableViewCell()
{
    CBMessage *_messageResource;
}

@property (nonatomic, strong) CBLocationManager *locationManager;

@end

@implementation CBTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)configureForMessage:(NSManagedObject *)message;
{
    _messageResource = [CBMessage makeFromEntity:message];

    if([_messageResource.name isEqualToString:@"bot"])
    {
        self.avatar.image = [UIImage imageNamed:@"Bender"];
    }
    else
    {
        self.avatar.image = [UIImage imageNamed:@"radiation"];
    }

    self.message.text = _messageResource.text;
    
    NSNumber *latitudeLocation = _messageResource.latitudeLocation;
    if(latitudeLocation)
    {
        self.latitudeLocation.text = latitudeLocation.stringValue;
    }
    
    NSNumber *longitudeLocation = _messageResource.longitudeLocation;
    if(longitudeLocation)
    {
        self.longitudeLocation.text = longitudeLocation.stringValue;
    }

    self.locationManager.completionBlock = nil;
    if(!longitudeLocation || !longitudeLocation.integerValue)
    {
        [self.locationManager loadLocationForCompletionBlock:^(CLLocationCoordinate2D newLocation) {
            _messageResource.latitudeLocation = @(newLocation.latitude);
            _messageResource.longitudeLocation = @(newLocation.longitude);
            
            [_messageResource saveChanges];
        }];
    }
}

#pragma mark - lazy initialization

- (CBLocationManager *)locationManager
{
    if(!_locationManager)
    {
        _locationManager = [CBLocationManager new];
    }
    
    return _locationManager;
}

@end
