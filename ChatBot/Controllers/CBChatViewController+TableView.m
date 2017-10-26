//
//  CBChatViewController+TableView.m
//  ChatBot
//
//  Created by Александр on 26.10.2017.
//  Copyright © 2017 Александр Баранов. All rights reserved.
//

#import "CBChatViewController+TableView.h"
#import "CBLocationViewController.h"
#import "CBMessage.h"
#import <CoreData/NSFetchedResultsController.h>
#import "CBTableViewCell.h"

@implementation CBChatViewController (TableView)

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSManagedObject *message = [self.fetchedResultsController objectAtIndexPath:indexPath];
    CBMessage *messageResource = [CBMessage makeFromEntity:message];

    CGFloat detailTextheight = [self heightForText:messageResource.text
                                             width:self.tableView.frame.size.width
                                           andFont:[UIFont systemFontOfSize:16] ];
    
    return detailTextheight + 50;
}

- (CGFloat)heightForText:(NSString *)text width:(CGFloat)width andFont:(UIFont *)font {
    if(!text)
    {
        return 0;
    }
    
    CGRect frame = [text boundingRectWithSize:CGSizeMake(width, CGFLOAT_MAX)
                                      options:NSStringDrawingUsesLineFragmentOrigin
                                   attributes:@{NSFontAttributeName:font}
                                      context:nil];
    return frame.size.height + 10;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSManagedObject *message = [self.fetchedResultsController objectAtIndexPath:indexPath];
    CBMessage *messageResource = [CBMessage makeFromEntity:message];
    
    [self performSegueWithIdentifier:[CBLocationViewController description] sender:messageResource];
}

#pragma mark - UITableViewDataSource

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    CBTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    
    NSManagedObject *message = [self.fetchedResultsController objectAtIndexPath:indexPath];
    [cell configureForMessage:message];
    
    return cell;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[self.fetchedResultsController sections] objectAtIndex:section].numberOfObjects;
}

@end
