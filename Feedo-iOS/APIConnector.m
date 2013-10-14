//
//  APIConnector.m
//  Feedo-iOS
//
//  Created by Sören Gade on 14.10.13.
//  Copyright (c) 2013 Sören Gade. All rights reserved.
//

#import "APIConnector.h"

@interface APIConnector ()
{
    RKObjectManager *manager;
}
@end

@implementation APIConnector

#pragma mark - Setters/Getters
- (void)setHostUrl:(NSString *)hostUrl
{
    manager = [RKObjectManager managerWithBaseURL:[NSURL URLWithString:hostUrl]];
    [self setupRKObjectManager];
}

#pragma mark - Init
- (id)initWithHost:(NSString*)host
{
    self.hostUrl = host;
    
    return self;
}
- (void)setupRKObjectManager
{
    RKResponseDescriptor *feedDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:[self mappingForFeed] method:RKRequestMethodGET pathPattern:@"/api/feeds" keyPath:@"" statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)];
    
    [manager addResponseDescriptor:feedDescriptor];
}
- (RKObjectMapping *)mappingForFeed
{
    RKObjectMapping *mapping = [RKObjectMapping mappingForClass:[FDFeed class]];
    [mapping addAttributeMappingsFromDictionary:@{
                                                  @"id": @"identifier",
                                                  @"title": @"title",
                                                  @"description": @"description",
                                                  @"link": @"link",
                                                  @"favicon_url": @"faviconUrl",
                                                  @"hasUnread": @"hasUnread",
                                                  @"items": @"items"
                                                  }];
    return mapping;
}

#pragma mark - Requests

- (NSArray*)requestFeeds
{
    [manager getObjectsAtPath:@"/api/feeds"
                   parameters:nil
                      success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
                          NSLog(@"requestFeeds succeeded (%d): %@", mappingResult.count, mappingResult);
                      }
                      failure:^(RKObjectRequestOperation *operation, NSError *error) {
                          NSLog(@"requestFeed failed: %@", error.description);
                      }];
    return nil;
}

@end
