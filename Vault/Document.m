//
//  Document.m
//  Vault
//
//  Created by Jace Allison on 2/8/12.
//  Copyright (c) 2012 Issaquah High School. All rights reserved.
//

#import "Document.h"

@implementation Document

@synthesize documentId;
@synthesize type;
@synthesize name;
@synthesize contentFile;
@synthesize dateLastModified;

/* Function that takes binary PDF data and a file name as parameters, and determines
 * if the PDF data from the parameter is the same as the PDF data already stored.
 * If it is not the same, the function overwrites the old PDF data with the new
 * PDF data.  The function returns where the path string */

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

+ (void)loadPDF:(NSString *)pdfName {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *pdfFilePath = [documentsDirectory stringByAppendingPathComponent:pdfName];
    NSURL *pdfURL = [NSURL fileURLWithPath:pdfFilePath isDirectory:NO];
}

+ (void)saveDocInfo:(NSMutableDictionary *)infoToSave forKey:(NSString *)key {
    NSUserDefaults *standardDefaults = [NSUserDefaults standardUserDefaults];
    
    if (standardDefaults) {
        [standardDefaults setObject:infoToSave forKey:key];
        [standardDefaults synchronize];
    }
    
}

+ (NSMutableDictionary *)loadDocInfoForKey:(NSString *)key {
    NSUserDefaults *standardDefaults = [NSUserDefaults standardUserDefaults];
    
    return [standardDefaults objectForKey:key];
    
}

+ (void)saveFilters:(NSMutableArray *)array forKey:(NSString *)filterName {
    NSUserDefaults *standardDefaults = [NSUserDefaults standardUserDefaults];
    
    if (standardDefaults) {
        [standardDefaults setObject:array forKey:filterName];
        [standardDefaults synchronize];
    }
}

+ (NSMutableArray *)loadFiltersForKey:(NSString *)key {
    NSUserDefaults *standardDefaults = [NSUserDefaults standardUserDefaults];
    
    return [standardDefaults objectForKey:key];
}

+ (NSString *)timeSinceModified:(NSString *)dateStr {
    NSString *month = nil;
    NSString *day = nil;
    NSString *year = @"20";
    NSString *hour = nil;
    NSString *min = nil;
    
    NSDateComponents *dateComps = [[NSDateComponents alloc] init];
    NSDate *todaysDate = [NSDate date];
    NSDate *lastModified = nil;
    NSCalendar *calender = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    
    NSTimeInterval lastDiff;
    NSTimeInterval todaysDiff = [todaysDate timeIntervalSinceNow];
    double dateDiff = 0;
    double elapsed = 0;
    
    int lastLoc = 0;
    for (int i = 0; i <= [dateStr length]; i++) {
        if ([dateStr characterAtIndex:i] == '/') {
            if (month == nil) 
               month = [dateStr substringWithRange:NSMakeRange(lastLoc, i - lastLoc)];
            else if (day == nil) 
                day = [dateStr substringWithRange:NSMakeRange(3, i - lastLoc)];
            
            lastLoc = i + 1;
        }
        
        else if ([dateStr characterAtIndex:i] == ' ') {
            year = [year stringByAppendingString:[dateStr substringWithRange:NSMakeRange(lastLoc, i - lastLoc)]];
            lastLoc = i + 1;
        }
        
        else if ([dateStr characterAtIndex:i] == ':') {
            if (hour == nil) 
                hour = [dateStr substringWithRange:NSMakeRange(lastLoc, i - lastLoc)];
            else {
                min = [dateStr substringWithRange:NSMakeRange(lastLoc, i - lastLoc)];
                break;
            }
            lastLoc = i + 1;
            
        }
        
      
    }
    
    
    NSLog(@"day is %@", day);
    NSLog(@"year is %@", year);
    NSLog(@"hour is %@", hour);
    NSLog(@"minute is %@", min);
    
    [dateComps setMonth:[month intValue]];
    [dateComps setDay:[day intValue]];
    [dateComps setYear:[year intValue]];
    [dateComps setHour:[hour intValue]];
    [dateComps setMinute:[min intValue]];
     
    lastModified = [calender dateFromComponents:dateComps];
    lastDiff = [lastModified timeIntervalSinceNow];
    dateDiff = todaysDiff - lastDiff;
    
    elapsed = dateDiff / 60;                                    /* Minutes */
    
    NSLog(@"elapsed is %f", elapsed);
    if (elapsed < 60) {
        if (elapsed == 1)
            return [NSString stringWithFormat:@"A minute ago", elapsed];
        else
            return [NSString stringWithFormat:@"%d minutes ago", elapsed];
    }
    
    elapsed = elapsed / 60;                                     /* Hours */
    NSLog(@"elapsed is %f", elapsed);
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
    NSLog(@"elapsed is months %f", elapsed);
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

@end
