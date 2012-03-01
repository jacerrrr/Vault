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

@synthesize filters;            /* UISegmentedControl buttons */

@synthesize documents;          /* The custom table view cells being used */
@synthesize mainView;

@synthesize nameButton;         /* Name button at top left-mid */
@synthesize typeButton;         /* Type button at top middle */
@synthesize dateButton;         /* Date button at top right */

@synthesize documentTypes;      /* Dictionary with all the document types for id */
@synthesize documentNames;      /* Dictionary with all the document names for id */
@synthesize datesModified;      /* Dates with all the last modified times for id */
@synthesize fileFormats;        /* Dictionary with all the file formats for id */
@synthesize documentPaths;      /* Dictionary will all the document paths for each file */

@synthesize numOfDocuments;     /* Integer counter for number of documents use has */
@synthesize currentDoc;         /* The current document counter for filter arrays */
@synthesize objResponseCount;   /* The count for the number of object response there are */

@synthesize namePressCount;
@synthesize typePressCount;
@synthesize datePressCount;

@synthesize recentDocsIds;      /* Array containing id's for all recent documents */
@synthesize favoriteDocsIds;    /* Array containing id's for all favorite documents */
@synthesize myDocumentDocsIds;  /* Array containing id's for all "my documents" documents */
@synthesize allDocIds;          /* Array containing all id's in documentNames dictionary */
@synthesize searchResults;      /* Array containing all id's for documents that match search words */

@synthesize filterIdentifier;   /* String which identifies which filter the user is currently on */
@synthesize searchFilterIdentifier;

@synthesize pdfData;            /* Data that is brought down and reset each time to store pdf's locally */

@synthesize sortedByName;       /* Array containing document id's sorted by name */
@synthesize sortedByType;       /* Array containing document id's sorted by type */
@synthesize sortedByDate;       /* Array containing document id's sorted by date */
@synthesize sortedFlags;
@synthesize sortedDateFlag, sortedNameFlag, sortedTypeFlag;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

/* Release any cached data, images, etc that aren't in use. */

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
}

#pragma mark - View lifecycle

- (void)viewDidLoad {
    
    /* Set the style for our table view */
    self.documents.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    /* Initialize all properties */
    
    /*Initialize dictionaries containing all document information */
    documentTypes = [[NSMutableDictionary alloc] 
                initWithDictionary:[Document loadDocInfoForKey:DOC_TYPES]];
    documentNames = [[NSMutableDictionary alloc] 
                initWithDictionary:[Document loadDocInfoForKey:DOC_NAMES]];
    datesModified = [[NSMutableDictionary alloc] 
                initWithDictionary:[Document loadDocInfoForKey:DATE_MOD]];
    fileFormats = [[NSMutableDictionary alloc] 
                initWithDictionary:[Document loadDocInfoForKey:FILE_FORMAT]];
    documentPaths = [[NSMutableDictionary alloc] initWithDictionary:[Document loadDocInfoForKey:DOC_PATHS]];
    
    /* Allocate data to be used for pdf binary */
    pdfData = [[NSMutableData alloc] init];
    
    /* Allocate each mutable array to be used for filtering */
    recentDocsIds = [[NSMutableArray alloc] 
                initWithArray:[Document loadFiltersForKey:RECENTS]];
    favoriteDocsIds = [[NSMutableArray alloc] 
                initWithArray:[Document loadFiltersForKey:FAVORITES]];
    myDocumentDocsIds = [[NSMutableArray alloc] 
                initWithArray:[Document loadFiltersForKey:MY_DOCUMENTS]];
    allDocIds = [[NSMutableArray alloc] initWithArray:[Document loadFiltersForKey:ALL_DOC_IDS]];
    searchResults = [[NSMutableArray alloc] init];
    
    /* Initialized sorting flags */
    sortedNameFlag = 0;
    sortedDateFlag = 0;
    sortedTypeFlag = 0;
    
    /* Initialized number of documents */
    numOfDocuments = [allDocIds count];
    
    /* Initialize class counters */
    currentDoc = 0;
    objResponseCount = 0;
    namePressCount = 0;
    typePressCount = 0;
    datePressCount = 0;
    
    /* Initilized dictionary to determine when to sort something */
    sortedFlags = [[NSMutableDictionary alloc] 
                   initWithObjectsAndKeys:@"0", @"documentTypes"
                   , @"0", @"datesModified"
                   , @"0", @"documentNames", nil];
    
    /* Set filter Identifier has not been set, set it to all documents */
    if (filterIdentifier == nil)
        filterIdentifier = MY_DOCUMENTS;

    searchFilterIdentifier = false;
    
    [super viewDidLoad];
}

/* Release any retained subviews of the main view. e.g. self.myOutlet = nil; */

- (void)viewDidUnload {
    
    /* Set all properties to nil for ARC */
    
    /* Remove our table view */
    documents = nil;
    
    /* Remove current instances of document information dictionaries */
    documentTypes = nil;
    documentNames = nil;
    datesModified = nil;
    fileFormats = nil;
    documentPaths = nil;
    
    /* Remove current instance of pdfData */
    pdfData = nil;
    
    /* Remove current instances of all filter arrays */
    recentDocsIds = nil;
    favoriteDocsIds = nil;
    myDocumentDocsIds = nil;
    allDocIds = nil;
    searchResults = nil;
    
    /* Set counters to 0 */
    numOfDocuments = 0;
    currentDoc = 0;
    objResponseCount = 0;
    
    /* Remove current instances of sortedFlags */
    sortedFlags = nil;
    
    /* Reset filter identifier to nil */
    filterIdentifier = nil;
    
    [super viewDidUnload];
}

- (void)viewWillAppear:(BOOL)animated {
    
    /* Sync documents if user just logged into Vault */
    if (needToSync == TRUE) {
        needToSync = FALSE;                                                         /* Reset sync global */
        NSString *session = [VaultUser loadSession];                                /* Load new session */
    
        /* Set the HTTP header to users session id for the "Authorization" paramter */
        [[RKObjectManager sharedManager].client setValue:session 
                                  forHTTPHeaderField:@"Authorization"];
      
        /* GET request to grab recent documents */
        [[RKObjectManager sharedManager] loadObjectsAtResourcePath:RECENTS          
                                                        usingBlock:^(RKObjectLoader *loader) {
                                                            loader.method = RKRequestMethodGET;
                                                            loader.delegate = self;
                                                        }];
        /* GET request to user documents */
        [[RKObjectManager sharedManager] loadObjectsAtResourcePath:MY_DOCUMENTS     
                                                    usingBlock:^(RKObjectLoader *loader) {
                                                        loader.method = RKRequestMethodGET;
                                                        loader.delegate = self;
                                                    }];
        /* GET request to grab favorite documents */
        [[RKObjectManager sharedManager] loadObjectsAtResourcePath:FAVORITES        
                                                    usingBlock:^(RKObjectLoader *loader) {
                                                        loader.method = RKRequestMethodGET;
                                                        loader.delegate = self;
                                                    }]; 
        
        /* Show activity indicator in ipad menu bar */
        [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    }
    
    [super viewWillAppear:animated];
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
   
    /* Return YES for supported orientations */
    return YES;                                                                 
}

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
    
    [mainView setNeedsDisplay];
    
    /* Going to Landscape Orientation */
    if (toInterfaceOrientation == UIInterfaceOrientationLandscapeRight
        || toInterfaceOrientation == UIInterfaceOrientationLandscapeLeft) {
        
        /* Reset locations of all sorting buttons */
        nameButton.frame = CGRectMake(DOCTYPEIMAGE_WIDTHLANDSCAPE, 44, DOCNAME_WIDTHLANDSCAPE, 36);
        typeButton.frame = CGRectMake(DOCTYPEIMAGE_WIDTHLANDSCAPE + DOCNAME_WIDTHLANDSCAPE, 44, DOCTYPE_WIDTHLANDSCAPE, 36);
        dateButton.frame = CGRectMake(DOCTYPEIMAGE_WIDTHLANDSCAPE + DOCNAME_WIDTHLANDSCAPE
                                      + DOCTYPE_WIDTHLANDSCAPE, 44, DOCLASTMODIFIED_WIDTHLANDSCAPE, 36);
        
        [self.documents reloadData];
        
    }
    
    else {  /* Going back to Portrait Orientation */
        
        /* Reset locations of all sorting buttons */
        nameButton.frame = CGRectMake(DOCTYPEIMAGE_WIDTH, 44, DOCNAME_WIDTH, 36);
        typeButton.frame = CGRectMake(DOCTYPEIMAGE_WIDTH + DOCNAME_WIDTH, 44, DOCTYPE_WIDTH, 36);
        dateButton.frame = CGRectMake(DOCTYPEIMAGE_WIDTH + DOCNAME_WIDTH + DOCTYPE_WIDTH, 44, DOCLASTMODIFIED_WIDTH, 36);
        
        [self.documents reloadData];
        
    }
}

/* Customize the number of sections in the Table View */

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	return 1;
}

/* Customize the number of visible cells depending on the orientation */
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if ([documentNames count] > 24)
        return [documentNames count];
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

/* Since the dictionaries start at 1, we want to hide the cell at row 0 */
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    /* Hide first cell */
    if(indexPath.row == 0){
        return 0.0f;
    }
    
    /* Show all other cells */
    else{
        return CELLHEIGHT;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TableView *cell = nil;
    NSString *docId = nil;
    NSString *fileType = nil;
    
    /* If there are files to load into table view */
    if ([fileFormats count] != 0 || fileFormats != nil) {
        
        if (searchFilterIdentifier == true) {
            if ((indexPath.row - 1 >= 0) &&
                (indexPath.row - 1 < [searchResults count])) {
                
                NSLog(@"Got in searchResults with indexPath %@\n",indexPath);
                docId = [searchResults objectAtIndex:indexPath.row -1];
            } else {
                NSLog(@"Got in the search else with indexPath %@\n",indexPath);
                docId = @"";
            }
        }
        
        else {
    
            /* Filter is set to My documents */
             if ([filterIdentifier isEqualToString:MY_DOCUMENTS] 
                     && (indexPath.row - 1 >= 0 
                     && indexPath.row - 1 < [myDocumentDocsIds count])) 
                docId = [myDocumentDocsIds objectAtIndex:indexPath.row - 1];
            
            /* Filter is set to Favorites */
            else if ([filterIdentifier isEqualToString:FAVORITES] 
                     && (indexPath.row - 1 >= 0 
                     && indexPath.row - 1 < [favoriteDocsIds count])) 
                docId = [favoriteDocsIds objectAtIndex:indexPath.row - 1];
                
            /* Filter is set to Recents */
            else if ([filterIdentifier isEqualToString:RECENTS] 
                     && (indexPath.row - 1 >= 0 
                         && indexPath.row - 1 < [recentDocsIds count])) 
                docId = [recentDocsIds objectAtIndex:indexPath.row - 1];
                    
            /* Filter is set to all documents */
            else if ([filterIdentifier isEqualToString:DOCUMENT_INFO] 
                     && indexPath.row - 1 >= 0 
                     && indexPath.row - 1 < [allDocIds count]) {
                docId = [allDocIds objectAtIndex:indexPath.row - 1];
                
            }
            /* There are no more documents to show */
            else
                docId = @"";
        }
        
        fileType = [fileFormats objectForKey:docId]; /* Get the format of the file */
        fileType = [fileType lastPathComponent];
        
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
        
        /* Determine if the user wants the documents sorted. Check to make sure there is a file
         * and determine what type of sorting the user wants.
         */
        if (fileType != nil) {                  /* Ensure there is a filepath */
            
            /* Sort by document names if user desires */
            if ([[sortedFlags objectForKey:@"documentNames"] isEqual:@"1"]) {
                id sorteddDocId = [sortedByName objectAtIndex:indexPath.row];
                docId = sorteddDocId;
                fileType = [fileFormats objectForKey:docId]; 
            }
            
            /* Sort by document types if user desires */
            else if ([[sortedFlags objectForKey:@"documentTypes"] isEqual:@"1"]) {
                //int sorteddDocId = [sortedByName indexOfObject:docId];
                //docId = [NSString stringWithFormat:@"%d", sorteddDocId];
                id sorteddDocId = [sortedByName objectAtIndex:indexPath.row];
                docId = sorteddDocId;
                fileType = [fileFormats objectForKey:docId]; 
            }
            
            /* Sort by dates if user desires */
            else if ([[sortedFlags objectForKey:@"datesModified"] isEqual:@"1"]) {
                id sorteddDocId = [sortedByName objectAtIndex:indexPath.row];
                docId = sorteddDocId;
                fileType = [fileFormats objectForKey:docId]; 
            }
            
            /* Set icon to a pdf icon if doucment is pdf document */
            if ([fileType isEqualToString:PDF_FORMAT]) 
                cell.docTypeImage.image = [UIImage imageNamed:PDF_IMG];
            
            /* Set icon to a word icon if document is word document */
            else if ([fileType isEqualToString:MSWORD_FORMAT]) 
                cell.docTypeImage.image = [UIImage imageNamed:DOC_IMG];
            
            /* Set icon to a powerpoint icon if document is powerpoint document */
            else if ([fileType isEqualToString:PPT_FORMAT])
                cell.docTypeImage.image = [UIImage imageNamed:PPT_IMG];
            
            /* Set icon to a excel icon if document is an excel document */
            else if ([fileType isEqualToString:XLS_FORMAT])
                cell.docTypeImage.image = [UIImage imageNamed:XLS_IMG];
            
            /* Do not know what file type the file is, display uknown document icon */
            else
                cell.docTypeImage.image = [UIImage imageNamed:UNKOWN_IMG];
        }
        
        /* There is no file to display */
        else
            cell.docTypeImage.image = nil;  /* Do not show an image */
        
        cell.docName.text = [documentNames objectForKey:docId];
        cell.docType.text = [documentTypes objectForKey:docId];
        cell.docLastModified.text = [Document 
                timeSinceModified:[datesModified objectForKey:docId]];
    }
    
    /* No files to load */
    else {
        cell.docName.text = @"";
        cell.docType.text = @"";
        cell.docLastModified.text = @"";
    }
            
    return cell;
}

/* Function called when a cell is clicked on by the user */

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (([filterIdentifier isEqualToString:MY_DOCUMENTS] && indexPath.row <= [myDocumentDocsIds count])
        || ([filterIdentifier isEqualToString:FAVORITES] && indexPath.row <= [favoriteDocsIds count])
        || ([filterIdentifier isEqualToString:RECENTS] && indexPath.row <= [recentDocsIds count])
        || ([filterIdentifier isEqualToString:DOCUMENT_INFO] && indexPath.row <= [allDocIds count])) {
        
        NSString *docNameText = nil;
        TableView *cell = ((TableView *)[tableView cellForRowAtIndexPath:indexPath]);
        
        docNameText = cell.docName.text;
        [DocViewController setFileNameToView:docNameText];
        
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
        UIViewController *pdfViewer = [storyboard instantiateViewControllerWithIdentifier:@"DocVC"];
        pdfViewer.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        [self presentModalViewController:pdfViewer animated:YES];
    }
    
}


/* Called when a request fails to be sent to the server and cannot retireve a response */

- (void)objectLoader:(RKObjectLoader *)objectLoader didFailWithError:(NSError *)error {
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    
}

/* Called when objects are loaded from the server resposne */

- (void)objectLoader:(RKObjectLoader *)objectLoader didLoadObjects:(NSArray *)objects {
    Document *document;
    objResponseCount++;
    
    /* The returned mapped objects are user documents */
    if ([objectLoader.resourcePath isEqualToString:MY_DOCUMENTS]) {
       
        for (int i = 0; i < [objects count]; i++) {
            document = [objects objectAtIndex:i];
          
            if ([documentNames objectForKey:document.documentId] == nil) {
                
                if ([myDocumentDocsIds count] > i)
                    [myDocumentDocsIds replaceObjectAtIndex:i withObject:document.documentId];  
                else
                    [myDocumentDocsIds insertObject:document.documentId atIndex:i];
                
                
                    [documentTypes setObject:document.type forKey:document.documentId];         /* Store document type */
                    [documentNames setObject:document.name forKey:document.documentId];         /* Store document name */
                    [fileFormats setObject:document.format forKey:document.documentId];         /* Store the content file name */
                    [datesModified setObject: [Document                                         /* Store date last modified on document */
                                    convertStringToDate:document.dateLastModified]             
                                    forKey:document.documentId];   
            }
            
            else {
                
                if ([myDocumentDocsIds count] > i)
                    [myDocumentDocsIds replaceObjectAtIndex:i withObject:document.documentId];  
                else
                    [myDocumentDocsIds insertObject:document.documentId atIndex:i];
                
            }
        }
        [Document saveFilters:myDocumentDocsIds forKey:MY_DOCUMENTS];
    }
    
    /* The returned mapped objects are favorite documents */
    else if ([objectLoader.resourcePath isEqualToString:FAVORITES]) {
    
        for (int i = 0; i < [objects count]; i++) {
            document = [objects objectAtIndex:i];
            
            if ([documentNames objectForKey:document.documentId] == nil) {
            
                if ([favoriteDocsIds count] > i)
                    [favoriteDocsIds replaceObjectAtIndex:i withObject:document.documentId];
                   
                else
                    [favoriteDocsIds insertObject:document.documentId atIndex:i];
                
                
                [documentTypes setObject:document.type forKey:document.documentId];         /* Store document type */
                [documentNames setObject:document.name forKey:document.documentId];         /* Store document name */
                [fileFormats setObject:document.format forKey:document.documentId];         /* Store the content file name */
                [datesModified setObject: [Document                                         /* Store date last modified on document */
                                    convertStringToDate:document.dateLastModified]             
                                    forKey:document.documentId];   
            }
            
            else {
                if ([favoriteDocsIds count] > i)
                    [favoriteDocsIds replaceObjectAtIndex:i withObject:document.documentId];
                
                else
                    [favoriteDocsIds insertObject:document.documentId atIndex:i];
            }
                
        }
        
        [Document saveFilters:favoriteDocsIds forKey:FAVORITES];
    }
    
    /* The returned mapped documents are recent documents */
    else if ([objectLoader.resourcePath isEqualToString:RECENTS]) {
        
        
        for (int i = 0; i < [objects count]; i++) {
            document = [objects objectAtIndex:i];
          
            if ([documentNames objectForKey:document.documentId] == nil) {
            
                if ([recentDocsIds count] > i)
                    [recentDocsIds replaceObjectAtIndex:i withObject:document.documentId];            
                else
                    [recentDocsIds insertObject:document.documentId atIndex:i];
                
                [documentTypes setObject:document.type forKey:document.documentId];         /* Store document type */
                [documentNames setObject:document.name forKey:document.documentId];         /* Store document name */
                [fileFormats setObject:document.format forKey:document.documentId];         /* Store the content file name */
                [datesModified setObject: [Document                                         /* Store date last modified on document */
                            convertStringToDate:document.dateLastModified]             
                            forKey:document.documentId]; 
            }
            
            else {
                
                if ([recentDocsIds count] > i)
                    [recentDocsIds replaceObjectAtIndex:i withObject:document.documentId];            
                else
                    [recentDocsIds insertObject:document.documentId atIndex:i];
                
            }
        }
        
        [Document saveFilters:recentDocsIds forKey:RECENTS];
    }
    
    /* Every object has been retrieved */
    if (objResponseCount == LAST_DOC_OBJ_REQ) {
        objResponseCount = 0;
        
        [allDocIds removeAllObjects];
        
        for (NSString *dId in documentNames) 
            [allDocIds addObject:dId];
        
        /* Save the newly populated dictionaries NSUserDefaults */
        [Document saveDocInfo:documentTypes forKey:DOC_TYPES];
        [Document saveDocInfo:documentNames forKey:DOC_NAMES];
        [Document saveDocInfo:fileFormats forKey:FILE_FORMAT];
        [Document saveDocInfo:datesModified forKey:DATE_MOD];
        
        [Document saveFilters:allDocIds forKey:ALL_DOC_IDS];
        
        numOfDocuments = [allDocIds count];
        
        currentDoc = 0;
        [self sendPdfRequest];    
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
    NSString *pdfName = [documentNames                                                  /* Retrieve documents file name */
            objectForKey:[allDocIds objectAtIndex:currentDoc]];   
    NSString *docPath = [Document savePDF:pdfData withFileName:pdfName];                /* Document path */
    
    [documentPaths setObject:docPath forKey:[allDocIds objectAtIndex:currentDoc]];                               /* Save the file path */
    
    currentDoc++;                                                                     /* Increment document count */
    if (currentDoc < numOfDocuments) {
        [self sendPdfRequest];
    }
    
    else {
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        [Document saveDocInfo:documentPaths forKey:DOC_PATHS];                          /* Save paths to NSUserDefaults */
        [self.documents reloadData];
    }
}

/* This will be called every time the text in the search bar is manipulated */

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    
    /* The text in the search bar has been manipulated. The old search results are no longer relevant
     *so searchResults needs to be emptied 
     */
    [searchResults removeAllObjects];
    
    searchFilterIdentifier = true;
    
    NSLog(@"Search text is %@", searchText);
    /* NSString containing the name of the current document from documentNames */
    NSString *document_name = nil;
    
    /* NSRange to test if searchText is a substring of a document_name */
    NSRange textRange;
    /*
     * If filterIdentifier is set to My Documents, iterate through myDocumentDocsIds to find substrings
     */
    if ([filterIdentifier isEqualToString:MY_DOCUMENTS]) {
        for (NSString *key in myDocumentDocsIds) {
            
            /* Store current document name */
            document_name = [documentNames objectForKey:key];
            
            /* Use rangeOfString to search for searchText in document_name
             Both strings are converted to lowercase first to inforce case insensitivity */
            textRange = [[document_name lowercaseString] rangeOfString:[searchText lowercaseString]];
            
            /* If not NSNotFound then we know that searchText is a substring of document_name */
            if (textRange.location != NSNotFound) {
                
                /* We found a match, now we need to add it to searchResults NSMutableArray */
                NSLog(@"My Document filter\n%@ is a substring of %@\n with key = %@\n", searchText, document_name, key);
                
                [self.searchResults addObject:key];
            }
            
        }
        
    }
    
    /*
     * If filter is set to Favorites, iterate through favoriteDocsIds to find substrings
     */
    else if ([filterIdentifier isEqualToString:FAVORITES]) {
        for (NSString *key in favoriteDocsIds) {
            
            /* Store current document name */
            document_name = [documentNames objectForKey:key];
            
            /* Use rangeOfString to search for searchText in document_name
             Both strings are converted to lowercase first to inforce case insensitivity */
            textRange = [[document_name lowercaseString] rangeOfString:[searchText lowercaseString]];
            
            /* If not NSNotFound then we know that searchText is a substring of document_name */
            if (textRange.location != NSNotFound) {
                
                /* We found a match, now we need to add it to searchResults NSMutableArray */
                NSLog(@"Favorite filter\n%@ is a substring of %@\n with key = %@\n", searchText, document_name, key);
                
                [self.searchResults addObject:key];
            }
            
        }
        
    }
    
    /* Filter is set to Recents */
    else if ([filterIdentifier isEqualToString:RECENTS]) {
        for (NSString *key in recentDocsIds) {
            
            /* Store current document name */
            document_name = [documentNames objectForKey:key];
            
            /* Use rangeOfString to search for searchText in document_name
             Both strings are converted to lowercase first to inforce case insensitivity */
            textRange = [[document_name lowercaseString] rangeOfString:[searchText lowercaseString]];
            
            /* If not NSNotFound then we know that searchText is a substring of document_name */
            if (textRange.location != NSNotFound) {
                
                /* We found a match, now we need to add it to searchResults NSMutableArray */
                NSLog(@"Recent filter\n%@ is a substring of %@\n with key = %@\n", searchText, document_name, key);
                
                [self.searchResults addObject:key];
            }
            
        }
        
    }
    else {
        /* For each loop that iterates through each index of documentNames and checks for the substring searchText */
        for (NSString *key in documentNames) {
            
            /* Store current document name */
            document_name = [documentNames objectForKey:key];
            
            /* Use rangeOfString to search for searchText in document_name
             Both strings are converted to lowercase first to inforce case insensitivity */
            textRange = [[document_name lowercaseString] rangeOfString:[searchText lowercaseString]];
            
            /* If not NSNotFound then we know that searchText is a substring of document_name */
            if (textRange.location != NSNotFound) {
                
                /* We found a match, now we need to add it to searchResults NSMutableArray */
                NSLog(@"All documents filter\n%@ is a substring of %@\n with key = %@\n", searchText, document_name, key);
                
                [self.searchResults addObject:key];
            }
            
        }
    }
    //NSInteger num = [searchResults count];
    if ([searchResults count] == 0) {
        NSLog(@"searchResults is empty\n");
    } else {
        NSLog(@"search count = %@\n", searchResults);
    }
    if ([searchText isEqualToString:@""]) {
        searchFilterIdentifier = false;
    }
    [documents reloadData];
}


- (void) sendPdfRequest {
    
    NSString *fileResourcePath = BASE_URL;                /* Resource path for rest call to document */
    
    NSMutableURLRequest *pdfRequest = [[NSMutableURLRequest alloc] init];
    NSURLConnection *pdfConnect = [NSURLConnection alloc];
    
    /* Set up the resource path to grab the pdf from */
    fileResourcePath = [fileResourcePath stringByAppendingString:DOCUMENT_INFO];
    fileResourcePath = [fileResourcePath stringByAppendingString:[allDocIds objectAtIndex:currentDoc]];
    fileResourcePath = [fileResourcePath stringByAppendingString:RENDITIONS];

    /* Set up a request to be sent for the binary PDF file */
    pdfRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:fileResourcePath]];
    [pdfRequest setValue:[VaultUser loadSession] forHTTPHeaderField:@"Authorization"];
    [pdfRequest setHTTPMethod:@"GET"];
    pdfConnect = [NSURLConnection connectionWithRequest:pdfRequest delegate:self];  /* Send request */
    
}

- (IBAction)filterPressed:(id)sender {
    
    if (filters.selectedSegmentIndex == MY_DOCS_FILTER) 
        filterIdentifier = MY_DOCUMENTS;
      
    else if (filters.selectedSegmentIndex == FAV_FILTER) 
        filterIdentifier = FAVORITES;
    
    else if (filters.selectedSegmentIndex == RECENT_FILTER) 
        filterIdentifier = RECENTS;
    
    else if (filters.selectedSegmentIndex == ALL_DOCS_FILTER) 
        filterIdentifier = DOCUMENT_INFO;
        
    [self.documents reloadData];
}

- (IBAction)sortByName:(id)sender{
    
    dateButton.imageView.image = nil;
    typeButton.imageView.image = nil;
    
    if (namePressCount % 2 == 0) {
        [nameButton setImageEdgeInsets:UIEdgeInsetsMake(0, 120, 2, 0)];
        [nameButton setImage:[UIImage imageNamed:SORT_UP] forState:UIControlStateNormal];
    }
    else {
        [nameButton setImageEdgeInsets:UIEdgeInsetsMake(5, 120, 0, 0)];
        [nameButton setImage:[UIImage imageNamed:SORT_DOWN] forState:UIControlStateNormal];
    }
    
    namePressCount++;
        
    [sortedFlags setObject:@"0" forKey:@"documentTypes"];
    [sortedFlags setObject:@"0" forKey:@"datesModified"];
    [sortedFlags setObject:@"1" forKey:@"documentNames"];
    if (sortedNameFlag == 0) {
    sortedByName = [documentNames keysSortedByValueUsingSelector:@selector(caseInsensitiveCompare:)];
    [self.documents reloadData];
        sortedNameFlag = 1;
    }
    else if (sortedNameFlag == 1){
        sortedByName = [[sortedByName reverseObjectEnumerator] allObjects];
        [self.documents reloadData];
        sortedNameFlag = 0;
    }
    
}

- (IBAction)sortByDateModified:(id)sender{
    
    nameButton.imageView.image = nil;
    typeButton.imageView.image = nil;
    
    if (datePressCount % 2 == 0) {
        [dateButton setImageEdgeInsets:UIEdgeInsetsMake(0, 105, 2, 0)];
        [dateButton setImage:[UIImage imageNamed:SORT_UP] forState:UIControlStateNormal];
    }
    else {
        [dateButton setImageEdgeInsets:UIEdgeInsetsMake(5, 105, 0, 0)];
        [dateButton setImage:[UIImage imageNamed:SORT_DOWN] forState:UIControlStateNormal];
    }
    
    datePressCount++;
    
    [sortedFlags setObject:@"0" forKey:@"documentTypes"];
    [sortedFlags setObject:@"1" forKey:@"datesModified"];
    [sortedFlags setObject:@"0" forKey:@"documentNames"];
    if(sortedDateFlag == 0){
        sortedByDate = [datesModified keysSortedByValueUsingSelector:@selector(compare:)];
        [self.documents reloadData];
        sortedDateFlag = 1;
    } else if (sortedDateFlag == 1){
        sortedByDate = [[sortedByDate reverseObjectEnumerator] allObjects];
        [self.documents reloadData];
        sortedDateFlag = 0;
    }
}

- (IBAction)sortbyType:(id)sender {
    
    nameButton.imageView.image = nil;
    typeButton.imageView.image = nil;
    
    if (typePressCount % 2 == 0) {
        [typeButton setImageEdgeInsets:UIEdgeInsetsMake(0, 105, 1, 0)];
        [typeButton setImage:[UIImage imageNamed:SORT_UP] forState:UIControlStateNormal];
    }
    else {
        [typeButton setImageEdgeInsets:UIEdgeInsetsMake(5, 105, 0, 0)];
        [typeButton setImage:[UIImage imageNamed:SORT_DOWN] forState:UIControlStateNormal];
    }
    
    typePressCount++;
    
    [sortedFlags setObject:@"1" forKey:@"documentTypes"];
    [sortedFlags setObject:@"0" forKey:@"datesModified"];
    [sortedFlags setObject:@"0" forKey:@"documentNames"];
    if (sortedTypeFlag == 0) {
        sortedByType = [documentTypes keysSortedByValueUsingSelector:@selector(caseInsensitiveCompare:)];
        [self.documents reloadData];
        sortedTypeFlag = 1;
    }
    else if (sortedTypeFlag == 1){
        sortedByType = [[sortedByType reverseObjectEnumerator] allObjects];
        [self.documents reloadData];
        sortedTypeFlag = 0;
    }
}

@end
