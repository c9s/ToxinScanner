//
//  CTDetailViewController.h
//  ToxinScanner
//
//  Created by Lin Yo-an on 6/27/13.
//  Copyright (c) 2013 Lin Yo-an. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CTDetailViewController : UIViewController <UISplitViewControllerDelegate>

@property (strong, nonatomic) id detailItem;

@property (weak, nonatomic) IBOutlet UILabel *detailDescriptionLabel;
@end
