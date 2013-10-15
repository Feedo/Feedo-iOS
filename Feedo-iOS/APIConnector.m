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

#pragma mark - Instance
+ (APIConnector *)instance
{
    static APIConnector *instance;
    if ( !instance )
        instance = [[APIConnector alloc] initWithHost:PREF_SERVER];
    
    return instance;
}

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
    NSIndexSet *statusCodesSuccess = RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful);
    
    // FEED object
    RKResponseDescriptor *feedDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:[self mappingForFeed]
                                                                                        method:RKRequestMethodGET
                                                                                   pathPattern:@"/api/feeds"
                                                                                       keyPath:nil
                                                                                   statusCodes:statusCodesSuccess];
    [manager addResponseDescriptor:feedDescriptor];
    
    // FEED ITEM ObjectS
    RKResponseDescriptor *feedItemDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:[self mappingForFeedItems]
                                                                                            method:RKRequestMethodGET
                                                                                       pathPattern:@"/api/feeds/:feedID/items"
                                                                                           keyPath:nil
                                                                                       statusCodes:statusCodesSuccess];
    [manager addResponseDescriptor:feedItemDescriptor];
    
    // Error message mapping
    NSIndexSet *statusCodesError = RKStatusCodeIndexSetForClass(RKStatusCodeClassClientError);
    RKObjectMapping *errorMapping = [RKObjectMapping mappingForClass:[RKErrorMessage class]];
    [errorMapping addPropertyMapping:[RKAttributeMapping attributeMappingFromKeyPath:nil toKeyPath:@"errorMessage"]];
    RKResponseDescriptor *errorDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:errorMapping
                                                                                         method:RKRequestMethodAny
                                                                                    pathPattern:nil
                                                                                        keyPath:@"message"
                                                                                    statusCodes:statusCodesError];
    [manager addResponseDescriptor:errorDescriptor];
    
    // ADD FEED request
    RKObjectMapping *feedRequestMapping = [RKObjectMapping requestMapping];
    [feedRequestMapping addAttributeMappingsFromDictionary:@{ @"link": @"file_url" }];
    RKRequestDescriptor *feedRequestDescriptor = [RKRequestDescriptor requestDescriptorWithMapping:feedRequestMapping
                                                                                       objectClass:[FDFeed class]
                                                                                       rootKeyPath:nil
                                                                                            method:RKRequestMethodPOST];
    [manager addRequestDescriptor:feedRequestDescriptor];
    
    // force request types to be JSON encoded
    manager.requestSerializationMIMEType = RKMIMETypeJSON;
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
                                                  @"has_unread": @"hasUnread",
                                                  @"items": @"items"
                                                  }];
    return mapping;
}
- (RKObjectMapping *)mappingForFeedItems
{
    RKObjectMapping *mapping = [RKObjectMapping mappingForClass:[FDFeedItem class]];
    [mapping addAttributeMappingsFromDictionary:@{
                                                  @"title": @"title",
                                                  @"content": @"content",
                                                  @"summary": @"summary",
                                                  @"image": @"imageUrl",
                                                  @"published": @"published",
                                                  @"file_url": @"link",
                                                  @"author": @"author",
                                                  @"itemGuid": @"itemGuid",
                                                  @"read": @"read"
                                                  }];
    return mapping;
}

#pragma mark - Requests

- (void)requestFeedsWithCallback:(void (^)(NSArray* items, NSError *error))callback
{
    [manager getObjectsAtPath:@"/api/feeds"
                   parameters:nil
                      success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
                          // NSLog(@"requestFeeds succeeded (%d): %@", mappingResult.count, mappingResult);
                          
                          callback(mappingResult.array, nil);
                          
                      }
                      failure:^(RKObjectRequestOperation *operation, NSError *error) {
                          NSLog(@"requestFeed failed: %@", error.description);
                          
                          callback(nil, error);
                      }];
}

- (void)requestFeedItemsWithFeedID:(int)feedId
                      WithCallback:(void (^)(NSArray *array, NSError *error))callback
{
    NSString* url = [NSString stringWithFormat:@"/api/feeds/%d/items", feedId];
    
    [manager getObjectsAtPath:url
                   parameters:nil
                      success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
                          callback(mappingResult.array, nil);
                      }
                      failure:^(RKObjectRequestOperation *operation, NSError *error) {
                          NSLog(@"requestFeedItemsWithFeedID: failed.");
                          
                          callback(nil, error);
                      }];
}

- (void)addFeedFromURL:(NSString *)url
          WithCallback:(void (^)(NSArray *items, NSError *error))callback
{
    FDFeed *feed = [[FDFeed alloc] init];
    feed.link = url;
    
    [self addFeed:feed WithCallback:callback];
}
- (void)addFeed:(FDFeed *)feed
   WithCallback:(void (^)(NSArray *items, NSError *error))callback
{
    [manager postObject:feed
                   path:@"/api/feeds"
             parameters:nil
                success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
                    callback(mappingResult.array, nil);
                }
                failure:^(RKObjectRequestOperation *operation, NSError *error) {
                    callback(nil, error);
                }];
}

@end
