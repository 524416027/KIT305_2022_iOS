//
//  ActionDetail.swift
//  assignment3
//
//  Created by mobiledev on 20/5/2022.
//

import Firebase
import FirebaseFirestoreSwift

public struct ActionDetail : Codable
{
    var description : String? = ""
    var actionTime : String? = ""
    var actionType : String? = ""
    var buttonCorrect : Int? = -1 //not apply: -1, wrong: 0, correct: 1
}
