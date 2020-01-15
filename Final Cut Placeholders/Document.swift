//
//  Document.swift
//  Final Cut Placeholders
//
//  Created by Michael Forrest on 26/03/2019.
//  Copyright © 2019 Good To Hear. All rights reserved.
//

import Cocoa

struct Placeholder{
    let rawDuration:String
    var text:String?
    var duration: TimeInterval {
        let pair = rawDuration.replacingOccurrences(of: "s", with: "").components(separatedBy: "/")
        return TimeInterval(pair[0])! / TimeInterval(pair[1])!
    }
}

class Document: NSDocument {
    var parser: XMLParser?
    var placeholders = [Placeholder]()
    override init() {
        super.init()
        // Add your subclass-specific initialization here.
    }

    override class var autosavesInPlace: Bool {
        return true
    }
    // weird I have to add this by hand.
    var viewController: ViewController? {
        return windowControllers[0].contentViewController as? ViewController
    }
    override func makeWindowControllers() {
        // Returns the Storyboard that contains your Document window.
        let storyboard = NSStoryboard(name: NSStoryboard.Name("Main"), bundle: nil)
        let windowController = storyboard.instantiateController(withIdentifier: NSStoryboard.SceneIdentifier("Document Window Controller")) as! NSWindowController
        self.addWindowController(windowController)
        viewController?.representedObject = self
    }

    override func data(ofType typeName: String) throws -> Data {
        // Insert code here to write your document to data of the specified type, throwing an error in case of failure.
        // Alternatively, you could remove this method and override fileWrapper(ofType:), write(to:ofType:), or write(to:ofType:for:originalContentsURL:) instead.
        throw NSError(domain: NSOSStatusErrorDomain, code: unimpErr, userInfo: nil)
    }

    override func read(from data: Data, ofType typeName: String) throws {
        let parser = XMLParser(data: data)
        parser.delegate = self
        parser.parse()
        self.parser = parser
    }


}

extension Document: XMLParserDelegate{
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
        if elementName == "video" && attributeDict["name"] == "Placeholder"{
            placeholders.append(Placeholder(rawDuration: attributeDict["duration"]!, text: nil))
            Swift.print(elementName, attributeDict["name"], attributeDict["duration"])
        }
        if var currentPlaceholder = placeholders.last, let name = attributeDict["name"], let text = attributeDict["value"]{
            if elementName == "param" && name == "Text" && currentPlaceholder.text == nil{
                currentPlaceholder.text = text
                placeholders.removeLast()
                placeholders.append(currentPlaceholder)
            }
        }
    }
    
    func parserDidEndDocument(_ parser: XMLParser) {
        Swift.print(placeholders)
        
    }

}
