/*
 Returns the string return result of a server request (to a script), provided
 requestString:	 the string to send,
 URLasString:	 the URL to send to, and
 method:	@"GET" or @"POST"
 */

#import "HotelInvURLRequestManager.h"

@interface HotelInvURLRequestManager ()
@property (nonatomic) bool showDebug;
@property (nonatomic) SEL callback;
@property (strong, nonatomic) id caller;
@property (strong, nonatomic) NSMutableData *data;
@end

@implementation HotelInvURLRequestManager

-(HotelInvURLRequestManager*) initializeWithDebugSwitch:(bool)showDebug {
    self.showDebug = showDebug;
    self.data = [[NSMutableData alloc] init];
    return self;
}

-(void) sendRequest:(NSString*)requestString forCaller:(id)caller withCallback:(SEL)selector toURL:(NSString*)URLasString withHTTPMethod:(NSString*)method {
    //Log the sent request.
    if (self.showDebug) NSLog(@"RequestManager now sending %@ request %@ to %@.", method, requestString, URLasString);
    
    //Store references.
    self.caller = caller;
    self.callback = selector;
    
    //Setup request.
    NSData *requestData = [requestString dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    NSString *requestLength = [NSString stringWithFormat:@"%d", [requestData length]];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    
    [request setURL:[NSURL URLWithString:URLasString]];
    [request setHTTPMethod:method];
    [request setValue:requestLength forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Current-Type"];
    [request setHTTPBody: requestData];
    
    //Send request's data over connection to request's URL.
    NSURLConnection *conn = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    if (self.showDebug && conn) NSLog(@"Connection to %@ was Successful", URLasString);
    	else if (self.showDebug) NSLog(@"Connection to %@ was Unsuccessful", URLasString);
}

//As we get data back from the connection, add it to our mutable data property.
-(void)connection:(NSURLConnection*)connection didReceiveData:(NSData*)data {
    [self.data appendData:data];
}

//When we have all of the data, respond to it.
-(void)connectionDidFinishLoading:(NSURLConnection*)connection {
    NSString *response = [[NSString alloc] initWithData:self.data encoding:NSUTF8StringEncoding];
    if (self.showDebug && response != nil) NSLog(@"Response = %@", response);
    	else if (self.showDebug) NSLog(@"The response NSString object came back nil.");
            NSError *err;
    
    NSDictionary *serverResult = [NSJSONSerialization JSONObjectWithData:self.data options:NSJSONReadingAllowFragments error:&err];
    if (self.showDebug) NSLog(@"Content of serverResult:\n%@", serverResult);
        
    [self.data setData:nil];
    
    /*
    SEL selector = NSSelectorFromString(@"requestFinished:withResult:");
    IMP imp = [self.caller methodForSelector:selector];
    void (*func)(id, SEL) = (void*)imp;
    func(self.caller, selector);
    */
    [self.caller performSelector:self.callback withObject:serverResult];
}

@end