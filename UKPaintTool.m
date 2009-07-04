//
//  UKPaintTool.m
//  UKPaintView
//
//  Created by Uli Kusterer on Fri Oct 31 2003.
//  Copyright (c) 2003 M. Uli Kusterer. All rights reserved.
//

#import "UKPaintTool.h"
#import "UKPaintView.h"
#import "NSCursor+CrossHair.h"


@implementation UKPaintTool

+(id)			paintToolWithPaintView: (UKPaintView*)pv
{
	return [[[self alloc] initWithPaintView: pv] autorelease];
}


-(id)			init
{
	self = [super init];
	return self;
}


-(id)			initWithPaintView: (UKPaintView*)pv
{
	if( self = [super init] )
	{
		owner = pv;
	}
	
	return self;
}

/* Override this to draw a shape during tracking:
	The drawings you do in here will be undone before you're called again. */
-(void)			drawTemporaryTrackingToolShapeFrom: (NSPoint*)prevPos to: (NSPoint)currPos
{
	
}

/* Override this to draw a brush during tracking:
	The drawings you do in here will end up in the actual image buffer. */
-(void)			drawTrackingToolShapeFrom: (NSPoint*)prevPos to: (NSPoint)currPos
{
	
}

/* Override this to draw a shape once tracking has finished:
	The drawings you do here will end up in the actual image buffer. */
-(void)			drawFinalToolShapeFrom: (NSPoint*)prevPos to: (NSPoint)currPos
{
	[self drawTemporaryTrackingToolShapeFrom: prevPos to: currPos];	// Usually they should be the same, but if you need to optimize, you can use a more detailed version here.
}


-(void)			drawDisposableToolShapeFrom: (NSPoint*)prevPos to: (NSPoint)currPos
{
	
}


-(NSRect)		rectFrom: (NSPoint)prevPos to: (NSPoint)currPos
{
	NSRect		box;
	
	box.origin = prevPos;
	if( box.origin.x > currPos.x )
		box.origin.x = currPos.x;
	if( box.origin.y > currPos.y )
		box.origin.y = currPos.y;
	box.size.width = abs(currPos.x -prevPos.x) +1;
	box.size.height = abs(currPos.y -prevPos.y) +1;
	
	return box;
}


-(NSRect)		rectWithLineSizeFrom: (NSPoint)prevPos to: (NSPoint)currPos
{
	return [self rectWithLineSize: [owner lineSize] from: prevPos to: currPos];
}


-(NSRect)		rectWithLineSize: (NSSize)lineSize from: (NSPoint)prevPos to: (NSPoint)currPos
{
	NSRect		box;
	
	box = [self rectFrom: prevPos to: currPos];
	box.origin.x -= lineSize.width;
	box.origin.y -= lineSize.height;
	box.size.width += lineSize.width *2;
	box.size.height += lineSize.height *2;
	
	return box;
}


-(void)			trackingWillStart
{

}



-(void)			paintToolWillUnload: (id)sender
{
	
}

-(void)			paintToolDidLoad: (id)sender
{
	
}


-(IBAction)		chooseTool: (id)sender
{
	[owner setCurrentTool: self];
}


-(void)			setOwner: (UKPaintView*)o
{
	owner = o;
}

-(UKPaintView*)	owner
{
	return owner;
}


-(NSButton*)	toolButton
{
	return toolButton;
}


-(void)			setToolButton: (NSButton*)b
{
	toolButton = b;
}


-(void)		awakeFromNib
{
	if( toolButton )
	{
		NSImage*	theIcon = [[[self toolIcon] copy] autorelease];
		NSSize		theSize = [toolButton bounds].size;
		theSize.width -= 8;
		theSize.height -= 8;
		[theIcon setScalesWhenResized: YES];
		[theIcon setSize: theSize];
		[toolButton setImage: theIcon];
	}
}


-(NSCursor*)		drawingCursor
{
	return [NSCursor crossHairCursorWithLineSize: [owner lineSize] color: [owner lineColor]];
}


-(NSCursor*)		selectionCursor
{
	return [self drawingCursor];
}


// Return an image to use as the icon for this tool in the tool palette:
-(NSImage*)		toolIcon			// By default loads the image named toolIconName.
{
	return [NSImage imageNamed: [self toolIconName]];
}

// Return the name of an image to use as the icon for this tool in the tool palette.
-(NSString*)	toolIconName
{
	return @"";
}


-(void)			restoreSavedShapeFrom: (NSPoint)startPos to: (NSPoint*)endPos
{
	[self trackingWillStart];
	[self drawFinalToolShapeFrom: &startPos to: *endPos];
	[self drawDisposableToolShapeFrom: &startPos to: *endPos];
}


-(BOOL)			isSaveableTool
{
	return YES;
}


-(BOOL)			adjustCoordinates
{
	return YES;
}


@end
