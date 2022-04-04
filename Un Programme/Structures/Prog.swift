//
//  Prog.swift
//  Un Programme
//
//  Created by Cyril Delamare on 14/03/2022.
//  Copyright © 2022 Home. All rights reserved.
//

import Foundation


class Prog : NSObject
{
    @objc var titre       : String = String()
    @objc var debut       : Date   = Date()
    @objc var fin         : Date   = Date()
    @objc var chaine      : String = String()
    @objc var sousTitre   : String = String()
    @objc var resume      : String = String()
    @objc var category    : String = String()
    @objc var grpCategory : String = String()
    @objc var capture     : String = String()
    @objc var ratingCSA   : String = String()
    @objc var ratingTelerama     : String = String()
    @objc var annee       : String = String()
    @objc var episode     : String = String()
    @objc var duree       : String = String()

    init(chaine: String)
    {
        self.chaine = chaine
    }
}
