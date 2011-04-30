//
//  UKPaintTempRectTool.h
//  UKPaintView
//
//  Created by Uli Kusterer on Sat Nov 01 2003.
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
	A tool that draws a rectangle into a special "disposable" area, not touching
	the actual image. Whenever a new disposable shape is drawn, the old one is
	erased. This is useful to highlight what you are currently talking about.
*/

#import <AppKit/AppKit.h>
#import "ULIPaintTool.h"


@interface ULIPaintTempRectangleTool : ULIPaintTool
{

}

@end