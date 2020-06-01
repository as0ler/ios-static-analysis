//
//  RealmUser.h
//  ios-static-analysis
//
//  Created by Murphy on 01/06/2020.
//  Copyright © 2020 Murphy. All rights reserved.
//

#import <Realm/Realm.h>

@interface RealmUser : RLMObject

@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *password;

@end
