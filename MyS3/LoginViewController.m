//
//  LoginViewController.m
//  MyS3
//
//  Created by rashid khaleefa on 28/12/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "LoginViewController.h"

@implementation LoginViewController
@synthesize AccessKeyTxtfield;
@synthesize SecretKeyTxtfield;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
     self.navigationController.navigationBarHidden = true;

    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
-(IBAction)SubmitButtonPress:(id)sender{
    
    if(![AccessKeyTxtfield.text length]||![SecretKeyTxtfield.text length]){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle: @"MyS3" message: @"kindly enter the values" delegate: self cancelButtonTitle: @"Ok" otherButtonTitles: nil];
        [alert show];
        [alert release];
    }
    else{
        [self performSelector:@selector(GoWithLoginRequest) withObject:nil afterDelay:0.0]; 
        loginIndicator = [[WinkProgress showHUDAddedTo:self.navigationController.view animated:YES] retain];
        loginIndicator.dimBackground = YES;
        loginIndicator.labelText = @"Logging In";	
        loginIndicator.detailsLabelText = @"Please wait...";
    
    }
}
-(void)GoWithLoginRequest{
    [[NSUserDefaults standardUserDefaults] setObject:AccessKeyTxtfield.text forKey:@"$AccessKey"];
    [[NSUserDefaults standardUserDefaults] setObject:SecretKeyTxtfield.text forKey:@"$SecretKey"];
    
    BucketListViewController *bucketListView=[[BucketListViewController alloc] initWithNibName:@"BucketListViewController" bundle:nil];
    
    [self.navigationController pushViewController:bucketListView animated:YES];
    [bucketListView release];
    [loginIndicator hide:YES afterDelay:0];
    
}
@end
