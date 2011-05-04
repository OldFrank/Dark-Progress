//
//  NPStrippedProgressView.m
//  Progress
//
//  Created by Nick Paulson on 5/3/11.
//  Copyright 2011 Linebreak. All rights reserved.
//

#import "NPStrippedProgressView.h"
#import "NSBezierPath+BezierPathQuartzUtilities.h"

static void NPContextDrawInnerShadowWithColor(CGContextRef context, CGSize offset, CGFloat blur, CGColorRef color)
{
    CGRect boundingRect = CGContextGetPathBoundingBox(context);
    CGRect outterRect = CGRectInset(boundingRect, -abs(offset.width) - blur, -abs(offset.height) - blur);
    
    CGPathRef currPath = CGContextCopyPath(context);
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    const CGFloat blackComponents[] = { 0.0f, 0.0f, 0.0f, 0.5f };
    CGColorRef blackColor = CGColorCreate(colorSpace, blackComponents);
    
    CGContextSaveGState(context);
    {
        CGContextClip(context);
        CGContextBeginTransparencyLayer(context, NULL);
        {
            CGContextSaveGState(context);
            {
                CGContextAddPath(context, currPath);
                CGContextAddRect(context, outterRect);
                
                CGContextSetFillColorWithColor(context, blackColor);
                
                CGContextSetShadowWithColor(context, offset, blur, color);
                CGContextEOFillPath(context);
                
            }
            CGContextRestoreGState(context);
        }
        CGContextEndTransparencyLayer(context);
        
    }
    CGContextRestoreGState(context);
    
    CGColorRelease(blackColor);
    CGPathRelease(currPath);
    CGColorSpaceRelease(colorSpace);
}

static void NPDrawStripePattern (void *info, CGContextRef context) 
{
    CGMutablePathRef patternPath = CGPathCreateMutable();
    CGPathMoveToPoint(patternPath, NULL, 0, 5);
    CGPathAddLineToPoint(patternPath, NULL, 5, 0);
    CGPathAddLineToPoint(patternPath, NULL, 0, 0);
    CGPathCloseSubpath(patternPath);
    
    CGPathMoveToPoint(patternPath, NULL, 0, 15);
    CGPathAddLineToPoint(patternPath, NULL, 0, 20);
    CGPathAddLineToPoint(patternPath, NULL, 5, 20);
    CGPathAddLineToPoint(patternPath, NULL, 20, 5);
    CGPathAddLineToPoint(patternPath, NULL, 20, 0);
    CGPathAddLineToPoint(patternPath, NULL, 15, 0);
    CGPathCloseSubpath(patternPath);
    
    CGPathMoveToPoint(patternPath, NULL, 15, 20);
    CGPathAddLineToPoint(patternPath, NULL, 20, 20);
    CGPathAddLineToPoint(patternPath, NULL, 20, 15);
    CGPathCloseSubpath(patternPath);
    
    CGContextAddPath(context, patternPath);
    
    CGContextFillPath(context);
    
    CGPathRelease(patternPath);
}

@implementation NPStrippedProgressView

- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}

- (void)dealloc
{
    if (_animationTimer != nil) {
        [_animationTimer invalidate];
        [_animationTimer release];
        _animationTimer = nil;
    }
    [super dealloc];
}

- (void)stopAnimating
{
    if (_animationTimer == nil)
        return;
    [_animationTimer invalidate];
    [_animationTimer release];
    _animationTimer = nil;
}

- (void)startAnimating
{
    if (_animationTimer != nil)
        return;
    _animationTimer = [[NSTimer scheduledTimerWithTimeInterval:0.03 target:self selector:@selector(_animationTimerDidEnd:) userInfo:nil repeats:YES] retain];
}

- (void)_animationTimerDidEnd:(NSTimer *)timer
{
    _xPatternOffset++;
    [self setNeedsDisplay:YES];
}

- (void)drawRect:(NSRect)dirtyRect
{
    CGContextRef context = (CGContextRef)[[NSGraphicsContext currentContext] graphicsPort];
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    
    NSRect holderRectWithoutShadow = NSMakeRect(self.bounds.origin.x, self.bounds.origin.y + 1, self.bounds.size.width, self.bounds.size.height - 1);
    NSBezierPath *holderBezierPath = [NSBezierPath bezierPathWithRoundedRect:holderRectWithoutShadow xRadius:8 yRadius:8];
    
    NSRect progressRectPath = NSMakeRect(holderRectWithoutShadow.origin.x + 1, holderRectWithoutShadow.origin.y + 1, floorf((holderRectWithoutShadow.size.width - 2) * .75), holderRectWithoutShadow.size.height - 2);
    NSBezierPath *progressBezierPath = [NSBezierPath bezierPathWithRoundedRect:progressRectPath xRadius:6 yRadius:6];
    
    CGPathRef holderPath = [holderBezierPath quartzPath];
    CGPathRef progressPath = [progressBezierPath quartzPath];
    
    // Draw the holder
    CGContextSaveGState(context);
    {
        
        CGContextSaveGState(context);
        {
            
            const CGFloat dropShadowComponents[] = {1.0f, 1.0f, 1.0f, 0.06f};
            CGColorRef dropShadowColor = CGColorCreate(colorSpace, dropShadowComponents);
            
            CGContextSetShadowWithColor(context, CGSizeMake(0, -1), 0, dropShadowColor);
            
            // Draw holder background gradient
            CGContextBeginTransparencyLayer(context, NULL);
            {
                CGContextAddPath(context, holderPath);
                CGContextClip(context);
                
                
                CGFloat components[] = {0.0f, 0.0f, 0.0f, 0.14f,
                    0.0f, 0.0f, 0.0f, 0.0f};
                CGFloat locations[] = { 0, 1 };
                CGGradientRef backgroundGradient = CGGradientCreateWithColorComponents(colorSpace, components, locations, 2);
                
                const CGFloat backgroundColorComponents[] = { 0.1176f, 0.1176f, 0.1176f, 0.70f };
                
                CGColorRef backgroundColor = CGColorCreate(colorSpace, backgroundColorComponents);
                
                CGContextSaveGState(context);
                {
                    
                    CGContextSetFillColorWithColor(context, backgroundColor);
                    CGContextFillRect(context, NSRectToCGRect(self.bounds));
                    
                    CGColorRelease(backgroundColor);
                    
                    CGContextDrawLinearGradient(context, backgroundGradient, CGPointMake(0, self.bounds.size.height), CGPointMake(0, 0), 0);
                    
                    CGGradientRelease(backgroundGradient);
                    
                }
                CGContextRestoreGState(context);
                
            }
            CGContextEndTransparencyLayer(context);
        }
        CGContextRestoreGState(context);
        
        // Draw the holder inner shadow
        CGContextSaveGState(context);
        {
            CGContextAddPath(context, holderPath);
            const CGFloat holderInnerShadowComponents[] = {0.0f, 0.0f, 0.0f, 1.0f};
            CGColorRef holderInnerShadowColor = CGColorCreate(colorSpace, holderInnerShadowComponents); 
            NPContextDrawInnerShadowWithColor(context, CGSizeMake(0, -1), 3, holderInnerShadowColor);
            CGColorRelease(holderInnerShadowColor);
        }
        CGContextRestoreGState(context);
    }
    CGContextRestoreGState(context);
    
    
    // Draw the progress bar
    CGContextSaveGState(context);
    {
        // Draw the stroke.  It'll draw it inside, too, so have it draw the rest on top
        CGContextSaveGState(context);
        {
            CGContextAddPath(context, progressPath);
            const CGFloat progressBarStrokeComponents[] = { 0.0f, 0.0f, 0.0f, 0.37f };
            CGColorRef progressBarStrokeColor = CGColorCreate(colorSpace, progressBarStrokeComponents);
            
            CGContextSetStrokeColorWithColor(context, progressBarStrokeColor);
            CGContextSetLineWidth(context, 2.0f);
            CGContextStrokePath(context);
            CGColorRelease(progressBarStrokeColor);
            
        }
        CGContextRestoreGState(context);
        
        // Draw the actual progress bar
        CGFloat progressComponents[] = {0.7569f, 0.2706f, 0.7608f, 1.000f,
            0.2824f, 0.1961f, 0.4431f, 1.000f};
        CGFloat progressLocations[] = {1, 0};
        CGGradientRef progressGradient = CGGradientCreateWithColorComponents(colorSpace, progressComponents, progressLocations, 2);
        
        
        CGContextAddPath(context, progressPath);
        CGContextClip(context);
        
        CGRect progressBoundingBox = CGPathGetBoundingBox(progressPath);
        
        CGContextDrawLinearGradient(context, progressGradient, CGPointMake(progressBoundingBox.origin.x, 0), CGPointMake(CGRectGetMaxX(progressBoundingBox), 0), 0);
        
        
        CGContextSaveGState(context);
        {
            //Draw the gloss
            CGContextSetBlendMode(context, kCGBlendModeOverlay);
            CGContextBeginTransparencyLayerWithRect(context, CGRectMake(progressBoundingBox.origin.x, progressBoundingBox.origin.y + floorf(progressBoundingBox.size.height) / 2, progressBoundingBox.size.width, floorf(progressBoundingBox.size.height) / 2), NULL);
            {
                const CGFloat glossGradientComponents[] = {1.0f, 1.0f, 1.0f, 0.47f,
                    0.0f, 0.0f, 0.0f, 0.0f};
                const CGFloat glossGradientLocations[] = {1.0, 0.0};
                CGGradientRef glossGradient = CGGradientCreateWithColorComponents(colorSpace, glossGradientComponents, glossGradientLocations, 2);
                CGContextDrawLinearGradient(context, glossGradient, CGPointMake(0, 0), CGPointMake(0, CGRectGetMaxY(progressBoundingBox)), 0);
                CGGradientRelease(glossGradient);
            }
            CGContextEndTransparencyLayer(context);
            
            //Draw the gloss's drop shadow
            CGContextSetBlendMode(context, kCGBlendModeSoftLight);
            CGContextBeginTransparencyLayer(context, NULL);
            {
                
                const CGFloat glossDropShadowComponents[] = {0.0f, 0.0f, 0.0f, 0.56f,
                    0.0f, 0.0f, 0.0f, 0.0f};
                CGColorRef glossDropShadowColor = CGColorCreate(colorSpace, glossDropShadowComponents);
                
                CGRect fillRect = CGRectMake(progressBoundingBox.origin.x, progressBoundingBox.origin.y + floorf(progressBoundingBox.size.height / 2), progressBoundingBox.size.width, floorf(progressBoundingBox.size.height / 2));
                
                CGContextSaveGState(context);
                {
                    CGContextSetShadowWithColor(context, CGSizeMake(0, -1), 4, glossDropShadowColor);
                    CGContextFillRect(context, fillRect);
                    CGColorRelease(glossDropShadowColor);
                }
                CGContextRestoreGState(context);
                CGContextSetBlendMode(context, kCGBlendModeClear);
                CGContextFillRect(context, fillRect);
            }
            CGContextEndTransparencyLayer(context);
        }
        CGContextRestoreGState(context);
        
        // Draw progress bar glow
        CGContextSaveGState(context);
        {
            CGContextAddPath(context, progressPath);
            const CGFloat progressBarGlowComponents[] = { 1.0f, 1.0f, 1.0f, 0.12f };
            CGColorRef progressBarGlowColor = CGColorCreate(colorSpace, progressBarGlowComponents);
            
            CGContextSetBlendMode(context, kCGBlendModeOverlay);
            CGContextSetStrokeColorWithColor(context, progressBarGlowColor);
            CGContextSetLineWidth(context, 2.0f);
            CGContextStrokePath(context);
            CGColorRelease(progressBarGlowColor);
        }
        CGContextRestoreGState(context);
        
        // Draw progress bar inner shadow
        CGContextSaveGState(context);
        {
            CGContextAddPath(context, progressPath);
            const CGFloat progressBarInnerShadowComponents[] = { 1.0f, 1.0f, 1.0f, 0.16f };
            CGColorRef progressBarInnerShadowColor = CGColorCreate(colorSpace, progressBarInnerShadowComponents);
            CGContextSetBlendMode(context, kCGBlendModeOverlay);
            NPContextDrawInnerShadowWithColor(context, CGSizeMake(0, -1), 0, progressBarInnerShadowColor);
            CGColorRelease(progressBarInnerShadowColor);
        }
        CGContextRestoreGState(context);
        
        // Draw stripes
        CGContextSaveGState(context);
        {
            CGContextSetPatternPhase(context, CGSizeMake(_xPatternOffset, 0));
            static const CGPatternCallbacks callbacks = {0, &NPDrawStripePattern, NULL};
            CGColorSpaceRef patternSpace = CGColorSpaceCreatePattern(colorSpace);
            CGContextSetFillColorSpace(context, patternSpace);
            CGColorSpaceRelease(patternSpace);
            
            CGPatternRef pattern = CGPatternCreate(NULL, CGRectMake(0, 0, 20, 20), CGAffineTransformIdentity, 20, 20, kCGPatternTilingConstantSpacing, false, &callbacks);
            const CGFloat patternColorComponents[] = { 0.0f, 0.0f, 0.0f, 0.28f };
            CGContextSetFillPattern(context, pattern, patternColorComponents);
            CGPatternRelease(pattern);
            CGContextSetBlendMode(context, kCGBlendModeSoftLight);
            CGContextFillRect(context, CGRectMake(progressBoundingBox.origin.x, -2, progressBoundingBox.size.width, self.bounds.size.height + 2));
        }
        CGContextRestoreGState(context);
        
    }
    CGContextRestoreGState(context);
    
    CGColorSpaceRelease(colorSpace);
}

@end
