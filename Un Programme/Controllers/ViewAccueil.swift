//
//  ViewAccueil.swift
//  Un Programme
//
//  Created by Cyril DELAMARE on 14/03/2022.
//

import UIKit




class CellProgramme : UITableViewCell {
    @IBOutlet weak var titre: UILabel!
    @IBOutlet weak var jour: UILabel!
    @IBOutlet weak var debut: UILabel!
    @IBOutlet weak var fin: UILabel!
    @IBOutlet weak var categorie: UILabel!
    @IBOutlet weak var chaine: UIImageView!
    
    var index : Int = 0
}

class CellFiltre : UITableViewCell {
    @IBOutlet weak var nom: UILabel!
    @IBOutlet weak var valeur: UILabel!
}


class ViewAccueil: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var nbChaines: UILabel!
    @IBOutlet weak var nbProgs: UILabel!
    
    @IBOutlet weak var listeProgs: UITableView!
    @IBOutlet weak var listeFiltres: UITableView!
    
    @IBOutlet weak var jour: UISegmentedControl!
    @IBOutlet weak var heure: UISegmentedControl!
    @IBOutlet weak var categories: UIPickerView!
    @IBOutlet weak var mot: UITextField!
    
    @IBOutlet weak var chainesSel: UIImageView!
    @IBOutlet weak var boutonCategLeft: UIButton!
    @IBOutlet weak var boutonCategRight: UIButton!
    
    @IBOutlet weak var viewDynamique: UIView!
    @IBOutlet weak var viewMisc: UIView!
    @IBOutlet weak var viewFiltresPredef: UIView!
    
    @IBOutlet weak var roue: UIActivityIndicatorView!
    @IBOutlet weak var menuSel: UISegmentedControl!
    
    
    var FiltresListe   : [Filtre] = []
    var ProgListe      : [Prog] = [Prog]()
    var selectedChaine : String = ""
    var categLevel     : Int = 1
    var categLevel1    : String = ""
    var dispCateg      : [String] = Categories
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        dateFormat.locale = Locale.current
        dateFormat.dateFormat = "ccc dd MMMM"

        heureFormat.locale = Locale.current
        heureFormat.dateFormat = "HH:mm"

        print("* Checking directories")
        checkDirectories()

        print("* Loading Programmes")
        db.purge()
        db.Download(source : "TNT", force : false)
        db.Download(source : "Canal", force : false)

        print("* Parsing Programmes")
        db.DataRead(source : "Canal")
        db.DataRead(source : "TNT")
       
        print("* Loading des Filtres")
        FiltresListe = loadFilters()

        
        
        nbChaines.text = String(db.Chaines.count)
        nbProgs.text = String(db.Programme.count)
        
        let predicatForm : String = "fin >= %@"
        let predicatArgs : [Any] = [Date()]

        ProgListe = db.Programme.filter { NSPredicate.init(format: predicatForm, argumentArray: predicatArgs).evaluate(with: $0) }
    }


    
    // Table view implementation
    // =================================================================
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if ( tableView == listeProgs ) { return ProgListe.count }
        else if (tableView == listeFiltres ) { return FiltresListe.count }
        else { return 0 }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if ( tableView == listeProgs ) {
            let cell = tableView.dequeueReusableCell(withIdentifier: "CellProgramme", for: indexPath) as! CellProgramme
            
            cell.titre.text = ProgListe[indexPath.row].titre
            cell.jour.text = dateFormat.string(from: ProgListe[indexPath.row].debut)
            cell.debut.text = heureFormat.string(from: ProgListe[indexPath.row].debut)
            cell.fin.text = heureFormat.string(from: ProgListe[indexPath.row].fin)
            cell.categorie.text = ProgListe[indexPath.row].grpCategory
            cell.chaine.image = getImage((db.Chaines[ProgListe[indexPath.row].chaine] as! Chaine).icone)
            cell.index = indexPath.row
            
            cell.categorie.layer.borderColor = UIColor.systemBlue.cgColor
            cell.categorie.layer.borderWidth = 1
            cell.categorie.layer.cornerRadius = 12
            cell.categorie.layer.masksToBounds = true
            
            return cell
        }
        else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "CellFiltre", for: indexPath) as! CellFiltre
            
            cell.nom.text = FiltresListe[indexPath.row].nom
            cell.valeur.text = "42"
            cell.valeur.layer.cornerRadius = 8
            cell.valeur.layer.masksToBounds = true

            return cell
        }
    }
    
    
    
    // Segmented Controls implementation
    // =================================================================

    @IBAction func jourChanged(_ sender: Any) {
        if ( (jour.selectedSegmentIndex == 0)
            || ( (jour.selectedSegmentIndex == 2) && ( (heure.selectedSegmentIndex == 1) || (heure.selectedSegmentIndex == 2) ) ) ) {
            heure.selectedSegmentIndex = 0
        }
        
        self.filter(sender)
    }
    
    @IBAction func heureChanged(_ sender: Any) {
        if ( (heure.selectedSegmentIndex == 1)
            || (heure.selectedSegmentIndex == 2)
            || ( (heure.selectedSegmentIndex == 3) && (jour.selectedSegmentIndex == 0) )
            || ( (heure.selectedSegmentIndex == 4) && (jour.selectedSegmentIndex == 0) ) ) {
            jour.selectedSegmentIndex = 1
        }
        
        self.filter(sender)
    }
    
    
    
    // Picker view implementation
    // =================================================================

    func numberOfComponents(in pickerView: UIPickerView) -> Int                                     { return 1 }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int      { return dispCateg.count }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent: Int) {
        if ( (categLevel == 1) && (pickerView.selectedRow(inComponent: 0) != 0) ) {
            boutonCategRight.isHidden = false
            categLevel1 = dispCateg[categories.selectedRow(inComponent: 0)]
        }
        else if ( (categLevel == 1) && (pickerView.selectedRow(inComponent: 0) == 0) ) {
            boutonCategRight.isHidden = true
            categLevel1 = ""
        }

        self.filter(pickerView)
    }

    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        var pickerLabel: UILabel? = (view as? UILabel)
        if pickerLabel == nil {
            pickerLabel = UILabel()
            pickerLabel?.font = UIFont(name: "System", size: 15)
            pickerLabel?.textAlignment = .center
        }
        pickerLabel?.text = dispCateg[row]

        return pickerLabel!
    }
    

    @IBAction func categLeft(_ sender: Any) {
        if (categLevel == 2) {
            categLevel = 1
            boutonCategRight.isHidden = false
            boutonCategLeft.isHidden = true
            
            dispCateg = Categories
            categories.reloadAllComponents()
            categories.selectRow(Categories.firstIndex(of: categLevel1)!, inComponent: 0, animated: false)
            categories.setNeedsDisplay()
            
            filter(self)
        }
    }
    
    @IBAction func categRight(_ sender: Any) {
        if (categLevel == 1) {
            categLevel = 2
            boutonCategRight.isHidden = true
            boutonCategLeft.isHidden = false
            
            dispCateg = buildSousCategList(CategLevel1: dispCateg[categories.selectedRow(inComponent: 0)])
            categories.reloadAllComponents()
            categories.selectRow(0, inComponent: 0, animated: false)
            categories.setNeedsDisplay()
            
            filter(self)
        }
    }
    
    func buildSousCategList(CategLevel1: String) -> [String] {
        var liste : [String] = [""]
        
        for oneKeyValue in shortCategorie {
            if ((oneKeyValue.value as! String) == CategLevel1) { liste.append((oneKeyValue.key as! String))}
        }
        
        return liste
    }
    
    
    @IBAction func filter(_ sender: Any) {
        roue.startAnimating()
        
        ProgListe = db.Programme.filter { buildPredicat().evaluate(with: $0) }
        
        listeProgs.reloadData()
        listeProgs.setNeedsDisplay()
        
        roue.stopAnimating()
    }

    
    func buildPredicat() -> NSPredicate
    {
        var predicatForm : String = "fin >= %@"
        var predicatArgs : [Any] = [Date()]
        let cal: Calendar = Calendar(identifier: .gregorian)

        // Suppression des programmes passés
        let now : Date = Date()
        let tomorrow : Date = cal.date(byAdding: .day, value: 1, to: now)!
        var debut : Date = Date()
        var fin : Date = Date()
        
        if ( (jour.selectedSegmentIndex == 0) && (heure.selectedSegmentIndex == 0) ) { debut = now; fin = cal.date(byAdding: .day, value: 10, to: now)!; }
        if ( (jour.selectedSegmentIndex == 1) && (heure.selectedSegmentIndex == 1) ) { debut = now; fin = now; }
        if ( (jour.selectedSegmentIndex == 1) && (heure.selectedSegmentIndex == 2) ) { debut = cal.date(byAdding: .minute, value: 1, to: now)!; fin = cal.date(byAdding: .minute, value: 10, to: now)!; }
        if ( (jour.selectedSegmentIndex == 1) && (heure.selectedSegmentIndex == 0) ) { debut = cal.date(bySettingHour: 0, minute: 0, second: 0, of: now)!; fin = cal.date(bySettingHour: 23, minute: 59, second: 0, of: now)!; }
        if ( (jour.selectedSegmentIndex == 2) && (heure.selectedSegmentIndex == 0) ) { debut = cal.date(bySettingHour: 0, minute: 0, second: 0, of: tomorrow)!; fin = cal.date(bySettingHour: 23, minute: 59, second: 0, of: tomorrow)!; }
        if ( (jour.selectedSegmentIndex == 1) && (heure.selectedSegmentIndex == 3) ) { debut = cal.date(bySettingHour: 20, minute: 45, second: 0, of: now)!; fin = cal.date(bySettingHour: 21, minute: 15, second: 0, of: now)!; }
        if ( (jour.selectedSegmentIndex == 1) && (heure.selectedSegmentIndex == 4) ) { debut = cal.date(bySettingHour: 22, minute: 15, second: 0, of: now)!; fin = cal.date(bySettingHour: 23, minute: 0, second: 0, of: now)!; }
        if ( (jour.selectedSegmentIndex == 2) && (heure.selectedSegmentIndex == 3) ) { debut = cal.date(bySettingHour: 20, minute: 45, second: 0, of: tomorrow)!; fin = cal.date(bySettingHour: 21, minute: 15, second: 0, of: tomorrow)!; }
        if ( (jour.selectedSegmentIndex == 2) && (heure.selectedSegmentIndex == 4) ) { debut = cal.date(bySettingHour: 22, minute: 15, second: 0, of: tomorrow)!; fin = cal.date(bySettingHour: 23, minute: 0, second: 0, of: tomorrow)!; }
        
        if ( (jour.selectedSegmentIndex == 1) && (heure.selectedSegmentIndex == 1) ) { predicatForm.append(" AND debut <= %@ AND fin >= %@") }
        else if ( (jour.selectedSegmentIndex == 1) && (heure.selectedSegmentIndex == 3) ) { predicatForm.append(" AND debut >= %@ AND debut <= %@ AND fin >= %@") }
        else if ( (jour.selectedSegmentIndex == 2) && (heure.selectedSegmentIndex == 3) ) { predicatForm.append(" AND debut >= %@ AND debut <= %@ AND fin >= %@") }
        else { predicatForm.append(" AND debut >= %@ AND debut <= %@") }
        
        predicatArgs.append(debut)
        predicatArgs.append(fin)
        if (heure.selectedSegmentIndex == 3) { predicatArgs.append(fin) }
        
        // Choix de la categorie
        if (categLevel == 1) {
            if (categories.selectedRow(inComponent: 0) != 0) {
                predicatForm.append(" AND grpCategory = %@")
                predicatArgs.append(dispCateg[categories.selectedRow(inComponent: 0)])
            }
        } else {
            if (categories.selectedRow(inComponent: 0) == 0) {
                predicatForm.append(" AND grpCategory = %@")
                predicatArgs.append(categLevel1)
            } else {
                predicatForm.append(" AND category = %@")
                predicatArgs.append(dispCateg[categories.selectedRow(inComponent: 0)])
            }
        }
        
        // Filtrage par mot clé
        if (mot.text != "") {
            predicatForm.append(" AND titre CONTAINS[cd] %@")
            predicatArgs.append(mot.text!)
        }
        
        // Filtrage par chaine
        if (selectedChaine != "") {
            predicatForm.append(" AND chaine = %@")
            predicatArgs.append(selectedChaine)
        }
            
        
        return NSPredicate.init(format: predicatForm, argumentArray: predicatArgs)
    }
    
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        if ((identifier == "ShowChaines") && (selectedChaine != "")) {
            selectedChaine = ""
            chainesSel.image = UIImage(systemName: "nosign")
            filter(self)

            return false
        }
        
        return true
    }

    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if (segue.identifier == "ShowDetail") {
            let fiche : DetailProgramme = segue.destination as! DetailProgramme
            let tableCell : CellProgramme = sender as! CellProgramme
            fiche.prog = ProgListe[tableCell.index]
        }
        else if (segue.identifier == "ShowChaines") {
            print ("Segue Chaines")
            let chaineSelector : ChaineSelection = segue.destination as! ChaineSelection
            chaineSelector.delegate = self
        }
        else {
            print ("Segue Inconnu")
            let filterDef : FilterDetails = segue.destination as! FilterDetails
            filterDef.delegate = self
        }
    }

    
    @IBAction func menuSelector(_ sender: Any) {
        if ( menuSel.selectedSegmentIndex == 0) {
            viewMisc.isHidden = true
            viewFiltresPredef.isHidden = true
            viewDynamique.isHidden = false
        } else if ( menuSel.selectedSegmentIndex == 1) {
            viewMisc.isHidden = true
            viewFiltresPredef.isHidden = false
            viewDynamique.isHidden = true
        } else if ( menuSel.selectedSegmentIndex == 2) {
            viewMisc.isHidden = false
            viewFiltresPredef.isHidden = true
            viewDynamique.isHidden = true
        }
        
    }
}


extension ViewAccueil: ChaineSelectionViewControllerDelegate {
    func ChaineSelecUpdated(id : String) {
        chainesSel.image = getImage((db.Chaines[id] as! Chaine).icone)
        selectedChaine = id
        
        filter(self)
    }
}

extension ViewAccueil: FilterDetailsViewControllerDelegate {
    func FilterUpdated(filter : Filtre, mode : Int) {
        print ("FILTER UPDATE : \(filter.nom) en mode \(mode)")
        
        if (mode == modeAdd) {
            FiltresListe.append(filter)
        }
        else if (mode == modeDelete) {
            FiltresListe.remove(at: FiltresListe.firstIndex(of: filter)!)
        }
        else if (mode == modeEdit) {
            print ("Mode Edit à coder ...)")
        }
        else {
            print ("Mode inconnu ...)")
        }

        FiltresListe = FiltresListe.sorted(by: { $0.nom < $1.nom })
        saveFilters(filtres: FiltresListe)
        
        listeFiltres.reloadData()
        listeFiltres.setNeedsDisplay()
    }
}


