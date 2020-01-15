//
//  ChecklistPresenter.swift
//  Final Cut Placeholders
//
//  Created by Michael Forrest on 26/03/2019.
//  Copyright © 2019 Good To Hear. All rights reserved.
//

import Cocoa

class ChecklistPresenter: NSObject {
    let doc: Document
    init(doc: Document){
        self.doc = doc
    }
    var markdown: String {
        return doc.placeholders.enumerated().map { "\($0).\t\(Int(($1.duration.rounded())))s\t\($1.text ?? "")" }.joined(separator: "\n")
    }
}
