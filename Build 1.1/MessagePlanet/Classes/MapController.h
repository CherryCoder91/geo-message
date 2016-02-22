//
//  MapController.h
//  MessagePlanet
//
//  Created by James Pickup on 02/05/2013.
//  Copyright (c) 2013 James Pickup. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>

@interface MapController : UIViewController <MKMapViewDelegate>
//Interface builder variable/method decalrations
@property (weak, nonatomic) IBOutlet MKMapView *MessageMap;
- (IBAction)ChangeMap:(id)sender;
- (IBAction)locateMe:(id)sender;

//Variable Declarations
@property (strong, nonatomic) NSArray *messagesArray;
@property (strong, nonatomic) NSDictionary *messagesDictionary;
@property (strong, nonatomic) NSString *currentTitle;
@property (strong, nonatomic) NSString *currentSubtitle;

//Method declarations
-(void)addAnnotationAtLattitude:(double)lattitude withLongitude:(double)longitude withTitle:(NSString *)title withSubtitle:(NSString *)subtitle;
-(void)addAnnotationsWithContentsOfPlist;
-(void)CreateUsersPlistCopyFromMainBundleVersion;
-(void)updateArrayfromUpdatedPlist;

@end




