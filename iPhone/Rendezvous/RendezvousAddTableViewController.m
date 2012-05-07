//
//  RendezvousAddTableViewController.m
//  Rendezvous
//
//  Created by akonig on 5/5/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "RendezvousAddTableViewController.h"
#define kaddUserURL @"http://rendezvous.cs147.org/addList.php?"


@interface RendezvousAddTableViewController ()

@end

@implementation RendezvousAddTableViewController

@synthesize responseData,listIDs,listUserInfo,filteredListContent,searchBar,saveButton;


- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    RendezvousCurrentUser *sharedSingleton=[RendezvousCurrentUser sharedInstance];
    
    friendsList=[[sharedSingleton userInfo] objectForKey:@"friends"];
    self.filteredListContent = [NSMutableArray arrayWithCapacity:[friendsList count]];

    [self.tableView reloadData];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)viewDidUnload
{
    [self setSearchBar:nil];
    [self setSaveButton:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark Need to fix for bad content!!!

- (void) searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    
    NSLog(searchBar.text);
    RendezvousAppDelegate *delegate = (RendezvousAppDelegate *)[[UIApplication sharedApplication] delegate];
    NSString *path=[NSString stringWithFormat:@"search?q=%@&type=user&limit=50",[searchBar.text stringByReplacingOccurrencesOfString:@" " withString:@"%20"]];
    [[delegate facebook] requestWithGraphPath:path andDelegate:self];

    
    
}

/*
- (void) searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    RendezvousAppDelegate *delegate = (RendezvousAppDelegate *)[[UIApplication sharedApplication] delegate];
    NSString *path=[NSString stringWithFormat:@"search?q=%@&type=user&limit=50",[searchBar.text stringByReplacingOccurrencesOfString:@" " withString:@"%20"]];

    [[delegate facebook] requestWithGraphPath:path andDelegate:self];
}
 */

/*
#pragma mark - Backend Data Loading

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    [responseData setLength:0];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    [responseData appendData:data];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
	self.responseData = nil;
}

#pragma mark Process loan data
- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    
    NSLog(@"Added User!");
    
}

*/



#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
 
    return 1;

}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == self.searchDisplayController.searchResultsTableView)
	{
        return [self.filteredListContent count];
    }
	else
	{
        return [friendsList count];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"CellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    if (tableView == self.searchDisplayController.searchResultsTableView)
	{
        // Get the cell label using its tag and set it.
        cell.textLabel.text=[[filteredListContent objectAtIndex:indexPath.row] objectForKey:@"name"];
        // The object's image
        cell.imageView.image = [self imageForObject:[[filteredListContent objectAtIndex:indexPath.row] objectForKey:@"id"]];
    }
	else
	{
        // Get the cell label using its tag and set it
        UILabel *cellLabel = (UILabel *)[cell viewWithTag:1];
        [cellLabel setText:[[friendsList objectAtIndex:indexPath.row] objectForKey:@"name"]];
        // The object's image
        cell.imageView.image = [self imageForObject:[[friendsList objectAtIndex:indexPath.row] objectForKey:@"id"]];
    }
    
    //UILabel *cellLabel = (UILabel *)[cell viewWithTag:1];
    //[cellLabel setText:@"Testing Text"];
    
    
    
    return cell;

}

- (UIImage *)imageForObject:(NSString *)objectID {
    // Get the object image
    NSString *url = [[NSString alloc] initWithFormat:@"https://graph.facebook.com/%@/picture",objectID];
    UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:url]]];
    return image;
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
    
    RendezvousCurrentUser *sharedSingelton=[RendezvousCurrentUser sharedInstance];
    NSString *addRequest=[NSString alloc];
    
    if (tableView == self.searchDisplayController.searchResultsTableView)
	{
        addRequest=[kaddUserURL stringByAppendingFormat:@"from_id=%@&to_id=%@",[sharedSingelton userId],[[filteredListContent objectAtIndex:indexPath.row] objectForKey:@"id"]];
        NSLog(addRequest);
    }
	else
	{
        addRequest=[kaddUserURL stringByAppendingFormat:@"from_id=%@&to_id=%@",[sharedSingelton userId],[[friendsList objectAtIndex:indexPath.row] objectForKey:@"id"]];
        NSLog(addRequest);
    }

    
    NSURLRequest *request = [NSURLRequest requestWithURL:([NSURL URLWithString:addRequest])];
    [[NSURLConnection alloc] initWithRequest:request delegate:self];
}


#pragma mark -
#pragma mark Content Filtering

- (void)filterContentForSearchText:(NSString*)searchText scope:(NSString*)scope
{
	/*
	 Update the filtered array based on the search text and scope.
	 */
	
	[self.filteredListContent removeAllObjects]; // First clear the filtered array.
	
	/*
	 Search the main list for products whose type matches the scope (if selected) and whose name matches searchText; add items that match to the filtered array.
	 */
    
	for (NSDictionary *friend in friendsList)
	{
			NSComparisonResult result = [[friend objectForKey:@"name"] compare:searchText options:(NSCaseInsensitiveSearch|NSDiacriticInsensitiveSearch) range:NSMakeRange(0, [searchText length])];
            if (result == NSOrderedSame)
			{
				[self.filteredListContent addObject:friend];
            }
	}
}


#pragma mark -
#pragma mark UISearchDisplayController Delegate Methods

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString
{
    [self filterContentForSearchText:searchString scope:
     [[self.searchDisplayController.searchBar scopeButtonTitles] objectAtIndex:[self.searchDisplayController.searchBar selectedScopeButtonIndex]]];
    
    // Return YES to cause the search result table view to be reloaded.
    return YES;
}


- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchScope:(NSInteger)searchOption
{
    [self filterContentForSearchText:[self.searchDisplayController.searchBar text] scope:
     [[self.searchDisplayController.searchBar scopeButtonTitles] objectAtIndex:searchOption]];
    
    // Return YES to cause the search result table view to be reloaded.
    return YES;
}

#pragma mark - FB callback

- (void)request:(FBRequest *)request didLoad:(id)result
{
    
    NSLog(@"Facebook request %@ loaded", [request url]);

    NSArray *resultData = [result objectForKey:@"data"];
    NSDictionary* user = [resultData objectAtIndex:1];
    for (NSDictionary *user in resultData){
        [self.filteredListContent addObject:user];
    }
    
    NSLog(@"Loaded Search Results");
    [self.searchDisplayController.searchResultsTableView reloadData];
    
    
}


@end