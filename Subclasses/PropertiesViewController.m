//
//  PropertiesViewController.m
//  Vault
//
//  Created by Jace Allison on 4/18/12.
//  Copyright (c) 2012 Issaquah High School. All rights reserved.
//

#import "PropertiesViewController.h"

@implementation PropertiesViewController

@synthesize properties;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
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

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
	return YES;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

+ (NSString*) titleForHeaderForSection:(int) section 
{
    switch (section)
    {
        case 0:
            return @"General Properties";
            break;
        case 1:
            return @"Product Information";
            break;
        case 2:
            return @"Sharing Settings";
            break;
        case 3:
            return @"Supporting Documents";
            break;
        case 4:
            return @"Version History";
            break;
        default:
            break;
    }
    return @"There is an issue if you see this, report it!";
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return [PropertiesViewController titleForHeaderForSection:section];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch(section){
        case 0:
            return 11;
            break;
        case 1:
            //   NSLog(@"PICount = %d", docProperties.)
            return 1;
            break;
        case 2:
            return 2;
            break;
        case 3:
            return 2; // Sharing Settings
            break;
        case 4:
            return 2; // Supporting Documents
            break;
        default:
            return 4; // Version History
            break;
    }
}

/* Determine what is going to be displayed on each cell */
-(void) fillCell:(UITableViewCell *)cell inLocation:(NSIndexPath *)indexPath {
    NSMutableDictionary *propertiesType = nil;
    
    if (indexPath.section == 0) {
        
        propertiesType = [self.properties objectAtIndex:0];
        switch (indexPath.row) {
            case 0:
                cell.textLabel.text = @"Name";
                
                if ([propertiesType objectForKey:@"Name"] != nil)
                    cell.detailTextLabel.text = [propertiesType objectForKey:@"Name"];
                else
                    cell.detailTextLabel.text = @"Unavailable";
                
                break;
            case 1:
                cell.textLabel.text = @"Title";
                
                if ([propertiesType objectForKey:@"Title"] != nil)
                    cell.detailTextLabel.text = [propertiesType objectForKey:@"Title"];
                else
                    cell.detailTextLabel.text = @"Unavailable";
                
                break;
            case 2:
                cell.textLabel.text = @"Type";
                
                if ([propertiesType objectForKey:@"Type"] != nil)
                    cell.detailTextLabel.text = [propertiesType objectForKey:@"Type"];
                else
                    cell.detailTextLabel.text = @"Unavailable";
                
                break;
            case 3:
                cell.textLabel.text = @"Document Number";
                
                if ([propertiesType objectForKey:@"Document Number"] != nil)
                    cell.detailTextLabel.text = [propertiesType objectForKey:@"Document Number"];
                else
                    cell.detailTextLabel.text = @"Unavailable";
                
                break;
            case 4:
                cell.textLabel.text = @"Size";
                
                if ([propertiesType objectForKey:@"Size"] != nil)
                    cell.detailTextLabel.text = [propertiesType objectForKey:@"Size"];
                else
                    cell.detailTextLabel.text = @"Unavailable";
                
                break;
            case 5:
                cell.textLabel.text = @"Format";
                
                if ([propertiesType objectForKey:@"Format"] != nil)
                    cell.detailTextLabel.text = [propertiesType objectForKey:@"Format"];
                else
                    cell.detailTextLabel.text = @"Unavailable";
                
                break;
            case 6:
                cell.textLabel.text = @"Created By";
                
                if ([propertiesType objectForKey:@"Created By"] != nil)
                    cell.detailTextLabel.text = [propertiesType objectForKey:@"Created By"];
                else
                    cell.detailTextLabel.text = @"Unavailable";
                
                break;
            case 7:
                cell.textLabel.text = @"Last Modified By";
            
                if ([propertiesType objectForKey:@"Last Modified By"] != nil)
                    cell.detailTextLabel.text = [propertiesType objectForKey:@"Last Modified By"];
                else
                    cell.detailTextLabel.text = @"Unavailable";
                
                break;
            case 8:
                cell.textLabel.text = @"Version";
                
                if ([propertiesType objectForKey:@"Version"] != nil)
                    cell.detailTextLabel.text = [propertiesType objectForKey:@"Version"];
                else
                    cell.detailTextLabel.text = @"Unavailable";
               
                break;
            case 9:
                cell.textLabel.text = @"Lifecycle";
                
                if ([propertiesType objectForKey:@"Lifecycle"] != nil)
                    cell.detailTextLabel.text = [propertiesType objectForKey:@"Lifecycle"];
                else
                    cell.detailTextLabel.text = @"Unavailable";
                
                break;
            case 10:
                cell.textLabel.text = @"Status";
                
                if ([propertiesType objectForKey:@"Status"] != nil)
                    cell.detailTextLabel.text = [propertiesType objectForKey:@"Status"];
                else
                    cell.detailTextLabel.text = @"Unavailable";
                
                break;
            default:
                cell.textLabel.text = @"Something is wrong, report it!";
                break;
        }
    }
    else if (indexPath.section == 1){
        switch (indexPath.row) {
            case 0:
                cell.textLabel.text = @"Product";
                cell.detailTextLabel.text = @"The Test";
                break;
                
            default:
                cell.textLabel.text = @"Something is wrong, report it!";
                break;
        }
    }
    else if (indexPath.section == 2) {
        switch (indexPath.row) {
            case 0:
                cell.textLabel.text = @"Owner";
                cell.detailTextLabel.text = @"The Test";
                break;
            case 1:
                cell.textLabel.text = @"All Internal Users";
                cell.detailTextLabel.text = @"The Test";
                break;
            default:
                cell.textLabel.text = @"Something is wrong, report it!";
                break;
        }
    }
    else if (indexPath.section == 3){ //This one will need work
        switch (indexPath.row) {
            default:
                cell.textLabel.text = @"Supporting Document:";
                cell.detailTextLabel.text = @"Here";
                break;
        }
    }
    else if (indexPath.section == 4) { // This one too
        switch (indexPath.row) {
            case 0:
                cell.textLabel.text = @"Here is the viewable rendition";
                cell.detailTextLabel.text = @"The Test";
                break;
            default:
                cell.textLabel.text = @"Something is wrong, report it!";
                break;
        }
    }
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"PropertiesCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) 
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    /* Determine if we are on a section header or a section row and fill the cell accordingly */
    [self fillCell:cell inLocation:indexPath];
    
    
    
    return cell;
}

/*
 // Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the specified item to be editable.
 return YES;
 }
 */

/*
 // Override to support editing the table view.
 - (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
 {
 if (editingStyle == UITableViewCellEditingStyleDelete) {
 // Delete the row from the data source
 [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
 }   
 else if (editingStyle == UITableViewCellEditingStyleInsert) {
 // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
 }   
 }
 */

/*
 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
 {
 }
 */

/*
 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
 }
 */

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
}

@end
