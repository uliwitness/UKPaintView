//
//  UKPaintView.h
//  UKPaintView
//
//  Created by Uli Kusterer on Fri Oct 31 2003.
//  Copyright (c) 2003 M. Uli Kusterer. All rights reserved.
//

#import <AppKit/AppKit.h>


@class UKPaintTool;


@interface UKPaintView : NSView
{
	NSImage*				image;
	NSImage*				tempTrackImage;
	NSImage*				floatingSelectionImage;
	NSPoint					initialPos;
	NSPoint					lastPos;
	NSColor*				lineColor;
	NSColor*				fillColor;
	NSSize					lineSize;
	NSUndoManager*			undoManager;
	NSTrackingRectTag		tempTrackTag;
	NSRect					selectionFrame;
	NSBezierPath*			selectionPath;
	float					selectionAlpha;
	float					selectionPhase;
	NSTimer*				selectionTimer;
	float					selectionTimerDelta;
	BOOL					drawSelectionHighlight;
	IBOutlet UKPaintTool*	currentTool;
	IBOutlet UKPaintTool*	selectionTool;
	IBOutlet id				delegate;
}


-(IBAction)	takeLineSizeFromObject: (id)sender;
-(IBAction)	takeToolFromObject: (id)sender;

-(IBAction)	clearMarkersBuffer: (id)sender;
-(IBAction)	clearSelectionBuffer: (id)sender;
-(IBAction)	drawSelectionBuffer: (id)sender;
-(void)		drawSelectionHighlightAroundPath: (NSBezierPath*)thePath;

-(NSUndoManager*)	undoManager;

-(id)			delegate;
-(void)			setDelegate: (id)d;

-(void)			setImage: (NSImage*)img;
-(NSImage*)		image;

-(NSColor*)		lineColor;
-(void)			setLineColor: (NSColor*)col;

-(NSColor*)		fillColor;
-(void)			setFillColor: (NSColor*)col;

-(NSSize)		lineSize;
-(void)			setLineSize: (NSSize)ls;

-(UKPaintTool*)	currentTool;
-(void)			setCurrentTool: (UKPaintTool*)t;

-(UKPaintTool*)	selectionTool;
-(void)			setSelectionTool: (UKPaintTool*)t;

-(NSPoint)		initialPos;

-(void)			setDrawSelectionHighlight: (BOOL)state;
-(BOOL)			drawSelectionHighlight;

-(NSImage*)		floatingSelectionImage;
-(void)			setSelectionFrame: (NSRect)box;
-(NSRect)		selectionFrame;
-(void)			setSelectionPath: (NSBezierPath*)thePath;
-(NSBezierPath*)selectionPath;
-(void)			removeSelection;
-(void)			moveSelectionByX: (float)xDelta andY: (float)yDelta;
-(void)			selectionHighlightNeedsDisplayForRect: (NSRect)box;

-(void)			paintToolDidChange: (id)sender;
-(void)			paintToolWillChange: (id)sender;

-(void)			cut: (id)sender;
-(void)			copy: (id)sender;
-(void)			paste: (id)sender;
-(void)			clear: (id)sender;
-(void)			delete: (id)sender;

@end


@interface NSObject (UKPaintViewDelegate)

-(void)		paintViewImageChanged: (id)sender;
-(void)		paintViewToolWillChange: (id)sender;
-(void)		paintViewToolDidChange: (id)sender;

@end


@protocol UKPaintViewToolProvider

-(UKPaintTool*)	paintTool;

@end
