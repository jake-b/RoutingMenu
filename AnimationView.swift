//
//  AnimationView.swift
//  Screenshot
//
//  Created by Bordens, Jacob on 1/26/17.
//  Copyright © 2017 Merck. All rights reserved.
//

import Cocoa

extension NSBezierPath {
    
    public var cgPath: CGPath {
        let path = CGMutablePath()
        var points = [CGPoint](repeating: .zero, count: 3)
        
        for i in 0 ..< self.elementCount {
            let type = self.element(at: i, associatedPoints: &points)
            switch type {
            case .moveTo:
                path.move(to: points[0])
            case .lineTo:
                path.addLine(to: points[0])
            case .curveTo:
                path.addCurve(to: points[2], control1: points[0], control2: points[1])
            case .closePath:
                path.closeSubpath()
            }
        }
        
        return path
    }
}

let frameData = [[[0.00348837209302326,0.0228070175438597], [0.5,0.0228070175438597], [0.994186046511628,0.0228070175438597], [0.991860465116279,0.5], [0.994186046511628,0.97719298245614], [0.5,0.980701754385965], [0.00116279069767442,0.973684210526316], [0.00813953488372093,0.5]],
                 
                 [[0.0837209302325581,0.0982456140350877], [0.5,0.0982456140350877], [0.92093023255814,0.0105263157894737], [0.912790697674419,0.517543859649123], [0.918604651162791,0.9], [0.5,0.903508771929825], [0.0813953488372093,0.905263157894737], [0.086046511627907,0.5]],
                 [[0.165116279069767,0.178947368421053], [0.506976744186047,0.163157894736842], [0.838372093023256,0.175438596491228], [0.836046511627907,0.5], [0.833720930232558,0.826315789473684], [0.559302325581395,0.829824561403509], [0.16046511627907,0.819298245614035], [0.167441860465116,0.466666666666667]],
                 [[0.246511627906977,0.291228070175439], [0.498837209302326,0.285964912280702], [0.752325581395349,0.27719298245614], [0.754651162790698,0.514035087719298], [0.752325581395349,0.770175438596491], [0.5,0.771929824561403], [0.23953488372093,0.773684210526316], [0.238372093023256,0.5]],
                 [[0.325581395348837,0.359649122807018], [0.501162790697674,0.380701754385965], [0.666279069767442,0.354385964912281], [0.656976744186046,0.545614035087719], [0.663953488372093,0.696491228070175], [0.502325581395349,0.680701754385965], [0.327906976744186,0.692982456140351], [0.309302325581395,0.517543859649123]],
                 [[0.397674418604651,0.445614035087719], [0.509302325581395,0.421052631578947], [0.584883720930233,0.424561403508772], [0.604651162790698,0.519298245614035], [0.590697674418605,0.617543859649123], [0.504651162790698,0.649122807017544], [0.4,0.619298245614035], [0.396511627906977,0.540350877192982]]]


let crumple1 = NSImage(named: "Crumple1")
let crumple2 = NSImage(named: "Crumple2")
let crumple3 = NSImage(named: "Crumple3")
let crumple4 = NSImage(named: "Crumple4")
let crumple5 = NSImage(named: "Crumple5")
let crumple6 = NSImage(named: "Crumple6")

let crumpleFrames = [crumple1, crumple1, crumple2, crumple2, crumple3, crumple3, crumple4, crumple4, crumple5, crumple5, crumple6, crumple6, crumple1, crumple1]

class AnimationView: NSView {
    // Constants
    let startOfCrush = 1
    let startOfCrumple = 7
    
    // Members
    var image : NSImage?
    var frameNumber = 0
    var timer : Timer?
    var A : Double = 0, B : Double = 0, C : Double = 0
    
    let XPositionOfTrashCan : Double = Double((NSScreen.main?.frame.size.width)!) * 0.75;
    let trash = NSImage(named:"TrashCan")
    let sound = NSSound(named: "Trash.aiff")

    override func draw(_ dirtyRect: NSRect) {
        
        if (frameNumber == 0) {
            if let image = image {
                image.draw(in: dirtyRect)
            }
        }
        
        NSGraphicsContext.current?.shouldAntialias = false
        
        if (frameNumber >= startOfCrush && frameNumber < startOfCrumple) {
            guard let path = drawPath(forFrame: frameNumber - startOfCrush) else {
                return
            }
            
            // Draw the screenshot
            if (frameNumber == 1) {
                if let image = image {
                    image.draw(in: dirtyRect)
                }
            } else {
                let r = NSInsetRect(pathBounds(forFrame: frameNumber - startOfCrush), -30.0, -30.0)
                let segmentH = r.size.height / 2.0
                let segmentW = r.size.width / 2.0
                
                let centerX = self.bounds.size.width/2.0
                let centerY = self.bounds.size.height/2.0
                
                //let imgCenterX = (image?.size.width)! / 2.0
                //let imgCenterY = (image?.size.height)! / 2.0
                
                //Swift.print("IMAGE W: \(image?.size.width) H: \(image?.size.height)")
                //Swift.print("SEGMT W: \(segmentW) H: \(segmentH)")
                image?.draw(in: NSRect(x: (centerX-segmentW), y: (centerY-segmentH), width: segmentW, height: segmentH),
                          from: NSRect(x: 0.0, y: 0.0, width: segmentW/2, height: segmentH/2), operation: NSCompositingOperation.sourceOver, fraction: 1.0)
                image?.draw(in: NSRect(x: centerX, y: centerY-segmentH,          width: segmentW, height: segmentH),
                          from: NSRect(x: (image?.size.width)!-(segmentW/2), y: 0.0, width: segmentW/2, height: segmentH/2), operation: NSCompositingOperation.sourceOver, fraction: 1.0)
                image?.draw(in: NSRect(x: (centerX-segmentW), y: centerY,          width: segmentW, height: segmentH),
                            from: NSRect(x: 0.0, y: (image?.size.height)!-segmentH/2, width: segmentW/2, height: segmentH/2), operation: NSCompositingOperation.sourceOver, fraction: 1.0)
                image?.draw(in: NSRect(x: centerX, y: centerY,          width: segmentW, height: segmentH),
                            from: NSRect(x: (image?.size.width)!-(segmentW/2), y: (image?.size.height)!-segmentH/2, width: segmentW/2, height: segmentH/2), operation: NSCompositingOperation.sourceOver, fraction: 1.0)
                
                
            }

            //if (frameNumber >= 1 && frameNumber < startOfCrumple) {
            //    let crossHairs=NSBezierPath()
            //    let thisFrame = frameData[frameNumber - startOfCrush]
            //    let viewW = CGFloat(self.bounds.size.width)
            //    let viewH = CGFloat(self.bounds.size.height)
            //    crossHairs.move(to: NSPoint(x:CGFloat(thisFrame[1][0]) * viewW, y:CGFloat(thisFrame[1][1])*viewH))
            //    crossHairs.line(to: NSPoint(x:CGFloat(thisFrame[5][0]) * viewW, y:CGFloat(thisFrame[5][1])*viewH))
            //    crossHairs.move(to: NSPoint(x:CGFloat(thisFrame[3][0]) * viewW, y:CGFloat(thisFrame[3][1])*viewH))
            //    crossHairs.line(to: NSPoint(x:CGFloat(thisFrame[7][0]) * viewW, y:CGFloat(thisFrame[7][1])*viewH))
            //    crossHairs.lineWidth = 1.0
            //    NSColor.black.setStroke()
            //    crossHairs.stroke()
            //    Swift.print(crossHairs)
            // }
            
            // Draw the outline
            NSColor.black.setFill()
            NSColor.white.setStroke()
            path.lineWidth = CGFloat(6.0);
            path.fill()
            path.stroke()
            
            path.lineWidth = CGFloat(3.0);
            let color = NSColor(red: 0.5, green: 0.5, blue: 0.5, alpha: 0.5)
            color.setStroke()
            path.stroke()
        
        } else if (frameNumber >= startOfCrumple) {
            self.bounds.fill()
        }
        
        let x1 : Double = Double(self.bounds.width)/2.0
        let y1 : Double = Double(self.bounds.height)/2.0
        let x2 : Double = x1 + ((XPositionOfTrashCan - x1) / 2.0)
        let y2 : Double = Double(self.bounds.height)*0.6
        let x3 : Double = XPositionOfTrashCan
        let y3 : Double = 0.0
        
        let denom = (x1-x2) * (x1-x3) * (x2-x3);
        let A     = (x3 * (y2-y1) + x2 * (y1-y3) + x1 * (y3-y2)) / denom;
        let B     = (x3*x3 * (y1-y2) + x2*x2 * (y3-y1) + x1*x1 * (y2-y3)) / denom;
        let C     = (x2 * x3 * (x2-x3) * y1+x3 * x1 * (x3-x1) * y2+x1 * x2 * (x1-x2) * y3) / denom;
        
        let xStep = ((XPositionOfTrashCan) - (Double(self.bounds.size.width / 2.0))) / Double(crumpleFrames.count)
        if (frameNumber >= startOfCrumple && frameNumber < startOfCrumple+crumpleFrames.count) {
            let xpos = (Double(self.bounds.size.width / 2.0)) + (Double(frameNumber - startOfCrumple) * xStep)
            let ypos = A * (xpos * xpos) + (B * xpos) + C
            let myCrumple = crumpleFrames[frameNumber-startOfCrumple]
            var destRect = NSRect(x: xpos+60, y: ypos, width: 150, height: 150)
            myCrumple?.draw(in: destRect, from: NSZeroRect, operation: .sourceOver, fraction: 1.0)
            //myCrumple?.draw(at: NSPoint(x:xpos, y:ypos), from: NSZeroRect, operation: .sourceOver, fraction: 1.0)
        }
        
        trash?.draw(at: NSPoint(x:XPositionOfTrashCan, y:0), from: NSZeroRect, operation: .sourceOver, fraction: 1.0)
    }
    
    func startAnimation() {
        //Swift.print(")startAnimation()")
        frameNumber = 0
        self.setNeedsDisplay(self.bounds)
        
        timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(self.step), userInfo: nil, repeats: true);
        sound?.play()
        NSCursor.hide()
    }
    
    func stopAnimating() {
        timer?.invalidate()
        NSCursor.unhide()
    }
    
    @objc func step() {
        frameNumber+=1
        //if (frameNumber == startOfCrumple) {
        //    timer?.invalidate()
        //    timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(self.step), userInfo: nil, repeats: true);
        //}
        let r = self.bounds
        self.setNeedsDisplay(r)
    }
    
    func drawPath(forFrame:Int) -> NSBezierPath? {
        if (forFrame > 5 || forFrame < 0) {
            return nil;
        }
        
        let frame = frameData[forFrame];

 
        let curve = NSBezierPath()
        curve.lineWidth = CGFloat(6);
        curve.move(to: NSPoint(x:-10.0, y:-10.0))
        curve.line(to: NSPoint(x:-10.0, y:self.frame.size.height + 10.0))
        curve.line(to: NSPoint(x:self.frame.size.width + 10.0, y:self.frame.size.height + 10.0))
        curve.line(to: NSPoint(x:self.frame.size.width + 10.0, y:-10.0))
        curve.close()
        
        curve.move(to: NSPoint(x: frame[0][0] * Double(self.frame.size.width), y: frame[0][1] * Double(self.frame.size.height)))
        
        for i in 1...7 {
            curve.line(to: NSPoint(x: frame[i][0] * Double(self.frame.size.width), y: frame[i][1] * Double(self.frame.size.height)))
        }
        
        curve.close()
        return curve
    }
    
    func pathBounds(forFrame: Int) -> NSRect {
        let frame = frameData[forFrame];
        
        var maxX:CGFloat = 0, minX:CGFloat = 9999999
        var maxY:CGFloat = 0, minY:CGFloat = 9999999
        for i in 0...7 {
            let x = CGFloat(frame[i][0]) * self.bounds.size.width
            let y = CGFloat(frame[i][1]) * self.bounds.size.height
            if (x > maxX) { maxX = x }
            if (x < minX) { minX = x }
            if (y > maxY) { maxY = y }
            if (y < minY) { minY = y }
        }
        return NSRect(x: minX, y: minY, width: maxX-minX, height: maxY-minY)
    }
    
}
