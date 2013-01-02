//
//  BucketListViewController.m
//  MyS3
//
//  Created by rashid khaleefa on 28/12/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "BucketListViewController.h"
#import "AmazonClientManager.h"
#import <AWSiOSSDK/S3/AmazonS3Client.h>
#import "ObjectListViewController.h"

@implementation BucketListViewController
@synthesize BucketListArray,ListBucketTable;

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
    loginIndicator = [[WinkProgress showHUDAddedTo:self.navigationController.view animated:YES] retain];
    loginIndicator.dimBackground = YES;
    loginIndicator.labelText = @"Logging In";	
    loginIndicator.detailsLabelText = @"Please wait...";
    NSArray *bucketNames = [[AmazonClientManager s3] listBuckets];
    if (BucketListArray == nil) {
        BucketListArray = [[NSMutableArray alloc] initWithCapacity:[bucketNames count]];
    }
    else {
        [BucketListArray removeAllObjects];
    }
    
    if (bucketNames != nil) {
        for (S3Bucket *bucket in bucketNames) {
            
            
            
            [BucketListArray addObject:[bucket name]];
        }
    }
    
    [BucketListArray sortUsingSelector:@selector(compare:)];
    [loginIndicator hide:YES afterDelay:0];
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

#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return [BucketListArray count];
    
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
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
     cell.textLabel.text  = [BucketListArray objectAtIndex:indexPath.row];
    //NSLog(@"bucket list  : %@", BucketListArray);
    
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSLog(@"rowselected");
       [self performSelector:@selector(GoWithListObjects:) withObject:indexPath afterDelay:0.0]; 
    loginIndicator = [[WinkProgress showHUDAddedTo:self.navigationController.view animated:YES] retain];
    loginIndicator.dimBackground = YES;
    loginIndicator.labelText = @"Logging In";	
    loginIndicator.detailsLabelText = @"Please wait...";
    

}
-(void)GoWithListObjects:(NSIndexPath*)indexPath {
    ObjectListViewController* objectList = [[ObjectListViewController alloc] init];
	objectList.bucket = [BucketListArray objectAtIndex:indexPath.row];
	//objectList.objects = objectNames;
	
	[self.view addSubview:objectList.view];
    [loginIndicator hide:YES afterDelay:0];
}
#pragma mark -
#pragma mark Table view delegate


@end
