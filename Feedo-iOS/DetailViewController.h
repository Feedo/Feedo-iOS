//
//  DetailViewController.h
//  Feedo-iOS
//
//  Created by Sören Gade on 14.10.13.
//  Copyright (c) 2013 Sören Gade. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailViewController : UIViewController

@property (strong, nonatomic) id detailItem;

@property (weak, nonatomic) IBOutlet UILabel *detailDescriptionLabel;
@end
