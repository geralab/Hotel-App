//
//  HotelInvItemViewController.m
//  HotelInventory
//
//  Created by GIBSON BENJAMIN D on 11/24/13.
//  Copyright (c) 2013 KarashanCS. All rights reserved.
//

#import "HotelInvItemViewController.h"
#import "Matt'sFilesItem.h"

@interface HotelInvItemViewController ()

//For web service communication.
@property (strong, nonatomic) NSDictionary *serverResult;
@property (strong, nonatomic) NSString *countToChange1, *countToChange2;
@property (nonatomic) int newAmount1, newAmount2;
@property (weak, nonatomic) IBOutlet UIButton *saveButton;

//For radio button behavior.
@property (strong, nonatomic) NSArray *buttons;
@property (weak, nonatomic) IBOutlet UISegmentedControl *inDirtyButton;
@property (weak, nonatomic) IBOutlet UISegmentedControl *inRoomsButton;
@property (weak, nonatomic) IBOutlet UISegmentedControl *inStorageButton;
@property (strong, nonatomic) UISegmentedControl *lastTappedButton;

//For amount logic.
@property (weak, nonatomic) IBOutlet UILabel *amountToMoveLabel;
@property (weak, nonatomic) IBOutlet UITextField *amountToMoveTextField;
@property (weak, nonatomic) IBOutlet UILabel *inDirtyAmountLabel;
@property (weak, nonatomic) IBOutlet UILabel *inRoomsAmountLabel;
@property (weak, nonatomic) IBOutlet UILabel *inStorageAmountLabel;

@end

@implementation HotelInvItemViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.buttons = [[NSArray alloc] initWithObjects:self.inDirtyButton,
                    self.inRoomsButton, self.inStorageButton, nil];
    
    self.navigationItem.title = self.item.itemName;
    self.inDirtyAmountLabel.text = [NSString stringWithFormat:@"%i", self.item.inProcess];
    self.inRoomsAmountLabel.text = [NSString stringWithFormat:@"%i", self.item.inRoom];
    self.inStorageAmountLabel.text = [NSString stringWithFormat:@"%i", self.item.inStock];}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.amountToMoveTextField resignFirstResponder];
}

- (void)updateAmountLabels {
    self.amountToMoveLabel.text = @"Amount to Move:";
    if (self.showDebug) NSLog(@"===== Update Received ======");
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
- (IBAction)inDirtyTapped:(UISegmentedControl*)sender {
    [self dimAllButtonsExcept:sender];
    int amountToMove = [self.amountToMoveTextField.text intValue];
    if (sender.selectedSegmentIndex == 0) {
        
        //Taking from dirty items to stocked items, as we assume they are now clean.
        if (self.item.inProcess - amountToMove < 0) {
            self.amountToMoveLabel.text = @"Not enough in Dirty!";
            sender.selectedSegmentIndex = -1; //Deselect button.
            return;
        }
    }
    else {
        
        //Adding to dirty items from rooms' items, as we assume they are now dirty.
        if (self.item.inRoom - amountToMove < 0) {
            self.amountToMoveLabel.text = @"Not enough in Rooms!";
            sender.selectedSegmentIndex = -1; //Deselect button.
            return;
        }
    }
    self.lastTappedButton = sender;
    [self updateAmountLabels];
}

- (IBAction)inRoomsTapped:(UISegmentedControl*)sender {
    [self dimAllButtonsExcept:sender];
    int amountToMove = [self.amountToMoveTextField.text intValue];
    if (sender.selectedSegmentIndex == 0) {
        
        //Taking from rooms' items to dirty items, as we assume they are now dirty.
        if (self.item.inRoom - amountToMove < 0) {
            self.amountToMoveLabel.text = @"Not enough in Rooms!";
            sender.selectedSegmentIndex = -1; //Deselect button.
            return;
        }
    }
    else {
        
        //Adding to rooms' items from stocked items, as we assume they are now in use.
        if (self.item.inStock - amountToMove < 0) {
            self.amountToMoveLabel.text = @"Not enough in Storage!";
            sender.selectedSegmentIndex = -1; //Deselect button.
            return;
        }
    }
    self.lastTappedButton = sender;
    [self updateAmountLabels];
}

- (IBAction)inStorageTapped:(UISegmentedControl*)sender {
    [self dimAllButtonsExcept:sender];
    int amountToMove = [self.amountToMoveTextField.text intValue];
    if (sender.selectedSegmentIndex == 0) {
        
        //Taking from storage items to rooms' items, as we assume they are now in use.
        if (self.item.inStock - amountToMove < 0) {
            self.amountToMoveLabel.text = @"Not enough in Storage!";
            sender.selectedSegmentIndex = -1; //Deselect button.
            return;
        }
    }
    else {
        
        //Adding to storage items from dirty items, as we assume they are now clean.
        if (self.item.inProcess - amountToMove < 0) {
            self.amountToMoveLabel.text = @"Not enough in Dirty!";
            sender.selectedSegmentIndex = -1; //Deselect button.
            return;
        }
    }
    self.lastTappedButton = sender;
    [self updateAmountLabels];
}

//Treat the UISegmentedControls like radio buttons.
-(void) dimAllButtonsExcept:(UISegmentedControl*)selectedButton {
    for (UISegmentedControl* button in self.buttons) {
        if (button != selectedButton) {
            button.selectedSegmentIndex = -1;
        }
    }
}

- (IBAction)saveButtonPressed:(UIButton*)sender {
    
    //Loop over all the buttons as indimAllButtonsExcept:.
    int amountToMove = [self.amountToMoveTextField.text intValue];
    
    if (amountToMove < 1) return;
    
    if (self.lastTappedButton.selectedSegmentIndex == 0) { //Removing.
        switch (self.lastTappedButton.tag) {
            case 1:
                [self.item addToInProcess:-1*amountToMove]; self.countToChange1 = @"in_process"; self.newAmount1 = self.item.inProcess;
                [self.item addToInStock:amountToMove]; self.countToChange2 = @"in_stock"; self.newAmount2 = self.item.inStock;
                break; //Dirty.
            case 2:
                [self.item addToInRoom:-1*amountToMove]; self.countToChange1 = @"in_room"; self.newAmount1 = self.item.inRoom;
                [self.item addToInProcess:amountToMove]; self.countToChange2 = @"in_process"; self.newAmount2 = self.item.inProcess;
                break; //Rooms.
            case 3:
                [self.item addToInStock:-1*amountToMove]; self.countToChange1 = @"in_stock"; self.newAmount1 = self.item.inStock;
                [self.item addToInRoom:amountToMove]; self.countToChange2 = @"in_room"; self.newAmount2 = self.item.inRoom;
                break; //Storages.
        }
    }
    else if (self.lastTappedButton.selectedSegmentIndex == 1) { //Adding.
        switch (self.lastTappedButton.tag) {
            case 1:
                [self.item addToInProcess:amountToMove]; self.countToChange1 = @"in_process"; self.newAmount1 = self.item.inProcess;
                [self.item addToInRoom:-1*amountToMove]; self.countToChange2 = @"in_room"; self.newAmount2 = self.item.inRoom;
                break; //Dirty.
            case 2:
                [self.item addToInRoom:amountToMove]; self.countToChange1 = @"in_room"; self.newAmount1 = self.item.inRoom;
                [self.item addToInStock:-1*amountToMove]; self.countToChange2 = @"in_stock"; self.newAmount2 = self.item.inStock;
                break; //Rooms.
            case 3:
                [self.item addToInStock:amountToMove]; self.countToChange1 = @"in_stock"; self.newAmount1 = self.item.inStock;
                [self.item addToInProcess:-1*amountToMove]; self.countToChange2 = @"in_process"; self.newAmount2 = self.item.inProcess;
                break; //Storages.
        }
    }
    else return;
    
    //Get the requestManager to send a request for updating the item amounts.
    [self.requestManager sendRequest:[NSString stringWithFormat:@"&token=%@&storage_id=%d&item_id=%d&%@=%i&%@=%i",
                                      self.userToken, self.storageId, self.item.itemId,
                                      self.countToChange1, self.newAmount1, self.countToChange2, self.newAmount2]
                           forCaller:self
                        withCallback:@selector(requestFinished:)
                               toURL:@"https://cs.okstate.edu/~hussach/HotelInventory/index.php/service/stocks"
                      withHTTPMethod:@"POST"];
    
    //But prevent a resend!
    sender.enabled = NO;
}

//When we have all of the data, respond to it.
-(void)requestFinished:(NSDictionary*)serverResult {
    self.serverResult = serverResult;
    if ([[self.serverResult objectForKey:@"result"] isEqual:@"ok"]) {
        self.navigationItem.title = [NSString stringWithFormat:@"Amounts Updated!"];
        [self setupPlayer:@"BUTANE" with:@"WAV"];
        [self.player play];
        [self.navigationController popViewControllerAnimated:YES];
    }
    else {
        self.navigationItem.title = [self.serverResult objectForKey:@"message"];
        self.saveButton.enabled = YES;
    }
}



@end
