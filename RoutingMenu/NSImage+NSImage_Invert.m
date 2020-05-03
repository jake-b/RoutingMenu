//
//  NSImage+NSImage_Invert.m
//  RoutingMenu
//
//  Created by Jake Bordens on 1/27/17.
//  Copyright © 2017 Jake Bordens. All rights reserved.
//

#import "NSImage+NSImage_Invert.h"

// Probably borrowed from https://stackoverflow.com/questions/12896831/nsimage-to-nsbitmapimagerep

@implementation NSImage (NSImage_Invert)

- (NSBitmapImageRep *)bitmapImageRepresentation {
    int width = [self size].width;
    int height = [self size].height;
    
    if(width < 1 || height < 1)
        return nil;
    
    NSBitmapImageRep *rep = [[NSBitmapImageRep alloc]
                             initWithBitmapDataPlanes: NULL
                             pixelsWide: width
                             pixelsHigh: height
                             bitsPerSample: 8
                             samplesPerPixel: 4
                             hasAlpha: YES
                             isPlanar: NO
                             colorSpaceName: NSDeviceRGBColorSpace
                             bytesPerRow: width * 4
                             bitsPerPixel: 32];
    
    NSGraphicsContext *ctx = [NSGraphicsContext graphicsContextWithBitmapImageRep: rep];
    [NSGraphicsContext saveGraphicsState];
    [NSGraphicsContext setCurrentContext: ctx];
    [self drawAtPoint: NSZeroPoint fromRect: NSZeroRect operation: NSCompositeCopy fraction: 1.0];
    [ctx flushGraphics];
    [NSGraphicsContext restoreGraphicsState];
    
    return rep;
}

- (NSImage*) invert {
    NSBitmapImageRep* srcImageRep = [self bitmapImageRepresentation];
    
    // srcImageRep is the NSBitmapImageRep of the source image
    int n = [srcImageRep bitsPerPixel] / 8;           // Bytes per pixel
    int w = [srcImageRep pixelsWide];
    int h = [srcImageRep pixelsHigh];
    int rowBytes = [srcImageRep bytesPerRow];
    int i;
    
    NSImage *destImage = [[NSImage alloc] initWithSize:NSMakeSize(w, h)];
    NSBitmapImageRep *destImageRep = [[NSBitmapImageRep alloc]
                                       initWithBitmapDataPlanes:NULL
                                       pixelsWide:w
                                       pixelsHigh:h
                                       bitsPerSample:8
                                       samplesPerPixel:n
                                       hasAlpha:[srcImageRep hasAlpha]
                                       isPlanar:NO
                                       colorSpaceName:[srcImageRep colorSpaceName]
                                       bytesPerRow:rowBytes
                                       bitsPerPixel:srcImageRep.bitsPerPixel];
    
    unsigned char *srcData = [srcImageRep bitmapData];
    unsigned char *destData = [destImageRep bitmapData];
    
    for ( i = 0; i < rowBytes * h; i+=4 ) {
        *(destData+i) = 255 - *(srcData+i);
        *(destData+i+1) = 255 - *(srcData+i+1);
        *(destData+i+2) = 255 - *(srcData+i+2);
        *(destData+i+3) = *(srcData+i+3);
        //*(destData + i) = 255 - *(srcData + i);
    }
    [destImage addRepresentation:destImageRep];
    
    return destImage;
}

@end
