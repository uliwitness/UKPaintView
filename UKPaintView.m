//
//  UKPaintView.m
//  UKPaintView
//
//  Created by Uli Kusterer on Fri Oct 31 2003.
//  Copyright (c) 2003 M. Uli Kusterer. All rights reserved.
//

#import "UKPaintView.h"
#import "UKPaintTool.h"


@implementation UKPaintView

-(id)	initWithFrame: (NSRect)frame
{
    if( self = [super initWithFrame:frame] )
	{
        image = [[NSImage alloc] initWithSize: frame.size];
		[image lockFocus];
		[image unlockFocus];
        tempTrackImage = [[NSImage alloc] initWithSize: frame.size];
		[tempTrackImage lockFocus];
		[tempTrackImage unlockFocus];
        floatingSelectionImage = [[NSImage alloc] initWithSize: frame.size];
		[floatingSelectionImage lockFocus];
		[floatingSelectionImage unlockFocus];
		lineSize = NSMakeSize( 1, 1 );
		lineColor = [[NSColor blackColor] retain];
		fillColor = [[NSColor clearColor] retain];
		undoManager = [[NSUndoManager alloc] init];
		selectionAlpha = 1.0;
		selectionTimer = nil;
		selectionTimerDelta = -0.2;
		drawSelectionHighlight = YES;
	}
    return self;
}

-(void)	dealloc
{
	[undoManager release];
	[image release];
	[tempTrackImage release];
	[floatingSelectionImage release];
	[fillColor release];
	[lineColor release];
	[selectionTimer invalidate];
	selectionTimer = nil;
	
	[super dealloc];
}


-(void)	awakeFromNib
{
	[[self window] invalidateCursorRectsForView: self];	// Make sure cursor looks right.
}


-(void)	setDrawSelectionHighlight: (BOOL)state
{
	drawSelectionHighlight = state;
}


-(BOOL)	drawSelectionHighlight
{
	return drawSelectionHighlight;
}


-(void)	animateSelection: (NSTimer*)sender
{
	selectionAlpha += selectionTimerDelta;
	if( selectionTimerDelta > 0 && selectionAlpha > 1.0 )
	{
		selectionAlpha = 1.0;
		selectionTimerDelta = -0.2;
	}
	else if( selectionTimerDelta < 0 && selectionAlpha < 0.0 )
	{
		selectionAlpha = 0.0;
		selectionTimerDelta = 0.2;
	}
	selectionPhase += 0.3;
	if( selectionPhase > 1.0 )
		selectionPhase = 0;
	[self setNeedsDisplayInRect: NSInsetRect(selectionFrame,-4,-4)];
}


-(NSImage*)		floatingSelectionImage
{
	return floatingSelectionImage;
}


-(void)	setFrame: (NSRect) newbox
{
	[super setFrame: newbox];
	newbox = [self frame];
	
	NS_DURING
		[image setSize: newbox.size];
		[tempTrackImage setSize: newbox.size];
	NS_HANDLER
		NSLog( @"%s: Couldn't resize image: %@", __FUNCTION__, localException );
	NS_ENDHANDLER
}


-(void)	drawSelectionHighlightAroundPath: (NSBezierPath*)thePath
{
	[[[NSColor keyboardFocusIndicatorColor] colorWithAlphaComponent: selectionAlpha] set];
	[thePath setLineWidth: 3];
	float		pattern[2] = { 6, 6 };
	[thePath setLineDash: pattern count: 2 phase: selectionPhase * 12];
	[thePath stroke];
}


-(void)	selectionHighlightNeedsDisplayForRect: (NSRect)box
{
	[self setNeedsDisplayInRect: NSInsetRect(box,-4,-4)];
}


-(void)	drawRect: (NSRect)rect
{
    [image drawInRect: rect fromRect: rect operation: NSCompositeSourceAtop fraction: 1.0];
	NSRect		selBounds = NSZeroRect;
	selBounds.size = [floatingSelectionImage size];
	if( selBounds.size.width > 0 && selBounds.size.height > 0 )
	{
		[floatingSelectionImage drawInRect: selectionFrame fromRect: selBounds operation: NSCompositeSourceAtop fraction: 1.0];
		if( drawSelectionHighlight )
			[self drawSelectionHighlightAroundPath: selectionPath];
	}
    [tempTrackImage drawInRect: rect fromRect: rect operation: NSCompositeSourceAtop fraction: 1.0];
}


- (void)moveRight:(id)sender
{
	[self selectionHighlightNeedsDisplayForRect: selectionFrame];
	selectionFrame.origin.x += 1;
	selectionAlpha = 0;	// So user sees what she's doing.
	[self selectionHighlightNeedsDisplayForRect: selectionFrame];
	[[self window] invalidateCursorRectsForView: self];
}


- (void)moveLeft:(id)sender
{
	[self selectionHighlightNeedsDisplayForRect: selectionFrame];
	selectionFrame.origin.x -= 1;
	selectionAlpha = 0;	// So user sees what she's doing.
	[self selectionHighlightNeedsDisplayForRect: selectionFrame];
	[[self window] invalidateCursorRectsForView: self];
}


- (void)moveUp:(id)sender
{
	[self selectionHighlightNeedsDisplayForRect: selectionFrame];
	selectionFrame.origin.y += 1;
	selectionAlpha = 0;	// So user sees what she's doing.
	[self selectionHighlightNeedsDisplayForRect: selectionFrame];
	[[self window] invalidateCursorRectsForView: self];
}


- (void)moveDown:(id)sender
{
	[self selectionHighlightNeedsDisplayForRect: selectionFrame];
	selectionFrame.origin.y -= 1;
	selectionAlpha = 0;	// So user sees what she's doing.
	[self selectionHighlightNeedsDisplayForRect: selectionFrame];
	[[self window] invalidateCursorRectsForView: self];
}


- (void)cut:(id)sender
{
	[self copy: sender];
	[self delete: sender];
}


- (void)copy:(id)sender
{
	NSData*	tiffData = [floatingSelectionImage TIFFRepresentation];
	[[NSPasteboard generalPasteboard] declareTypes: [NSArray arrayWithObject: NSTIFFPboardType] owner: nil];
	[[NSPasteboard generalPasteboard] setData: tiffData forType: NSTIFFPboardType];
}


- (void)paste:(id)sender
{
	NSData*	tiffData = [[NSPasteboard generalPasteboard] dataForType: NSTIFFPboardType];
	[self removeSelection];
	
	[floatingSelectionImage release];
	floatingSelectionImage = [[NSImage alloc] initWithData: tiffData];
	NSSize		selectionSize = [floatingSelectionImage size];
	if( selectionFrame.size.width == 0 || selectionFrame.size.height == 0 )
	{
		if( selectionFrame.origin.x == 0 && selectionFrame.origin.y == 0 )		// Was completely empty selection?
		{
			// Center pasted image:
			NSSize	imgSize = [image size];
			selectionFrame.origin.x = truncf((imgSize.width -selectionSize.width) /2);
			selectionFrame.origin.y = truncf((imgSize.height -selectionSize.height) /2);
			selectionFrame.size = selectionSize;
		}
		else	// Have a click position? Put it there, but at correct size:
			selectionFrame.size = selectionSize;
	}
	// else just fit it in current selection.
	
	// If desired, change tool to selection tool after paste:
	if( [self selectionTool] )
		[self setCurrentTool: [self selectionTool]];
	
	[[self window] invalidateCursorRectsForView: self];
	[self setNeedsDisplay: YES];
}


-(void)	removeSelection
{
	[self drawSelectionBuffer: self];	// Merge selection with image again.
	[self clearSelectionBuffer: self];	// Clear now unneeded selection.
}


- (void)delete:(id)sender
{
	[self setSelectionFrame: NSZeroRect];
	[floatingSelectionImage setSize: NSMakeSize(8,8)];
	[self setNeedsDisplay: YES];
}


- (void)	keyDown:(NSEvent*)evt
{
	if( [evt keyCode] == 51 )
		[self delete: self];
	else
	{
		switch( [[evt characters] characterAtIndex: 0] )
		{
			case NSDeleteFunctionKey:
			case NSDeleteCharFunctionKey:
				[self delete: self];
				break;
			
			default:
				[super keyDown: evt];
				break;
		}
	}
}


- (void)selectAll:(id)sender
{
	[self removeSelection];
	
	// Make selection frame encompass whole image:
	selectionFrame.origin = NSZeroPoint;
	selectionFrame.size = [image size];
	
	// Create a new, empty "image":
	NSImage*	nuImg = [[NSImage alloc] initWithSize: selectionFrame.size];
	[nuImg lockFocus];
	[nuImg unlockFocus];
	
	// Remove selection, set selection to old "image" (all is now selected)
	// and set the "image" to our new, empty image:
	[floatingSelectionImage release];
	floatingSelectionImage = image;
	image = nuImg;
	
	[[self window] invalidateCursorRectsForView: self];
	[self setNeedsDisplay: YES];
}



- (void)unselectAll:(id)sender
{
	[self removeSelection];
	selectionFrame = NSZeroRect;
	[floatingSelectionImage setSize: NSMakeSize(8,8)];
	
	[[self window] invalidateCursorRectsForView: self];
	[self setNeedsDisplay: YES];
}



- (void)clear:(id)sender
{
	[self delete: sender];
}


-(void)		setSelectionPath: (NSBezierPath*)thePath
{
	selectionPath = [thePath retain];
	selectionFrame = [thePath bounds];
}


-(NSBezierPath*)selectionPath
{
	return selectionPath;
}


-(void)		setSelectionFrame: (NSRect)box
{
	selectionFrame = box;
	selectionPath = [[NSBezierPath bezierPathWithRect: selectionFrame] retain];
	
	[[self window] invalidateCursorRectsForView: self];
}


-(NSRect)		selectionFrame
{
	return selectionFrame;
}


-(void)		moveSelectionByX: (float)xDelta andY: (float)yDelta
{
	NSRect		oldBox = selectionFrame;
	NSAffineTransform*	trans = [NSAffineTransform transform];
	[trans translateXBy: xDelta yBy: yDelta];
	[selectionPath transformUsingAffineTransform: trans];
	
	selectionFrame = NSOffsetRect( selectionFrame, xDelta, yDelta );
	
	[self selectionHighlightNeedsDisplayForRect: oldBox];
	[self selectionHighlightNeedsDisplayForRect: selectionFrame];
}


-(IBAction)	clearMarkersBuffer: (id)sender
{
	NSRect		box = { { 0, 0 }, { 0, 0 } };
	
	box.size = [tempTrackImage size];
	
	[tempTrackImage lockFocus];
		[NSGraphicsContext saveGraphicsState];
		[[NSColor clearColor] set];
		NSRectFill(box);
		[NSGraphicsContext restoreGraphicsState];
	[tempTrackImage unlockFocus];
	
	[self setNeedsDisplay: YES];	// Make sure user sees the change.
}


-(IBAction)	clearSelectionBuffer: (id)sender
{
	NSRect		box = { { 0, 0 }, { 0, 0 } };
	
	box.size = [floatingSelectionImage size];
	
	[floatingSelectionImage lockFocus];
		[NSGraphicsContext saveGraphicsState];
		[[NSColor clearColor] set];
		NSRectFill(box);
		[NSGraphicsContext restoreGraphicsState];
	[floatingSelectionImage unlockFocus];
	
	[self setNeedsDisplay: YES];	// Make sure user sees the change.
}


-(IBAction)	drawSelectionBuffer: (id)sender	// Draw the selection buffer into the image buffer.
{
	NSRect		box = NSZeroRect;
	box.size = [floatingSelectionImage size];
	
	[image lockFocus];
		[floatingSelectionImage drawInRect: selectionFrame fromRect: box operation: NSCompositeSourceOver fraction: 1.0];
	[image unlockFocus];
	
	[self setNeedsDisplay: YES];	// Make sure user sees the change.
}


-(void)	mouseDown: (NSEvent*)event
{
	NSRect		box = { { 0, 0 }, { 0, 0 } };
	NSPoint		clickPos = [event locationInWindow];
		
	clickPos = [self convertPoint: clickPos fromView: nil];
	if( [currentTool adjustCoordinates] )
	{
		clickPos.x += 0.5;
		clickPos.y += 0.5;
	}
	
	lastPos = clickPos;
	initialPos = clickPos;
	
	box.size = [image size];
	
	// Register current state with our undo stack:
	[undoManager registerUndoWithTarget:self
                selector:@selector(setImage:)
                object: [[image copy] autorelease]];
	
	// Let the tool draw its first "blotch" or whatever:
	[currentTool trackingWillStart];
	
	[tempTrackImage lockFocus];
		[NSGraphicsContext saveGraphicsState];
		[[NSColor clearColor] set];
		NSRectFill(box);
		[currentTool drawTemporaryTrackingToolShapeFrom: &lastPos to: clickPos];
		[NSGraphicsContext restoreGraphicsState];
	[tempTrackImage unlockFocus];
	
	[image lockFocus];
		[NSGraphicsContext saveGraphicsState];
		[currentTool drawTrackingToolShapeFrom: &lastPos to: clickPos];
		[NSGraphicsContext restoreGraphicsState];
	[image unlockFocus];
	
	// Tight loop, faster:
	NSEvent*		currEvt = nil;
	BOOL			keepGoing = YES;
	while( keepGoing )
	{
		int		evtType;
		
		currEvt = [[self window] nextEventMatchingMask: (NSLeftMouseDraggedMask | NSLeftMouseUpMask)
								untilDate: [NSDate dateWithTimeIntervalSinceNow: 0.001] inMode: NSEventTrackingRunLoopMode
								dequeue: YES];
		if( !currEvt )
			continue;
		else
			evtType = [currEvt type];
			
		switch( evtType )
		{
			case NSLeftMouseDragged:
				[self mouseDragged: currEvt];
				break;
			
			case NSLeftMouseUp:
				[self mouseUp: currEvt];
				keepGoing = NO;
				break;
		}
	}

}

-(void)	mouseDragged: (NSEvent*)event
{
	NSRect		box = { { 0, 0 }, { 0, 0 } };
	NSPoint		clickPos = [event locationInWindow];
	clickPos = [self convertPoint: clickPos fromView: nil];
	if( [currentTool adjustCoordinates] )
	{
		clickPos.x += 0.5;
		clickPos.y += 0.5;
	}
	
	box.size = [image size];
	
	[tempTrackImage lockFocus];
		[NSGraphicsContext saveGraphicsState];
		[[NSColor colorWithCalibratedWhite: 1.0 alpha: 0.0] set];
		NSRectFill(box);
		[currentTool drawTemporaryTrackingToolShapeFrom: &lastPos to: clickPos];
		[NSGraphicsContext restoreGraphicsState];
	[tempTrackImage unlockFocus];
	
	[image lockFocus];
		[NSGraphicsContext saveGraphicsState];
		[currentTool drawTrackingToolShapeFrom: &lastPos to: clickPos];
		[NSGraphicsContext restoreGraphicsState];
	[image unlockFocus];
}

-(void)	mouseUp: (NSEvent*)event
{
	NSRect		box = { { 0, 0 }, { 0, 0 } };
	NSPoint		clickPos = [event locationInWindow];
	clickPos = [self convertPoint: clickPos fromView: nil];
	if( [currentTool adjustCoordinates] )
	{
		clickPos.x += 0.5;
		clickPos.y += 0.5;
	}
	
	box.size = [image size];
	
	[tempTrackImage lockFocus];
		[NSGraphicsContext saveGraphicsState];
		[[NSColor colorWithCalibratedWhite: 1.0 alpha: 0.0] set];
		NSRectFill(box);
		[currentTool drawDisposableToolShapeFrom: &lastPos to: clickPos];
		[NSGraphicsContext restoreGraphicsState];
	[tempTrackImage unlockFocus];
	
	[image lockFocus];
		[NSGraphicsContext saveGraphicsState];
		[currentTool drawFinalToolShapeFrom: &lastPos to: clickPos];
		[NSGraphicsContext restoreGraphicsState];
	[image unlockFocus];
	
	[delegate paintViewImageChanged: self];
}


-(BOOL)	acceptsFirstResponder
{
	return YES;
}

-(BOOL)	becomeFirstResponder
{
	[[NSColorPanel sharedColorPanel] setShowsAlpha: YES];
	[[NSColorPanel sharedColorPanel] setColor: lineColor];
	
	if( !selectionTimer )
		selectionTimer = [NSTimer scheduledTimerWithTimeInterval: 0.1 target: self selector:@selector(animateSelection:) userInfo: nil repeats: YES];
	
	return YES;
}


-(BOOL)	resignFirstResponder
{
	[selectionTimer invalidate];
	selectionTimer = nil;

	return YES;
}


-(IBAction)	undo: (id)sender
{
	[undoManager undo];
}


-(IBAction)	redo: (id)sender
{
	[undoManager redo];
}


-(BOOL)	validateMenuItem: (NSMenuItem*)menuItem
{
	if( [menuItem action] == @selector(undo:) )
		return [undoManager canUndo];
	else if( [menuItem action] == @selector(redo:) )
		return [undoManager canRedo];
	else if( [menuItem action] == @selector(paste:) )
		return [[NSPasteboard generalPasteboard] availableTypeFromArray: [NSArray arrayWithObject: NSTIFFPboardType]] != nil;
	else if( [menuItem action] == @selector(copy:) || [menuItem action] == @selector(cut:)
			|| [menuItem action] == @selector(delete:) || [menuItem action] == @selector(clear:)
			|| [menuItem action] == @selector(unselectAll:) )
		return selectionFrame.size.height > 0 && selectionFrame.size.width > 0;
	else if( [menuItem action] == @selector(selectAll:))
	{
		NSSize	imgSize = [image size];
		return selectionFrame.origin.x != 0 || selectionFrame.origin.y != 0
				|| selectionFrame.size.width != imgSize.width || selectionFrame.size.height != imgSize.height;
	}
	else
		return NO;
}


-(void)	changeColor: (id)sender
{
	[self setLineColor: [sender color]];
	[[self window] invalidateCursorRectsForView: self];
}


-(IBAction)	takeLineSizeFromObject: (id)sender
{
	[self setLineSize: NSMakeSize( [sender floatValue], [sender floatValue] ) ];
	[[self window] invalidateCursorRectsForView: self];
}


-(IBAction)	takeToolFromObject: (id)sender
{
	if( [sender isKindOfClass: [UKPaintTool class]] )
		[self setCurrentTool: sender];
	else
		[self setCurrentTool: [sender paintTool]];
}


-(UKPaintTool*)	currentTool
{
	return currentTool;
}

-(void)		setCurrentTool: (UKPaintTool*)t
{
	if( t != currentTool )
	{
		[self paintToolWillChange: self];
		[[currentTool toolButton] setState: 0];
		[currentTool release];
		currentTool = [t retain];
		[[currentTool toolButton] setState: 1];
		[[self window] invalidateCursorRectsForView: self];
		[self paintToolDidChange: self];
	}
}


-(UKPaintTool*)	selectionTool
{
	return selectionTool;
}

-(void)		setSelectionTool: (UKPaintTool*)t
{
	if( t != selectionTool )
	{
		[selectionTool release];
		selectionTool = [t retain];
	}
}


-(void)			paintToolDidChange: (id)sender
{
	[currentTool paintToolDidLoad: sender];
	[delegate paintViewToolDidChange: self];
}


-(void)			paintToolWillChange: (id)sender
{
	[delegate paintViewToolWillChange: self];
	[currentTool paintToolWillUnload: sender];
}



-(void)	resetCursorRects
{
	// +++ FIXME: Should really set selection cursor based on selectionPath, not just selectionFrame.
	[self addCursorRect:[self bounds] cursor: [currentTool drawingCursor]];
	if( selectionFrame.size.height != 0 && selectionFrame.size.width != 0 )
		[self addCursorRect: selectionFrame cursor: [currentTool selectionCursor]];
}


-(BOOL)	acceptsFirstMouse: (NSEvent*)theEvent
{
	return YES;
}


-(NSUndoManager*)	undoManager
{
	return undoManager;
}




-(id)			delegate
{
	return delegate;
}


-(void)			setDelegate: (id)d
{
	delegate = d;
}



-(NSImage*)	image
{
	return image;
}

-(void)		setImage: (NSImage*)img
{
	// Register current state with our undo stack:
	[undoManager registerUndoWithTarget:self
                selector:@selector(setImage:)
                object: [[image copy] autorelease]];
	
	// Do the usual set-accessor dance:
	NSImage*	nuImg = [img retain];
	[image release];
	image = nuImg;
	
	// Notify our delegate:
	[delegate paintViewImageChanged: self];
	
	[self setNeedsDisplay: YES];	// Make sure user notices the change.
}


-(NSColor*)	lineColor
{
	return lineColor;
}

-(void)		setLineColor: (NSColor*)col
{
	[lineColor release];
	lineColor = [col retain];
}


-(NSColor*)	fillColor
{
	return fillColor;
}

-(void)		setFillColor: (NSColor*)col
{
	[fillColor release];
	fillColor = [col retain];
}


-(NSSize)	lineSize
{
	return lineSize;
}

-(void)		setLineSize: (NSSize)ls
{
	lineSize = ls;
}


-(NSPoint)	initialPos
{
	return initialPos;
}

@end



@implementation NSObject (UKPaintViewDelegate)

-(void)		paintViewImageChanged: (id)sender
{
	
}


-(void)		paintViewToolWillChange: (id)sender
{
	
}


-(void)		paintViewToolDidChange: (id)sender
{
	
}

@end

