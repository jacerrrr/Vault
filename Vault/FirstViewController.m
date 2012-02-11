/* 
 * AppDelegate.h
 * Vault
 *
 * Created by Jace Allison on December 21, 2011
 * Last modified on December 22, 2011 by Jace Allison
 *
 * Copyright 2011 Oregon State University. All rights reserved.
 */

#import "FirstViewController.h"

extern BOOL needToSync;

@implementation FirstViewController

@synthesize documents;
@synthesize documentTypes;
@synthesize documentNames;
@synthesize contentFiles;
@synthesize datesModified;
@synthesize numOfDocuments;

/* Release any cached data, images, etc that aren't in use. */

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
}

#pragma mark - View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    documentTypes = [[NSMutableDictionary alloc] init];
    documentNames = [[NSMutableDictionary alloc] init];
    contentFiles = [[NSMutableDictionary alloc] init];
    datesModified = [[NSMutableDictionary alloc] init];
}

/* Release any retained subviews of the main view. e.g. self.myOutlet = nil; */
- (void)viewDidUnload {
    [super viewDidUnload];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.documents.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    /* Sync documents if user just logged into Vault */
   // if (needToSync == TRUE) {
        needToSync = FALSE;
        NSString * session = [VaultUser loadSession];                                                       /* Load new session */
        
        [[RKObjectManager sharedManager].client setValue:session forHTTPHeaderField:@"Authorization"];      /* Set session to Authorization HTTP header */
        [[RKObjectManager sharedManager] loadObjectsAtResourcePath:DOCUMENT_INFO                            /* GET request to grab document information */
                                                        usingBlock:^(RKObjectLoader *loader) {
                                                            loader.method = RKRequestMethodGET;
                                                            loader.delegate = self;
                                                        }];
        
        
  //  }
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated {
	[super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    
    return YES;                                                             /* Return YES for supported orientations */
}

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
    
    /* Going to Landscape Orientation */
    if (toInterfaceOrientation == UIInterfaceOrientationLandscapeRight
        || toInterfaceOrientation == UIInterfaceOrientationLandscapeLeft) {
        
        [self.documents reloadData];
        
    }
    
    else {  /* Going back to Portrait Orientation */
        
        [self.documents reloadData];
        
    }
}

/* Customize the number of sections in the Table View */

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    if ([[UIDevice currentDevice] orientation] == UIDeviceOrientationPortrait || [[UIDevice currentDevice] orientation] == UIDeviceOrientationPortraitUpsideDown){
        return PORTRAIT_COUNT;
    }
    else{
        return LANDSCAPE_COUNT;
    }
	
}



- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ( indexPath.row%2 == 0) {
        UIColor *altCellColor = [UIColor colorWithRed:237/256.0 green:243/256.0 blue:254/256.0 alpha:1.0];
        cell.backgroundColor = altCellColor;
    }
    else { 
        UIColor *altCellColor2 = [UIColor whiteColor];
        cell.backgroundColor = altCellColor2;
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier;
    
    
    if ([[UIApplication sharedApplication] statusBarOrientation ] == UIInterfaceOrientationPortrait || [[UIApplication sharedApplication] statusBarOrientation] == UIInterfaceOrientationPortraitUpsideDown){
        CellIdentifier = @"PortraitCell";
    }else {
        CellIdentifier = @"LandscapeCell";
    }
    
    
    TableView *cell = (TableView*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[TableView alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
		cell.lineColor = [UIColor blackColor];
    }
    
    
	// Configure the cell.
	cell.docTypeImage.text = @"docImage";
	cell.docName.text = @"%This Is A Document Name";
	cell.docType.text = @"Requirements Document";
    cell.docLastModified.text = @"January 31st, 2012";
    
    return cell;
}


/* Called when a request fails to be sent to the server and cannot retireve a resposne */

- (void)objectLoader:(RKObjectLoader *)objectLoader didFailWithError:(NSError *)error {
    
}

/* Called when objects are loaded from the server resposne */

- (void)objectLoader:(RKObjectLoader *)objectLoader didLoadObjects:(NSArray *)objects {
    Document *document;
    
   
    
    /* If the request is retreiving document information */
    if ([objectLoader.resourcePath isEqualToString:DOCUMENT_INFO]) {
        
        numOfDocuments = [objects count];                                                               /* Number of documents pulled down */
        
        for (int i = 0; i < [objects count]; i++) {
            document = [objects objectAtIndex:i];                                                       /* Load document object */
            [documentTypes setObject:document.type forKey:document.documentId];                          /* Store document type */
            [documentNames setObject:document.name forKey:document.documentId];                          /* Store document name */
            [contentFiles setObject:document.contentFile forKey:document.documentId];                    /* Store document content file */
            [datesModified setObject:document.dateLastModified forKey:document.documentId];              /* Store date last modified on document */
        }
        
        [self docInfoDidLoad];          
    }
    else {
        
    }
}

- (void) docInfoDidLoad {
    NSString *documentId = nil;                                                                         /* Document Id to be pasrsed to string */
    NSString *fileResourcePath = nil;                                                                   /* Resource path for rest call to document */
   
     NSLog(@"I am here now! %@", [documentNames valueForKey:@"1"]);
    
    /* Grab all document files */
   // for (int i = 1; i<=numOfDocuments; i++) {    
     //   documentId = [NSString stringWithFormat:@"%d", i];
       // fileResourcePath = [DOCUMENT_INFO stringByAppendingString:documentId];
        //fileResourcePath = [fileResourcePath stringByAppendingString:@"/file"];                         /* Format the request path */
        //[[RKObjectManager sharedManager] loadObjectsAtResourcePath:fileResourcePath 
          //                                              usingBlock:^(RKObjectLoader *loader) {
            //                                                loader.method = RKRequestMethodGET;
              //                                              loader.delegate = self;
                //                                        }];
   // }
    
}

@end
