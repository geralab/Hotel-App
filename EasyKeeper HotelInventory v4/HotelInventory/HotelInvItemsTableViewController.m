//
//  HotelInvItemsTableViewController.m
//  HotelInventory
//
//  Created by GIBSON BENJAMIN D on 11/24/13.
//  Copyright (c) 2013 KarashanCS. All rights reserved.
//

#import "HotelInvItemsTableViewController.h"
#import "HotelInvItemViewController.h"
#import "Matt'sFilesItem.h"

@interface HotelInvItemsTableViewController ()

@property (strong, nonatomic) NSMutableArray *combinedItemAndTypeArr;
//@property (strong, nonatomic) NSMutableArray *itemTypeFirstLetters;
@property (strong, nonatomic) NSDictionary *serverResult;
@property (strong, nonatomic) NSArray *itemTypes;

@end

@implementation HotelInvItemsTableViewController

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
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    //Set the background of the tableview.
    [self.tableView setBackgroundView:[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"hall1.jpg"]]];
    
    self.tableView.separatorColor = [UIColor blackColor];
    
    //Set title to note we are loading.
    self.navigationItem.title = [NSString stringWithFormat:@"Loading %@", self.storageData.locationName];
    
    //Get the requestManager to send a request for fetching the item_types for the hotel to sort the items.
    [self.requestManager sendRequest:@""
                           forCaller:self
                        withCallback:@selector(requestFinished:)
                               toURL:[NSString stringWithFormat:@"https://cs.okstate.edu/~hussach/HotelInventory/index.php/service/item_types?token=%@", self.userToken]
                      withHTTPMethod:@"GET"];
    
    //Get the requestManager to send a request for fetching the items in the given storage location.
    [self.requestManager sendRequest:@""
                           forCaller:self
                        withCallback:@selector(requestFinished:)
                               toURL:[NSString stringWithFormat:@"https://cs.okstate.edu/~hussach/HotelInventory/index.php/service/stocks?token=%@&storage_id=%i", self.userToken, self.storageData.locationId]
                      withHTTPMethod:@"GET"];
}
- (void)setupPlayer:(NSString *)str1 with:(NSString*) str2
{
    NSError *err;
    // Set up the URL of the sound file.
    self.theSound= [[NSURL alloc] initFileURLWithPath:[[NSBundle mainBundle] pathForResource:str1 ofType:str2]];
    // Create the player, and initialize it with the sound file.
    self.player = [[AVAudioPlayer alloc] initWithContentsOfURL:(self.theSound) error:&err];
    // Set the view contoller as the delegate.
    self.player.delegate = self; 
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//When we have all of the data, respond to it.
-(void)requestFinished:(NSDictionary*)serverResult {
    self.serverResult = serverResult;
    if ([[self.serverResult objectForKey:@"result"] isEqual:@"ok"]) {
        if (!([self.serverResult objectForKey:@"stocks"] == nil)) {
            self.navigationItem.title = [NSString stringWithFormat:@"%@'s Items", self.storageData.locationName];
            [self populateStorageStocks:[self.serverResult objectForKey:@"stocks"]];
        }
        else if (!([self.serverResult objectForKey:@"item_types"] == nil)) {
            [self populateItemTypes:[self.serverResult objectForKey:@"item_types"]];
        }
    }
    else {
        self.navigationItem.title = [self.serverResult objectForKey:@"message"];
    }
    
    //If we now have both the itemTypes array set and the stocks stored in itemsInLocations of Matt's Files,
    //Then execute the following magic: synthesize the two arrays into one 2D array to be used in cellForRowAtIndexPath.
    //Otherwise, getting the correct names for the cells becomes nearly impossible to do with two unmerged arrays.
    if (self.itemTypes != nil && self.storageData.itemsInLocation != nil) {
        
        //Each element of the top level itemType array will have count == the # of items in self.storageData.itemsInLocation with that item type.
        
        self.combinedItemAndTypeArr = [[NSMutableArray alloc] initWithCapacity:self.itemTypes.count];
        
        for (int i = 0; i < self.itemTypes.count; i++) {
            self.combinedItemAndTypeArr[i] = [[NSMutableArray alloc] init];
            for (Matt_sFilesItem* item in self.storageData.itemsInLocation) {
                if ([item.itemType isEqualToString:[self.itemTypes[i] objectForKey:@"name"]])
                    [self.combinedItemAndTypeArr[i] addObject:item];
            }
        }
        if (self.showDebug) NSLog(@"2D Array of items associated with item_types is: \n%@", self.combinedItemAndTypeArr);
        
        //Now the magical part: reset the itemsInLocation within self.storageData to use this new array?
    }
}


-(void)populateStorageStocks:(NSArray*)storageItems {
    
    //Convert storageLocation arrays inside the storages object to Matt_sStorageLocations in a NSMutableArray that's passed to a Matt_sFilesHotel object.
    NSMutableArray *stocksArr = [NSMutableArray arrayWithArray:storageItems]; //Should be an array of NSDictionaries.
    
    if (self.showDebug) NSLog(@"Now stocksArr holds: \n%@", stocksArr);
    [self.storageData setItemsList:[Matt_sFilesItem jsonArrayToItemArray:stocksArr]];
    [self.tableView reloadData];
}

-(void)populateItemTypes:(NSArray*)itemTypes /*<- An array of NSDictionaries.*/ {
    
    NSSortDescriptor *descriptor = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES];
    self.itemTypes = [itemTypes sortedArrayUsingDescriptors:[NSArray arrayWithObjects:descriptor, nil]];
    /*self.itemTypeFirstLetters = [[NSMutableArray alloc] initWithCapacity:self.itemTypes.count];
    for (int i = 0; i < self.itemTypes.count; i++) {
        [self.itemTypeFirstLetters addObject:[NSString stringWithFormat:@"%c", [[self.itemTypes[i] objectForKey:@"name"] characterAtIndex:0]]];
    }*/
    if (self.showDebug) NSLog(@"ItemTypes Sorted by Name:\n%@", self.itemTypes);
    [self.tableView reloadData];
}

#pragma mark - Table view data source

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return [self.itemTypes[section] objectForKey:@"name"];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return self.itemTypes.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    int numRowsInSection = 0;
    for (Matt_sFilesItem* item in self.storageData.itemsInLocation) {
        if ([item.itemType isEqualToString:[self.itemTypes[section] objectForKey:@"name"]]) numRowsInSection++;
    }
    NSLog(@"numRowsInSection: %i", numRowsInSection);
    return numRowsInSection;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"ItemCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
    cell.textLabel.text = ((Matt_sFilesItem*)self.combinedItemAndTypeArr[indexPath.section][indexPath.row]).itemName;
    [cell.backgroundView setBackgroundColor:[UIColor clearColor]];
    return cell;
}

/*-(NSArray*)sectionIndexTitlesForTableView:(UITableView *)tableView {
    return self.itemTypeFirstLetters;
}

-(NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index {
    return [self.itemTypeFirstLetters indexOfObject:title];
}*/

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
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
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
    [self setupPlayer:@"TYPE" with:@"WAV"];
    [self.player play];
}

//On segue, needs to forward the userData, the userToken, and what storage was requested to show its items next view.
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(UITableViewCell*)sender {
    if ([[segue identifier] isEqualToString:@"ItemCellTapped"]) {
        
        HotelInvItemViewController *dvc = [segue destinationViewController];
        dvc.userData = self.userData;
        dvc.userToken = self.userToken;
        dvc.item = self.storageData.itemsInLocation[[self.tableView indexPathForCell:sender].row];
        dvc.storageId = self.storageData.locationId;
        dvc.requestManager = self.requestManager;
        dvc.showDebug = self.showDebug;
    }
}

@end
