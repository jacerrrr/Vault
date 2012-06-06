/* 
 * Document.m
 * Vault
 *
 * Created by Jace Allison on February 15, 2012
 * Last modified on May 24, 2012 by Jace Allison
 *
 * Copyright © 2011-2012 Veeva Systems. All rights reserved.
 *
 * FILE DESCRIPTION
 *
 * This file contains properties which map to JSON objects returned from Vault when requesting a
 * document.  These properties can then be stored programmatically.  This class also contains functions
 * that perform tasks on documents, such as saving and loading documents locally,saving and loading document
 * information, and converting dates to strings.
 *
 ************************************************
 * EXAMPLE FOR JSON OBJECT MAPPING FOR DOCUMENT:
 ************************************************
 *
 * {"responseStatus":"SUCCESS",
 * "size":13,
 * "start":0,
 * "documents":[{
 * "document":{
 * "id":1,
 * "document_number__v":"00001",
 * "product__v":["1"],
 * "country_b":[],
 * "lifecycle__v":"General Lifecycle",
 * "created_by__v":977,
 * "document_creation_date__v":"2011-10-12T00:08:04.363Z",
 * "document_last_modified_by__v":977,
 * "document_modified_date__v":"2011-10-12T00:09:59.021Z",
 * "reviewer__v":{"users":[],
 * "groups":[]},
 * "viewer__v":{
 * "users":[],
 * "groups":[1]},
 * "distribution_contacts__v":{
 * "users":[],
 * "groups":[]},
 * "consumer__v":{
 * "users":[],
 * "groups":[]},
 * "approver__v":{
 * "users":[],
 * "groups":[]},
 * "editor__v":{
 * "users":[],
 * "groups":[]},
 * "owner__v":{
 * "users":[977],
 * "groups":[]},
 * "coordinator__v":{
 * "users":[],
 * "groups":[]},
 * "type__v":"Requirements",
 * "version_modified_date__v":"2011-10-12T00:09:59.021Z",
 * "size__v":118631,
 * "classification__v":"",
 * "last_modified_by__v":977,
 * "name__v":"Original Project Submission",
 * "version_created_by__v":977,
 * "major_version_number__v":1,
 * "status__v":"Approved",
 * "minor_version_number__v":0,
 * "version_creation_date__v":"2011-10-12T00:08:04.363Z",
 * "subtype__v":"",
 * "format__v":"application/pdf"}}
 *
 ********************************************************
 */

#import "Document.h"

@implementation Document

@synthesize documentId;                                     /* Vault Document id */
@synthesize type;                                           /* Vault Document type */
@synthesize name;                                           /* Vault Document name */
@synthesize format;                                         /* Vault Document format */
@synthesize dateLastModified;                               /* Vault Docment last modified date */
@synthesize title;                                          /* Vault Document title */
@synthesize docNumber;                                      /* Vault Document document number */
@synthesize size;                                           /* Vault Document size in KB */
@synthesize majorVNum;                                      /* Vault Document major version number */
@synthesize minorVNum;                                      /* Vault Document minor version number */
@synthesize lifecycle;                                      /* Vault Document lifecycle */
@synthesize status;                                         /* Vault Document status */
@synthesize owner;                                          /* Vault Document owner */
@synthesize lastModifier;                                   /* Vault Document last modified date */

/* Function that takes binary PDF data and a file name as parameters, and determines
 * if the PDF data from the parameter is the same as the PDF data already stored.
 * If it is not the same, the function overwrites the old PDF data with the new
 * PDF data.  The function returns where the path string 
 *
 * PARAMETER(S)
 *
 * (NSData *)newPdfContent              Data of pdf to be saved
 * (NSString *)fileName                 Filename of pdf to be saved
 *
 * RETURN VALUE(S)
 *
 * (NSString *)                         A String that contains the final path
 */

+ (NSString *)savePDF:(NSData *)newPdfContent withFileName:(NSString *)fileName {
    NSArray *paths = NSSearchPathForDirectoriesInDomains
            (NSDocumentDirectory, NSUserDomainMask ,YES );      /* Get the path array for directories */
   
    NSString *documentsDirectory = [paths objectAtIndex:0];     /* Get the documents path as a string */
    NSString *finalPath = [documentsDirectory 
            stringByAppendingPathComponent:fileName];           /* Get the full path, including file name */
    
    NSData *currentPDF = nil;                                   /* Data object to be used later */
    
    /* Change the file path to have a file extension .pdf */
    finalPath = [finalPath stringByDeletingPathExtension];
    finalPath = [finalPath stringByAppendingPathExtension:@"pdf"];
    currentPDF = [NSData dataWithContentsOfFile:finalPath];     /* Created data object to have the current PDF data */ 
    
    /* Determine if the data of the current PDF and the new PDF are the same */
    if (!([currentPDF isEqualToData:newPdfContent])
            || currentPDF == nil) {                             /* Data is not the same */
        
        [newPdfContent writeToFile:finalPath atomically:YES];   /* Save the new data */
    }
    
    return finalPath;
    
}

/* Function that returns the filepath of a pdf on the iPad given a PDF Name.
 *
 * PARAMETER(S)
 *
 *  (NSString *)pdfName                 Name of a pdf from Vault
 *
 * RETURN VALUE(S)
 *
 *  (NSString *)                        A string that holds the path of the pdf given by the parameter
 */

+ (NSString *)loadPDF:(NSString *)pdfName {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *pdfFilePath = [documentsDirectory stringByAppendingPathComponent:pdfName];
    
    pdfFilePath = [pdfFilePath stringByDeletingPathExtension];
    pdfFilePath = [pdfFilePath stringByAppendingPathExtension:@"pdf"];
    
    return pdfFilePath;
}

/* Function that saves document information in dictionary form to NSUserDefaults for later use.
 *
 * PARAMETER(S)
 *
 *  (NSMutableDictionary *)infoToSave   A Dictionary to save to NSUserDefaults
 *  (NSString *)key                     The key that will retreive the dictionary for later use
 */

+ (void)saveDocInfo:(NSMutableDictionary *)infoToSave forKey:(NSString *)key {
    NSUserDefaults *standardDefaults = [NSUserDefaults standardUserDefaults];
    
    if (standardDefaults) {
        [standardDefaults setObject:infoToSave forKey:key];
        [standardDefaults synchronize];
    }
    
}

/* Function that loads a dictionary for a key given to the NSUserDefaults.
 *
 * PARAMETER(S)
 *
 *  (NSString *)key                     The key that will retreive the dictionary for later use
 *
 * RETURN VALUE(S)
 *
 *  (NSMutableDictionary *)infoToSave   A Dictionary to retrieve from NSUserDefaults
 */

+ (NSMutableDictionary *)loadDocInfoForKey:(NSString *)key {
    NSUserDefaults *standardDefaults = [NSUserDefaults standardUserDefaults];
    
    return [standardDefaults objectForKey:key];
    
}

/* 
 * Function that loads an array for a key given to the NSUserDefaults. 
 *
 * PARAMETER(S)
 *
 *  (NSMutableArray *)array             An array to save to NSUserDefaults
 *  (NSString *)key                     The key to save in user defaults for the filter
 */

+ (void)saveFilters:(NSMutableArray *)array forKey:(NSString *)filterName {
    NSUserDefaults *standardDefaults = [NSUserDefaults standardUserDefaults];
    
    if (standardDefaults) {
        [standardDefaults setObject:array forKey:filterName];
        [standardDefaults synchronize];
    }
}

/* Function that loads an array for a key given to the NSUserDefaults
 *
 * PAREMETER(S)
 *
 *  (NSString *)key                     A key to retrieve an array from the dictionary
 *
 * RETURN VALUE(S)
 *
 * (NSMutableArray *)loadFiltersForKey  An array that is returned for a specific key given in the parameter
 */

+ (NSMutableArray *)loadFiltersForKey:(NSString *)key {
    NSUserDefaults *standardDefaults = [NSUserDefaults standardUserDefaults];
    
    return [standardDefaults objectForKey:key];
}

/* Convert A String into an NSDate for iOS. 
 * 
 * PAREMETER(S)
 *
 *  (NSString *)dateString              A string that represents a date
 *
 * RETURN VALUE(S)
 *
 *  (NSDate *)                          A date the is returned after formatted from string
 */

+ (NSDate *)convertStringToDate:(NSString *)dateString{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateStyle:NSDateFormatterNoStyle];
    [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"];
    NSDate *dateFromString = [[NSDate alloc] init];
    dateFromString = [dateFormatter dateFromString:dateString];
    return dateFromString;
}

/* This function takes an NSDate and determines how far away that date is from the current
 * date.  The function converts this time in to years, weeks, days, minutes, or seconds and 
 * then displays a string telling the user how long it has been since a document has been 
 * modified.
 *
 * PARAMETER(S)
 *
 *  (NSDate *)docDate                   The date since a document has been last modified
 *
 * RETURN VALUE(S)
 *
 *  (NSString *)                        The string that tells the user how long its been since the document has been modified
 */

+ (NSString *)timeSinceModified:(NSDate *)docDate {
    NSString *todaysDateString;
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"];
    todaysDateString = [formatter stringFromDate:[NSDate date]];
    NSDate *todaysDate = [formatter dateFromString:todaysDateString];
    
    int elapsed;
    
    if(docDate == nil)
        return @"";
    
    NSTimeInterval timeDifference = [todaysDate timeIntervalSinceDate:docDate];
    
    timeDifference += 25140;
    
    
   // NSLog(@"Time difference is %@", (int)timeDifference);
    
    elapsed = (int)timeDifference / 60;                         /* Minutes */
    
    if (elapsed < 60) {
        if (elapsed == 1)
            return [NSString stringWithFormat:@"A minute ago", elapsed];
        else
            return [NSString stringWithFormat:@"%d minutes ago", elapsed];
    }
    
    elapsed = elapsed / 60;                                     /* Hours */
   
    if (elapsed < 24) {
        if (elapsed == 1)
            return [NSString stringWithFormat:@"An hour ago", elapsed];
        else
            return [NSString stringWithFormat:@"%d hours ago", elapsed];
    }
    
    elapsed = elapsed / 24;                                     /* Days */
    
    if (elapsed < 7) {
        if (elapsed == 1)
            return [NSString stringWithFormat:@"Yesterday", elapsed];
        else
            return [NSString stringWithFormat:@"%d days ago", elapsed];
    }
    
    elapsed = elapsed / 7;                                      /* Weeks */
    
    if (elapsed < 4) {
        if (elapsed == 1) 
            return [NSString stringWithFormat:@"A week ago", elapsed];
        else
            return [NSString stringWithFormat:@"%d weeks ago", elapsed];
    }
    
    elapsed = elapsed / 4;                                      /* Months */
    if (elapsed < 12) {
        if (elapsed == 1)
            return [NSString stringWithFormat:@"A month ago", elapsed];
        else 
            return [NSString stringWithFormat:@"%d months ago", elapsed];
    }
    
    elapsed = elapsed / 12;                                     /* Years */
    
    if (elapsed == 1)
        return [NSString stringWithFormat:@"A year ago", elapsed];
    else
        return [NSString stringWithFormat:@"%d years ago", elapsed];
}

- (void)dealloc
{
    documentId = nil;
    type = nil;
    name = nil;
    format = nil;
    dateLastModified = nil;
    title = nil;
    docNumber = nil;
    size = nil;
    majorVNum = nil;
    minorVNum = nil;
    lifecycle = nil;
    status = nil;
    owner = nil;
    lastModifier = nil;
}


#pragma mark - NSCopying methods

-(id) copyWithZone: (NSZone *) zone
{
    Document *documentCopy = [[Document allocWithZone: zone] init];
    documentCopy.documentId = self.documentId;
    documentCopy.name = self.name;
    documentCopy.type = self.type;
    documentCopy.format = self.format;
    
    return documentCopy;
}

@end
