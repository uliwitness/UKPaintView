//
//  UKPaintTool.h
//  UKPaintView
//
//  Created by Uli Kusterer on Fri Oct 31 2003.
//  Copyright (c) 2003 M. Uli Kusterer. All rights reserved.
//

#import <Foundation/Foundation.h>

@class	UKPaintView;


@interface UKPaintTool : NSObject
{
	IBOutlet UKPaintView*		owner;
	IBOutlet NSButton*			toolButton;
}


+(id)			paintToolWithPaintView: (UKPaintView*)pv;


-(id)			initWithPaintView: (UKPaintView*)pv;


-(IBAction)		chooseTool: (id)sender;


-(void)			setOwner: (UKPaintView*)o;
-(UKPaintView*)	owner;


-(NSButton*)	toolButton;
-(void)			setToolButton: (NSButton*)b;


/* Sent immediately before the first draw[Temporary]TrackingToolShapeFrom:to: message:
	If you need 'trackingDidEnd', just do your clean-up in drawFinalToolShapeFrom:to: or
	drawDisposableToolShapeFrom:to: */
-(void)			trackingWillStart;

/* Override this to draw a shape during tracking:
	The drawings you do in here will be undone before you're called again. */
-(void)			drawTemporaryTrackingToolShapeFrom: (NSPoint*)prevPos to: (NSPoint)currPos;

/* Override this to draw a brush during tracking:
	The drawings you do in here will end up in the actual image buffer. */
-(void)			drawTrackingToolShapeFrom: (NSPoint*)prevPos to: (NSPoint)currPos;

/* Override this to draw a shape once tracking has finished:
	The drawings you do here will end up in the actual image buffer. */
-(void)			drawFinalToolShapeFrom: (NSPoint*)prevPos to: (NSPoint)currPos;

/* The following is the "final" method for markers:
	This draws into the tracking buffer, and will be erased as soon as tracking starts. */
-(void)			drawDisposableToolShapeFrom: (NSPoint*)prevPos to: (NSPoint)currPos;


/* If you're doing something like a Text tool, where the tool just creates an editable area,
	Override this:
	You'll want to draw some sort of outline in drawTemporaryTrackingToolShapeFrom:to: and
	create the text box in drawFinalToolShapeFrom:to:, and then delete it from this method. */
-(void)			paintToolWillUnload: (id)sender;
-(void)			paintToolDidLoad: (id)sender;

/* If you're drawing a shape, this will generate a rect from the two points that can be drawn:
	This is also useful for getting the rect to update after drawing something: */
-(NSRect)		rectFrom: (NSPoint)prevPos to: (NSPoint)currPos;

-(NSRect)		rectWithLineSizeFrom: (NSPoint)prevPos to: (NSPoint)currPos;	// Uses paint view's default line size.
-(NSRect)		rectWithLineSize: (NSSize)lineSize from: (NSPoint)prevPos to: (NSPoint)currPos;

// Return a cursor for use when this tool is current:
-(NSCursor*)	drawingCursor;
-(NSCursor*)	selectionCursor;	// When mouse is over selection. Defaults to drawingCursor.


// Return an image to use as the icon for this tool in the tool palette:
-(NSImage*)		toolIcon;			// By default loads the image named toolIconName.

// Return the name of an image to use as the icon for this tool in the tool palette.
-(NSString*)	toolIconName;

-(BOOL)			adjustCoordinates;	// Do we want this tool to get coordinates offset to draw on full pixels instead of between? Defaults to YES.


-(void)			restoreSavedShapeFrom: (NSPoint)startPos to: (NSPoint*)endPos;
-(BOOL)			isSaveableTool;


@end
