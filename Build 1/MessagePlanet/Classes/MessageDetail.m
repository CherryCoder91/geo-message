//
//  MessageDetail.m
//  MessagePlanet
//
//  Created by James Pickup on 04/05/2013.
//  Copyright (c) 2013 James Pickup. All rights reserved.
//

#import "MessageDetail.h"

@interface MessageDetail ()

@end

@implementation MessageDetail
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
	self.lblTitle.text = self.messageTitle;
    self.txtviewSubtitle.text = self.messageSubtitle;
    
    //iAD
    myAddBanner.delegate = self;
    [myAddBanner setHidden:YES];
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)btnCloseMessage:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}


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
