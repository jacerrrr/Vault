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

@synthesize filters;

@synthesize documents;
@synthesize documentTypes;
@synthesize documentNames;
@synthesize datesModified;
@synthesize numOfDocuments;
@synthesize contentFiles;
@synthesize documentPaths;
@synthesize recentDocsIds;
@synthesize favoriteDocsIds;
@synthesize myDocumentDocsIds;
@synthesize filterIdentifier;
@synthesize pdfData;
@synthesize currentDocId;

/* Release any cached data, images, etc that aren't in use. */

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
}

#pragma mark - View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.documents.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    documentTypes = [[NSMutableDictionary alloc] 
                initWithDictionary:[Document loadDocInfoForKey:DOC_TYPES]];
    documentNames = [[NSMutableDictionary alloc] 
                initWithDictionary:[Document loadDocInfoForKey:DOC_NAMES]];
    datesModified = [[NSMutableDictionary alloc] 
                initWithDictionary:[Document loadDocInfoForKey:DATE_MOD]];
    
    contentFiles = [[NSMutableDictionary alloc] 
                initWithDictionary:[Document loadDocInfoForKey:CONTENT_F]];
    
    pdfData = [[NSMutableData alloc] init];
    
    recentDocsIds = [[NSMutableArray alloc] initWithArray:[Document loadFiltersForKey:RECENTS]];
    favoriteDocsIds = [[NSMutableArray alloc] initWithArray:[Document loadFiltersForKey:FAVORITES]];
    myDocumentDocsIds = [[NSMutableArray alloc] initWithArray:[Document loadFiltersForKey:MY_DOCUMENTS]];
    
    
    
}

/* Release any retained subviews of the main view. e.g. self.myOutlet = nil; */

- (void)viewDidUnload {
    [super viewDidUnload];
    
    documentTypes = nil;
    documentNames = nil;
    datesModified = nil;
    pdfData = nil;
    numOfDocuments = 0;
    currentDocId = 0;
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    /* Sync documents if user just logged into Vault */
    if (needToSync == TRUE) {
        needToSync = FALSE;
        NSString *session = [VaultUser loadSession];                               /* Load new session */
    
        [[RKObjectManager sharedManager].client setValue:session 
                                  forHTTPHeaderField:@"Authorization"];
      
        [[RKObjectManager sharedManager] loadObjectsAtResourcePath:DOCUMENT_INFO/* GET request to grab document information */
                                                        usingBlock:^(RKObjectLoader *loader) {
                                                            loader.method = RKRequestMethodGET;
                                                            loader.delegate = self;
                                                        }];
        
        [[RKObjectManager sharedManager] loadObjectsAtResourcePath:MY_DOCUMENTS   /* GET request to grab document information */
                                                    usingBlock:^(RKObjectLoader *loader) {
                                                        loader.method = RKRequestMethodGET;
                                                        loader.delegate = self;
                                                    }];
    
        [[RKObjectManager sharedManager] loadObjectsAtResourcePath:FAVORITES      /* GET request to grab document information */
                                                    usingBlock:^(RKObjectLoader *loader) {
                                                        loader.method = RKRequestMethodGET;
                                                        loader.delegate = self;
                                                    }]; 
    
        [[RKObjectManager sharedManager] loadObjectsAtResourcePath:RECENTS      /* GET request to grab document information */
                                                    usingBlock:^(RKObjectLoader *loader) {
                                                        loader.method = RKRequestMethodGET;
                                                        loader.delegate = self;
                                                    }];
    
        [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
        
        
    }
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
    
    return YES;                                                                     /* Return YES for supported orientations */
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

/* Customize the number of visible cells depending on the orientation */
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    if ([[UIDevice currentDevice] orientation] == UIDeviceOrientationPortrait || 
        [[UIDevice currentDevice] orientation] == UIDeviceOrientationPortraitUpsideDown)
        return PORTRAIT_COUNT;
    
    else  
        return LANDSCAPE_COUNT;
    
	
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

/* Since the dictionaries start at 1, we want to hide the cell at row 0 */
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.row == 0){
        return 0.0f;
    }
    else{
        return 44.0f;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TableView *cell = nil;
    NSString *docId = nil;
    NSLog(@"Index path is %d", indexPath.row);
    if ([contentFiles count] != 0) {
        if ([filterIdentifier isEqualToString:MY_DOCUMENTS] 
                && (indexPath.row - 1 >= 0 
                && indexPath.row - 1 < [myDocumentDocsIds count])) 
            docId = [myDocumentDocsIds objectAtIndex:indexPath.row - 1];
        
        else if ([filterIdentifier isEqualToString:FAVORITES] 
                && (indexPath.row - 1 >= 0 
                && indexPath.row < [favoriteDocsIds count])) 
            docId = [favoriteDocsIds objectAtIndex:indexPath.row - 1];
            
        else if ([filterIdentifier isEqualToString:RECENTS] 
                && (indexPath.row - 1 >= 0 
                && indexPath.row < [recentDocsIds count])) 
            docId = [recentDocsIds objectAtIndex:indexPath.row - 1];
            
        else {
            
            if ([filterIdentifier isEqualToString:MY_DOCUMENTS] 
                || [filterIdentifier isEqualToString:FAVORITES] 
                || [filterIdentifier isEqualToString:RECENTS]) {
                docId = @"11111111";
            }
            else
                docId = [NSString stringWithFormat:@"%d", indexPath.row];
        }
        
        NSString *fileType = [contentFiles objectForKey:docId]; /* Get the full name of the file */
         NSLog(@"File is %@", fileType);
        
        static NSString *CellIdentifier;
        
        
        if ([[UIApplication sharedApplication] statusBarOrientation ] == UIInterfaceOrientationPortrait || [[UIApplication sharedApplication] statusBarOrientation] == UIInterfaceOrientationPortraitUpsideDown){
            CellIdentifier = @"PortraitCell";
        }else {
            CellIdentifier = @"LandscapeCell";
        }
        
        
        cell = (TableView*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell = [[TableView alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            cell.lineColor = [UIColor blackColor];
        }
        
        
        if ([fileType pathExtension] == nil) {
            /* Leave everything blank */
        }
        else if ([[fileType pathExtension] caseInsensitiveCompare:@"pdf"] == NSOrderedSame) {  
            cell.imageView.image = [UIImage imageNamed:PDF];
                
        }
        else if ([[fileType pathExtension] caseInsensitiveCompare:@"doc"] 
                 == NSOrderedSame 
                 || [[fileType pathExtension] caseInsensitiveCompare:@"docx"] 
                 == NSOrderedSame){
            cell.imageView.image = [UIImage imageNamed:DOC];
        }
        else if ([[fileType pathExtension] caseInsensitiveCompare:@"ppt"] 
                 == NSOrderedSame 
                 || [[fileType pathExtension] caseInsensitiveCompare:@"pptx"] 
                 == NSOrderedSame){
            cell.imageView.image = [UIImage imageNamed:PPT];
        }
        else if ([[fileType pathExtension] caseInsensitiveCompare:@"xls"] 
                 == NSOrderedSame 
                 || [[fileType pathExtension] caseInsensitiveCompare:@"xlsx"] 
                 == NSOrderedSame){
            cell.imageView.image = [UIImage imageNamed:XLS];
        }
            
        cell.docName.text = [documentNames objectForKey:docId];
        cell.docType.text = [documentTypes objectForKey:docId];
        cell.docLastModified.text = [datesModified objectForKey:docId];
        //NSLog(@"%@", [datesModified objectForKey:docId]);
    }
            
    return cell;
}


/* Called when a request fails to be sent to the server and cannot retireve a response */

- (void)objectLoader:(RKObjectLoader *)objectLoader didFailWithError:(NSError *)error {
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    
}

/* Called when objects are loaded from the server resposne */

- (void)objectLoader:(RKObjectLoader *)objectLoader didLoadObjects:(NSArray *)objects {
    Document *document;
    
    if ([objectLoader.resourcePath isEqualToString:MY_DOCUMENTS]) {
        
        for (int i = 0; i < [objects count]; i++) {
            document = [objects objectAtIndex:i];
            [myDocumentDocsIds insertObject:document.documentId atIndex:i];
        }
        
        [Document saveFilters:recentDocsIds forKey:MY_DOCUMENTS];
    }
    
    else if ([objectLoader.resourcePath isEqualToString:FAVORITES]) {
       
        for (int i = 0; i < [objects count]; i++) {
            document = [objects objectAtIndex:i];
            [favoriteDocsIds insertObject:document.documentId atIndex:i];
        }
        
        [Document saveFilters:favoriteDocsIds forKey:FAVORITES];
    }
    
    else if ([objectLoader.resourcePath isEqualToString:RECENTS]) {
        
        for (int i = 0; i < [objects count]; i++) {
            document = [objects objectAtIndex:i];
            [recentDocsIds insertObject:document.documentId atIndex:i];
        }
        
        [Document saveFilters:recentDocsIds forKey:RECENTS];
    }
        
    else {
        
        numOfDocuments = [objects count];                                               /* Number of documents pulled down */
        
        for (int i = 0; i < [objects count]; i++) {
            document = [objects objectAtIndex:i];                                       /* Load document object */
            [documentTypes setObject:document.type forKey:document.documentId];         /* Store document type */
            [documentNames setObject:document.name forKey:document.documentId];         /* Store document name */
            [contentFiles setObject:document.contentFile forKey:document.documentId];   /* Store the content file name */
            [datesModified setObject:document.dateLastModified forKey:document.documentId];             /* Store date last modified on document */
                           
        }
        
        /* Save the newly populated dictionaries NSUserDefaults */
        [Document saveDocInfo:documentTypes forKey:DOC_TYPES];
        [Document saveDocInfo:documentNames forKey:DOC_NAMES];
        [Document saveDocInfo:contentFiles forKey:CONTENT_F];
        [Document saveDocInfo:datesModified forKey:DATE_MOD];
       
        currentDocId = 1;                                                               /* Set counter to first document */
        [self sendPdfRequest];                                                          /* Load pdf binarys from Vault server */
    }
}

/* Function that resets the data before PDF data is recieved request. */

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    
    [pdfData setLength:0];
    
}

/* Retrieves all binary data from the pdf retrieved from Vault server. */

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {

    [pdfData appendData:data];                                                          /* Append all data for each request */
}

/* 
 * After the connection is completed with response, save the pdf file to the iPad 
 * and prepare to recieve the next pdf binary data. 
 */
 
- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    
    /* Convert current document Id to a string to use for retrieving the name of the file */
    NSString *docIdString = [NSString stringWithFormat:@"%d", currentDocId];
    NSString *pdfName = [documentNames objectForKey:docIdString];                       /* Retrieve documents file name */
    NSString *docPath = nil;                                                            /* Document path */
    
    docPath = [Document savePDF:pdfData withFileName:pdfName];                          /* Save PDF and get saved path */
    
    [documentPaths setObject:docPath forKey:docIdString];                               /* Save the file path */
    
    currentDocId++;                                                                     /* Increment document count */
    if (currentDocId <= numOfDocuments) {
        [self sendPdfRequest];
    }
    
    else {
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        [Document saveDocInfo:documentPaths forKey:DOC_PATHS];                          /* Save paths to NSUserDefaults */
    }
}

- (void) sendPdfRequest {
    NSString *documentId = nil;                                                         /* Document Id to be pasrsed to string */
    NSString *fileResourcePath = @"https://vv1.veevavault.com/api/v1.0";                /* Resource path for rest call to document */
    
    NSMutableURLRequest *pdfRequest = [[NSMutableURLRequest alloc] init];
    NSURLConnection *pdfConnect = [NSURLConnection alloc];
    
    
    /* Set up the resource path to grab the file from */
    documentId = [NSString stringWithFormat:@"/%d", currentDocId];
    fileResourcePath = [fileResourcePath stringByAppendingString:DOCUMENT_INFO];
    fileResourcePath = [fileResourcePath stringByAppendingString:documentId];
    fileResourcePath = [fileResourcePath stringByAppendingString:RENDITIONS];
    
    /* Set up a request to be sent for the binary PDF file */
    pdfRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:fileResourcePath]];
    [pdfRequest setValue:[VaultUser loadSession] forHTTPHeaderField:@"Authorization"];
    [pdfRequest setHTTPMethod:@"GET"];
    pdfConnect = [NSURLConnection connectionWithRequest:pdfRequest delegate:self];  /* Send request */
    
}

- (IBAction)filterPressed:(id)sender {
    
    if (filters.selectedSegmentIndex == 0) {
        filterIdentifier = nil;
        [self.documents reloadData];
    }
    else if (filters.selectedSegmentIndex == 1) {
        filterIdentifier = MY_DOCUMENTS;
        [self.documents reloadData];
    }
    else if (filters.selectedSegmentIndex == 3) {
        filterIdentifier = FAVORITES;
        [self.documents reloadData];
    }
    else if (filters.selectedSegmentIndex == 4) {
        filterIdentifier = RECENTS;
        [self.documents reloadData];
    }
}

@end
