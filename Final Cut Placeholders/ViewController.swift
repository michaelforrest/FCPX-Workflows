//
//  ViewController.swift
//  Final Cut Placeholders
//
//  Created by Michael Forrest on 26/03/2019.
//  Copyright © 2019 Good To Hear. All rights reserved.
//

import Cocoa

class ViewController: NSViewController {

    @IBOutlet weak var checklistTextField: NSTextFieldCell!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override var representedObject: Any? {
        didSet {
            if let doc = representedObject as? Document{
                let presenter = ChecklistPresenter(doc: doc)
                checklistTextField.stringValue = presenter.markdown
            }
        }
    }


}

