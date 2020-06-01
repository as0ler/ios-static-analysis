//
//  UserViewController.m
//  DynamicAnalysis
//
//  Created by Murphy on 10/06/2019.
//  Copyright © 2019 Murphy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UserViewController.h"

@interface UserViewController ()

@end

@implementation UserViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSUserDefaults *secretDetails = [NSUserDefaults standardUserDefaults];
    
    [secretDetails setObject:@"1337" forKey:@"PIN"];
    
    [secretDetails synchronize];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)verify:(id)sender {
    
    
    if ([self.txt_pin.text isEqualToString:@""])
    {
        UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Error"
                                                                       message:@"Enter details!"
                                                                preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                              handler:^(UIAlertAction * action) {}];
        
        [alert addAction:defaultAction];
        [self presentViewController:alert animated:YES completion:nil];
        
    }
    
    else
    {
        NSUserDefaults *secretDetails = [NSUserDefaults standardUserDefaults];
        
        NSString *pin = [secretDetails objectForKey:@"PIN"];
        if ([self.txt_pin.text isEqualToString:pin]) {
            
            self.txt_pin.text = @"";
            
            UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Success"
                                                                           message:@"Congrats! You're on right track."
                                                                    preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                                  handler:^(UIAlertAction * action) {    [self performSegueWithIdentifier: @"startSecretView" sender: self];}];
            
            [alert addAction:defaultAction];
            [self presentViewController:alert animated:YES completion:nil];
        }
        else{
            UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Invalid!"
                                                                           message:@"Try harder!"
                                                                    preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                                  handler:^(UIAlertAction * action) {}];
            
            [alert addAction:defaultAction];
            [self presentViewController:alert animated:YES completion:nil];
        }
    }
    
}

@end
