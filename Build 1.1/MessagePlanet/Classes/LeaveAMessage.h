//
//  LeaveAMessage.h
//  MessagePlanet
//
//  Created by James Pickup on 02/05/2013.
//  Copyright (c) 2013 James Pickup. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import <AVFoundation/AVFoundation.h>
#import <iAd/iAd.h>

@interface LeaveAMessage : UIViewController <CLLocationManagerDelegate, UITextViewDelegate, ADBannerViewDelegate> {
    //adds
    ADBannerView * myAdBanner;
}
@property (nonatomic, retain) IBOutlet ADBannerView * myAddBanner;

@property (weak, nonatomic) IBOutlet UITextField *txtMessageTitle;
@property (weak, nonatomic) IBOutlet UITextView *txtMessageContent;
- (IBAction)txtFieldHideKeyboard:(id)sender;
- (IBAction)btnPostMessage:(id)sender;

@property (strong, nonatomic) CLLocationManager *myLocationManager;
@property (nonatomic) NSString *myCurrentLattitude;
@property (nonatomic) NSString *myCurrentLongitude;
@property AVAudioPlayer *audioPlayer;
@end
