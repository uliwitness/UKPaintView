//
//  UKLineSizeView.h
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

/*
	A view that shows little sample swatches of line widths and lets you select
	one.
*/

#import <AppKit/AppKit.h>


@class ULIPaintView;


@protocol ULILineSizeViewDelegate <NSObject>

-(NSColor*)	lineColor;

@end


@interface ULILineSizeView : NSView
{
	float						floatValue;	// Current line size value.
	float						maxValue;	// Maximum line size we display (used for swatch widths).
	SEL							action;		// Action to send to the target when our value changes through user input.
	id							target;		// Object to notify when user changes our value.
	id<ULILineSizeViewDelegate>	delegate;
}

@property (assign) IBOutlet id<ULILineSizeViewDelegate>	delegate;

-(float)	floatValue;
-(void)		setFloatValue: (float)v;

-(float)	maxValue;
-(void)		setMaxValue: (float)v;

-(id)		target;
-(void)		setTarget: (id)anObject;

-(SEL)		action;
-(void)		setAction: (SEL)aSelector;

@end
