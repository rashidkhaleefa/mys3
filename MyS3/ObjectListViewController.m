//
//  ObjectListViewController.m
//  MyS3
//
//  Created by rashid khaleefa on 28/12/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ObjectListViewController.h"
#import <AWSiOSSDK/S3/AmazonS3Client.h>
#import "AmazonClientManager.h"

@implementation ObjectListViewController
@synthesize objectsArray,bucket,objectListTable,myToolbar, overlayViewController,capturedImages;;
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
    // Do any additional setup after loading the view from its nib.
    
    self.overlayViewController =
    [[[OverlayViewController alloc] initWithNibName:@"OverlayViewController" bundle:nil] autorelease];
    
    // as a delegate we will be notified when pictures are taken and when to dismiss the image picker
    self.overlayViewController.delegate = self;
    
    self.capturedImages = [NSMutableArray array];
    
    S3ListObjectsRequest  *listObjectRequest = [[[S3ListObjectsRequest alloc] initWithName:self.bucket] autorelease];
    S3ListObjectsResponse *listObjectResponse = [[AmazonClientManager s3] listObjects:listObjectRequest];
    
    NSLog(@"#################### BucketResponse : %@", listObjectResponse);
    
    
    if(listObjectResponse.error != nil)
    {
        NSLog(@"Error: %@", listObjectResponse.error);
        [objectsArray addObject:@"Unable to load objects!"];
    }
    
    else
    {
        S3ListObjectsResult *listObjectsResults = listObjectResponse.listObjectsResult;
        if (objectsArray == nil) {
            objectsArray = [[NSMutableArray alloc] initWithCapacity:[listObjectsResults.objectSummaries count]];
        }
        else {
            [objectsArray removeAllObjects];
        }
        
        // By defrault, listObjects will only return 1000 keys
        // This code will fetch all objects in bucket.
        // NOTE: This could cause the application to run out of memory
        NSString *lastKey;
        for (S3ObjectSummary *objectSummary in listObjectsResults.objectSummaries) {
            [objectsArray addObject:[objectSummary key]];
            lastKey = [objectSummary key];
        }
        
        while (listObjectsResults.isTruncated) {
            listObjectRequest = [[[S3ListObjectsRequest alloc] initWithName:self.bucket] autorelease];
            listObjectRequest.marker = lastKey;
            
            listObjectResponse = [[AmazonClientManager s3] listObjects:listObjectRequest];
            if(listObjectResponse.error != nil)
            {
                NSLog(@"Error: %@", listObjectResponse.error);
                [objectsArray addObject:@"Unable to load objects!"];
                
                break;
            }
            
            listObjectsResults = listObjectResponse.listObjectsResult;
            
            for (S3ObjectSummary *objectSummary in listObjectsResults.objectSummaries) {
                [objectsArray addObject:[objectSummary key]];
                lastKey = [objectSummary key];
            }
        }
    }
    
    [objectListTable reloadData];

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
- (void)showImagePicker:(UIImagePickerControllerSourceType)sourceType
{
 	
    if (self.capturedImages.count > 0)
        [self.capturedImages removeAllObjects];
    
    if ([UIImagePickerController isSourceTypeAvailable:sourceType])
    {
        [self.overlayViewController setupImagePicker:sourceType];
        [self presentModalViewController:self.overlayViewController.imagePickerController animated:YES];
    }
}
- (void)didFinishWithCamera
{
    [self dismissModalViewControllerAnimated:YES];
    
//    if ([self.capturedImages count] > 0)
//    {
//        if ([self.capturedImages count] == 1)
//        {
//            // we took a single shot
//                }
//        else
//        {
//            // we took multiple shots, use the list of images for animation
//                      
//            if (self.capturedImages.count > 0)
//                // we are done with the image list until next time
//                [self.capturedImages removeAllObjects];  
//            
//                }
//    }
}
// as a delegate we are being told a picture was taken
- (void)didTakePicture:(UIImage *)picture
{
    [self.capturedImages addObject:picture];
    
    NSLog(@"Image taken is : %@", picture);
    // Convert the image to JPEG data.
    NSData *imageData = UIImageJPEGRepresentation(picture, 1.0);
    
    // Initial the S3 Client.
   
    
    NSDate *date = [NSDate date];
	NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
	[formatter setDateFormat:@"HH:MM:SS"];
	NSString *timeString = [NSString stringWithFormat:@"%@.jpeg",[formatter stringFromDate:date]];
    
    S3PutObjectRequest *por = [[[S3PutObjectRequest alloc] initWithKey:timeString inBucket:bucket] autorelease];
    por.contentType = @"image/jpeg";
    por.data = imageData;
    [[AmazonClientManager s3] putObject:por];
    
    S3PutObjectResponse *putObjectResponse = [[AmazonClientManager s3] putObject:por];
    if(putObjectResponse.error != nil)
    {
        NSLog(@"Error: %@", putObjectResponse.error);
        
        NSLog(@"Error: %@", putObjectResponse.error);
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle: @"MyS3 Error" message: [putObjectResponse.error.userInfo objectForKey:@"message"] delegate: self cancelButtonTitle: @"Ok" otherButtonTitles: nil];
        [alert show];
        [alert release];    
    }
    
    
}

-(IBAction)selectPhoto:(id)sender
{
	UIActionSheet *styleAlert = [[UIActionSheet alloc] initWithTitle:@"Please select a mode"
															delegate:self cancelButtonTitle:@"Cancel"
											  destructiveButtonTitle:nil
												   otherButtonTitles:@"Gallery",@"Camera", nil, nil];
	
	styleAlert.tag = 20;
	styleAlert.actionSheetStyle = UIActionSheetStyleBlackTranslucent;
	[styleAlert showInView:self.view];
	[styleAlert release];
}

- (void)actionSheet:(UIActionSheet *)modalView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex)
    {
        case 0:
        {
            UIImagePickerController *imagePicker = [[[UIImagePickerController alloc] init] autorelease];
            
            imagePicker.delegate = self;
            [self presentModalViewController:imagePicker animated:YES];
            
            break;
        }
        case 1:
        {
            [self showImagePicker:UIImagePickerControllerSourceTypeCamera];
            
            NSLog(@"Second pressed");
            
            break;
        }
    }
    
}
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    // Get the selected image.
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    
    // Convert the image to JPEG data.
    NSData *imageData = UIImageJPEGRepresentation(image, 1.0);
    
    // Initial the S3 Client.
    
    NSDate *date = [NSDate date];
	NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
	[formatter setDateFormat:@"HH:MM:SS"];
	NSString *timeString = [NSString stringWithFormat:@"%@.jpeg",[formatter stringFromDate:date]];
    
    
    S3PutObjectRequest *por = [[[S3PutObjectRequest alloc] initWithKey:timeString inBucket:bucket] autorelease];
    por.contentType = @"image/jpeg";
    por.data = imageData;
    [[AmazonClientManager s3] putObject:por];
    
    S3PutObjectResponse *putObjectResponse = [[AmazonClientManager s3]putObject:por];
    if(putObjectResponse.error != nil)
    {
        NSLog(@"Error: %@", putObjectResponse.error);
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle: @"MyS3 Error" message: [putObjectResponse.error.userInfo objectForKey:@"message"] delegate: self cancelButtonTitle: @"Ok" otherButtonTitles: nil];
        [alert show];
        [alert release];
        
       
    }
    
    [picker dismissModalViewControllerAnimated:YES];
}


-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissModalViewControllerAnimated:YES];
}



#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return [objectsArray count];
    
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView 
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {  
    
    static NSString *CellID = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellID];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellID] autorelease];
    }
    cell.textLabel.font = [UIFont fontWithName:@"Helvetica" size:14.0];
    cell.selectionStyle = UITableViewCellSelectionStyleGray;
    cell.accessoryType = UITableViewCellAccessoryNone;
    
    cell.textLabel.text  = [objectsArray objectAtIndex:indexPath.row];
    NSLog(@"bucket list  : %@", objectsArray);
    
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSLog(@"rowselected");
  
}
#pragma mark -
#pragma mark Table view delegate
-(IBAction)BackButtonPress:(id)sender{
    
    [self.view removeFromSuperview]; 

}
@end
