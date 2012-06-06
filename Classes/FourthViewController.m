/* 
 * FourthViewController.m
 * Vault
 *
 * Created by Jace Allison on December 21, 2011
 * Last modified on May 24, 2011 by Jace Allison
 *
 * Copyright © 2011-2012 Veeva Systems. All rights reserved.
 *
 * FILE DESCRIPTION
 * 
 * This class contains all functions that pertain to the User Interface
 * for searching Veeva Vault to obtain new documents on the iPad. This Interface is the
 * fourth tab on the tab bar named "Search".  Examples of functions this
 * class holds are:
 *
 *  - A function called when the user uses the search bar
 *  - A function called when the user clicks on the download button
 *  - A function called when a request from vault is finished
 */

#import "FourthViewController.h"

@implementation FourthViewController

@synthesize documents;
@synthesize mySearchBar;
@synthesize vaultSearchResults;

#pragma mark - Memory management methods

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    
    [super viewDidLoad];
    
    vaultSearchResults = [[NSMutableArray alloc] init];
    
    /* Set the mapping attributes to obtain relevent information from Vault */
    RKObjectMapping *vaultSearchMapping = [RKObjectMapping mappingForClass:[VaultSearch class]];
    
    vaultSearchMapping.setNilForMissingRelationships = YES;
    
    [vaultSearchMapping mapAttributes:@"responseStatus", @"responseMessage", @"columns", @"resultSet", @"totalFound", nil];
    
    /* Set object mappings */
    [[RKObjectManager sharedManager].mappingProvider addObjectMapping:vaultSearchMapping];
    
    /* 
     * Find the 'X' button's text field in the searchBar and set its delegate to this view so
     * we can call a function when a user clicks on it
     */
    for (UIView *view in mySearchBar.subviews){
        if ([view isKindOfClass: [UITextField class]]) {
            UITextField *tf = (UITextField *)view;
            tf.delegate = self;
            break;
        }
    }
    
    /* Set the style for our table view */
    self.documents.separatorStyle = UITableViewCellSeparatorStyleNone;
    
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
	return YES;
}

- (void) viewDidAppear:(BOOL)animated{
    [self.documents reloadData];
}

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
    
    [self.documents reloadData];
    
}

#pragma mark - UITableViewCellDelegate methods

/* Customize the number of sections in the Table View */

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    /* Only one section in this tableView */
	return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    /* Customize the number of visible cells depending on the orientation */
    if ([vaultSearchResults count] > 24)
        return [vaultSearchResults count];
    else
        return PORTRAIT_COUNT;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    /* Set the cells up to have alternating background colors */
    if ( indexPath.row % 2 == 0) {
        UIColor *altCellColor = [UIColor colorWithRed:237/256.0 green:243/256.0 blue:254/256.0 alpha:1.0];
        cell.backgroundColor = altCellColor;
    }
    else { 
        UIColor *altCellColor2 = [UIColor whiteColor];
        cell.backgroundColor = altCellColor2;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TableView *cell = nil;
    NSString *fileType = nil;
    
    static NSString *CellIdentifier;
    
    if ([[UIApplication sharedApplication] statusBarOrientation ] == UIInterfaceOrientationPortrait || [[UIApplication sharedApplication] statusBarOrientation] == UIInterfaceOrientationPortraitUpsideDown){
        CellIdentifier = @"DownloadCell";
    }else {
        CellIdentifier = @"DownloadLandscapeCell";
    }
    
    cell = (TableView*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[TableView alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.lineColor = [UIColor blackColor];
    }
    
    /* Set up the cell if there are search results and the tableView row is in bounds */
    if (vaultSearchResults.count != 0 && (indexPath.row > -1 && indexPath.row < vaultSearchResults.count)) {
        Document *myDoc = [vaultSearchResults objectAtIndex:indexPath.row];
        
        cell.docName.text = myDoc.name;
        cell.docType.text = myDoc.type;
        cell.downloadButton.hidden = NO;
        [cell.downloadButton addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
        
        /* Get the format of the file */ 
        fileType = myDoc.format;
        /* Strip everything but the last component so it can be easily checked. */
        fileType = [fileType lastPathComponent];
        
        /* Determine what type of file the document is */
        if ([fileType isEqualToString:PDF_FORMAT]) 
            cell.docTypeImage.image = [UIImage imageNamed:PDF_IMG];
        else if ([fileType isEqualToString:MSWORD_FORMAT]) 
            cell.docTypeImage.image = [UIImage imageNamed:DOC_IMG];
        else if ([fileType isEqualToString:PPT_FORMAT])
            cell.docTypeImage.image = [UIImage imageNamed:PPT_IMG];
        else if ([fileType isEqualToString:XLS_FORMAT])
            cell.docTypeImage.image = [UIImage imageNamed:XLS_IMG];
        else
            cell.docTypeImage.image = [UIImage imageNamed:UNKOWN_IMG];
    }
    
    /* Format empty cells to be blank and not show the download button */
    else{
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.docName.text = @"";
        cell.docType.text = @"";
        cell.docTypeImage.image = nil;
        cell.downloadButton.hidden = YES;
    }
    
    return cell;
}

#pragma mark - UISearchBarDelegate methods

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    
    /* Handle the empty string */
    if (searchBar.text.length == 0) {
        [self updateVaultSearchResults:nil];
    } else { /* Search Vault for the string. */
        /* String that will contain the second half of the query URL */
        NSString *query = [NSString stringWithFormat:@"%@%@*'", SEARCH_BASE_URL, searchBar.text];
        
        /* ObjectMapping of VaultSearch attributes that will be parsed from the response */
        RKObjectMapping *vaultSearchMapping = [[RKObjectManager sharedManager].mappingProvider objectMappingForClass:[VaultSearch class] ];
        
        /* Loads objects from baseURL+query using vaultSearchMapping */
        /* This gives warning: 'loadObjectsAtResourcePath:objectMapping:delegate:' is deprecated
         * It's deprecated because you can use the resourcePath mapping registration instead*/
        [[RKObjectManager sharedManager] loadObjectsAtResourcePath:query objectMapping:vaultSearchMapping delegate:self];
        
        [searchBar resignFirstResponder];
    }
} 

#pragma mark - UITextFieldDelegate methods

- (BOOL)textFieldShouldClear:(UITextField *)textField {
    
    /* Clear the search contents and reload the cells to create a blank screen */
    [self updateVaultSearchResults:nil];
    [self.documents reloadData];
    return YES;
}

#pragma mark - RKObjectLoader Delegate methods

- (void)objectLoader:(RKObjectLoader *)objectLoader didLoadObjects:(NSArray *)objects {
    
    VaultSearch *vaultSearchResponse = [objects objectAtIndex:0];            /* Load objects from response */
    
    if ([vaultSearchResponse.responseStatus isEqualToString:SUCCESS]) {
        
        [self updateVaultSearchResults:vaultSearchResponse.resultSet];
    }
    
}

- (void)objectLoader:(RKObjectLoader *)objectLoader didFailWithError:(NSError *)error {
    
    /* If there is an error, show an alert */
    if (error) {
        RKLogError(@"Load of RKObjectLoader %@ failed with error: %@", objectLoader, error);
    }
}

#pragma mark - FourthViewController misc. methods


/* 
 * This function will format the JSON data onto a document and then add it to an
 * array. The array, vaultSearchResults will be used to populate the cells in the tableView.
 *
 * PARAMETERS
 *
 * resultSet        Array containing the JSON data
 *
 * RETURN VALUES
 * 
 * nil
 */
- (void)updateVaultSearchResults:(NSArray *)resultSet {
    
    Document *doc = [[Document alloc] init];
    
    /* Remove outdated vaultSearchResults */
    [vaultSearchResults removeAllObjects];
    
    /* For loop to extract data from resultSet and enter data into vaultSearchResults */
    for (NSDictionary *resultDoc in resultSet) {
        
        doc.documentId = [[resultDoc objectForKey:@"values"] objectAtIndex:0];
        doc.name = [[resultDoc objectForKey:@"values"] objectAtIndex:1];
        doc.type = [[resultDoc objectForKey:@"values"] objectAtIndex:2];
        doc.format = [[resultDoc objectForKey:@"values"] objectAtIndex:3];
        
        [vaultSearchResults addObject:[doc copy]];
        
    }
    
    for (Document *savedDoc in vaultSearchResults) {     
        NSLog(@"Name = %@\n", savedDoc.name);
        NSLog(@"documentId = %@\n", savedDoc.documentId);
        NSLog(@"format = %@\n", savedDoc.format);
        NSLog(@"type = %@\n", savedDoc.type);
        
    }
    
    [self.documents reloadData];
}


/* 
 * This function will download the document the user indicates.
 *
 * PARAMETERS
 *
 * sender           User clicks on the button 'Download' button in the tableView.
 *
 * RETURN VALUES
 * 
 * nil
 */
-(void)buttonPressed:(id)sender {
    
    /* Determine what the cell is by asking for the superview of the button */
    UITableViewCell *clickedCell = (UITableViewCell *)[sender superview];
    /* Then convert the cell to an indexPath so we can later access the row */
    NSIndexPath *clickedButtonPath = [self.documents indexPathForCell:clickedCell];
    
    //Add Code to download file
    
    
    Document *myDoc = [vaultSearchResults objectAtIndex:clickedButtonPath.row];
    NSString *downloadString = [NSString stringWithFormat:@"%@ has successfully been added to the iPad", myDoc.name];
    /* Create alert */
    UIAlertView *connectAlert = [[UIAlertView alloc] initWithTitle:@"Download Complete" message:downloadString delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
    
    [connectAlert show];
    
}

@end
