//
//  APIConnector.m
//  Feedo-iOS
//
//  Created by Sören Gade on 14.10.13.
//  Copyright (c) 2013 Sören Gade. All rights reserved.
//

#import "APIConnector.h"

@implementation APIConnector

-(id)initWithHost:(NSString*)host
{
    self.hostUrl = host;
    
    return self;
}


-(NSArray*)requestFeeds
{
    return nil;
}

@end
