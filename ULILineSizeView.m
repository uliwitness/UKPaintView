//
//  UKLineSizeView.m
//  UKPaintView
//
//  Created by Uli Kusterer on Mon Nov 03 2003.
//  Copyright (c) 2003 M. Uli Kusterer. All rights reserved.
//
//	This software is provided 'as-is', without any express or implied
//	warranty. In no event will the authors be held liable for any damages
//	arising from the use of this software.
//
//	Permission is granted to anyone to use this software for any purpose,
//	including commercial applications, and to alter it and redistribute it
//	freely, subject to the following restrictions:
//
//	   1. The origin of this software must not be misrepresented; you must not
//	   claim that you wrote the original software. If you use this software
//	   in a product, an acknowledgment in the product documentation would be
//	   appreciated but is not required.
//
//	   2. Altered source versions must be plainly marked as such, and must not be
//	   misrepresented as being the original software.
//
//	   3. This notice may not be removed or altered from any source
//	   distribution.
//

#import "ULILineSizeView.h"


@implementation ULILineSizeView

@synthesize delegate;

-(id)	initWithFrame: (NSRect)frame
{
    if(( self = [super initWithFrame:frame] ))
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
	if( delegate && [delegate respondsToSelector: @selector(lineColor)] )
		currColor = [delegate lineColor];
	
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
	#if MAC_OS_X_VERSION_MAX_ALLOWED >= MAC_OS_X_VERSION_10_2
	botPos.y += 18.0 +2;
	#else
	botPos.y += [descFont defaultLineHeightForFont] +2;
	#endif
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
