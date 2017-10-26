//
//  AppDelegate.h
//  ChatBot
//
//  Created by Александр on 24.10.2017.
//  Copyright © 2017 Александр Баранов. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong) NSPersistentContainer *persistentContainer;

- (void)saveContext;


@end

