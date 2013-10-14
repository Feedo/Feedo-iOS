//
//  FDFeedItem.h
//  Feedo-iOS
//
//  Created by Sören Gade on 15.10.13.
//  Copyright (c) 2013 Sören Gade. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FDFeedItem : NSObject

@property (nonatomic, retain) NSString *title;
@property (nonatomic, retain) NSString *content;
@property (nonatomic, retain) NSString *summary;
@property (nonatomic, retain) NSString *imageUrl;
@property (nonatomic, retain) NSString *published;
@property (nonatomic, retain) NSString *link;
@property (nonatomic, retain) NSString *author;
@property (nonatomic, retain) NSString *itemGuid;
@property (atomic) BOOL read;

@end
