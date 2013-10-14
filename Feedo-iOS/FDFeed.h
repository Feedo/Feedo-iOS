//
//  FDFeed.h
//  Feedo-iOS
//
//  Created by Sören Gade on 14.10.13.
//  Copyright (c) 2013 Sören Gade. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FDFeed : NSObject

@property (atomic) int identifier; // id == identifier, avoid type
@property (nonatomic, retain) NSString* title;
@property (nonatomic, retain) NSString* description;
@property (nonatomic, retain) NSString* link;
@property (nonatomic, retain) NSString* faviconUrl;
@property (atomic) BOOL hasUnread;
@property (nonatomic, retain) NSArray* items;

@end
