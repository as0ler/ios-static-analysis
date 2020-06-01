//  Created by Murphy on 20/03/16.
//  Copyright © 2016 Murphy. All rights reserved.
//

#import "MainViewController.h"
#import <Realm/Realm.h>
#import <CoreData/CoreData.h>
#import "RealmUser.h"
#import "YapDatabase.h"
#import "User.h"
#import "AppDelegate.h"





@interface MainViewController ()

@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;

@end

@implementation MainViewController: UIViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    AppDelegate* appDelegate = [UIApplication sharedApplication].delegate;
    self.managedObjectContext = appDelegate.managedObjectContext;
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)saveInRealm:(id)sender {
    RLMRealm *realm = [RLMRealm defaultRealm];
    RealmUser *user = [[RealmUser alloc] init];
    
    user.name = @"TheKing";
    user.password = @"TheRealmS3cr3tKeys";
    
    [realm beginWriteTransaction];
    [realm addObject:user];
    [realm commitWriteTransaction];
    
    [self showAlert:@"Sensitive information stored successfully!"];
}

- (IBAction)saveYapDatabase:(id)sender {
    NSString *databaseName = @"YetAnotherDb.sqlite";
    NSURL *baseURL = [[NSFileManager defaultManager] URLForDirectory:NSApplicationSupportDirectory
                                                            inDomain:NSUserDomainMask
                                                   appropriateForURL:nil
                                                              create:YES
                                                               error:NULL];
    NSURL *databaseURL = [baseURL URLByAppendingPathComponent:databaseName isDirectory:NO];
    NSString *databasePath = databaseURL.filePathURL.path;
    
    YapDatabase *database = [[YapDatabase alloc] initWithPath:databasePath];
    YapDatabaseConnection *connection = [database newConnection];
    [connection readWriteWithBlock:^(YapDatabaseReadWriteTransaction *transaction) {
        
        [transaction setObject:@"Administrator" forKey:@"Username" inCollection:@"master"];
        [transaction setObject:@"ThisIsAnotherS3cr3t" forKey:@"Password" inCollection:@"master"];
    }];
    [self showAlert:@"Sensitive information stored successfully!"];
    
}

- (IBAction)saveCoreData:(id)sender {
    User *newUser = [NSEntityDescription insertNewObjectForEntityForName:@"User"
                                                  inManagedObjectContext:self.managedObjectContext];
    newUser.name = @"core_admin";
    newUser.email = @"core_admin@example.org";
    newUser.phone = @"606102102";
    newUser.password = @"OtherS3cr3tF0und";
    NSError *error;
    if (![self.managedObjectContext save:&error]) {
        NSLog(@"Error in saving data: %@", [error localizedDescription]);
        [self showAlert:@"Error Saved in Core Data"];
        
    }else{
        [self showAlert:@"Data saved in Core Data"];
    }
}

- (IBAction)createFile:(id)sender {
    
    NSLog(@"Creating File With DataProtection -> ");
    NSFileManager *filemgr;
    filemgr = [NSFileManager defaultManager];
    NSString *str = @"Here another secret stored in the filesystem. => p4ssw0rd!\n";
    NSData *content = [str dataUsingEncoding:NSUTF8StringEncoding];
    
    NSString *tmpDirectory = NSTemporaryDirectory();
    NSString *tmpFile = [tmpDirectory stringByAppendingPathComponent:@"newfile.txt"];
    
    if (![filemgr createFileAtPath:tmpFile contents: content attributes: [NSDictionary dictionaryWithObject:NSFileProtectionComplete forKey:NSFileProtectionKey]])
    {
        NSLog(@"Error was code: %d - message: %s", errno, strerror(errno));
    }
    
    [self showAlert:@"File created successfully!"];
    NSLog(@"File created successfully :)");
}

- (void) showAlert:(NSString *)message {
    
    UIAlertController *alert = [UIAlertController
                                alertControllerWithTitle:@"Success"
                                message:message
                                preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* ok = [UIAlertAction
                         actionWithTitle:@"OK"
                         style:UIAlertActionStyleDefault
                         handler:^(UIAlertAction * action)
                         {
        [alert dismissViewControllerAnimated:YES completion:nil];
        
    }];
    [alert addAction:ok];
    [self presentViewController:alert animated:YES completion:nil];
}

@end
