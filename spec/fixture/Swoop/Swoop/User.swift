//
//  Model.swift
//  Swoop
//
//  Created by Ikhsan Assaat on 24/04/2016.
//  Copyright © 2016 Ikhsan. All rights reserved.
//

import Foundation

struct Position {
    var x : Double
    var y : Double
}

// struct _Position {}

class User {
    let firstName : String = ""
    let lastName : String = ""
}

private class Admin : User { }

// private class _User {
//     let firstName : String = ""
// }
//
//class _Admin : User { }

extension User {
    var fullName : String {
        return firstName + " " + lastName
    }
}

// extension _User {}
