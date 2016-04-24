//
//  Model+Utilities.swift
//  Swoop
//
//  Created by Ikhsan Assaat on 24/04/2016.
//  Copyright © 2016 Ikhsan. All rights reserved.
//

import Foundation

extension User {
    var name : String {
        return firstName + " " + lastName
    }
}