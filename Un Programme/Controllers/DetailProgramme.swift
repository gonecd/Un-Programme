//
//  DetailProgramme.swift
//  Un Programme
//
//  Created by Cyril DELAMARE on 17/03/2022.
//

import Foundation
import UIKit

class DetailProgramme: UIViewController
{
    @IBOutlet weak var titre: UILabel!
    @IBOutlet weak var soustitre: UILabel!
    @IBOutlet weak var categorie: UILabel!
    @IBOutlet weak var chaine: UIImageView!
    @IBOutlet weak var resume: UITextView!
    @IBOutlet weak var capture: UIImageView!
    @IBOutlet weak var jour: UILabel!
    @IBOutlet weak var debut: UILabel!
    @IBOutlet weak var fin: UILabel!
    @IBOutlet weak var annee: UILabel!
    @IBOutlet weak var episode: UILabel!
    @IBOutlet weak var duree: UILabel!
    @IBOutlet weak var ratingCSA: UILabel!
    @IBOutlet weak var ratingTelerama: UILabel!
    
    
    var prog : Prog = Prog(chaine: "")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        titre.text = prog.titre
        soustitre.text = prog.sousTitre
        categorie.text = prog.category
        resume.text = prog.resume
        jour.text = dateFormat.string(from: prog.debut)
        debut.text = heureFormat.string(from: prog.debut)
        fin.text = heureFormat.string(from: prog.fin)
        annee.text = prog.annee
        ratingCSA.text = prog.ratingCSA
        ratingTelerama.text = prog.ratingTelerama
        duree.text = prog.duree

        if (prog.episode != "") {
            let composants = prog.episode.split(separator: ".", omittingEmptySubsequences: false)
            if (composants[1] == "") { episode.text = "Sais \(Int(composants[0])! + 1)" }
            else { episode.text = "Sais \(Int(composants[0])! + 1) Ep \(Int(composants[1])! + 1)" }
        }
        else {
            episode.text = ""
        }
        
        chaine.image = getImage((db.Chaines[prog.chaine] as! Chaine).icone)
        capture.image = loadImage(prog.capture)
    }

}
