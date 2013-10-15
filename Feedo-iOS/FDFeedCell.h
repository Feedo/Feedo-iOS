//
//  FDFeedCell.h
//  Feedo-iOS
//
//  Created by Sören Gade on 15.10.13.
//  Copyright (c) 2013 Sören Gade. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FDFeedCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;
@property (weak, nonatomic) IBOutlet UIImageView *feedImage;

@end
