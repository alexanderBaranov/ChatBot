//
//  CBMessage.h
//  ChatBot
//
//  Created by Александр on 26.10.2017.
//  Copyright © 2017 Александр Баранов. All rights reserved.
//

#import <UIKit/UIKit.h>

@class NSManagedObject;

NS_ASSUME_NONNULL_BEGIN

@interface CBMessage : NSObject

+ (CBMessage *)makeFromEntity:(NSManagedObject *)entity;

- (void)saveChanges;

@property (nonatomic, strong) NSDate *date;
@property (nonatomic, strong) NSNumber *latitudeLocation;
@property (nonatomic, strong) NSNumber *longitudeLocation;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *text;

@end

NS_ASSUME_NONNULL_END
