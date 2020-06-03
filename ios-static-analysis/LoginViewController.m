//  Created by Murphy on 11/06/17.
//  Copyright © 2017 Murphy. All rights reserved.
//

#import "LoginViewController.h"
#import "MainViewController.h"
#import "UserViewController.h"
#import <sqlite3.h>

@interface LoginViewController ()

@end

@implementation LoginViewController

@synthesize usernameField;
@synthesize passwordField;



- (NSString *)getPathForFilename:(NSString *)filename {
    // Get the path to the Documents directory belonging to this app.
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    
    // Append the filename to get the full, absolute path.
    NSString *fullPath = [NSString stringWithFormat:@"%@/%@", documentsDirectory, filename];
    return fullPath;
}

- (void)storeCredentialsForUsername:(NSString *)username withPassword:(NSString *)password {
    // Write the credentials to a SQLite database.
    sqlite3 *credentialsDB;
    const char *path = [[self getPathForFilename:@"credentials.sqlite"] UTF8String];
    
    if (sqlite3_open(path, &credentialsDB) == SQLITE_OK) {
        sqlite3_stmt *compiledStmt;
        
        //sqlite3_exec(credentialsDB, "PRAGMA key = 'secretKey!'", NULL, NULL, NULL);
        // Create the table if it doesn't exist.
        const char *createStmt =
        "CREATE TABLE IF NOT EXISTS creds (id INTEGER PRIMARY KEY AUTOINCREMENT, username TEXT, password TEXT);";
        
        sqlite3_exec(credentialsDB, createStmt, NULL, NULL, NULL);
        
        // Check to see if the user exists; update if yes, add if no.
        const char *queryStmt = "SELECT id FROM creds WHERE username=?";
        int userID = -1;
        
        if (sqlite3_prepare_v2(credentialsDB, queryStmt, -1, &compiledStmt, NULL) == SQLITE_OK) {
            sqlite3_bind_text(compiledStmt, 1, [username UTF8String], -1, SQLITE_TRANSIENT);
            while (sqlite3_step(compiledStmt) == SQLITE_ROW) {
                userID = sqlite3_column_int(compiledStmt, 0);
            }
            
            sqlite3_finalize(compiledStmt);
        }
        
        const char *addUpdateStmt;
        
        if (userID >= 0) {
            NSLog(@"%@", [NSString stringWithFormat:@"Updating username %@ and password %@", username, password]);
            addUpdateStmt = "UPDATE creds SET username=?, password=? WHERE id=?";
        } else {
            NSLog(@"%@", [NSString stringWithFormat:@"Creating username %@ and password %@", username, password]);
            addUpdateStmt = "INSERT INTO creds(username, password) VALUES(?, ?)";
        }
        
        if (sqlite3_prepare_v2(credentialsDB, addUpdateStmt, -1, &compiledStmt, NULL) == SQLITE_OK) {
            sqlite3_bind_text(compiledStmt, 1, [username UTF8String], -1, SQLITE_TRANSIENT);
            sqlite3_bind_text(compiledStmt, 2, [password UTF8String], -1, SQLITE_TRANSIENT);
            
            if (userID >= 0) sqlite3_bind_int(compiledStmt, 3, userID);
            if (sqlite3_step(compiledStmt) != SQLITE_DONE) {
                NSLog(@"Error storing credentials in SQLite database.");
            }
        }
        
        // Clean things up.
        if (compiledStmt && credentialsDB) {
            if (sqlite3_finalize(compiledStmt) != SQLITE_OK) {
                NSLog(@"Error finalizing SQLite compiled statement.");
            } else if (sqlite3_close(credentialsDB) != SQLITE_OK) {
                NSLog(@"Error closing SQLite database.");
            }
            
        } else {
            NSLog(@"Error closing SQLite database.");
        }
    }
}

- (void)doLogin {
    // Write the credentials to a SQLite database.
    sqlite3 *credentialsDB;
    NSString *username = self.usernameField.text;
    NSString *password = self.passwordField.text;
    const char *path = [[self getPathForFilename:@"credentials.sqlite"] UTF8String];
    
    if (sqlite3_open(path, &credentialsDB) == SQLITE_OK) {
        sqlite3_stmt *compiledStmt;
        
        // Check to see if the user exists; update if yes, add if no.
        const char *queryStmt = "SELECT id FROM creds WHERE username=? and password=?";
        int userID = -1;
        
        if (sqlite3_prepare_v2(credentialsDB, queryStmt, -1, &compiledStmt, NULL) == SQLITE_OK) {
            sqlite3_bind_text(compiledStmt, 1, [username UTF8String], -1, SQLITE_TRANSIENT);
            sqlite3_bind_text(compiledStmt, 2, [password UTF8String], -1, SQLITE_TRANSIENT);
            while (sqlite3_step(compiledStmt) == SQLITE_ROW) {
                userID = sqlite3_column_int(compiledStmt, 0);
            }   
            
            sqlite3_finalize(compiledStmt);
        }
        
       
        if (userID >= 0) {
            NSLog(@"%@", [NSString stringWithFormat:@"Username %@ and password %@ are correct!", username, password]);
            [self performSegueWithIdentifier: @"startUserView" sender: self];
        }
        
        // Clean things up.
        if (compiledStmt && credentialsDB) {
           if (sqlite3_close(credentialsDB) != SQLITE_OK) {
                NSLog(@"Error closing SQLite database.");
            }
        } else {
            NSLog(@"Error closing SQLite database.");
        }
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    NSString *username = @"master";
    NSString *password = @"Passw0rd!";
    
    [self storeCredentialsForUsername:username withPassword:password];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)submit:(id)sender {
    [self doLogin];
}

- (IBAction)getHint:(UIButton *)sender {
    UIAlertController *alert = [UIAlertController
                                alertControllerWithTitle:@"HINT"
                                message:@"Some Data is insecurely stored."
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
