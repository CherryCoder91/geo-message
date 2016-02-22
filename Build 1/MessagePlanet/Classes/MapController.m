//
//  MapController.m
//  MessagePlanet
//
//  Created by James Pickup on 02/05/2013.
//  Copyright (c) 2013 James Pickup. All rights reserved.
//

#import "MapController.h"
#import "MessageDetail.h"

@interface MapController ()

@end

@implementation MapController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}


#pragma mark - LOAD/APPEAR Methods

- (void)viewDidLoad {
    [super viewDidLoad];
    //Check to see if user has plist document (first run), if not create, then load into array.
    [self CreateUsersPlistCopyFromMainBundleVersion];
    //centre map on user.
    [_MessageMap setCenterCoordinate:_MessageMap.userLocation.coordinate animated:YES];
    //set map delegat to VC so will call delegate methods for annotation icon etc.
    self.MessageMap.delegate = self;
}

-(void)viewDidAppear:(BOOL)animated {
    //Centre map on users location.
    [_MessageMap setCenterCoordinate:_MessageMap.userLocation.coordinate animated:YES];
    //UpdateArrayWithPlistValues
    [self updateArrayfromUpdatedPlist];
    //add annotations.
    [self addAnnotationsWithContentsOfPlist];
    }





#pragma mark - Annotation Methods


-(void)addAnnotationAtLattitude:(double)lattitude withLongitude:(double)longitude withTitle:(NSString *)title withSubtitle:(NSString *)subtitle{
    //Handles the adding off an anotation with given arguments.
    CLLocationCoordinate2D annotationCoord;
    annotationCoord.latitude = lattitude;
    annotationCoord.longitude = longitude;

    MKPointAnnotation *annotationPoint = [[MKPointAnnotation alloc] init];
    annotationPoint.coordinate = annotationCoord;
    annotationPoint.title = title;
    annotationPoint.subtitle = subtitle;
    [self.MessageMap addAnnotation:annotationPoint];
}

-(void)addAnnotationsWithContentsOfPlist{
    //calls add annotation for every dictionary in array. 
    for (int loopCounter = 0; loopCounter < self.messagesArray.count; loopCounter++) {
        //for each element in array output annotation
        self.messagesDictionary = [self.messagesArray objectAtIndex:loopCounter];
        NSString *stringTitle = [self.messagesDictionary objectForKey:@"Title"];
        NSString *stringSubtitle = [self.messagesDictionary objectForKey:@"Subtitle"];
        double dLattitude = [[self.messagesDictionary objectForKey:@"Lattitude"] doubleValue];
        double dLongitude = [[self.messagesDictionary objectForKey:@"Longitude"] doubleValue];
        [self addAnnotationAtLattitude:dLattitude withLongitude:dLongitude withTitle:stringTitle withSubtitle:stringSubtitle];
    }
}

- (MKAnnotationView *)mapView:(MKMapView *)_mapView viewForAnnotation:(id <MKAnnotation>)annotation {
    //Custom map view annotation delegate method
    NSString *AnnotationViewID = @"annotationViewID";
    MKAnnotationView *annotationView = (MKAnnotationView *)[_mapView dequeueReusableAnnotationViewWithIdentifier:AnnotationViewID];
    
    if (annotationView == nil) {
        annotationView = [[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:AnnotationViewID];
    }
    
    //if not users location then do:
    if (![annotationView.annotation isKindOfClass:[MKUserLocation class]]) {
        annotationView.image = [UIImage imageNamed:@"CustomPin.png"];//add any image which you want to show on map instead of red pins
        annotationView.annotation = annotation;
        annotationView.enabled = YES;
        annotationView.canShowCallout = YES;
        UIButton *disclosureButton = [UIButton buttonWithType: UIButtonTypeDetailDisclosure];
        annotationView.rightCalloutAccessoryView = disclosureButton;
        return annotationView;
    } else {
        return NULL;
    }
}





#pragma mark - MapStyle Handling

- (IBAction)ChangeMap:(id)sender {
    //handles map style with segmented controll
    switch (((UISegmentedControl *)sender).selectedSegmentIndex) {  //method is called when segmented control value is changed
        case 0:
            self.MessageMap.mapType = MKMapTypeStandard;
            break;
        case 1:
            self.MessageMap.mapType = MKMapTypeSatellite;
            break;
        case 2:
            self.MessageMap.mapType = MKMapTypeHybrid;
            break;
    }
}

- (IBAction)locateMe:(id)sender {
    //Centers map with users location.
    MKCoordinateRegion mapRegion;     
    mapRegion.center.latitude=_MessageMap.userLocation.coordinate.latitude;                
    mapRegion.center.longitude=_MessageMap.userLocation.coordinate.longitude;    
    mapRegion.span.latitudeDelta=0.005;
    mapRegion.span.longitudeDelta=0.005;
    [self.MessageMap setRegion:mapRegion animated:YES];      
}




#pragma mark - Plist Directory handling

-(void)CreateUsersPlistCopyFromMainBundleVersion{
    NSString *destPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    destPath = [destPath stringByAppendingPathComponent:@"usersMessages.plist"];
    
    // If the file doesn't exist in the Documents Folder, copy it.
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    if (![fileManager fileExistsAtPath:destPath]) {
        NSString *sourcePath = [[NSBundle mainBundle] pathForResource:@"Messages" ofType:@"plist"];
        [fileManager copyItemAtPath:sourcePath toPath:destPath error:nil];
    }
}




#pragma mark - Update methods
-(void)updateArrayfromUpdatedPlist{
    NSString *destPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    destPath = [destPath stringByAppendingPathComponent:@"usersMessages.plist"];
    self.messagesArray = [[NSArray alloc] initWithContentsOfFile:destPath];
}


#pragma mark - Annotation Disclosure btn handling
- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control {
    self.currentTitle = view.annotation.title;
    self.currentSubtitle = view.annotation.subtitle;
    [self performSegueWithIdentifier: @"MessageDetailSegue" sender: self];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    //(passing of data to new viewcontroller)
    MessageDetail *messageDetail = (MessageDetail *) segue.destinationViewController;  //sets view controller
    messageDetail.messageTitle = self.currentTitle;
    messageDetail.messageSubtitle = self.currentSubtitle;
}

@end
