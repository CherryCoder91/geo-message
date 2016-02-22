//
//  MessageDetail.h
//  MessagePlanet
//
//  Created by James Pickup on 04/05/2013.
//  Copyright (c) 2013 James Pickup. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <iAd/iAd.h>


@interface MessageDetail : UIViewController <ADBannerViewDelegate> {
//adds
ADBannerView * myAdBanner;
}
@property (nonatomic, retain) IBOutlet ADBannerView * myAddBanner;

@property (weak, nonatomic) IBOutlet UILabel *lblTitle;
@property (weak, nonatomic) IBOutlet UITextView *txtviewSubtitle;
- (IBAction)btnCloseMessage:(id)sender;
@property (strong, nonatomic) NSString *messageTitle;
@property (strong, nonatomic) NSString *messageSubtitle;
@end
