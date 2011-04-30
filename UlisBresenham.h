//
//  UlisBresenham.h
//  Mediator 4
//
//  Created by Uli Kusterer on 2001-12-25
//  Copyright (c) 2001 Uli Kusterer.
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
	Utility routine that allows computing lines. E.g. to draw shapes that are
	on a line, hit-testing on a line or whatever.
*/

#ifndef ULIS_BRESENHAM_H
#define ULIS_BRESENHAM_H

#ifdef __cplusplus
extern "C" {
#endif


/* -----------------------------------------------------------------------------
	Data types:
		This is the kind of callback procedure you pass to DrawBresenhamLine.
		Each point of the line will be passed to this function (in order).
		Provide such a function that does whatever you want with the points.
		It could record them in an array, it could draw a brush shape across
		the line, it could even just call SetPixel() to draw the pixel.
		
		userData is the data you pass into DrawBresenhamLine(). Use this to
		e.g. pass in the GrafPort you're drawing to, or a C++ object with
		additional data, or whatever.
   -------------------------------------------------------------------------- */

typedef void (*BresenhamPixelProcPtr)( float h, float v, void* userData );


/* -----------------------------------------------------------------------------
	DrawBresenhamLine:
		Computes a line from startX,startY to endX,endY, passing the
		coordinates to the function specified.
	
	TAKES:
		startX			-	Horizontal coordinate of starting point.
		startY			-	Vertical coordinate of starting point.
		endX			-	Horz. coord. of end pt.
		endY			-	Vert. coord. of end pt.
		pixelDrawProc	-	Function of type
							void name( float h, float v, void* userData )
							that will be called for each pixel to do something
							with it, e.g. draw it.
		userData		-	Any data you wish that will be passed on to your
							pixeldrawProc as a service (i.e. it's a refCon).
	
	REVISIONS:
		2001-12-25	UK	Created.
   -------------------------------------------------------------------------- */

void	DrawBresenhamLine( float startX, float startY, float endX, float endY,
							BresenhamPixelProcPtr pixelDrawProc, void* userData );


#ifdef __cplusplus
}
#endif


#endif /*ULIS_BRESENHAM_H*/