//
//  RepetitionExercise.swift
//  assignment3
//
//  Created by mobiledev on 20/5/2022.
//

import Firebase
import FirebaseFirestoreSwift

public struct RepetitionExercise : Codable
{
    @DocumentID var documentID : String?
    
    var mode : String? = ""
    var repeatTimes : Int? = -1 //not apply: -1
    var startTime : String? = ""
    var endTime : String? = ""
    var completion : Int? = 0 //not paply: -1, false: 0, true: 1, default didn't completed
    var action : [ActionDetail] = []
}
