//
//  UKPixelPaintbrushTool.m
//  ULIPaintView
//
//  Created by Uli Kusterer on Fri Oct 31 2003.
//  Copyright (c) 2003 M. Uli Kusterer. All rights reserved.
//

#import "ULIPaintBrushTool.h"
#import "ULIPaintView.h"
#import "NSCursor+Box.h"
#import "UlisBresenham.h"
#import "UKHelperMacros.h"


@implementation ULIPaintBrushTool

@synthesize brushImage = mBrushImage;
@synthesize tintedBrushImage = mTintedBrushImage;

-(id)			initWithPaintView: (ULIPaintView*)pv
{
	if(( self = [super initWithPaintView: pv] ))
	{
		mBrushImage = [[NSImage imageNamed: @"brush01"] retain];
	}
	
	return self;
}


-(void)	dealloc
{
	DESTROY_DEALLOC(mBrushImage);
	DESTROY_DEALLOC(mTintedBrushImage);
	
	[super dealloc];
}


void	ULIPaintbrushBresenhamPixelProc( float x, float y, void* data )
{
	ULIPaintBrushTool*	tool = (ULIPaintBrushTool*) data;
	NSImage*				brushImage = [tool tintedBrushImage];
	NSSize					brushSize = [brushImage size];
	NSRect					box = NSZeroRect;
	
	box.origin.x = x -truncf(brushSize.width / 2);
	box.origin.y = y -truncf(brushSize.height / 2);
	box.size = brushSize;
	
	[brushImage drawAtPoint: box.origin fromRect: NSZeroRect operation: NSCompositeSourceOver fraction: 1.0];
	[[tool owner] setNeedsDisplayInRect: box];
}


-(void)	trackingWillStart
{
	DESTROY(mTintedBrushImage);
	mTintedBrushImage = [[NSImage alloc] initWithSize: [mBrushImage size]];
	CGRect		theBox = CGRectZero;
	theBox.size = NSSizeToCGSize( [mBrushImage size] );
	
	[mTintedBrushImage lockFocus];
		CGContextRef		theContext = [[NSGraphicsContext currentContext] graphicsPort];
		CGImageRef			brushCGImage = [mBrushImage CGImageForProposedRect: NULL context: [NSGraphicsContext currentContext] hints: nil];
		CGContextClipToMask( theContext, theBox, brushCGImage );
		[[owner lineColor] set];
		[NSBezierPath fillRect: NSRectFromCGRect(theBox)];
	[mTintedBrushImage unlockFocus];
}


/* Override this to draw a brush during tracking:
	The drawings you do in here will end up in the actual image buffer. */
-(void)			drawTrackingToolShapeFrom: (NSPoint*)lastPos to: (NSPoint)currPos
{
	// Draw a brush line using the owning paint view's line color:
	DrawBresenhamLine( lastPos->x, lastPos->y, currPos.x, currPos.y,
							ULIPaintbrushBresenhamPixelProc, self );
	
	*lastPos = currPos;		// Make sure we continue drawing at end of this line segment.
}


// Return the name of an image to use as the icon for this tool in the tool palette.
-(NSString*)	toolIconName
{
	return @"UKPaintbrushTool";
}


-(NSCursor*)	drawingCursor
{
	NSPoint	pos = { 0, 0 };
	NSSize	brushSize = [mBrushImage size];
	
	pos.x = truncf(brushSize.width / 2);
	pos.y = truncf(brushSize.height / 2);
	
	return [[[NSCursor alloc] initWithImage: mBrushImage hotSpot: pos] autorelease];
}


-(BOOL)			isSaveableTool
{
	return NO;
}



@end
