//
//  ProgressAppDelegate.h
//  Progress
//
//  Created by Nick Paulson on 5/4/11.
//  Copyright 2011 Linebreak. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface ProgressAppDelegate : NSObject <NSApplicationDelegate> {
@private
    NSWindow *window;
}

@property (assign) IBOutlet NSWindow *window;

@end
