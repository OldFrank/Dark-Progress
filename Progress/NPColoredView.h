//
//  NPColoredView.h
//  Progress
//
//  Created by Nick Paulson on 5/3/11.
//  Copyright 2011 Linebreak. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface NPColoredView : NSView {
    NSColor *_color;
}

@property (nonatomic, readwrite, retain) NSColor *color;

@end
