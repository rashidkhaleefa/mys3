//
//  BucketListViewController.h
//  MyS3
//
//  Created by rashid khaleefa on 28/12/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WinkProgress.h"
@interface BucketListViewController : UIViewController{
    WinkProgress *loginIndicator;
}
@property(nonatomic,retain)IBOutlet UITableView *ListBucketTable;
@property(nonatomic,retain)NSMutableArray* BucketListArray;
@end
