//
//  CBChatViewController.m
//  ChatBot
//
//  Created by Александр on 24.10.2017.
//  Copyright © 2017 Александр Баранов. All rights reserved.
//

#import "CBChatViewController.h"
#import "AppDelegate.h"
#import "CBMessage.h"
#import "CBLocationViewController.h"
#import "CBChatViewController+TableView.h"
#import "CBChatViewController+FetchedResults.h"

@interface CBChatViewController ()
{
    CGRect _defaultTextFieldFrame;
}

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *textFieldBottomConstraint;

@end

@implementation CBChatViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    _managedObjectContext = appDelegate.persistentContainer.viewContext;

    _sendMessage = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
    _sendMessage.backgroundColor = [UIColor redColor];
    [_sendMessage setImage:[UIImage imageNamed:@"right-arrow"] forState:UIControlStateNormal];
    [_sendMessage addTarget:self action:@selector(actionSendMessage) forControlEvents:UIControlEventTouchUpInside];

    _textField.rightViewMode = UITextFieldViewModeAlways;
    _textField.rightView = _sendMessage;
    
    [_textField becomeFirstResponder];

    _defaultTextFieldFrame = _textField.frame;
    
    NSError *error;
    if (![self.fetchedResultsController performFetch:&error]) {
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        exit(-1);  // Fail
    }

    self.title = @"Chat";
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShowNotification:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHideNotification:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];

    [self scrollToLastIndexInTableView];
}

- (void)scrollToLastIndexInTableView
{
    NSInteger numberOfRows = [_tableView numberOfRowsInSection:0];
    if(numberOfRows)
    {
        NSIndexPath *scrollIndexPath = [NSIndexPath indexPathForRow:(numberOfRows - 1) inSection:0];
        [_tableView scrollToRowAtIndexPath:scrollIndexPath atScrollPosition:UITableViewScrollPositionBottom animated:NO];
    }
}

- (void)loadMessages
{
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"Messages"];
    
    NSError *error;
    _messages = [_managedObjectContext executeFetchRequest:fetchRequest error:&error];
    
    if(error)
    {
        NSLog(@"Error fetch request: %@", error);
    }
}

#pragma mark - Actions

- (void)keyboardWillShowNotification:(NSNotification *)notification
{
    NSDictionary *keyboardInfo = notification.userInfo;
    CGRect keyboardFrame = [keyboardInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    
    [self setupTextFieldHeight:keyboardFrame.size.height];
}

- (void)keyboardWillHideNotification:(NSNotification *)notification
{
    [self setupTextFieldHeight:0];
}

- (void)setupTextFieldHeight:(CGFloat)height
{
    _textFieldBottomConstraint.constant = -height;
}

- (IBAction)actionClearChatHistory:(id)sender
{
    for (NSManagedObject *obj in _fetchedResultsController.fetchedObjects)
    {
        [_managedObjectContext deleteObject:obj];
    }
    
    [self saveContext];
}

- (void)actionSendMessage
{
    if(!_textField.text.length)
    {
        return;
    }

    [_textField resignFirstResponder];
    
    NSString *inputText = _textField.text;
    _textField.text = @"";

    [self saveTextForUserName:@"user" text:inputText];
    
    __weak __typeof(self) weakSelf = self;
    dispatch_time_t hideTime = dispatch_time(DISPATCH_TIME_NOW, 0.5f * NSEC_PER_SEC);
    dispatch_after(hideTime, dispatch_get_main_queue(), ^(void){
        
        __typeof(self) strongSelf = weakSelf;
        if(!strongSelf)
        {
            return;
        }

        [strongSelf saveTextForUserName:@"bot" text:inputText];
    });
}

- (void)saveTextForUserName:(NSString *)userName text:(NSString *)text
{
    NSManagedObject *message = [NSEntityDescription insertNewObjectForEntityForName:@"Messages" inManagedObjectContext:_managedObjectContext];
    
    CBMessage *messageResource = [CBMessage makeFromEntity:message];
    
    messageResource.name = userName;
    messageResource.date = [NSDate new];
    messageResource.text = text;
    
    [self saveContext];
}

- (void)saveContext
{
    if([_managedObjectContext hasChanges])
    {
        NSError *error;
        [_managedObjectContext save:&error];
        
        if(error)
        {
            NSLog(@"Error save context: %@", error);
        }
    }
}

#pragma mark - lazy initializations

- (NSFetchedResultsController *)fetchedResultsController
{
    if (_fetchedResultsController != nil) {
        return _fetchedResultsController;
    }
    
    NSFetchRequest *fetchRequest = [NSFetchRequest new];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Messages" inManagedObjectContext:_managedObjectContext];
    [fetchRequest setEntity:entity];
    
    NSSortDescriptor *sort = [[NSSortDescriptor alloc] initWithKey:@"date" ascending:YES];
    [fetchRequest setSortDescriptors:[NSArray arrayWithObject:sort]];

    NSFetchedResultsController *theFetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest
                                                                                                  managedObjectContext:_managedObjectContext sectionNameKeyPath:nil
                                                   cacheName:@"Root"];
    _fetchedResultsController = theFetchedResultsController;
    _fetchedResultsController.delegate = self;

    return _fetchedResultsController;
}

#pragma mark - Storyboard Delegate

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:[CBLocationViewController description]])
    {
        CBMessage *messageResource = sender;
        CBLocationViewController *locationViewController = segue.destinationViewController;
        locationViewController.newLocation = CLLocationCoordinate2DMake(messageResource.latitudeLocation.doubleValue, messageResource.longitudeLocation.doubleValue);
    }
}

@end
