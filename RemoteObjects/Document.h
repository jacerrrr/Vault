//
//  Document.h
//  Vault
//
//  Created by Jace Allison on 2/8/12.
//  Copyright (c) 2012 Issaquah High School. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Document : NSObject <NSCopying>

@property (nonatomic, retain) NSString *documentId;
@property (nonatomic, retain) NSString *type;
@property (nonatomic, retain) NSString *name;
@property (nonatomic, retain) NSString *format;
@property (nonatomic, retain) NSString *dateLastModified;
@property (nonatomic, retain) NSString *title;
@property (nonatomic, retain) NSString *docNumber;
@property (nonatomic, retain) NSString *size;
@property (nonatomic, retain) NSString *majorVNum;
@property (nonatomic, retain) NSString *minorVNum;
@property (nonatomic, retain) NSString *lifecycle;
@property (nonatomic, retain) NSString *status;
@property (nonatomic, retain) NSString *owner;
@property (nonatomic, retain) NSString *lastModifier;



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
