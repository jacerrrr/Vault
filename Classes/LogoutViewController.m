/* 
 * LogoutViewController.m
 * Vault
 *
 * Created by Jace Allison on January 21, 2012
 * Last modified on May 5, 2012 by Jace Allison
 *
 * Copyright © 2011-2012 Veeva Systems. All rights reserved.
 *
 * FILE DESCRIPTION
 *
 * Contains all functions related to the user logining out of Vault
 * on the iPad.  These functions interact with the view presented when
 * the tab "Logout" is selected from the tab bar.
 */

#import "LogoutViewController.h"

extern BOOL initLogin;

@implementation LogoutViewController

#define LOGOUT_YES  0
#define LOGOUT_NO   1


#pragma mark - View lifecycle

/* Creates a logout alert right when the view appears 
 *
 * PARAMETER(S)
 *
 *  (BOOL)animated              Determines whether the view should be animated on appearance
 *
 */

-(void)viewWillAppear:(BOOL)animated 
{
    /* Create alert */
    UIAlertView *logoutAlert = [[UIAlertView alloc] initWithTitle:@"Logout" message:@"Are you sure you want to logout?" delegate:self cancelButtonTitle:@"Yes" otherButtonTitles:@"No", nil];
    
    [logoutAlert show];      
}

/* Return YES for all supoorted orientations */

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return YES;
}

/* AlertVewDelegate function that is called when a button is clicked 
 *
 * PARAMETER(S)
 *
 *  (UIAlertView *)alertview            AlertView that appears
 *  (NSInteger)buttonIndex              Button index clicked on AlertView i.e. "Cancel"
 */

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    /* If the user wants to logout */
    if (buttonIndex == LOGOUT_YES) {
        initLogin = TRUE;
        
        /* Present login screen */
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
        UIViewController *loginScreen = [storyboard instantiateViewControllerWithIdentifier:@"loginVC"];
        loginScreen.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
        [self presentModalViewController:loginScreen animated:YES];
    }
    
    /* Go back to documents view */
    [self.tabBarController setSelectedIndex:0];
    [self removeUserDefaultsAndFilesForLogout];
}

/* Function that removes all the information related to Vault that is saved in the application.
 * Once the function is called, all this information, which is stored in NSUserDefaults, is removed.
 */

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
