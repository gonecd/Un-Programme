//
//  ProgramData.swift
//  Un truc à la télé ?
//
//  Created by Cyril Delamare on 12/08/2018.
//  Copyright © 2018 Home. All rights reserved.
//

import UIKit

var db           : ProgramData       = ProgramData.init()
let dateXML      : DateFormatter     = DateFormatter()
let dateXMLshort : DateFormatter     = DateFormatter()


class ProgramData : NSObject, XMLParserDelegate {
    var parsedValue  : String = ""
    var valSvg  : String = ""
    var parserScope  : Int = 0
    let parserChaine : Int = 0
    let parserProgs  : Int = 1
    var currentSource : String = ""
    
    var Chaines         : NSMutableDictionary = NSMutableDictionary()
    var ChainesArray    : [String] = []
    var uneChaine       : Chaine = Chaine(id: "")
    
    var Programme   : [Prog] = [Prog]()
    var unProg      : Prog = Prog(chaine: "")
    
    override init() {
        dateXML.locale = Locale.current
        dateXML.dateFormat = "yyyyMMddHHmmss Z"
        dateXMLshort.locale = Locale.current
        dateXMLshort.dateFormat = "yyyyMMddHHmm Z"
    }
    
    func Download(source : String, force : Bool) {
        let TNT   : String = "https://xmltv.ch/xmltv/xmltv-tnt.xml"
        let Canal : String = "https://xmltv.ch/xmltv/xmltv-cplus.xml"
        var sourceURL : String = ""
        
        if (source == "TNT") { sourceURL = TNT }
        else if (source == "Canal") { sourceURL = Canal }
        else { return }
        
        if FileManager.default.fileExists(atPath: XMLDir.appendingPathComponent(source+".xml").path) {
            if (force == false) {
                // On ne download que si le fichier a plus de 24h (= 86400s)
                let attributs = try! FileManager.default.attributesOfItem(atPath: XMLDir.appendingPathComponent(source+".xml").path)
                let modifDate: Date = attributs[FileAttributeKey.modificationDate] as! Date
                if (modifDate.timeIntervalSinceNow > -86400) { return }
            }
            
            try! FileManager.default.removeItem(at: XMLDir.appendingPathComponent(source+".xml"))
        }
        
        let rawData = NSData(contentsOf: URL(string: sourceURL)!)
        try! rawData?.write(to: XMLDir.appendingPathComponent(source+".xml"))
    }
    
    func DataRead(source : String) {
        currentSource = source
        let parser = XMLParser(contentsOf: XMLDir.appendingPathComponent(source+".xml"))
        parser?.delegate = self

        if (parser?.parse())! {
            Programme = Programme.sorted { $0.debut < $1.debut }
        }
    }
    
    
    func purge() {
        Programme.removeAll()
        ChainesArray.removeAll()
        Chaines.removeAllObjects()
    }
    
    
    func parser(_ parser: XMLParser, didStartElement: String, namespaceURI: String?, qualifiedName: String?, attributes: [String : String] = [:]) {
        parsedValue = ""
        
        if (didStartElement == "channel") { parserScope = parserChaine }
        else if (didStartElement == "programme") { parserScope = parserProgs }
        
        if (parserScope == parserChaine) {
            if (didStartElement == "channel") { uneChaine = Chaine.init(id : attributes["id"]!) }
            else if (didStartElement == "icon") {
                if (attributes["src"]!.starts(with: "http://")) { uneChaine.icone = (attributes["src"]!).replacingOccurrences(of: "http://", with: "https://") }
                if (attributes["src"]!.starts(with: "https://")) { uneChaine.icone = (attributes["src"]!) }
                else if (attributes["src"]!.starts(with: "//")) { uneChaine.icone = (attributes["src"]!).replacingOccurrences(of: "//", with: "https://") }
            }
        }
        
        if (parserScope == parserProgs) {
            if (didStartElement == "programme") {
                unProg = Prog.init(chaine : attributes["channel"]!)
                unProg.debut = dateXML.date(from: attributes["start"]!)!
                
                if ((attributes["stop"]!).count == 20) {
                    unProg.fin = dateXML.date(from: attributes["stop"]!)! }
                else {
                    unProg.fin = dateXMLshort.date(from: attributes["stop"]!)! }
            }
            else if (didStartElement == "icon") { if (unProg.capture == "" ) { unProg.capture = (attributes["src"]!).replacingOccurrences(of: "http://", with: "https://") } }
            else if (didStartElement == "length") { unProg.duree = attributes["units"]! }
            
        }
    }
    
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        parsedValue += string
    }
    
    
    func parser(_ parser: XMLParser, didEndElement: String, namespaceURI: String?, qualifiedName: String?) {
        if (parserScope == parserChaine) {
            if (didEndElement == "display-name")    { uneChaine.nom = parsedValue }
            else if (didEndElement == "channel")    {
                if ((uneChaine.id != "C34.api.telerama.fr") || (currentSource != "Canal") ) {
                    Chaines.setValue(uneChaine, forKey: uneChaine.id)
                    ChainesArray.append(uneChaine.id)
                }
            }
            else if (didEndElement == "icon")       {  }
            else { print ("Balise de chaine inconnue : " + didEndElement) }
        }
        
        if (parserScope == parserProgs) {
            if (didEndElement == "title")                   { unProg.titre = parsedValue }
            else if (didEndElement == "desc")               { unProg.resume = parsedValue }
            else if (didEndElement == "sub-title")          { unProg.sousTitre = parsedValue }
            else if (didEndElement == "category")           { unProg.category = parsedValue; unProg.grpCategory = shortCategorie[parsedValue] as? String ?? "" }
            else if (didEndElement == "audio")              { /* Nothing to do */ }
            else if (didEndElement == "stereo")             { /* Nothing to do */ }
            else if (didEndElement == "date")               { unProg.annee = parsedValue }
            else if (didEndElement == "icon")               { /* Nothing to do */ }
            else if (didEndElement == "language")           { /* Nothing to do */ }
            else if (didEndElement == "subtitles")          { /* Nothing to do */ }
            else if (didEndElement == "previously-shown")   { /* Nothing to do */ }
            else if (didEndElement == "premiere")           { /* Nothing to do */ }
            else if (didEndElement == "rating")             { unProg.ratingCSA = valSvg }
            else if (didEndElement == "star-rating")        { unProg.ratingTelerama = valSvg }
            else if (didEndElement == "value")              { valSvg = parsedValue }
            else if (didEndElement == "length")             { unProg.duree = parsedValue + " " + unProg.duree }
            else if (didEndElement == "episode-num")        { unProg.episode = parsedValue }
            else if (didEndElement == "tv")                 { /* Nothing to do */ }
            else if (didEndElement == "new")                { /* Nothing to do ? */ }

            else if (didEndElement == "programme")          {
                if ((unProg.chaine != "C34.api.telerama.fr") || (currentSource != "Canal") ) {
                    Programme.append(unProg)
                }
            }

            else { print ("Balise de programme inconnue : " + didEndElement) }
        }
    }
    
    func parser(_ parser: XMLParser, parseErrorOccurred parseError: Error) {
        print("###" + parseError.localizedDescription)
    }
    
    
    func checkMappings() {
        
        for unProg in db.Programme {
            if (unProg.grpCategory == "") {
                print ("--> \(unProg.category)")
            }
        }
    }
}
