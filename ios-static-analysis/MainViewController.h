//  Created by Murphy on 20/03/16.
//  Copyright © 2016 Murphy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MainViewController : UIViewController

- (IBAction)createFile:(id)sender;
- (IBAction)saveInRealm:(id)sender;
- (IBAction)saveYapDatabase:(id)sender;
- (IBAction)saveCoreData:(id)sender;
- (void) showAlert:(NSString *)message;


@end

