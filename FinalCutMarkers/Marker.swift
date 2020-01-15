//
//  Marker.swift
//  FinalCutMarkers
//
//  Created by Michael Forrest on 04/09/2018.
//  Copyright © 2018 Good To Hear. All rights reserved.
//

import Cocoa

class Marker: NSObject {
    let text: String
    let timeString: String
    init(string: String){
        let components = string.components(separatedBy: .whitespaces)
        let a = components[0]
        let b = components[1]
        let c = components[2]
        timeString = components[3]
        text = components[4...].joined(separator: " ")
        print("a: \(a), b: \(b), text: \(text)")
    }
    var inSeconds: TimeInterval?{
        let components:[String] = timeString.split(separator: ":").map{ String($0) }
        if components.count == 2{
            let minutes = components[0]
            let seconds = components[1]
            return (TimeInterval(minutes)! * 60 + TimeInterval(seconds)!)
        }else if components.count == 3{
            
            let hours = components[0]
            let minutes = components[1]
            let seconds = components[2]
            return (TimeInterval(hours)! * 60 * 60) + (TimeInterval(minutes)! * 60) + TimeInterval(seconds)!
        }
        return nil
    }
    func toXML(offset: TimeInterval)->XML{
        let xml = XML(name: "marker")
        xml.addAttributes([
            "start": "\(offset + inSeconds!.rounded())s",
            "duration": "1/44100s",
            "value": text,
            "completed": "0"
            ])
        return xml
    }
}
