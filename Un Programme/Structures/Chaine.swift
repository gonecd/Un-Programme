//
//  Chaine.swift
//  Un Programme
//
//  Created by Cyril Delamare on 14/03/2022.
//  Copyright © 2022 Home. All rights reserved.
//

import Foundation



class Chaine : NSObject
{
    var nom : String = String()
    var id : String = String()
    var icone : String = String()

    init(id: String)
    {
        self.id = id
    }
}
