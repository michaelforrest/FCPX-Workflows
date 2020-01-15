//
//  ViewController.swift
//  FinalCutMarkers
//
//  Created by Michael Forrest on 04/09/2018.
//  Copyright © 2018 Good To Hear. All rights reserved.
//

import Cocoa

class ViewController: NSViewController {
    
    @IBOutlet var textView: NSTextView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override var representedObject: Any? {
        didSet {
            print("Representing \(representedObject)")
        }
    }
    @IBAction func didPressAddMarkers(_ sender: NSButton) {
        let document = representedObject as! Document
        let markers = createMarkers()
        sender.title = "Saved \(markers.count) marker/s"
        document.add(markers: markers)
        document.save(self)
    }
    
    func createMarkers() -> [Marker]{
        let lines = textView.string.components(separatedBy: "\n")
        return lines.map{ Marker(string: $0) } 
    }
    

}

