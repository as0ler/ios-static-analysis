//
//  ModelUser.h
//  ios-static-analysis
//
//  Created by Murphy on 01/06/2020.
//  Copyright © 2020 Murphy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface User : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * phone;
@property (nonatomic, retain) NSString * email;
@property (nonatomic, retain) NSString * password;

@end
