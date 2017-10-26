//
//  CBChatViewController.h
//  ChatBot
//
//  Created by Александр on 24.10.2017.
//  Copyright © 2017 Александр Баранов. All rights reserved.
//

#import <UIKit/UIKit.h>

@class NSManagedObject;
@class CBLocationManager;
@class NSFetchedResultsController;

@interface CBChatViewController : UIViewController
{
    UIButton *_sendMessage;
    NSArray<NSManagedObject *> *_messages;
    NSManagedObjectContext *_managedObjectContext;
    CBLocationManager *_locManager;
}

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UITextField *textField;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *clearBarButton;

@property (nonatomic, strong) NSFetchedResultsController *fetchedResultsController;

- (void)scrollToLastIndexInTableView;

@end
