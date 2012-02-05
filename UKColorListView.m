//
//  UKColorListView.m
//  UKPaintView
//
//  Created by Uli Kusterer on Mon Nov 03 2003.
//  Copyright (c) 2003 M. Uli Kusterer. All rights reserved.
//

#import "UKColorListView.h"
#import "UKHelperMacros.h"


@implementation UKColorListView

-(id)	initWithFrame: (NSRect)frame
{
    if( self = [super initWithFrame:frame] )
	{
		NSString*		colorListName = [[NSBundle mainBundle] objectForInfoDictionaryKey: @"CFBundleName"];
		colorList = [[NSColorList colorListNamed: colorListName] retain];
		
		if( colorList == nil )
		{
			colorList = [[NSColorList alloc] initWithName: colorListName];
			[colorList setColor:[NSColor whiteColor] forKey: @"White"];
			[colorList setColor:[NSColor grayColor] forKey: @"Gray"];
			[colorList setColor:[NSColor blackColor] forKey: @"Black"];
			[colorList setColor:[NSColor redColor] forKey: @"Bright Red"];
			[colorList setColor:[[NSColor redColor] shadowWithLevel: 0.4] forKey: @"Dark Red"];
			[colorList setColor:[NSColor purpleColor] forKey: @"Bright Purple"];
			[colorList setColor:[[NSColor purpleColor] shadowWithLevel: 0.4] forKey: @"Medium Purple"];
			[colorList setColor:[NSColor blueColor] forKey: @"Bright Blue"];
			[colorList setColor:[[NSColor blueColor] shadowWithLevel: 0.4] forKey: @"Medium Blue"];
			[colorList setColor:[NSColor greenColor] forKey: @"Bright Green"];
			[colorList setColor:[[NSColor greenColor] shadowWithLevel: 0.4] forKey: @"Medium Green"];
			[colorList setColor:[[NSColor yellowColor] blendedColorWithFraction:0.5 ofColor:[NSColor whiteColor]] forKey: @"Bright Yellow"];
			[colorList setColor:[NSColor yellowColor] forKey: @"Yellow"];
			[colorList setColor:[NSColor orangeColor] forKey: @"Bright Orange"];
			[colorList setColor:[[NSColor orangeColor] shadowWithLevel: 0.4] forKey: @"Dark Orange"];
			[colorList setColor:[[NSColor orangeColor] shadowWithLevel: 0.8] forKey: @"Brown"];
			[colorList writeToFile: nil];	// Save to default location.
		}
		
		[[NSColorPanel sharedColorPanel] attachColorList: colorList];
		
		[[NSNotificationCenter defaultCenter] addObserver:self selector: @selector(colorChanged:)
					name: NSColorPanelColorDidChangeNotification object: [NSColorPanel sharedColorPanel]];
		if( colorList )
			[[NSNotificationCenter defaultCenter] addObserver:self selector: @selector(colorChanged:)
					name: NSColorListDidChangeNotification object: colorList];
    }
	
    return self;
}


-(void)	dealloc
{
	[[NSNotificationCenter defaultCenter] removeObserver:self
					name: NSColorPanelColorDidChangeNotification
					object: [NSColorPanel sharedColorPanel]];
	[colorList writeToFile: nil];	// Save to default location.
	DESTROY_DEALLOC(colorList);
	
	[super dealloc];
}


-(void)	drawRect: (NSRect)rect
{
	NSArray*		colorKeyList = [colorList allKeys];
	NSEnumerator*	enny = [colorKeyList objectEnumerator];
	NSColor *		currColor = nil,
			*		currPanelColor = [[NSColorPanel sharedColorPanel] color];
	NSString*		currKey;
	NSRect			swatchBox = { { 0.5, 0 }, { 0, 0 } };
	
	swatchBox.size.height = [self bounds].size.height;
	swatchBox.size.width = truncf(([self bounds].size.width -SWATCH_DISTANCE) / [colorKeyList count]) -SWATCH_DISTANCE;
	if( swatchBox.size.width < MIN_SWATCH_WIDTH )
		swatchBox.size.width = MIN_SWATCH_WIDTH;
	swatchBox.size.height = truncf(SWATCH_WIDTH_HEIGHT_RATIO * swatchBox.size.width);
	swatchBox.origin.y = [self bounds].size.height -swatchBox.size.height -SWATCH_BORDER -0.5;
	swatchBox.origin.x += SWATCH_BORDER;
	
	// Draw background and box:
	[NSBezierPath setDefaultLineWidth: 1.0];
	[[NSColor whiteColor] set];
	[NSBezierPath fillRect: [self bounds]];
	
	[[NSColor controlShadowColor] set];
	[NSBezierPath strokeRect: [self bounds]];
	
	while( currKey = [enny nextObject] )
	{
		currColor = [colorList colorWithKey: currKey];
		
		// Draw swatch:
		[currColor drawSwatchInRect: swatchBox];
		if( currPanelColor == currColor )	// Current color? Draw this swatch highlighted.
		{
			NSRect			currBox = swatchBox;
			
			currBox = NSInsetRect( currBox, -1.0, -1.0 );
			[NSBezierPath setDefaultLineWidth: 1.0];
			[[NSColor blackColor] set];
			[NSBezierPath strokeRect: currBox];
			
			currBox = NSInsetRect( currBox, 2.0, 2.0 );
			[NSBezierPath setDefaultLineWidth: 2.0];
			[[NSColor whiteColor] set];
			[NSBezierPath strokeRect: currBox];
			
			currBox = NSInsetRect( currBox, 1.0, 1.0 );
			[NSBezierPath setDefaultLineWidth: 1.0];
			[[NSColor blackColor] set];
			[NSBezierPath strokeRect: currBox];
		}
		else	
		{
			[NSBezierPath setDefaultLineWidth: 1.0];
			[[NSColor blackColor] set];
			[NSBezierPath strokeRect: swatchBox];
		}
		
		// Calculate next swatch's position:
		swatchBox.origin.x += swatchBox.size.width +SWATCH_DISTANCE;
		if( (swatchBox.origin.x +swatchBox.size.width) > [self bounds].size.width )
		{
			swatchBox.origin.x = SWATCH_BORDER +0.5;
			swatchBox.origin.y -= swatchBox.size.height +SWATCH_DISTANCE;
		}
	}
	
	// Draw current color's name at bottom of view:
	NSFont*			descFont = [NSFont boldSystemFontOfSize: [NSFont smallSystemFontSize]];
	NSDictionary*	strAttributes = [NSDictionary dictionaryWithObjectsAndKeys: descFont, NSFontAttributeName, [NSColor whiteColor], NSForegroundColorAttributeName, nil];
	NSString*		colorName = [colorList nameForColor: currPanelColor];
	
	if( colorName == nil )
		colorName = [[currPanelColor colorUsingColorSpaceName: NSNamedColorSpace] localizedColorNameComponent];
	
	NSRect	bgBox = { { 0, 0 }, { 0, 0 } };
	#if MAC_OS_X_VERSION_MAX_ALLOWED >= MAC_OS_X_VERSION_10_2
	bgBox.size.height = 18.0;
	#else
	bgBox.size.height = [descFont defaultLineHeightForFont] +SWATCH_BORDER;
	#endif
	bgBox.size.width = [self bounds].size.width;
	
	[[NSColor controlShadowColor] set];
	[NSBezierPath fillRect: bgBox];
	[colorName drawAtPoint: NSMakePoint(SWATCH_BORDER, SWATCH_BORDER)
					withAttributes: strAttributes];
}


-(void)	mouseDown: (NSEvent*)event
{
	NSPoint			clickPos = [event locationInWindow];
	NSArray*		colorKeyList = [colorList allKeys];
	NSColor*		currColor;
	NSString*		currKey;
	NSRect			swatchBox = { { 0.5, 0 }, { 0, 0 } };
	int				hitX, hitY,
					numXSwatches;
	
	clickPos = [self convertPoint: clickPos fromView: nil];
	
	swatchBox.size.height = [self bounds].size.height;
	swatchBox.size.width = truncf(([self bounds].size.width -SWATCH_DISTANCE) / [colorKeyList count]) -SWATCH_DISTANCE;
	if( swatchBox.size.width < MIN_SWATCH_WIDTH )
		swatchBox.size.width = MIN_SWATCH_WIDTH;
	swatchBox.size.height = truncf(SWATCH_WIDTH_HEIGHT_RATIO * swatchBox.size.width);
	swatchBox.origin.y = [self bounds].size.height -swatchBox.size.height -SWATCH_BORDER -0.5;
	swatchBox.origin.x += SWATCH_BORDER;
	
	clickPos.y = [self bounds].size.height -clickPos.y;	// Swap y coordinate.
	hitX = (clickPos.x -SWATCH_BORDER) / (swatchBox.size.width +SWATCH_DISTANCE) +1;
	hitY = (clickPos.y -SWATCH_BORDER) / (swatchBox.size.height +SWATCH_DISTANCE);
	numXSwatches = ([self bounds].size.width -SWATCH_DISTANCE) / (swatchBox.size.width +SWATCH_DISTANCE);
	
	int	clickedIndex = ((hitY * numXSwatches) +hitX);
	if( clickedIndex >= [colorKeyList count] )
		clickedIndex = [colorKeyList count] -1;
	currKey = [colorKeyList objectAtIndex: clickedIndex];
	currColor = [colorList colorWithKey: currKey];
		
	[[NSColorPanel sharedColorPanel] setColor: currColor];
	
	// SetNeedsDisplay is called when we get the color change notification from the panel.
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


@end


@implementation NSColorList (UKFindNameForColor)

-(NSString*)	nameForColor: (NSColor*) col
{
	NSArray*		colorKeyList = [self allKeys];
	NSEnumerator*	enny = [colorKeyList objectEnumerator];
	NSString*		currKey;
	
	while( currKey = [enny nextObject] )
	{
		if( col == [self colorWithKey: currKey] )
			return currKey;
	}
	
	return nil;
}

@end
