//
//  ViewController.swift
//  FCPX-Workflows
//
//  Created by Michael Forrest on 28/08/2018.
//  Copyright © 2018 Good To Hear. All rights reserved.
//

import Cocoa

class ViewController: NSViewController {
    @IBOutlet weak var filePathLabel: NSTextField!
    @IBOutlet var textArea: NSTextView!
    @IBOutlet weak var button: NSButton!
    
    var filePath: String?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    override func viewDidLayout() {
        super.viewDidLayout()
        if let path = filePath{
            filePathLabel.stringValue = path
        }
        button.isEnabled = filePath != nil && textArea.string != ""
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }


    @IBAction func didPressButton(_ sender: Any) {
    }
}

extension ViewController:DropViewDelegate{
    func dropViewDidDidDrop(path: String) {
        filePath = path
        view.needsLayout = true
    }
}

