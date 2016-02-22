//
//  LeaveAMessage.m
//  MessagePlanet
//
//  Created by James Pickup on 02/05/2013.
//  Copyright (c) 2013 James Pickup. All rights reserved.
//

#import "LeaveAMessage.h"
#import <AVFoundation/AVFoundation.h>

static const CGFloat KEYBOARD_ANIMATION_DURATION = 0.3;
static const CGFloat MINIMUM_SCROLL_FRACTION = 0.2;
static const CGFloat MAXIMUM_SCROLL_FRACTION = 0.8;
static const CGFloat PORTRAIT_KEYBOARD_HEIGHT = 216;
static const CGFloat LANDSCAPE_KEYBOARD_HEIGHT = 162;

@interface LeaveAMessage (){
    CGFloat animatedDistance; //for moving the textfield around keyboard
}
@end

@implementation LeaveAMessage
@synthesize myAddBanner;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	[self createLocationManager];
    self.txtMessageContent.delegate = self;
    
    //iAD
    myAddBanner.delegate = self;
    [myAddBanner setHidden:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Add Message to map
- (IBAction)btnPostMessage:(id)sender {
    //Save The Message, create alert and reset message fields!
    
    if ([self.txtMessageTitle.text length] >30) {
        UIAlertView *titleSizeAlert = [[UIAlertView alloc]initWithTitle:@"Title too Big" message:@"Please shorten your message title to less than 30 charachters." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        [titleSizeAlert show];
    } else {
    
        if ([_txtMessageTitle.text length] > 0 && [_txtMessageContent.text length] > 0) {
            NSMutableArray *messagesArray =[[NSMutableArray alloc]init];
            NSMutableDictionary *newMessageDictionary = [[NSMutableDictionary alloc] init];
            [newMessageDictionary setObject:_txtMessageTitle.text forKey:@"Title"];
            [newMessageDictionary setObject:_txtMessageContent.text forKey:@"Subtitle"];
            [newMessageDictionary setObject:self.myCurrentLongitude forKey:@"Longitude"];
            [newMessageDictionary setObject:self.myCurrentLattitude forKey:@"Lattitude"];
        
            //Load Plist into array
            NSString *messagesPath = [[NSBundle mainBundle] pathForResource:@"Messages" ofType:@"plist"];
            messagesArray = [NSMutableArray arrayWithContentsOfFile:messagesPath];
            [messagesArray addObject:newMessageDictionary];
        
            //write messages array to file
            NSString *plistPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
            plistPath = [plistPath stringByAppendingPathComponent:@"usersMessages.plist"];
            [messagesArray writeToFile:plistPath atomically:YES];
            
            self.txtMessageContent.text=@"***Your message has been added!***";
            
            //play sound
            [self playBellSound];
            
            //switch to map tab!
            self.tabBarController.selectedViewController
            = [self.tabBarController.viewControllers objectAtIndex:0];
            
        } else {
            UIAlertView *emptyTextAlert = [[UIAlertView alloc]initWithTitle:@"Enter a Message" message:@"Please enter your message to the world." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
            [emptyTextAlert show];
        }
    }
}


#pragma mark - Location Management/Keyboard hiding (background methods)

-(void)createLocationManager{
    self.myLocationManager = [[CLLocationManager alloc]init];
    self.myLocationManager.delegate = self;
    [self.myLocationManager setDesiredAccuracy:kCLLocationAccuracyBest];
    [self.myLocationManager startUpdatingLocation];
}

-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations{
    CLLocation *myCurrentLocation = [locations lastObject];
    float fLattitude = myCurrentLocation.coordinate.latitude;
    float fLongitude = myCurrentLocation.coordinate.longitude;
    self.myCurrentLattitude = [NSString stringWithFormat:@"%f", fLattitude];
    self.myCurrentLongitude = [NSString stringWithFormat:@"%f", fLongitude];
}

//Keyboard hiding
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    
    if([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    return YES;
}

- (IBAction)txtFieldHideKeyboard:(id)sender {
    [self.txtMessageTitle resignFirstResponder];
}

-(void)playBellSound{
    NSString *soundfile = [[NSBundle mainBundle]pathForResource:@"Bell" ofType:@"m4a"];
    _audioPlayer = [[AVAudioPlayer alloc]initWithContentsOfURL:[NSURL fileURLWithPath:soundfile] error:nil];
    //_audioPlayer.numberOfLoops=-1; //loops
    [_audioPlayer play];
}


#pragma mark - Moving text field because of keyboard obstruction

-(void) textViewDidBeginEditing:(UITextView *)textView{
    if ([textView.text isEqual: @"Your message goes here! Tell me about something you have found or maybe you just want to leave a note aout this location!"]){
        textView.text=@"";
    }
    
    CGRect textFieldRect =
    [self.view.window convertRect:textView.bounds fromView:textView];
    CGRect viewRect =
    [self.view.window convertRect:self.view.bounds fromView:self.view];
    
    CGFloat midline = textFieldRect.origin.y + 0.5 * textFieldRect.size.height;
    CGFloat numerator =
    midline - viewRect.origin.y
    - MINIMUM_SCROLL_FRACTION * viewRect.size.height;
    CGFloat denominator =
    (MAXIMUM_SCROLL_FRACTION - MINIMUM_SCROLL_FRACTION)
    * viewRect.size.height;
    CGFloat heightFraction = numerator / denominator;
    
    if (heightFraction < 0.0)
    {
        heightFraction = 0.0;
    }
    else if (heightFraction > 1.0)
    {
        heightFraction = 1.0;
    }
    
    UIInterfaceOrientation orientation =
    [[UIApplication sharedApplication] statusBarOrientation];
    if (orientation == UIInterfaceOrientationPortrait ||
        orientation == UIInterfaceOrientationPortraitUpsideDown)
    {
        animatedDistance = floor(PORTRAIT_KEYBOARD_HEIGHT * heightFraction);
    }
    else
    {
        animatedDistance = floor(LANDSCAPE_KEYBOARD_HEIGHT * heightFraction);
    }
    
    CGRect viewFrame = self.view.frame;
    viewFrame.origin.y -= animatedDistance;
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:KEYBOARD_ANIMATION_DURATION];
    
    [self.view setFrame:viewFrame];
    
    [UIView commitAnimations];
}

-(void)textViewDidEndEditing:(UITextView *)textView{

    CGRect viewFrame = self.view.frame;
    viewFrame.origin.y += animatedDistance;
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:KEYBOARD_ANIMATION_DURATION];
    
    [self.view setFrame:viewFrame];
    
    [UIView commitAnimations];
}

#pragma - iAD handling


//iAD handling

-(void)bannerViewDidLoadAd:(ADBannerView *)banner{
    [myAddBanner setHidden:NO];
    NSLog(@"add successfully loaded");
}

-(void)bannerView:(ADBannerView *)banner didFailToReceiveAdWithError:(NSError *)error{
    [myAddBanner setHidden:YES];
    NSLog(@"Hidden");
}

@end