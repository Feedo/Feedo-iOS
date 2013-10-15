//
//  Constants.h
//  Feedo-iOS
//
//  Created by Sören Gade on 15.10.13.
//  Copyright (c) 2013 Sören Gade. All rights reserved.
//

#ifndef Feedo_iOS_Constants_h
#define Feedo_iOS_Constants_h

#define REUSABLE_CELL_IDENFIIER @"Cell"

#define LOCAL_SERVER_ADDRESS @"localhost"
#define LOCAL_SERVER_PORT 9292
#define LOCAL_SERVER [NSString stringWithFormat:@"http://%@:%d", LOCAL_SERVER_ADDRESS, LOCAL_SERVER_PORT]

#define _PREF_SERVER_ADDRESS @"server_url"
#define _PREF_SERVER_PORT @"server_port"
#define _PREF [NSUserDefaults standardUserDefaults]
#define PREF_SERVER_ADDRESS [_PREF objectForKey:_PREF_SERVER_ADDRESS]
#define PREF_SERVER_PORT [_PREF integerForKey:_PREF_SERVER_PORT]
#define PREF_SERVER [NSString stringWithFormat:@"http://%@:%d", PREF_SERVER_ADDRESS, PREF_SERVER_PORT]

#endif
