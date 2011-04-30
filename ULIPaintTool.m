//
//  UKPaintTool.m
//  UKPaintView
//
//  Created by Uli Kusterer on Fri Oct 31 2003.
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

#import "ULIPaintTool.h"
#import "ULIPaintView.h"
#import "NSCursor+CrossHair.h"


@implementation ULIPaintTool

+(id)			paintToolWithPaintView: (ULIPaintView*)pv
{
	return [[[self alloc] initWithPaintView: pv] autorelease];
}


-(id)			init
{
	self = [self initWithPaintView: nil];
	return self;
}


-(id)			initWithPaintView: (ULIPaintView*)pv
{
	if(( self = [super init] ))
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


-(void)			setOwner: (ULIPaintView*)o
{
	owner = o;
}

-(ULIPaintView*)	owner
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
