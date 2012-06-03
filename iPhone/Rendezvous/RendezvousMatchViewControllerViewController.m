//
//  RendezvousMatchViewControllerViewController.m
//  Rendezvous
//
//  Created by akonig on 4/29/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "RendezvousMatchViewControllerViewController.h"
#import <QuartzCore/QuartzCore.h>

@interface RendezvousMatchViewControllerViewController ()

@end

@implementation RendezvousMatchViewControllerViewController
@synthesize nameLabel,matchName,matchPhoto, matchedUserId, responseData, timer;

@synthesize photoButton;
@synthesize photos = _photos;


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
    
    isInClock = true;
    isInInfo = true;
    UINavigationBar *NavBar = [[self navigationController] navigationBar];
    UIImage *back = [UIImage imageNamed:@"Bar.png"];
    [NavBar setBackgroundImage:back forBarMetrics:UIBarMetricsDefault];
    self.view.backgroundColor = [UIColor whiteColor];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(40, 40, 640, 640/11)];
    [label setFont:[UIFont fontWithName:@"Verdana-Bold" size:27.0]];
    label.textAlignment = UITextAlignmentCenter;
    label.backgroundColor = [UIColor clearColor];
    label.textColor = [UIColor colorWithRed:209.0/255.0 green:209.0/255.0 blue:209.0/255.0 alpha:1.0];
    label.shadowColor = [UIColor colorWithRed:26.0/255.0 green:26.0/255.0 blue:26.0/255.0 alpha:1.0];
    label.shadowOffset = CGSizeMake(0, 1.3);
    label.text = @"    MY MATCH";
    self.navigationItem.titleView = label;
    
    //    self.navigationItem.titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"MyList.png"]];
    //    UIBarButtonItem * item = [[UIBarItem alloc] initWithCustomView:[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"yourimage2.jpg"]]];    
    //    self.navigationItem.rightBarButtonItem = item; 
    //    
    UIImage *selectedImage0 = [UIImage imageNamed:@"list.png"];
    UIImage *unselectedImage0 = [UIImage imageNamed:@"list.png"];
    
    UIImage *selectedImage1 = [UIImage imageNamed:@"heart.png"];
    UIImage *unselectedImage1 = [UIImage imageNamed:@"heart.png"];
    
    UIImage *selectedImage2 = [UIImage imageNamed:@"messageIcon.png"];
    UIImage *unselectedImage2 = [UIImage imageNamed:@"messageIcon.png"];
    
    UITabBar *tabBar = self.tabBarController.tabBar;
    UITabBarItem *item0 = [tabBar.items objectAtIndex:0];
    UITabBarItem *item1 = [tabBar.items objectAtIndex:1];
    UITabBarItem *item2 = [tabBar.items objectAtIndex:2];
    
    [item0 setFinishedSelectedImage:selectedImage0 withFinishedUnselectedImage:unselectedImage0];
    [item1 setFinishedSelectedImage:selectedImage1 withFinishedUnselectedImage:unselectedImage1];
    [item2 setFinishedSelectedImage:selectedImage2 withFinishedUnselectedImage:unselectedImage2];
    [self.navigationController setNavigationBarHidden: YES animated:YES];
    
    [self loadUserPhotos];
    [super loadView];
    [super viewDidLoad];

}

-(void) onPress {
    [self performSegueWithIdentifier:@"home" sender: self];
}

-(IBAction)ClockPressed:(id)sender
{
    if (isInClock) {
        isInClock = false;
        slideImageView.center = CGPointMake(self.view.frame.size.width - slideImage.size.width/2 - 190, 60);
        slideImageView2.center = CGPointMake(self.view.frame.size.width - slideImage2.size.width/2 - 190, 43);
        slideImageView3.center = CGPointMake(self.view.frame.size.width - slideImage3.size.width/2-190, 74);
        [clockButton setCenter:CGPointMake(self.view.frame.size.width - 204, 60)];
        timeBox.hidden = NO;
    } else {
        isInClock = true;
        slideImageView.center = CGPointMake(self.view.frame.size.width - slideImage.size.width/2, 60);
        slideImageView2.center = CGPointMake(self.view.frame.size.width - slideImage2.size.width/2, 43);
        slideImageView3.center = CGPointMake(self.view.frame.size.width - slideImage3.size.width/2, 74);
        [clockButton setCenter:CGPointMake(self.view.frame.size.width - 14, 60)];
        timeBox.hidden = YES;
    }
    
}

-(IBAction)infoPressed:(id)sender
{
    if (isInInfo) {
        isInInfo = false;
        slideImageView4.center = CGPointMake(self.view.frame.size.width - slideImage.size.width/2 - 190, 90);
        slideImageView5.center = CGPointMake(self.view.frame.size.width - slideImage2.size.width/2 - 190, 73);
        slideImageView6.center = CGPointMake(self.view.frame.size.width - slideImage3.size.width/2-190, 104);
        [infoButton setCenter:CGPointMake(self.view.frame.size.width - 204, 90)];
        timeBox.hidden = NO;
    } else {
        isInInfo = true;
        slideImageView4.center = CGPointMake(self.view.frame.size.width - slideImage.size.width/2, 90);
        slideImageView5.center = CGPointMake(self.view.frame.size.width - slideImage2.size.width/2, 73);
        slideImageView6.center = CGPointMake(self.view.frame.size.width - slideImage3.size.width/2, 104);
        [infoButton setCenter:CGPointMake(self.view.frame.size.width - 14, 90)];
        timeBox.hidden = YES;
    }
    
}


- (void)loadUserPhotos
{
    NSLog(@"Load user Photos please");
    currentfbRequest=kLoadAlbums;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(displayPage) name:@"UserPhotosLoaded" object:nil];
    
    sharedSingleton = [RendezvousCurrentUser sharedInstance];
    RendezvousAppDelegate *delegate = (RendezvousAppDelegate *)[[UIApplication sharedApplication] delegate];
    NSString *path=[NSString stringWithFormat:@"%@/albums",[sharedSingleton matchedUserId]];
    [[delegate facebook] requestWithGraphPath:path andDelegate:self];
    NSLog(@"Sent Facebook Load Command");

}

- (void)displayPage
{    
    sharedSingleton = [RendezvousCurrentUser sharedInstance];
    
    if ([[sharedSingleton matchIDs] count] == 0)
    {
        [nameLabel setText:@"Unfortunately, you don't have a \n match loser :("];
    }
    else
    {
        
        [nameLabel setText:[[sharedSingleton matchInfo] objectForKey:[sharedSingleton matchedUserId]]];
        
        matchPhoto.image= [self imageForObject: [sharedSingleton matchedUserId]];
        
        UIScrollView *scroll = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
        
        scroll.scrollEnabled = YES;
        scroll.showsHorizontalScrollIndicator = NO;
        scroll.showsVerticalScrollIndicator = NO;
        UIImage *bar = [UIImage imageNamed:@"Jagged3.png"];
        UIImage *barLeft = [UIImage imageNamed:@"Jagged3.png"];
        UIImage *barRight = [UIImage imageNamed:@"Jagged3.png"];
        NSInteger numberOfViews = self.photos.count;
        NSInteger startX = 0;
        for (int i = 0; i < numberOfViews; i++) {
            UIImage *newImage = [self.photos objectAtIndex:i];
            NSInteger mesWidth = newImage.size.width * (self.view.frame.size.height /  newImage.size.height);
            
            UIImageView *awesomeView = [[UIImageView alloc] initWithFrame:CGRectMake(startX, 3, mesWidth, self.view.frame.size.height)];
            awesomeView.contentMode = UIViewContentModeScaleAspectFill;
            awesomeView.image=[self.photos objectAtIndex:i];
            [scroll addSubview:awesomeView];
            
            UIImageView *barView;
            if (i == 0) {
                barView = [[UIImageView alloc] initWithFrame:CGRectMake(startX - 15, 3, 30, self.view.frame.size.height)];
                barView.image=barLeft;
            } else {
                barView = [[UIImageView alloc] initWithFrame:CGRectMake(startX - 14, 3, 30, self.view.frame.size.height)];
                barView.image=bar;
            }
            [scroll addSubview:barView];
            startX += mesWidth;
            if (i == numberOfViews-1 ) {
                UIImageView *barView = [[UIImageView alloc] initWithFrame:CGRectMake(startX - 13, 3, 30, self.view.frame.size.height)];
                barView.image=barRight;
                [scroll addSubview:barView];
            }
        }
        [scroll setContentOffset:CGPointMake(100, 0)];
        scroll.contentSize = CGSizeMake(startX, self.view.frame.size.height);
        scroll.backgroundColor = [UIColor whiteColor];
        
        [self.view addSubview:scroll];
        
        
        UIImage *frameImage = [UIImage imageNamed:@"photoBrowserBackground3.png"];
        UIImageView *frameView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height +2)];
        frameView.image = frameImage;
        [self.view addSubview:frameView];
        
        timeBox = [[UILabel alloc] initWithFrame:CGRectMake(120, 40, 300, 38)];
        NSDate *date=[NSDate date];
        int secondsNow=(int)[date timeIntervalSince1970];
        NSDateFormatter *formatter=[[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"yyyy"];
        int currentYear = [[formatter stringFromDate:date] intValue];
        int nextYear=currentYear+1;
        NSString *nextYearBegin=[NSString stringWithFormat:@"%d0101",nextYear];
        [formatter setDateFormat:@"yyyyMMdd"];
        NSDate *otherDate=[formatter dateFromString:nextYearBegin];
        int secondsTarget=(int)[otherDate timeIntervalSince1970];
        int differenceSeconds=secondsTarget-secondsNow;
        int days=(int)((double)differenceSeconds/(3600.0*24.00));
        int diffDay=differenceSeconds-(days*3600*24);
        int hours=(int)((double)diffDay/3600.00);
        int diffMin=diffDay-(hours*3600);
        int minutes=(int)(diffMin/60.0);
        int seconds=diffMin-(minutes*60);
        timeBox.text = [NSString stringWithFormat:@"%d Days %d Hours %d Minutes %d Seconds",days,hours,minutes,seconds];
        timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timerFired:) userInfo:nil repeats:YES];
        [timeBox setTextColor:[UIColor whiteColor]];
        [timeBox setBackgroundColor:[UIColor colorWithWhite:0.0 alpha:0.7]];
        [timeBox setFont:[UIFont fontWithName: @"Verdana" size: 8.0f]]; 
        timeBox.hidden = YES;
        [self.view addSubview:timeBox];
        
        slideImage = [UIImage imageNamed:@"sideBarExtend.png"];
        slideImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, slideImage.size.width, slideImage.size.height +20)];
        slideImageView.image = slideImage;
        [self.view addSubview:slideImageView];
        slideImageView.center = CGPointMake(self.view.frame.size.width - slideImage.size.width/2, 60);
        
        slideImage2 = [UIImage imageNamed:@"sideBarTop.png"];
        slideImageView2 = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, slideImage2.size.width, slideImage2.size.height)];
        slideImageView2.image = slideImage2;
        [self.view addSubview:slideImageView2];
        slideImageView2.center = CGPointMake(self.view.frame.size.width - slideImage2.size.width/2, 43);
        
        slideImage3 = [UIImage imageNamed:@"sideBarBottom.png"];
        slideImageView3 = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, slideImage3.size.width, slideImage3.size.height)];
        slideImageView3.image = slideImage3;
        [self.view addSubview:slideImageView3];
        slideImageView3.center = CGPointMake(self.view.frame.size.width - slideImage3.size.width/2, 74);
        
        
        
        clockButton =  [UIButton buttonWithType:UIButtonTypeCustom];
        [clockButton setImage:[UIImage imageNamed:@"clock.png"] forState:UIControlStateNormal];
        [clockButton addTarget:self action:@selector(ClockPressed:) forControlEvents:UIControlEventTouchUpInside];
        [clockButton setFrame:CGRectMake(10, 285, 60, 60)];
        [clockButton setCenter:CGPointMake(self.view.frame.size.width - 14, 61)];
        [self.view addSubview:clockButton];
        
        slideImage4 = [UIImage imageNamed:@"sideBarExtend.png"];
        slideImageView4 = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, slideImage4.size.width, slideImage4.size.height +20)];
        slideImageView4.image = slideImage;
        [self.view addSubview:slideImageView4];
        slideImageView4.center = CGPointMake(self.view.frame.size.width - slideImage4.size.width/2, 90);
        
        slideImage5 = [UIImage imageNamed:@"sideBarTop.png"];
        slideImageView5 = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, slideImage5.size.width, slideImage5.size.height)];
        slideImageView5.image = slideImage5;
        [self.view addSubview:slideImageView5];
        slideImageView5.center = CGPointMake(self.view.frame.size.width - slideImage5.size.width/2, 73);
        
        slideImage6 = [UIImage imageNamed:@"sideBarBottom.png"];
        slideImageView6 = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, slideImage3.size.width, slideImage6.size.height)];
        slideImageView6.image = slideImage6;
        [self.view addSubview:slideImageView6];
        slideImageView3.center = CGPointMake(self.view.frame.size.width - slideImage6.size.width/2, 104);
        
        infoButton =  [UIButton buttonWithType:UIButtonTypeCustom];
        [infoButton setImage:[UIImage imageNamed:@"info.png"] forState:UIControlStateNormal];
        [infoButton addTarget:self action:@selector(infoPressed:) forControlEvents:UIControlEventTouchUpInside];
        [infoButton setFrame:CGRectMake(10, 285, 60, 60)];
        [infoButton setCenter:CGPointMake(self.view.frame.size.width - 14, 91)];
        [self.view addSubview:infoButton];
        
        NSLog(@"%f width", self.view.frame.size.height);
        
        
    }

    
}

- (void)timerFired:(NSTimer *)timer{
    NSDate *date=[NSDate date];
    int secondsNow=(int)[date timeIntervalSince1970];
    NSDateFormatter *formatter=[[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy"];
    int currentYear = [[formatter stringFromDate:date] intValue];
    int nextYear=currentYear+1;
    NSString *nextYearBegin=[NSString stringWithFormat:@"%d0101",nextYear];
    [formatter setDateFormat:@"yyyyMMdd"];
    NSDate *otherDate=[formatter dateFromString:nextYearBegin];
    //NSLog(@"%@",[otherDate description]);
    int secondsTarget=(int)[otherDate timeIntervalSince1970];
    int differenceSeconds=secondsTarget-secondsNow;
    int days=(int)((double)differenceSeconds/(3600.0*24.00));
    int diffDay=differenceSeconds-(days*3600*24);
    int hours=(int)((double)diffDay/3600.00);
    int diffMin=diffDay-(hours*3600);
    int minutes=(int)(diffMin/60.0);
    int seconds=diffMin-(minutes*60);
    timeBox.text = [NSString stringWithFormat:@"\t\t%d Days %d Hours %d Minutes %d Seconds",days,hours,minutes,seconds];
}


- (void)viewDidUnload
{
    [self setNameLabel:nil];
    [self setMatchName:nil];
    [self setMatchPhoto:nil];
    [self setMatchPhoto:nil];
    [self setMatchPhoto:nil];
    [self setPhotoButton:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (UIImage *)imageForObject:(NSString *)objectID {

    NSString *url = [[NSString alloc] initWithFormat:@"https://graph.facebook.com/%@/picture?type=large",objectID];
    UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:url]]];
   
 
    return image;
}
- (IBAction)loadMatchPhotos:(id)sender {
    if ([[sharedSingleton matchIDs] count] != 0)
    {
        currentfbRequest=kLoadAlbums;
        
        RendezvousCurrentUser *sharedSingleton=[RendezvousCurrentUser sharedInstance];
        RendezvousAppDelegate *delegate = (RendezvousAppDelegate *)[[UIApplication sharedApplication] delegate];
        NSString *path=[NSString stringWithFormat:@"%@/albums",[sharedSingleton matchedUserId]];
        [[delegate facebook] requestWithGraphPath:path andDelegate:self];
    }
}
- (IBAction)messageUser:(id)sender {
    if ([[sharedSingleton matchIDs] count] != 0)
    {
        RendezvousCurrentUser *s = [RendezvousCurrentUser sharedInstance];
        s.visitingMessageId=[s matchedUserId];
        
        if([[s uniqueMessageUserIDs] containsObject:s.matchedUserId]){
            [self performSegueWithIdentifier:@"matchChat" sender: self];
        }else{
            NSMutableArray *newChat = [[NSMutableArray alloc] init];
            [[s messages] setValue:newChat forKey:s.matchedUserId];
            [self performSegueWithIdentifier:@"matchChat" sender: self];
            
        }
    }
    

}

#pragma mark - MWPhotoBrowserDelegate

- (NSUInteger)numberOfPhotosInPhotoBrowser:(MWPhotoBrowser *)photoBrowser {
    return _photos.count;
}

- (MWPhoto *)photoBrowser:(MWPhotoBrowser *)photoBrowser photoAtIndex:(NSUInteger)index {
    if (index < _photos.count)
        return [_photos objectAtIndex:index];
    return nil;
}

//- (MWCaptionView *)photoBrowser:(MWPhotoBrowser *)photoBrowser captionViewForPhotoAtIndex:(NSUInteger)index {
//    MWPhoto *photo = [self.photos objectAtIndex:index];
//    MWCaptionView *captionView = [[MWCaptionView alloc] initWithPhoto:photo];
//    return [captionView autorelease];
//}



#pragma mark - MWPhotoBrowserDelegate

//- (MWCaptionView *)photoBrowser:(MWPhotoBrowser *)photoBrowser captionViewForPhotoAtIndex:(NSUInteger)index {
//    MWPhoto *photo = [self.photos objectAtIndex:index];
//    MWCaptionView *captionView = [[MWCaptionView alloc] initWithPhoto:photo];
//    return [captionView autorelease];
//}

- (void)request:(FBRequest *)request didFailWithError:(NSError *)error {
    NSLog(@"Facebook Bad Request");
}


#pragma mark - FB callback

- (void)request:(FBRequest *)request didLoad:(id)result
{
    
    
    switch (currentfbRequest) {
        case kLoadAlbums:
        {
            
            NSLog(@"Facebook request %@ loaded", [request url]);
            NSArray *resultData = [result objectForKey:@"data"];
            for (NSDictionary *album in resultData) {
                NSLog([album   objectForKey:@"name"]);
                
                if([@"Profile Pictures" compare:[album objectForKey:@"name"]] ==NSOrderedSame)
                {
                    NSLog(@"Matched Album");
                    currentfbRequest=kloadPhotos;
                    RendezvousAppDelegate *delegate = (RendezvousAppDelegate *)[[UIApplication sharedApplication] delegate];
                    NSString *path=[NSString stringWithFormat:@"%@/photos",[album objectForKey:@"id"]];
                    [[delegate facebook] requestWithGraphPath:path andDelegate:self];
                }
                
            }
            
            break;
            
        }
        case kloadPhotos:
        {
            
            NSLog(@"Facebook request %@ loaded", [request url]);
            NSArray *resultData = [result objectForKey:@"data"];
            NSMutableArray *photos=[[NSMutableArray alloc] init];
            
            NSLog(@"Loading Photos");
            for (NSDictionary *photo in resultData) {
                NSLog([photo  objectForKey:@"source"]);
                [photos addObject:[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[photo objectForKey:@"source"]]]]];
            }
            
            self.photos = photos;
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"UserPhotosLoaded" object:nil];
            break;
        }
    }
    
    
}


@end


