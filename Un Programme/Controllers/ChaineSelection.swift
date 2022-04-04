//
//  ChaineSelection.swift
//  Un Programme
//
//  Created by Cyril DELAMARE on 21/03/2022.
//

import Foundation
import UIKit



class CellChaine : UICollectionViewCell {
    @IBOutlet weak var logo: UIImageView!
    
    var id : String = ""
}


protocol ChaineSelectionViewControllerDelegate: AnyObject {
    func ChaineSelecUpdated(id : String)
}


class ChaineSelection: UICollectionViewController {
    weak var delegate: ChaineSelectionViewControllerDelegate?
    var selection : String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return db.Chaines.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CellChaine", for: indexPath as IndexPath) as! CellChaine
        
        cell.logo.image = getImage((db.Chaines[db.ChainesArray[indexPath.row]] as! Chaine).icone)
        cell.id = (db.Chaines[db.ChainesArray[indexPath.row]] as! Chaine).id

        if (cell.id == selection) {
            cell.isSelected = true
        }
        
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell : CellChaine = collectionView.cellForItem(at: indexPath) as! CellChaine
        
        delegate?.ChaineSelecUpdated(id : cell.id)
        dismiss(animated: true, completion: nil)
    }
}
