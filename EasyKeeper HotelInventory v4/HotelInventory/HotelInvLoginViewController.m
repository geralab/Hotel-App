//
//  HotelInvViewController.m
//  HotelInventory
//
//  Created by GIBSON BENJAMIN D on 11/24/13.
//  Copyright (c) 2013 KarashanCS. All rights reserved.
//

#import "HotelInvLoginViewController.h"
#import "HotelInvStoragesTableViewController.h"
#import "HotelInvURLRequestManager.h"

@interface HotelInvLoginViewController ()

//Needed for server response.
@property (strong, nonatomic) HotelInvURLRequestManager *requestManager;
@property (strong, nonatomic) NSDictionary *serverResult;

//Needed for UI interfacing.
@property (weak, nonatomic) IBOutlet UITextField *usernameTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UIButton *loginButton;

//Debug switch, set to true or false to show NSLog statements.
@property (nonatomic) bool showDebug;

@end

@implementation HotelInvLoginViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
	// Do any additional setup after loading the view, typically from a nib.
    
    self.showDebug = true;
    self.requestManager = [[HotelInvURLRequestManager alloc] initializeWithDebugSwitch:self.showDebug];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)dismissTappedKeyboard:(UITextField *)sender {
    [self.view endEditing:YES];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.usernameTextField resignFirstResponder];
    [self.passwordTextField resignFirstResponder];
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
- (IBAction)loginButtonPressed:(id)sender {
    
    //Require username and password to not be blank.
    if ([self.usernameTextField.text isEqualToString:@""]) {
        self.navigationItem.title = @"Please enter a username.";
        return;
    }
    else if ([self.passwordTextField.text isEqualToString:@""]) {
        self.navigationItem.title = @"Please enter a password.";
        return;
    }
    
    //Set status label to blank.
    self.navigationItem.title = @"Login";
    
    //Get the requestManager to send a request for authenticating the login.
    [self.requestManager sendRequest:[NSString stringWithFormat:@"username=%@&password=%@", self.usernameTextField.text, self.passwordTextField.text]
                           forCaller:self
                        withCallback:@selector(requestFinished:)
                               toURL:@"https://cs.okstate.edu/~hussach/HotelInventory/index.php/service/authenticate"
                      withHTTPMethod:@"POST"];
    
    //Set outlets' text to blank.
    self.usernameTextField.text = self.passwordTextField.text = @"";
    
}

//When we have all of the data, respond to it.
-(void)requestFinished:(NSDictionary*)serverResult {
    self.serverResult = serverResult;
    if ([[self.serverResult objectForKey:@"result"] isEqual:@"ok"]) {
        [self performSegueWithIdentifier:@"Login" sender:nil];
    } else {
        self.navigationItem.title = [self.serverResult objectForKey:@"message"];
    }
}

//On segue, we need to set the data depending on the userdata, and get the right hotel for this user.
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"Login"]) {
        
        [self setupPlayer: @"WELCOME" with:@"WAV"];
        [self.player play];
        
        //Set the user data property of the next view.
        HotelInvStoragesTableViewController *dvc = [segue destinationViewController];
        dvc.userData = [self.serverResult objectForKey:@"user"];
        dvc.userToken = [self.serverResult objectForKey:@"token"];
        dvc.showDebug = self.showDebug;
        dvc.requestManager = self.requestManager;
    }
}

@end
