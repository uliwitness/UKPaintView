//
//  UKPaintView.h
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

#import <AppKit/AppKit.h>


@class ULIPaintTool;
@protocol ULIPaintViewDelegate;


@interface ULIPaintView : NSView
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
	IBOutlet ULIPaintTool*	currentTool;
	IBOutlet ULIPaintTool*	selectionTool;
	IBOutlet id				delegate;
}

-(IBAction)	takeLineSizeFromObject: (id)sender;
-(IBAction)	takeToolFromObject: (id)sender;

-(IBAction)	clearMarkersBuffer: (id)sender;
-(IBAction)	clearSelectionBuffer: (id)sender;
-(IBAction)	drawSelectionBuffer: (id)sender;
-(void)		drawSelectionHighlightAroundPath: (NSBezierPath*)thePath;

-(NSUndoManager*)	undoManager;

-(id<ULIPaintViewDelegate>)	delegate;
-(void)						setDelegate: (id<ULIPaintViewDelegate>)d;

-(void)			setImage: (NSImage*)img;
-(NSImage*)		image;

-(NSColor*)		lineColor;
-(void)			setLineColor: (NSColor*)col;
-(IBAction)		takeLineColorFrom: (NSColorWell*)theControl;

-(NSColor*)		fillColor;
-(void)			setFillColor: (NSColor*)col;
-(IBAction)		takeFillColorFrom: (NSColorWell*)theControl;

-(NSSize)		lineSize;
-(void)			setLineSize: (NSSize)ls;

-(ULIPaintTool*)	currentTool;
-(void)				setCurrentTool: (ULIPaintTool*)t;

-(ULIPaintTool*)	selectionTool;
-(void)				setSelectionTool: (ULIPaintTool*)t;

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


@protocol ULIPaintViewDelegate

@optional
-(void)		paintViewImageDidChange: (ULIPaintView*)sender;
-(void)		paintViewToolWillChange: (ULIPaintView*)sender;
-(void)		paintViewToolDidChange: (ULIPaintView*)sender;

-(void)		paintViewLineColorDidChange: (ULIPaintView*)sender;
-(void)		paintViewFillColorDidChange: (ULIPaintView*)sender;

@end


@protocol UKPaintViewToolProvider

-(ULIPaintTool*)	paintTool;

@end
