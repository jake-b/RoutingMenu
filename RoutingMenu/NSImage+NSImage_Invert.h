//
//  NSImage+NSImage_Invert.h
//  RoutingMenu
//
//  Created by Jake Bordens on 1/27/17.
//  Copyright © 2017 Jake Bordens. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface NSImage (NSImage_Invert)

- (NSImage*) invert;
- (NSBitmapImageRep *)bitmapImageRepresentation;

@end
