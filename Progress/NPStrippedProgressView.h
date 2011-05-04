//
//  NPStrippedProgressView.h
//  Progress
//
//  Created by Nick Paulson on 5/3/11.
//  Copyright 2011 Linebreak. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface NPStrippedProgressView : NSView {
    NSTimer *_animationTimer;
    CGFloat _xPatternOffset;
}

- (void)startAnimating;
- (void)stopAnimating;

@end
