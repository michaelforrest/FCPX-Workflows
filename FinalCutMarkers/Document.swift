//
//  Document.swift
//  FinalCutMarkers
//
//  Created by Michael Forrest on 04/09/2018.
//  Copyright © 2018 Good To Hear. All rights reserved.
//

import Cocoa

func convertToSeconds(_ string: String?)->TimeInterval?{
    guard let string = string else { return nil }
    let components = string.replacingOccurrences(of: "s", with: "").split(separator: "/").map{ String($0) }
    let numerator = components[0]
    if components.count == 2{
        let denominator = components[1]
        return TimeInterval(numerator)! / TimeInterval(denominator)!
    }else{
        return TimeInterval(numerator)!
    }
}

class Document: NSDocument {
    var project: XML!
    var spine: XML!
    var xml: XML!
    
    override init() {
        super.init()
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
        return xml.toXMLString().data(using: String.Encoding.utf8)!
    }

    override func read(from data: Data, ofType typeName: String) throws {
        xml = XML(data: data)!
        project = try! xml["library"]["event"]["project"][0].getXML()
        spine = try! xml["library"]["event"]["project"]["sequence"]["spine"].getXML()
        
        let name = "\(project["@name"].string!) With Markers"
        project.addAttribute(name: "name", value: name)
        self.displayName = name

//        throw NSError(domain: NSOSStatusErrorDomain, code: unimpErr, userInfo: nil)
    }
    
    func add(markers: [Marker]){
        for marker in markers{
            add(marker: marker)
        }
    }
    func add(marker: Marker){
        var used = false
        for element in spine.children{
            let start = convertToSeconds(element["@start"].string)
            if let offset = convertToSeconds(element["@offset"].string),
                let duration = convertToSeconds(element["@duration"].string)
            {
                if let inSeconds = marker.inSeconds{
                    if inSeconds >= offset && inSeconds <= offset + duration {
                        //                    let otherMarker = element["marker"]
                        let markerXML = marker.toXML(offset: (start ?? 0) - offset)
                        if element.name.hasSuffix("clip"),
                            let audioChannelSourceIndex = element.children.index(where: { $0.name.starts(with: "audio-") })
                        {
                            element.children.insert(markerXML, at: audioChannelSourceIndex)
                        }else{
                            element.addChild(markerXML)
                        }
                        used = true
                    }
                }
                
            }
            
        }
        if !used{
            Swift.print("Couldn't place marker \(marker.text) \(marker.timeString)")
        }
    }
    
}

