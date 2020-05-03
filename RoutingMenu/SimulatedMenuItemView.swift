//
//  SimulatedMenuItemView.swift
//  RoutingMenu
//
//  Created by Jake Bordens on 1/26/17.
//  Copyright © 2017 Jake Bordens. All rights reserved.
//

import Cocoa

@objc protocol SimulatedMenuItemDelegate: class {
    func didFinishTask(sender: SimulatedMenuItemView)
}

@IBDesignable
class SimulatedMenuItemView: NSView {

    
    var _imageIndex : Int = 0
    var  mouseHovering : Bool = false
    var trackingArea : NSTrackingArea? = nil
    var timer : Timer? = nil
    
    let tapSound = NSSound(named: "tap2.aiff")!
    
    @IBOutlet weak var delegate : AnyObject?
    
    @IBInspectable var imageIndex: Int = 0 {
        
        didSet {
            _imageIndex = imageIndex
            self.setNeedsDisplay(self.frame)
        }
        
    }
    
    override func draw(_ dirtyRect: NSRect) {
        var image : NSImage?
        let bundle = Bundle(for: type(of: self))
        
        switch _imageIndex {
        case 0:
            image = bundle.image(forResource: "PrintMenu")
            break;
        case 1:
            image = bundle.image(forResource: "FaxMenu")
            break;
        case 2:
            image = bundle.image(forResource:"BeamMenu")
            break;
        case 3:
            image = bundle.image(forResource:"DuplicateMenu")
            break;
        case 4:
            image = bundle.image(forResource:"DeleteMenu")
            break;
            
        default:
            image = nil
        }

        if (mouseHovering) {
            image?.invert().draw(in: dirtyRect)
        } else {
            image?.draw(in: dirtyRect)
        }
        
    }
    
    override func mouseEntered(with event: NSEvent) {
        self.mouseHovering = true;
        let r = self.bounds
        self.setNeedsDisplay(r)
    }
    
    override func mouseExited(with event: NSEvent) {
        self.mouseHovering = false;
        let r = self.bounds
        self.setNeedsDisplay(r)
    }
    
    override func mouseUp(with event: NSEvent) {
        timer = Timer.scheduledTimer(timeInterval: 0.08, target: self, selector: #selector(self.flash), userInfo: nil, repeats: true);
        
        let dispatchTime = DispatchTime.now() + 0.3
        
        DispatchQueue.main.async(execute: {
            self.tapSound.play()
        })
        
        
        DispatchQueue.main.asyncAfter(deadline: dispatchTime) {
            if let delegate = self.delegate {
                self.timer?.invalidate()
                self.mouseHovering = false
                (delegate as! SimulatedMenuItemDelegate).didFinishTask(sender:self)
            }
        }

    }
    
    @objc func flash() {
        self.mouseHovering = !self.mouseHovering
        let r = self.bounds
        self.setNeedsDisplay(r)
    }
    
    override func updateTrackingAreas() {
        if let ta = trackingArea {
            self.removeTrackingArea(ta)
        }
        
        trackingArea = NSTrackingArea(rect: self.bounds, options: [.mouseEnteredAndExited, .activeAlways], owner: self, userInfo: nil)
        self.addTrackingArea(trackingArea!)
    }
}
