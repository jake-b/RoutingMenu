//
//  MainWindowController.swift
//  Screenshot
//
//  Created by Bordens, Jacob on 1/26/17.
//  Copyright © 2017 Merck. All rights reserved.
//

import Cocoa

class MainWindowController: NSWindowController, NSWindowDelegate {
    
    @IBOutlet weak var animationView : AnimationView?
    
    var image : NSImage?
    
    override func awakeFromNib() {
        window!.delegate = self
        animationView!.image = image
        //animationView?.startAnimation()
    }

    override func mouseUp(with event: NSEvent) {
        self.close();
        animationView?.stopAnimating()
    }
    
    func startAnimating() {
         animationView?.startAnimation()
    }
}
