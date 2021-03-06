//
//  MiscHelpers.swift
//  Un Programme
//
//  Created by Cyril DELAMARE on 14/03/2022.
//

import Foundation
import UIKit

let AppDir     : URL               = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
let ChainesDir : URL               = AppDir.appendingPathComponent("chaines")
let XMLDir     : URL               = AppDir.appendingPathComponent("xml")
let ConfigDir  : URL               = AppDir.appendingPathComponent("config")

let dateFormat      : DateFormatter     = DateFormatter()
let heureFormat     : DateFormatter     = DateFormatter()


func checkDirectories() {
    do
    {
        if (FileManager.default.fileExists(atPath: ChainesDir.path) == false) {
            try FileManager.default.createDirectory(at: ChainesDir, withIntermediateDirectories: false, attributes: nil)
        }
        
        if (FileManager.default.fileExists(atPath: XMLDir.path) == false) {
            try FileManager.default.createDirectory(at: XMLDir, withIntermediateDirectories: false, attributes: nil)
        }
        
        if (FileManager.default.fileExists(atPath: ConfigDir.path) == false) {
            try FileManager.default.createDirectory(at: ConfigDir, withIntermediateDirectories: false, attributes: nil)
        }
    }
    catch let error as NSError { print(error.localizedDescription); }
}

func loadFilters() -> [Filtre] {
    var loaded : [Filtre] = []
    
    if let nsData = NSData(contentsOf: ConfigDir.appendingPathComponent("Filtres")) {
        do {
            let data = Data(referencing:nsData)
            
            loaded = try (NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(data) as? [Filtre])!
        } catch {
            print("Echec de la lecture de la DB")
        }
    }
    
    return loaded
}

func saveFilters(filtres : [Filtre]) {
    do {
        let data = try NSKeyedArchiver.archivedData(withRootObject: filtres, requiringSecureCoding: false)
        try data.write(to: ConfigDir.appendingPathComponent("Filtres"))
    } catch {
        print ("Echec de la sauvegarde des filtres")
    }
}

func getImage(_ url: String) -> UIImage {
    if (url == "") { return UIImage() }
    
    let pathToImage = ChainesDir.appendingPathComponent(URL(string: url)!.lastPathComponent).path
    
    if (FileManager.default.fileExists(atPath: pathToImage)) {
        return UIImage(contentsOfFile: pathToImage)!
    }
    else {
        let imageData = NSData(contentsOf: URL(string: url)!)
        if (imageData != nil) {
            imageData?.write(toFile: pathToImage, atomically: true)
            return UIImage(data: imageData! as Data)!
        }
    }
    
    return UIImage()
}

func loadImage(_ url: String) -> UIImage {
    if (url == "") { return UIImage() }
    
    let imageData = NSData(contentsOf: URL(string: url)!)
    if (imageData != nil) { return UIImage(data: imageData! as Data)!}
    
    return UIImage()
}


let shortCategorie: NSDictionary = [
    "autre": "autre",
    "biographie": "biographie",
    "c??r??monie": "spectacle",
    "classique": "spectacle",
    "clips": "clips",
    "contemporain": "spectacle",
    "divertissement : jeu": "divertissement",
    "divertissement-humour": "divertissement",
    "divertissement": "divertissement",
    "documentaire animalier": "documentaire",
    "documentaire autre": "documentaire",
    "documentaire aventures": "documentaire",
    "documentaire beaux-arts": "documentaire",
    "documentaire cin??ma": "documentaire",
    "documentaire civilisations": "documentaire",
    "documentaire culture": "documentaire",
    "documentaire d??couvertes": "documentaire",
    "documentaire environnement": "documentaire",
    "documentaire fiction": "documentaire",
    "documentaire gastronomie": "documentaire",
    "documentaire g??opolitique": "documentaire",
    "documentaire histoire": "documentaire",
    "documentaire justice": "documentaire",
    "documentaire lettres": "documentaire",
    "documentaire musique classique": "documentaire",
    "documentaire musique": "documentaire",
    "documentaire nature": "documentaire",
    "documentaire politique": "documentaire",
    "documentaire religions": "documentaire",
    "documentaire sant??": "documentaire",
    "documentaire sciences et technique": "documentaire",
    "documentaire soci??t??": "documentaire",
    "documentaire sport": "documentaire",
    "documentaire t??l??r??alit??": "documentaire",
    "documentaire voyage": "documentaire",
    "d??bat parlementaire": "d??bat",
    "d??bat": "d??bat",
    "emission du bien-??tre": "emission",
    "emission musicale": "emission",
    "emission politique": "emission",
    "emission religieuse": "emission",
    "feuilleton policier": "feuilleton",
    "feuilleton r??aliste": "feuilleton",
    "feuilleton sentimental": "feuilleton",
    "film : autre": "film",
    "film : biographie": "film",
    "film : com??die dramatique": "film",
    "film : com??die polici??re": "film",
    "film : com??die sentimentale": "film",
    "film : com??die": "film",
    "film : court m??trage d'animation": "film",
    "film : court m??trage dramatique": "film",
    "film : court m??trage": "film",
    "film : drame": "film",
    "film : m??lodrame": "film",
    "film : thriller": "film",
    "film : western": "film",
    "film catastrophe": "film",
    "film d'action": "film",
    "film d'animation": "film",
    "film d'aventures": "film",
    "film d'espionnage": "film",
    "film d'horreur": "film",
    "film de guerre": "film",
    "film de science-fiction": "film",
    "film de suspense": "film",
    "film documentaire": "film",
    "film fantastique": "film",
    "film policier": "film",
    "film pornographique": "film",
    "film pour la jeunesse": "film",
    "film sentimental": "film",
    "fin": "ind??termin??",
    "humour": "spectacle",
    "interview": "interview",
    "jeunesse : dessin anim?? dessin anim??": "jeunesse",
    "jeunesse : dessin anim?? jeunesse": "jeunesse",
    "jeunesse : dessin anim?? manga": "jeunesse",
    "jeunesse : emission jeunesse": "jeunesse",
    "journal": "journal",
    "loterie": "loterie",
    "magazine animalier": "magazine",
    "magazine culinaire": "magazine",
    "magazine culturel": "magazine",
    "magazine d'actualit??": "magazine",
    "magazine d'information": "magazine",
    "magazine de d??couvertes": "magazine",
    "magazine de g??opolitique": "magazine",
    "magazine de l'art de vivre": "magazine",
    "magazine de l'automobile": "magazine",
    "magazine de l'emploi": "magazine",
    "magazine de l'environnement": "magazine",
    "magazine de l'??conomie": "magazine",
    "magazine de la d??coration": "magazine",
    "magazine de la gastronomie": "magazine",
    "magazine de la mer": "magazine",
    "magazine de la mode": "magazine",
    "magazine de la moto": "magazine",
    "magazine de la sant??": "magazine",
    "magazine de reportages": "magazine",
    "magazine de services": "magazine",
    "magazine de soci??t??": "magazine",
    "magazine de t??l??-achat": "magazine",
    "magazine des beaux-arts": "magazine",
    "magazine des m??dias": "magazine",
    "magazine du cin??ma": "magazine",
    "magazine du consommateur": "magazine",
    "magazine du court m??trage": "magazine",
    "magazine du jardinage": "magazine",
    "magazine du show-biz": "magazine",
    "magazine du tourisme": "magazine",
    "magazine historique": "magazine",
    "magazine jeunesse": "magazine",
    "magazine judiciaire": "magazine",
    "magazine litt??raire": "magazine",
    "magazine musical": "magazine",
    "magazine politique": "magazine",
    "magazine pornographique": "magazine",
    "magazine religieux": "magazine",
    "magazine r??gional": "magazine",
    "magazine scientifique": "magazine",
    "magazine sportif": "magazine",
    "magazine ??ducatif": "magazine",
    "musical": "musique",
    "musique : classique": "musique",
    "musique : jazz": "musique",
    "musique : pop %26 rock": "musique",
    "musique : rap": "musique",
    "musique : rap %26 techno": "musique",
    "musique : vari??t??s": "musique",
    "musique : world music": "musique",
    "m??t??o": "m??t??o",
    "one man show": "spectacle",
    "op??ra": "spectacle",
    "programme ind??termin??": "ind??termin??",
    "sport : basket-ball": "sport",
    "sport : biathlon": "sport",
    "sport : cyclisme": "sport",
    "sport : endurance": "sport",
    "sport : fitness": "sport",
    "sport : football": "sport",
    "sport : formule 1": "sport",
    "sport : formule 2": "sport",
    "sport : formule 3": "sport",
    "sport : golf": "sport",
    "sport : handball": "sport",
    "sport : hippisme": "sport",
    "sport : hockey sur glace": "sport",
    "sport : indycar": "sport",
    "sport : jt sport": "sport",
    "sport : marathon": "sport",
    "sport : mma": "sport",
    "sport : motocyclisme": "sport",
    "sport : multisports": "sport",
    "sport : patinage artistique": "sport",
    "sport : p??tanque": "sport",
    "sport : rallye": "sport",
    "sport : rugby": "sport",
    "sport : ski freestyle": "sport",
    "sport : ski": "sport",
    "sport : snowboard": "sport",
    "sport : voile": "sport",
    "sport : vtt": "sport",
    "sport de force": "sport",
    "sports fun": "sport",
    "sports m??caniques": "sport",
    "s??rie culinaire": "s??rie",
    "s??rie d'action": "s??rie",
    "s??rie d'animation": "s??rie",
    "s??rie d'aventures": "s??rie",
    "s??rie d'horreur": "s??rie",
    "s??rie de suspense": "s??rie",
    "s??rie de t??l??r??alit??": "s??rie",
    "s??rie dessin anim??": "s??rie",
    "s??rie dramatique": "s??rie",
    "s??rie fantastique": "s??rie",
    "s??rie hospitali??re": "s??rie",
    "s??rie humoristique": "s??rie",
    "s??rie jeunesse": "s??rie",
    "s??rie polici??re": "s??rie",
    "s??rie r??aliste": "s??rie",
    "s??rie sentimentale": "s??rie",
    "talk-show": "talk-show",
    "th????tre : pi??ce de th????tre": "spectacle",
    "t??l??film : autre": "t??l??film",
    "t??l??film catastrophe": "t??l??film",
    "t??l??film d'action": "t??l??film",
    "t??l??film d'animation": "t??l??film",
    "t??l??film d'aventures": "t??l??film",
    "t??l??film de science-fiction": "t??l??film",
    "t??l??film de suspense": "t??l??film",
    "t??l??film dramatique": "t??l??film",
    "t??l??film fantastique": "t??l??film",
    "t??l??film humoristique": "t??l??film",
    "t??l??film policier": "t??l??film",
    "t??l??film pour la jeunesse": "t??l??film",
    "t??l??film sentimental": "t??l??film",
    "t??l??film ??rotique": "t??l??film",
    "t??l??r??alit??": "t??l??r??alit??",
    "vari??t??s": "vari??t??s"
]


let Categories : [String] = [
    "",
    "biographie",
    "clips",
    "divertissement",
    "documentaire",
    "d??bat",
    "emission",
    "feuilleton",
    "film",
    "interview",
    "jeunesse",
    "journal",
    "loterie",
    "magazine",
    "musique",
    "m??t??o",
    "spectacle",
    "sport",
    "s??rie",
    "talk-show",
    "t??l??film",
    "t??l??r??alit??",
    "vari??t??s"
]

let balisesTable: Array = [
    (balise: "titre", description: "Titre", operations: ["BEGINSWITH[cd]", "CONTAINS[cd]", "ENDSWITH[cd]", "LIKE[cd]", "MATCHES"], values: []),
    (balise: "debut", description: "D??but", operations: ["=", ">", "<"], values: []),
    (balise: "fin", description: "Fin", operations: ["=", ">", "<"], values: []),
    (balise: "chaine", description: "Cha??ne", operations: ["BEGINSWITH[cd]", "CONTAINS[cd]", "ENDSWITH[cd]", "LIKE[cd]", "MATCHES"], values: []),
    (balise: "sousTitre", description: "Sous titre", operations: ["BEGINSWITH[cd]", "CONTAINS[cd]", "ENDSWITH[cd]", "LIKE[cd]", "MATCHES"], values: []),
    (balise: "resume", description: "R??sum??", operations: ["BEGINSWITH[cd]", "CONTAINS[cd]", "ENDSWITH[cd]", "LIKE[cd]", "MATCHES"], values: []),
    (balise: "category", description: "Cat??gorie", operations: ["BEGINSWITH[cd]", "CONTAINS[cd]", "ENDSWITH[cd]", "LIKE[cd]", "MATCHES"], values: []),
    (balise: "ratingCSA", description: "CSA", operations: ["=", "IN", "!="], values: ["-10", "-12", "-16", "Tout public", ""]),
    (balise: "ratingTelerama", description: "Etoiles", operations: ["=", "IN", "!="], values: ["1/5", "2/5", "3/5", "4/5", "5/5", ""]),
    (balise: "annee", description: "1??re diff", operations: ["BEGINSWITH[cd]", "CONTAINS[cd]", "ENDSWITH[cd]", "LIKE[cd]", "MATCHES"], values: []),
    (balise: "episode", description: "Episode", operations: ["BEGINSWITH[cd]", "CONTAINS[cd]", "ENDSWITH[cd]", "LIKE[cd]", "MATCHES"], values: []),
    (balise: "duree", description: "Dur??e", operations: ["BEGINSWITH[cd]", "CONTAINS[cd]", "ENDSWITH[cd]", "LIKE[cd]", "MATCHES"], values: [])
]

//let balisesTable: Array = [
//    (balise: "titre", description: "Titre du programme", operations: ["BEGINSWITH[cd]", "CONTAINS[cd]", "ENDSWITH[cd]", "LIKE[cd]", "MATCHES"], values: []),
//    (balise: "debut", description: "Heure de d??but", operations: ["=", ">", "<"], values: []),
//    (balise: "fin", description: "Heure de fin", operations: ["=", ">", "<"], values: []),
//    (balise: "chaine", description: "Cha??ne de diffusion", operations: ["BEGINSWITH[cd]", "CONTAINS[cd]", "ENDSWITH[cd]", "LIKE[cd]", "MATCHES"], values: []),
//    (balise: "sousTitre", description: "Sous titre du programme", operations: ["BEGINSWITH[cd]", "CONTAINS[cd]", "ENDSWITH[cd]", "LIKE[cd]", "MATCHES"], values: []),
//    (balise: "resume", description: "R??sum?? du programme", operations: ["BEGINSWITH[cd]", "CONTAINS[cd]", "ENDSWITH[cd]", "LIKE[cd]", "MATCHES"], values: []),
//    (balise: "category", description: "Cat??gorie de programme", operations: ["BEGINSWITH[cd]", "CONTAINS[cd]", "ENDSWITH[cd]", "LIKE[cd]", "MATCHES"], values: []),
//    (balise: "ratingCSA", description: "Signal??tique CSA", operations: ["=", "!="], values: ["-10", "-12", "-16", "Tout public", ""]),
//    (balise: "ratingTelerama", description: "Etoiles T??l??rama", operations: ["=", "!="], values: ["1/5", "2/5", "3/5", "4/5", "5/5", ""]),
//    (balise: "annee", description: "Ann??e de premi??re diffusion", operations: ["BEGINSWITH[cd]", "CONTAINS[cd]", "ENDSWITH[cd]", "LIKE[cd]", "MATCHES"], values: []),
//    (balise: "episode", description: "Episode num??ro", operations: ["BEGINSWITH[cd]", "CONTAINS[cd]", "ENDSWITH[cd]", "LIKE[cd]", "MATCHES"], values: []),
//    (balise: "duree", description: "Dur??e du programme", operations: ["BEGINSWITH[cd]", "CONTAINS[cd]", "ENDSWITH[cd]", "LIKE[cd]", "MATCHES"], values: [])
//]

let operateursListe: NSDictionary = [
    "="                 : "est ??gal ??",
    ">"                 : "est sup. ??",
    "<"                 : "est inf. ??",
    "!="                : "est diff. de",
    "IN"                : "est l'un de",
    "BEGINSWITH[cd]"    : "commence par",
    "CONTAINS[cd]"      : "contient",
    "ENDSWITH[cd]"      : "finit avec",
    "LIKE[cd]"          : "ressemble ??",
    "MATCHES"           : "matche"
]

let baliseIndex : NSDictionary = [
    "titre" : 0,
    "debut" : 1,
    "fin" : 2,
    "chaine" : 3,
    "sousTitre" : 4,
    "resume" : 5,
    "category" : 6,
    "ratingCSA" : 7,
    "ratingTelerama" : 8,
    "annee" : 9,
    "episode" : 10,
    "duree" : 11
]
