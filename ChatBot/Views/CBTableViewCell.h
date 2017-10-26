//
//  CBTableViewCell.h
//  ChatBot
//
//  Created by Александр on 24.10.2017.
//  Copyright © 2017 Александр Баранов. All rights reserved.
//

#import <UIKit/UIKit.h>

@class NSManagedObject;

@interface CBTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *avatar;
@property (weak, nonatomic) IBOutlet UILabel *message;
@property (weak, nonatomic) IBOutlet UILabel *latitudeLocation;
@property (weak, nonatomic) IBOutlet UILabel *longitudeLocation;

- (void)configureForMessage:(NSManagedObject *)message;

@end
