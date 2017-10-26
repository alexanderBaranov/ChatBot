//
//  CBLocationViewController.m
//  ChatBot
//
//  Created by Александр on 26.10.2017.
//  Copyright © 2017 Александр Баранов. All rights reserved.
//

#import "CBLocationViewController.h"
#import "CBLocationManager.h"

@interface CBLocationViewController ()
{
    CBLocationManager *_locManager;
}

@property (weak, nonatomic) IBOutlet MKMapView *mapView;

@end

@implementation CBLocationViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    MKPointAnnotation *annotation = [MKPointAnnotation new];
    annotation.coordinate = _newLocation;
    [_mapView addAnnotation:annotation];

    MKCoordinateSpan span = MKCoordinateSpanMake(0.1f, 0.1f);
    MKCoordinateRegion region;
    region.span=span;
    region.center=_newLocation;
    [self.mapView setRegion:region animated:NO];

    self.title = @"Location";
}

@end
