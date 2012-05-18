//
//  LogoutViewController.m
//  Vault
//
//  Created by Jace Allison on 3/8/12.
//  Copyright (c) 2012 Issaquah High School. All rights reserved.
//

#import "LogoutViewController.h"

extern BOOL initLogin;

@implementation LogoutViewController

#define LOGOUT_YES  0
#define LOGOUT_NO   1


#pragma mark - View lifecycle

-(void)viewWillAppear:(BOOL)animated 
{
    /* Create alert */
    UIAlertView *logoutAlert = [[UIAlertView alloc] initWithTitle:@"Logout" message:@"Are you sure you want to logout?" delegate:self cancelButtonTitle:@"Yes" otherButtonTitles:@"No", nil];
    
    [logoutAlert show];      
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
	return YES;
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if (buttonIndex == LOGOUT_YES) {
        initLogin = TRUE;
        
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
        UIViewController *loginScreen = [storyboard instantiateViewControllerWithIdentifier:@"loginVC"];
        loginScreen.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
        [self presentModalViewController:loginScreen animated:YES];
    }
    
    else if (buttonIndex == LOGOUT_NO) {
        
    }
    
    [self.tabBarController setSelectedIndex:0];
    [self removeUserDefaultsAndFilesForLogout];
}

-(void)removeUserDefaultsAndFilesForLogout {
    NSUserDefaults *standardDefaults = [NSUserDefaults standardUserDefaults];
    
    if (standardDefaults) {
        NSDictionary *defaultsDictionary = [[NSUserDefaults standardUserDefaults] dictionaryRepresentation];
        
        for (NSString *key in [defaultsDictionary allKeys]) {
            [standardDefaults removeObjectForKey:key];
        }
        
        [standardDefaults synchronize];
    }
    
    NSString *folderPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0]; 
    
    NSError *error = nil;
    for (NSString *file in [[NSFileManager defaultManager] contentsOfDirectoryAtPath:folderPath error:&error]) {
        [[NSFileManager defaultManager] removeItemAtPath:[folderPath stringByAppendingPathComponent:file] error:&error];
    }

}

@end
