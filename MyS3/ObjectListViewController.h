//
//  ObjectListViewController.h
//  MyS3
//
//  Created by rashid khaleefa on 28/12/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OverlayViewController.h"
#import <AudioToolbox/AudioServices.h>

@interface ObjectListViewController : UIViewController<UINavigationControllerDelegate,UIActionSheetDelegate, UIImagePickerControllerDelegate,OverlayViewControllerDelegate>{
    OverlayViewController *overlayViewController;
    NSMutableArray *capturedImages;
}
@property (nonatomic, retain) IBOutlet UIToolbar *myToolbar;

@property (nonatomic, retain) OverlayViewController *overlayViewController;

@property (nonatomic, retain) NSMutableArray *capturedImages;

@property(nonatomic,retain)  NSMutableArray       *objectsArray;
@property(nonatomic,retain)  NSString             *bucket;
@property(nonatomic,retain)IBOutlet UITableView *objectListTable;

-(IBAction)selectPhoto:(id)sender;
-(IBAction)BackButtonPress:(id)sender;



@end
