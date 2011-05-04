//
//  NPColoredView.m
//  Progress
//
//  Created by Nick Paulson on 5/3/11.
//  Copyright 2011 Linebreak. All rights reserved.
//

#import "NPColoredView.h"


@implementation NPColoredView

@synthesize color = _color;

- (id)initWithFrame:(NSRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code here.
    }
    return self;
}

- (void)dealloc {
	[_color release];
    _color = nil;
	
	[super dealloc];
}

- (void)drawRect:(NSRect)dirtyRect {
    
	if (self.color != nil) {
		[self.color set];
		NSRectFillUsingOperation(self.bounds, NSCompositeSourceOver);
	}
}

@end
