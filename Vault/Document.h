//
//  Document.h
//  Vault
//
//  Created by Jace Allison on 2/8/12.
//  Copyright (c) 2012 Issaquah High School. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Document : NSObject

@property (nonatomic, retain) NSString *documentId;
@property (nonatomic, retain) NSString *type;
@property (nonatomic, retain) NSString *name;
@property (nonatomic, retain) NSString *contentFile;
@property (nonatomic, retain) NSString *dateLastModified;

+ (NSString *)savePDF:(NSData *)newPdfContent withFileName:(NSString *)fileName;

+ (void)loadPDF:(NSString *)pdfFilePath;

+ (void)saveDocInfo:(NSMutableDictionary *)infoToSave forKey:(NSString *)key;

+ (NSMutableDictionary *)loadDocInfoForKey:(NSString *)key;

+ (void)saveFilters:(NSMutableArray *)array forKey:(NSString *)filterName;

+ (NSMutableArray *)loadFiltersForKey:(NSString *)key;

+ (NSString *)timeSinceModified:(NSString *)dateStr;

@end
