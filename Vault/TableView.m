//
//  TableView.m
//  Vault
//
//  Created by Jeremy on 1/31/12.
//  Copyright (c) 2012 Issaquah High School. All rights reserved.
//

#import "TableView.h"



@implementation TableView

@synthesize lineColor;
@synthesize docTypeImage;
@synthesize docName;
@synthesize docType;
@synthesize docLastModified;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];

    if (self) {
        if([reuseIdentifier isEqualToString:@"PortraitCell"]){
            // Initialization code
            
            // Add labels for the cells
            
            docTypeImage = [[UIImageView alloc] initWithFrame:CGRectMake(15, 7, 32, 32)];
            docTypeImage.backgroundColor = [UIColor clearColor];
            [self addSubview:docTypeImage];
            
            docName = [[UILabel alloc] initWithFrame:CGRectMake(DOCTYPEIMAGE_WIDTH, 0, DOCNAME_WIDTH, CELLHEIGHT)];
            docName.textAlignment = UITextAlignmentCenter;
            docName.backgroundColor = [UIColor clearColor];
            [self addSubview:docName];
            
            docType = [[UILabel alloc] initWithFrame:CGRectMake(DOCTYPEIMAGE_WIDTH+DOCNAME_WIDTH, 0, DOCTYPE_WIDTH, CELLHEIGHT)];
            docType.textAlignment = UITextAlignmentCenter;
            docType.backgroundColor = [UIColor clearColor];
            [self addSubview:docType];
            
            docLastModified = [[UILabel alloc] initWithFrame:CGRectMake(DOCTYPEIMAGE_WIDTH+DOCNAME_WIDTH+DOCTYPE_WIDTH, 0, DOCLASTMODIFIED_WIDTH, CELLHEIGHT)];
            docLastModified.textAlignment = UITextAlignmentCenter;
            docLastModified.backgroundColor = [UIColor clearColor];
            [self addSubview:docLastModified];
            
        }
        else if([reuseIdentifier isEqualToString:@"LandscapeCell"]){
            
            docTypeImage = [[UIImageView alloc] initWithFrame:CGRectMake(36, 7, 32, 32)];
            docTypeImage.backgroundColor = [UIColor clearColor];
            [self addSubview:docTypeImage];
            
            docName = [[UILabel alloc] initWithFrame:CGRectMake(DOCTYPEIMAGE_WIDTHLANDSCAPE, 0, DOCNAME_WIDTHLANDSCAPE, CELLHEIGHT)];
            docName.textAlignment = UITextAlignmentCenter;
            docName.backgroundColor = [UIColor clearColor]; 
            [self addSubview:docName];
            
            docType = [[UILabel alloc] initWithFrame:CGRectMake(DOCTYPEIMAGE_WIDTHLANDSCAPE+DOCNAME_WIDTHLANDSCAPE, 0, DOCTYPE_WIDTHLANDSCAPE, CELLHEIGHT)];
            docType.textAlignment = UITextAlignmentCenter;
            docType.backgroundColor = [UIColor clearColor];
            [self addSubview:docType];
            
            docLastModified = [[UILabel alloc] initWithFrame:CGRectMake(DOCTYPEIMAGE_WIDTHLANDSCAPE+DOCNAME_WIDTHLANDSCAPE+DOCTYPE_WIDTHLANDSCAPE, 0, DOCLASTMODIFIED_WIDTHLANDSCAPE, CELLHEIGHT)];
            docLastModified.textAlignment = UITextAlignmentCenter;
            docLastModified.backgroundColor = [UIColor clearColor];
            [self addSubview:docLastModified];
        }
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}



- (void)drawRect:(CGRect)rect
{
    
    if ([[UIApplication sharedApplication] statusBarOrientation ] == UIInterfaceOrientationPortrait || [[UIApplication sharedApplication] statusBarOrientation] == UIInterfaceOrientationPortraitUpsideDown){
        
        CGContextRef context = UIGraphicsGetCurrentContext();
        CGContextSetStrokeColorWithColor(context, lineColor.CGColor);       
        
        // CGContextSetLineWidth: The default line width is 1 unit. When stroked, the line straddles the path, with half of the total width on either side.
        // Therefore, a 1 pixel vertical line will not draw crisply unless it is offest by 0.5. This problem does not seem to affect horizontal lines.
        CGContextSetLineWidth(context, 1.0);
        
        // Add the vertical lines
        CGContextMoveToPoint(context, DOCTYPEIMAGE_WIDTH+0.5, 0);
        CGContextAddLineToPoint(context, DOCTYPEIMAGE_WIDTH+0.5, rect.size.height);
        
        CGContextMoveToPoint(context, DOCTYPEIMAGE_WIDTH+DOCNAME_WIDTH+0.5, 0);
        CGContextAddLineToPoint(context, DOCTYPEIMAGE_WIDTH+DOCNAME_WIDTH+0.5, rect.size.height);
        
        CGContextMoveToPoint(context, DOCTYPEIMAGE_WIDTH+DOCNAME_WIDTH+DOCTYPE_WIDTH+0.5, 0);
        CGContextAddLineToPoint(context, DOCTYPEIMAGE_WIDTH+DOCNAME_WIDTH+DOCTYPE_WIDTH+0.5, rect.size.height);
        
        // Draw the lines
        CGContextStrokePath(context);
    }
    else if ([[UIApplication sharedApplication] statusBarOrientation ] == UIInterfaceOrientationLandscapeLeft|| [[UIApplication sharedApplication] statusBarOrientation] == UIInterfaceOrientationLandscapeRight){
        
        CGContextRef context = UIGraphicsGetCurrentContext();
        CGContextSetStrokeColorWithColor(context, lineColor.CGColor);       
        
        CGContextSetLineWidth(context, 1.0);
        
        CGContextMoveToPoint(context, DOCTYPEIMAGE_WIDTHLANDSCAPE+0.5, 0);
        CGContextAddLineToPoint(context, DOCTYPEIMAGE_WIDTHLANDSCAPE+0.5, rect.size.height);
        
        CGContextMoveToPoint(context, DOCTYPEIMAGE_WIDTHLANDSCAPE+DOCNAME_WIDTHLANDSCAPE+0.5, 0);
        CGContextAddLineToPoint(context, DOCTYPEIMAGE_WIDTHLANDSCAPE+DOCNAME_WIDTHLANDSCAPE+0.5, rect.size.height);
        
        CGContextMoveToPoint(context, DOCTYPEIMAGE_WIDTHLANDSCAPE+DOCNAME_WIDTHLANDSCAPE+DOCTYPE_WIDTHLANDSCAPE+0.5, 0);
        CGContextAddLineToPoint(context, DOCTYPEIMAGE_WIDTHLANDSCAPE+DOCNAME_WIDTHLANDSCAPE+DOCTYPE_WIDTHLANDSCAPE+0.5, rect.size.height);
        
        CGContextStrokePath(context);
    }
    
    
}


@end
