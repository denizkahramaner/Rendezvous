//
//  RendezvousViewController.h
//  Rendezvous
//
//  Created by akonig on 4/29/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RendezvousAppDelegate.h"
#import "RendezvousCurrentUser.h"

@interface RendezvousHomeViewController : UIViewController <FBDialogDelegate,FBRequestDelegate,MWPhotoBrowserDelegate>
{
    NSArray *_photos;
    UIImageView *userPhoto;
}
@property (retain, nonatomic) NSTimer *timer;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *dayLabel;
@property (weak, nonatomic) IBOutlet UILabel *hourLabel;
@property (weak, nonatomic) IBOutlet UILabel *minuteLabel;
@property (weak, nonatomic) IBOutlet UILabel *secondLabel;
@property (weak, nonatomic) NSString *userName;
@property (retain, nonatomic) IBOutlet UIImageView *userPhoto;
@property (weak, nonatomic) IBOutlet UIButton *photoButton;
@property (nonatomic, retain) NSArray *photos;

@end
