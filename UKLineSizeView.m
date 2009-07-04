//
//  UKLineSizeView.m
//  UKPaintView
//
//  Created by Uli Kusterer on Mon Nov 03 2003.
//  Copyright (c) 2003 M. Uli Kusterer. All rights reserved.
//

#import "UKLineSizeView.h"


@implementation UKLineSizeView

-(id)	initWithFrame: (NSRect)frame
{
    if( self = [super initWithFrame:frame] )
	{
        floatValue = 1.0;
		maxValue = 20.0;
		target = nil;
		action = @selector(takeLineSizeFromObject:);
		[[NSNotificationCenter defaultCenter] addObserver:self selector: @selector(colorChanged:)
					name: NSColorPanelColorDidChangeNotification object: [NSColorPanel sharedColorPanel]];
    }
	
    return self;
}


-(void)	dealloc
{
	[[NSNotificationCenter defaultCenter] removeObserver:self
					name: NSColorPanelColorDidChangeNotification
					object: [NSColorPanel sharedColorPanel]];
	[super dealloc];
}

-(void)	drawRect: (NSRect)rect
{
	NSPoint		topPos = rect.origin,
				botPos = rect.origin;
	float		maxX = rect.origin.x +rect.size.width -4,
				currSize = 1.0, boxBot = rect.origin.y;
	short		numSamples,
				x;
	NSColor*	currColor = [[NSColorPanel sharedColorPanel] color];
	
	topPos.x += 4 +(maxValue /2) +0.5;
	botPos.x += topPos.x;
	botPos.y += 4;
	topPos.y = botPos.y +rect.size.height -8;
	
	numSamples = maxX -rect.origin.x -4;
	numSamples /= maxValue;
	if( (numSamples * maxValue) < (maxX -rect.origin.x -4) )
		numSamples += 1;
	currSize = 1;
	
	// Draw box that will hold line samples:
	NSColor*	checkColor = [currColor colorUsingColorSpaceName: NSCalibratedRGBColorSpace];
	if( (([checkColor redComponent] +[checkColor greenComponent] +[checkColor blueComponent]) / 3) >= 0.85 )
		NSDrawGrayBezel( rect, rect );	// Very bright color? Probably invisible on white surface, so draw dark one.
	else
		NSDrawWhiteBezel( rect, rect );	// Darker color? Draw on white surface, which is prettier.
	
	// Get a font to use for displaying line size numbers:
	NSFont*			descFont = [NSFont systemFontOfSize: [NSFont smallSystemFontSize]];
	NSDictionary*	sizeStrAttributes = [NSDictionary dictionaryWithObjectsAndKeys: descFont, NSFontAttributeName, currColor, NSForegroundColorAttributeName, nil];
	NSDictionary*	selSizeStrAttributes = [NSDictionary dictionaryWithObjectsAndKeys: descFont, NSFontAttributeName, [NSColor selectedTextColor], NSForegroundColorAttributeName, nil];
	
	boxBot = botPos.y;
	botPos.y += [descFont defaultLineHeightForFont] +2;
	[descFont set];
	
	// Make sure line samples look like taken out of a line:
	[NSBezierPath setDefaultLineCapStyle: NSButtLineCapStyle];
	[NSBezierPath setDefaultLineJoinStyle: NSMiterLineJoinStyle];
	
	for( x = 1; x <= numSamples; x++ )
	{
		NSColor*		lineColor = currColor;
		NSSize			sizeStrSize;
		NSString*		sizeStr;
		NSDictionary*	sizeStrAttrs = sizeStrAttributes;
		
		// Draw highlighted box if this is the current choice:
		if( currSize == floatValue )
		{
			NSRect		box;
			
			box.origin = botPos;
			box.origin.x -= (maxValue /2);
			box.origin.y = boxBot -2;
			box.size.width = maxValue;
			box.size.height = topPos.y -boxBot +4;
			
			[NSBezierPath setDefaultLineWidth: 1.0];
			[[NSColor selectedTextBackgroundColor] set];
			[NSBezierPath fillRect: box];
			
			// Make sure drawings are done in "selected text" color:
			lineColor = [NSColor selectedTextColor];
			sizeStrAttrs = selSizeStrAttributes;
		}
		
		// Draw line sample:
		[NSBezierPath setDefaultLineWidth: currSize];
		[lineColor set];
		[NSBezierPath strokeLineFromPoint: botPos toPoint: topPos];
		
		// Draw line size below sample:
		sizeStr = [NSString stringWithFormat: @"%d", (int) currSize];
		sizeStrSize = [sizeStr sizeWithAttributes: sizeStrAttrs];
		[sizeStr drawAtPoint: NSMakePoint(botPos.x -(sizeStrSize.width /2), boxBot)
					withAttributes: sizeStrAttrs];
		
		// Move drawing to next swatch:
		currSize += 1.0;
		botPos.x += maxValue;
		topPos.x += maxValue;
	}
}


-(void)	mouseDown: (NSEvent*)event
{
	NSPoint		clickPos = [event locationInWindow];
	NSPoint		topPos = [self bounds].origin,
				botPos = [self bounds].origin;
	float		maxX = [self bounds].origin.x +[self bounds].size.width -4,
				currSize = 1.0;
	short		numSamples;
	
	clickPos = [self convertPoint: clickPos fromView: nil];
	
	topPos.x += 4 +(maxValue /2) +0.5;
	botPos.x += topPos.x;
	botPos.y += 4;
	topPos.y = botPos.y +[self bounds].size.height -8;
	
	numSamples = maxX -[self bounds].origin.x -4;
	numSamples /= maxValue;
	currSize = 1;
	
	floatValue = currSize +truncf((clickPos.x -4) / maxValue);
	if( target )
		[target performSelector: action withObject: self];
	
	[self setNeedsDisplay: YES];
}


-(void)	mouseDragged: (NSEvent*)event
{
	[self mouseDown: event];
}


-(BOOL)	acceptsFirstMouse: (NSEvent*)theEvent
{
	return YES;
}


-(void)	colorChanged: (id)sender
{
	[self setNeedsDisplay: YES];
}


-(float)	floatValue
{
	return floatValue;
}


-(void)		setFloatValue: (float)v
{
	floatValue = v;
}


-(float)	maxValue
{
	return maxValue;
}


-(void)		setMaxValue: (float)v
{
	maxValue = v;
}


-(id)	target
{
	return target;
}

-(void)	setTarget: (id)anObject
{
	target = anObject;
}

-(SEL)	action
{
	return action;
}


-(void)	setAction: (SEL)aSelector
{
	action = aSelector;
}


@end
