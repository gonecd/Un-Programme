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

var filtres      : [Filtre]          = []


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
    "cérémonie": "spectacle",
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
    "documentaire cinéma": "documentaire",
    "documentaire civilisations": "documentaire",
    "documentaire culture": "documentaire",
    "documentaire découvertes": "documentaire",
    "documentaire environnement": "documentaire",
    "documentaire fiction": "documentaire",
    "documentaire gastronomie": "documentaire",
    "documentaire géopolitique": "documentaire",
    "documentaire histoire": "documentaire",
    "documentaire justice": "documentaire",
    "documentaire lettres": "documentaire",
    "documentaire musique classique": "documentaire",
    "documentaire musique": "documentaire",
    "documentaire nature": "documentaire",
    "documentaire politique": "documentaire",
    "documentaire religions": "documentaire",
    "documentaire santé": "documentaire",
    "documentaire sciences et technique": "documentaire",
    "documentaire société": "documentaire",
    "documentaire sport": "documentaire",
    "documentaire téléréalité": "documentaire",
    "documentaire voyage": "documentaire",
    "débat parlementaire": "débat",
    "débat": "débat",
    "emission du bien-être": "emission",
    "emission musicale": "emission",
    "emission politique": "emission",
    "emission religieuse": "emission",
    "feuilleton policier": "feuilleton",
    "feuilleton réaliste": "feuilleton",
    "feuilleton sentimental": "feuilleton",
    "film : autre": "film",
    "film : biographie": "film",
    "film : comédie dramatique": "film",
    "film : comédie policière": "film",
    "film : comédie sentimentale": "film",
    "film : comédie": "film",
    "film : court métrage d'animation": "film",
    "film : court métrage dramatique": "film",
    "film : court métrage": "film",
    "film : drame": "film",
    "film : mélodrame": "film",
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
    "fin": "indéterminé",
    "humour": "spectacle",
    "interview": "interview",
    "jeunesse : dessin animé dessin animé": "jeunesse",
    "jeunesse : dessin animé jeunesse": "jeunesse",
    "jeunesse : dessin animé manga": "jeunesse",
    "jeunesse : emission jeunesse": "jeunesse",
    "journal": "journal",
    "loterie": "loterie",
    "magazine animalier": "magazine",
    "magazine culinaire": "magazine",
    "magazine culturel": "magazine",
    "magazine d'actualité": "magazine",
    "magazine d'information": "magazine",
    "magazine de découvertes": "magazine",
    "magazine de géopolitique": "magazine",
    "magazine de l'art de vivre": "magazine",
    "magazine de l'automobile": "magazine",
    "magazine de l'emploi": "magazine",
    "magazine de l'environnement": "magazine",
    "magazine de l'économie": "magazine",
    "magazine de la décoration": "magazine",
    "magazine de la gastronomie": "magazine",
    "magazine de la mer": "magazine",
    "magazine de la mode": "magazine",
    "magazine de la moto": "magazine",
    "magazine de la santé": "magazine",
    "magazine de reportages": "magazine",
    "magazine de services": "magazine",
    "magazine de société": "magazine",
    "magazine de télé-achat": "magazine",
    "magazine des beaux-arts": "magazine",
    "magazine des médias": "magazine",
    "magazine du cinéma": "magazine",
    "magazine du consommateur": "magazine",
    "magazine du court métrage": "magazine",
    "magazine du jardinage": "magazine",
    "magazine du show-biz": "magazine",
    "magazine du tourisme": "magazine",
    "magazine historique": "magazine",
    "magazine jeunesse": "magazine",
    "magazine judiciaire": "magazine",
    "magazine littéraire": "magazine",
    "magazine musical": "magazine",
    "magazine politique": "magazine",
    "magazine pornographique": "magazine",
    "magazine religieux": "magazine",
    "magazine régional": "magazine",
    "magazine scientifique": "magazine",
    "magazine sportif": "magazine",
    "magazine éducatif": "magazine",
    "musical": "musique",
    "musique : classique": "musique",
    "musique : jazz": "musique",
    "musique : pop %26 rock": "musique",
    "musique : rap": "musique",
    "musique : rap %26 techno": "musique",
    "musique : variétés": "musique",
    "musique : world music": "musique",
    "météo": "météo",
    "one man show": "spectacle",
    "opéra": "spectacle",
    "programme indéterminé": "indéterminé",
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
    "sport : pétanque": "sport",
    "sport : rallye": "sport",
    "sport : rugby": "sport",
    "sport : ski freestyle": "sport",
    "sport : ski": "sport",
    "sport : snowboard": "sport",
    "sport : voile": "sport",
    "sport : vtt": "sport",
    "sport de force": "sport",
    "sports fun": "sport",
    "sports mécaniques": "sport",
    "série culinaire": "série",
    "série d'action": "série",
    "série d'animation": "série",
    "série d'aventures": "série",
    "série d'horreur": "série",
    "série de suspense": "série",
    "série de téléréalité": "série",
    "série dessin animé": "série",
    "série dramatique": "série",
    "série fantastique": "série",
    "série hospitalière": "série",
    "série humoristique": "série",
    "série jeunesse": "série",
    "série policière": "série",
    "série réaliste": "série",
    "série sentimentale": "série",
    "talk-show": "talk-show",
    "théâtre : pièce de théâtre": "spectacle",
    "téléfilm : autre": "téléfilm",
    "téléfilm catastrophe": "téléfilm",
    "téléfilm d'action": "téléfilm",
    "téléfilm d'animation": "téléfilm",
    "téléfilm d'aventures": "téléfilm",
    "téléfilm de science-fiction": "téléfilm",
    "téléfilm de suspense": "téléfilm",
    "téléfilm dramatique": "téléfilm",
    "téléfilm fantastique": "téléfilm",
    "téléfilm humoristique": "téléfilm",
    "téléfilm policier": "téléfilm",
    "téléfilm pour la jeunesse": "téléfilm",
    "téléfilm sentimental": "téléfilm",
    "téléfilm érotique": "téléfilm",
    "téléréalité": "téléréalité",
    "variétés": "variétés"
]


let Categories : [String] = [
    "",
    "biographie",
    "clips",
    "divertissement",
    "documentaire",
    "débat",
    "emission",
    "feuilleton",
    "film",
    "interview",
    "jeunesse",
    "journal",
    "loterie",
    "magazine",
    "musique",
    "météo",
    "spectacle",
    "sport",
    "série",
    "talk-show",
    "téléfilm",
    "téléréalité",
    "variétés"
]

let balisesTable: Array = [
    (balise: "titre", description: "Titre du programme", operations: ["BEGINSWITH[cd]", "CONTAINS[cd]", "ENDSWITH[cd]", "LIKE[cd]", "MATCHES"], values: []),
    (balise: "debut", description: "Heure de début", operations: ["=", ">", "<"], values: []),
    (balise: "fin", description: "Heure de fin", operations: ["=", ">", "<"], values: []),
    (balise: "chaine", description: "Chaîne de diffusion", operations: ["BEGINSWITH[cd]", "CONTAINS[cd]", "ENDSWITH[cd]", "LIKE[cd]", "MATCHES"], values: []),
    (balise: "sousTitre", description: "Sous titre du programme", operations: ["BEGINSWITH[cd]", "CONTAINS[cd]", "ENDSWITH[cd]", "LIKE[cd]", "MATCHES"], values: []),
    (balise: "resume", description: "Résumé du programme", operations: ["BEGINSWITH[cd]", "CONTAINS[cd]", "ENDSWITH[cd]", "LIKE[cd]", "MATCHES"], values: []),
    (balise: "category", description: "Catégorie de programme", operations: ["BEGINSWITH[cd]", "CONTAINS[cd]", "ENDSWITH[cd]", "LIKE[cd]", "MATCHES"], values: []),
    (balise: "ratingCSA", description: "Signalétique CSA", operations: ["=", "IN", "!="], values: ["-10", "-12", "-16", "Tout public", ""]),
    (balise: "ratingTelerama", description: "Etoiles Télérama", operations: ["=", "IN", "!="], values: ["1/5", "2/5", "3/5", "4/5", "5/5", ""]),
    (balise: "annee", description: "Année de première diffusion", operations: ["BEGINSWITH[cd]", "CONTAINS[cd]", "ENDSWITH[cd]", "LIKE[cd]", "MATCHES"], values: []),
    (balise: "episode", description: "Episode numéro", operations: ["BEGINSWITH[cd]", "CONTAINS[cd]", "ENDSWITH[cd]", "LIKE[cd]", "MATCHES"], values: []),
    (balise: "duree", description: "Durée du programme", operations: ["BEGINSWITH[cd]", "CONTAINS[cd]", "ENDSWITH[cd]", "LIKE[cd]", "MATCHES"], values: [])
]

let operateursListe: NSDictionary = [
    "=" : "est égal à",
    ">" : "est supérieur à",
    "<" : "est inférieur à",
    "!=" : "est différent de",
    "IN" : "est l'un de",
    "BEGINSWITH[cd]" : "commence avec",
    "CONTAINS[cd]" : "contient",
    "ENDSWITH[cd]" : "finit avec",
    "LIKE[cd]" : "ressemble à",
    "MATCHES" : "matche (regex)"
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
