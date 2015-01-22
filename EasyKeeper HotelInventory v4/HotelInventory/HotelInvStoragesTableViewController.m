//
//  HotelInvStoragesTableViewController.m
//  HotelInventory
//
//  Created by GIBSON BENJAMIN D on 11/24/13.
//  Copyright (c) 2013 KarashanCS. All rights reserved.
//

#import "HotelInvStoragesTableViewController.h"
#import "HotelInvItemsTableViewController.h"
#import "Matt'sFilesHotel.h"
#import "Matt'sFilesStorageLocation.h"

@interface HotelInvStoragesTableViewController ()

@property (strong, nonatomic) NSDictionary *serverResult;
@property (strong, nonatomic) Matt_sFilesHotel *hotel;

@end

@implementation HotelInvStoragesTableViewController

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
    [self.tableView setBackgroundView:[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"elevator1.jpg"]]];
    
    
    self.tableView.separatorColor = [UIColor blackColor];
    
    //Set title to note we are loading.
    self.navigationItem.title = [NSString stringWithFormat:@"Loading %@", [self.userData objectForKey:@"hotel_id"]];
    
    //Get the requestManager to send a request for fetching the storage locations.
    [self.requestManager sendRequest:[NSString stringWithFormat:@"token=%@", self.userToken]
                           forCaller:self
                        withCallback:@selector(requestFinished:)
                               toURL:@"https://cs.okstate.edu/~hussach/HotelInventory/index.php/service/storages"
                      withHTTPMethod:@"POST"];
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
        self.navigationItem.title = @"Storages";
        [self populateHotelStorages:[self.serverResult objectForKey:@"storages"]];
    }
    else {
        self.navigationItem.title = [self.serverResult objectForKey:@"message"];
    }
}

-(void)populateHotelStorages:(NSArray*)storageLocationsData {
    
    //Convert storageLocation arrays inside the storages object to Matt_sStorageLocations in a NSMutableArray that's passed to a Matt_sFilesHotel object.
    NSMutableArray *storagesArr = [NSMutableArray arrayWithArray:storageLocationsData];
    
    if (self.showDebug) NSLog(@"Now storagesArr holds: \n%@", storagesArr);
    self.hotel = [[Matt_sFilesHotel alloc] initWithName:[self.userData objectForKey:@"hotel_id"] andstorageLocations:storagesArr];
    
    [self.tableView reloadData];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [self.hotel.storageLocations count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"StorageLocationCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
    cell.textLabel.text = ((Matt_sFilesStorageLocation*)self.hotel.storageLocations[indexPath.row]).locationName;
    
    [cell.backgroundView setBackgroundColor:[UIColor clearColor]];
    
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
    if ([[segue identifier] isEqualToString:@"StorageCellTapped"]) {
        
        HotelInvItemsTableViewController *dvc = [segue destinationViewController];
        dvc.userData = self.userData;
        dvc.userToken = self.userToken;
        dvc.storageData = self.hotel.storageLocations[[self.tableView indexPathForCell:sender].row];
        dvc.requestManager = self.requestManager;
        dvc.showDebug = self.showDebug;
    }
}


@end
