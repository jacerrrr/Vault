//
//  FourthViewController.m
//  Vault
//
//  Created by Jace Allison on 12/22/11.
//  Copyright (c) 2011 Issaquah High School. All rights reserved.
//

#import "FourthViewController.h"

@implementation FourthViewController

@synthesize documents;
@synthesize mySearchBar;
@synthesize vaultSearchResults;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

/*
 // Implement loadView to create a view hierarchy programmatically, without using a nib.
 - (void)loadView
 {
 }
 */



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
    
    /* Find the 'X' button's text field in the searchBar */
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

/* Customize the number of sections in the Table View */

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	return 1;
}

/* Customize the number of visible cells depending on the orientation */
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if ([vaultSearchResults count] > 24)
        return [vaultSearchResults count];
    else
        return PORTRAIT_COUNT;
}

/* Set the cells up to have alternating background colors */
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ( indexPath.row % 2 == 0) {
        UIColor *altCellColor = [UIColor colorWithRed:237/256.0 green:243/256.0 blue:254/256.0 alpha:1.0];
        cell.backgroundColor = altCellColor;
    }
    else { 
        UIColor *altCellColor2 = [UIColor whiteColor];
        cell.backgroundColor = altCellColor2;
    }
}

/* Function called when a cell is clicked on by the user */

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
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
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
    }
    
    if (vaultSearchResults.count != 0 && (indexPath.row > -1 && indexPath.row < vaultSearchResults.count)) {
        Document *myDoc = [vaultSearchResults objectAtIndex:indexPath.row];
        cell.docName.text = myDoc.name;
        cell.docType.text = myDoc.type;
        cell.downloadButton.hidden = NO;
        [cell.downloadButton addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
        fileType = myDoc.format;
        fileType = [fileType lastPathComponent];
        
        /* Same as FirstViewController */
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
    
    else{
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.docName.text = @"";
        cell.docType.text = @"";
        cell.docTypeImage.image = nil;
        cell.downloadButton.hidden = YES;
    }
    
    return cell;
}

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

/* Clear the table of any search results when a user clicks on the 'X' button in the searchBar */
- (BOOL)textFieldShouldClear:(UITextField *)textField {
    
    [self updateVaultSearchResults:nil];
    [self.documents reloadData];
    return YES;
}

- (void)objectLoader:(RKObjectLoader *)objectLoader didLoadObjects:(NSArray *)objects {
    
    VaultSearch *vaultSearchResponse = [objects objectAtIndex:0];            /* Load objects from response */
    
    if ([vaultSearchResponse.responseStatus isEqualToString:SUCCESS]) {
        
        [self updateVaultSearchResults:vaultSearchResponse.resultSet];
    }
    
}


/* Function called when no request can be sent or recieved from Vault */

- (void)objectLoader:(RKObjectLoader *)objectLoader didFailWithError:(NSError *)error {
    
    /* If there is an error, show an alert */
    if (error) {
        RKLogError(@"Load of RKObjectLoader %@ failed with error: %@", objectLoader, error);
    }
}

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

/* When the Download button is pressed we need to determine what row was pressed then download the document */
-(void)buttonPressed:(id)sender {
    UITableViewCell *clickedCell = (UITableViewCell *)[sender superview];
    NSIndexPath *clickedButtonPath = [self.documents indexPathForCell:clickedCell];
    
    //Add Code to download file
    
    Document *myDoc = [vaultSearchResults objectAtIndex:clickedButtonPath.row];
    NSString *downloadString = [NSString stringWithFormat:@"%@ has successfully been added to the iPad", myDoc.name];
    /* Create alert */
    UIAlertView *connectAlert = [[UIAlertView alloc] initWithTitle:@"Download Complete" message:downloadString delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
    
    [connectAlert show];
    
}

@end
