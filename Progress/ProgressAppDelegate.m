//
//  ProgressAppDelegate.m
//  Progress
//
//  Created by Nick Paulson on 5/4/11.
//  Copyright 2011 Linebreak. All rights reserved.
//

#import "ProgressAppDelegate.h"
#import "NPColoredView.h"
#import "NPStrippedProgressView.h"

@implementation ProgressAppDelegate

@synthesize window;

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    [window setMinSize:NSMakeSize(350, 150)];
    
    NPColoredView *coloredView = [[NPColoredView alloc] initWithFrame:[[self.window contentView] bounds]];
    coloredView.color = [NSColor colorWithDeviceRed:0.1529 green:0.1529 blue:0.1529 alpha:0.90];
    [coloredView setAutoresizingMask:(NSViewWidthSizable | NSViewHeightSizable)];
    [[self.window contentView] addSubview:coloredView];
    
    NSRect contentBounds = [[self.window contentView] bounds];
    NSSize progressViewSize = NSMakeSize(198, 15);
    NSRect progressViewRect = NSMakeRect(floorf((contentBounds.size.width - progressViewSize.width) / 2), floorf((contentBounds.size.height - progressViewSize.height) / 2), progressViewSize.width, progressViewSize.height);
    
    NPStrippedProgressView *progressView = [[NPStrippedProgressView alloc] initWithFrame:progressViewRect];
    [progressView setAutoresizingMask:(NSViewWidthSizable | NSViewMaxYMargin | NSViewMinYMargin)];
    [[self.window contentView] addSubview:progressView];
    
    [progressView startAnimating];
    
    [coloredView release];
    [progressView release];

}

@end
