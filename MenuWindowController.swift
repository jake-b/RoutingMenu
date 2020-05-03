//
//  MenuWindowController.swift
//  RoutingMenu
//
//  Created by Jake Bordens on 1/26/17.
//  Copyright © 2017 Jake Bordens. All rights reserved.
//

import Cocoa

class MenuWindowController: NSWindowController {

    override func windowDidLoad() {
        super.windowDidLoad()

        // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
    }
}

extension MenuWindowController : SimulatedMenuItemDelegate {
    func didFinishTask(sender: SimulatedMenuItemView) {
        self.close()
        if let appDelegate = NSApplication.shared.delegate as? AppDelegate {
            appDelegate.startAnimation()
        }
    }
}
