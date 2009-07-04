//
//  UKLineSizeView.h
//  UKPaintView
//
//  Created by Uli Kusterer on Mon Nov 03 2003.
//  Copyright (c) 2003 M. Uli Kusterer. All rights reserved.
//

#import <AppKit/AppKit.h>


@interface UKLineSizeView : NSView
{
	float		floatValue;	// Current line size value.
	float		maxValue;	// Maximum line size we display (used for swatch widths).
	SEL			action;		// Action to send to the target when our value changes through user input.
	id			target;		// Object to notify when user changes our value.
}

-(float)	floatValue;
-(void)		setFloatValue: (float)v;

-(float)	maxValue;
-(void)		setMaxValue: (float)v;

-(id)		target;
-(void)		setTarget: (id)anObject;

-(SEL)		action;
-(void)		setAction: (SEL)aSelector;

@end
