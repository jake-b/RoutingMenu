//
//  AppDelegate.swift
//  RoutingMenu
//
//  Created by Jake Bordens on 1/26/17.
//  Copyright © 2017 Jake Bordens. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    let wc = MainWindowController(windowNibName:"MainWindow")
    let mc = MenuWindowController(windowNibName:"MenuWindowController")
    let tapSound = NSSound(named: "tap1.aiff")!
    
    @IBOutlet weak var statusMenu: NSMenu!
    
    let statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.squareLength)
     
    func startAnimation() {
        let screenRect = NSScreen.main!.frame;
        let screenScale = NSScreen.main?.backingScaleFactor;
        
        let cgImage = CGWindowListCreateImage(screenRect, .optionOnScreenOnly, CGWindowID(0), [])
        let rep = NSBitmapImageRep(cgImage: cgImage!)
        rep.size = CGSize(width: screenRect.size.width/screenScale!, height: screenRect.size.height/screenScale!)
        let image = NSImage()
        
        image.addRepresentation(rep)
        
        wc.image = image
        //wc.window?.toggleFullScreen(self);
        
        
        wc.window?.styleMask = NSWindow.StyleMask.borderless
        wc.window?.setFrame(screenRect, display: true, animate: false)
        wc.window?.level = NSWindow.Level(rawValue: Int(CGWindowLevelForKey(CGWindowLevelKey.mainMenuWindow)+1))
        wc.showWindow(self)
        
        wc.startAnimating()
    }

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Insert code here to initialize your application
        if let button = statusItem.button {
            button.image = NSImage(named: "NewtonRoutingIcon")
            button.target = self
            button.action = #selector(AppDelegate.showMenu)
        }
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }
    
    @objc func showMenu(sender:AnyObject?) {
        let statusBarView = NSView(frame: NSRect(x: 0, y: 0, width: 25, height: 21))
        statusItem.view = statusBarView
        
        var rect = statusItem.view?.window?.frame;
        //rect?.origin.y = (rect?.origin.y)! - 533;
        //rect?.origin.x = (rect?.origin.x)! - 280;
        
        //let y = rect?.origin.y;
        //let x = rect?.origin.x;
        
        
        if var unwrappedRect = rect {
            if (unwrappedRect.origin.x) + (mc.window?.frame.size.width)! > NSScreen.main!.frame.width {
                unwrappedRect.origin.x = unwrappedRect.origin.x + (unwrappedRect.size.width) - (mc.window?.frame.size.width)!
                rect = unwrappedRect
            }
        }
        
        DispatchQueue.main.async(execute: {
            self.tapSound.play()
        })
        
        statusItem.view = nil
        statusItem.highlightMode = true
        //statusItem.image = NSImage(named: "NewtonRoutingIcon")
        
        if let button = statusItem.button {
            button.image = NSImage(named: "NewtonRoutingIcon")
            button.target = self
            button.action = #selector(AppDelegate.showMenu)
        }

        mc.window?.styleMask = NSWindow.StyleMask.borderless
        mc.window?.setFrameOrigin((rect?.origin)!)
        mc.showWindow(self)
        NSApp.activate(ignoringOtherApps: true)    
    }

}

