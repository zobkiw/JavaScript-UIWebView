//
//  ViewController.m
//  Test JavaScript WebView
//
//  Created by Joe Zobkiw on 12/21/12.
//  Copyright (c) 2012 Zobcode LLC. All rights reserved.
//

#import "ViewController.h"

@interface ViewController () <UIWebViewDelegate>
@property (atomic, strong) IBOutlet UIWebView *webView;
@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
	
	// Make ourselves the delegate
	[self.webView setDelegate:self];

	// Get the path to the html file, this could have easily been loaded from a server as well
	NSString *htmlFile = [[NSBundle mainBundle] pathForResource:@"index" ofType:@"html"];
	if ([htmlFile length]) {

		// Get the contents of the html file
		NSError *error = NULL;
		NSString *html = [NSString stringWithContentsOfFile:htmlFile encoding:NSUTF8StringEncoding error:&error];
		if ([html length]) {
			
			// Define the string to inject into the html file - this can be anything you like including
			// JavaScript code, html, css, etc. - anything that the client can handle
			NSString *stringToInject = @"Click OK then watch the NSLog output for whatever follows the abc:// URL in the html file.";
			
			// Inject the string by replacing our placeholder. You can use anything you like as a placeholder
			// here including a comment such as <!-- put stuff here -->, etc. I happen to be setting a JavaScript
			// variable in this case but you could just as easily fill in the contents of a <div>, etc.
			html = [html stringByReplacingOccurrencesOfString:@"%inject%" withString:stringToInject];
			
			// Get the base URL of the file in question, in case the page loads any other assets, etc.
			NSURL *baseURL = [NSURL fileURLWithPath:htmlFile];
			
			// Load the html into the web view
			[self.webView loadHTMLString:html baseURL:baseURL];
			
		} // handle error here
	} // handle error here
}

// This delegate method is used to grab any links used to "talk back" to Objective-C code from the html/JavaScript
-(BOOL) webView:(UIWebView *)inWeb shouldStartLoadWithRequest:(NSURLRequest *)inRequest navigationType:(UIWebViewNavigationType)inType
{
	// In the event we see our URL scheme pass by, we deal with it, otherwise we let other URL schemes pass by
	// You may choose to handle other UIWebViewNavigationType values as your app requires
    if (inType == UIWebViewNavigationTypeOther || inType == UIWebViewNavigationTypeLinkClicked) {
		NSURL *URL = [inRequest URL];
		NSString *scheme = [URL scheme];
		if ([scheme isEqualToString:@"abc"]) {
			
			// This is the point where we are communicated with - the resourceSpecifier contains anything after the
			// abc: in the URL. We can parse it as needed. In this case we simple NSLog it.
			NSLog(@"%@", [URL resourceSpecifier]);
			
			// Let the webView know we handled it
			return NO;
		}
    }
	
	// Let the webView handle everything else
    return YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
