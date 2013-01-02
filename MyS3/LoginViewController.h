//
//  LoginViewController.h
//  MyS3
//
//  Created by rashid khaleefa on 28/12/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BucketListViewController.h"
#import "WinkProgress.h"
@interface LoginViewController : UIViewController{
     WinkProgress *loginIndicator;
}
@property(nonatomic,retain)IBOutlet UITextField *AccessKeyTxtfield;
@property(nonatomic,retain)IBOutlet UITextField *SecretKeyTxtfield;

-(IBAction)SubmitButtonPress:(id)sender;

@end
