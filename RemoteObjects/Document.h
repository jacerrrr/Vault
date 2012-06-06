/* 
 * Document.h
 * Vault
 *
 * Created by Jace Allison on February 15, 2012
 * Last modified on May 24, 2012 by Jace Allison
 *
 * Copyright © 2011-2012 Veeva Systems. All rights reserved.
 */

#import <Foundation/Foundation.h>

@interface Document : NSObject <NSCopying>

@property (nonatomic, strong) NSString *documentId;         /* A Vault document's id */
@property (nonatomic, strong) NSString *type;               /* A Vault document's type */
@property (nonatomic, strong) NSString *name;               /* A Vault document's name */
@property (nonatomic, strong) NSString *format;             /* A Vault document's format */
@property (nonatomic, strong) NSString *dateLastModified;   /* A Vault document's date last modified */
@property (nonatomic, strong) NSString *title;              /* A Vault document's title */
@property (nonatomic, strong) NSString *docNumber;          /* A Vault document's document number */
@property (nonatomic, strong) NSString *size;               /* A Vault document's size in KB */
@property (nonatomic, strong) NSString *majorVNum;          /* A Vault document's major version number */
@property (nonatomic, strong) NSString *minorVNum;          /* A Vault document's minor version number */
@property (nonatomic, strong) NSString *lifecycle;          /* A Vault document's lifecycle */
@property (nonatomic, strong) NSString *status;             /* A Vault document's status */
@property (nonatomic, strong) NSString *owner;              /* A Vault document's owner */
@property (nonatomic, strong) NSString *lastModifier;       /* A Vault documents last modifier user */



+ (NSString *)savePDF:(NSData *)newPdfContent withFileName:(NSString *)fileName;

+ (NSString *)loadPDF:(NSString *)pdfFilePath;

+ (void)saveDocInfo:(NSMutableDictionary *)infoToSave forKey:(NSString *)key;

+ (NSMutableDictionary *)loadDocInfoForKey:(NSString *)key;

+ (void)saveFilters:(NSMutableArray *)array forKey:(NSString *)filterName;

+ (NSMutableArray *)loadFiltersForKey:(NSString *)key;

+ (NSDate *)convertStringToDate:(NSString *)dateString;

+ (NSString *)timeSinceModified:(NSDate *)docDate;

-(id) copyWithZone: (NSZone *) zone;

@end
