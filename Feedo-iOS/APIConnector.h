//
//  APIConnector.h
//  Feedo-iOS
//
//  Created by Sören Gade on 14.10.13.
//  Copyright (c) 2013 Sören Gade. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RestKit/RestKit.h"

#import "FDFeed.h"

@interface APIConnector : NSObject

- (id)initWithHost:(NSString*)host;

- (void)requestFeedsWithCallback:(void (^)(NSArray* items, NSError *error))callback;

@property (nonatomic) NSString* hostUrl;

@end
