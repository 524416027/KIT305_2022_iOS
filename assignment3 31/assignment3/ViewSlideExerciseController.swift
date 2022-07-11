//
//  ViewSlideExerciseController.swift
//  assignment3
//
//  Created by mobiledev on 23/5/2022.
//

import UIKit
import Firebase
import FirebaseFirestoreSwift

class ViewSlideExerciseController: UIViewController {
    
    let db = Firestore.firestore()

    let preferences = UserDefaults.standard
    
    var randomSliderRotation : Bool = false
    var difficultyIndex : Int = 1
    
    var exercise = RepetitionExercise()
    
    var completeCount = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        randomSliderRotation = preferences.bool(forKey: "randomSliderRotation")
        difficultyIndex = preferences.integer(forKey: "difficultyIndex")
        
        if(randomSliderRotation)
        {
            randomSlider()
        }
        
        var sliderLength = 384
        
        switch difficultyIndex
        {
        case 0:
            sliderLength = 384
        case 1:
            sliderLength = 640
        case 2:
            sliderLength = 768
        default:
            sliderLength = 384
            
        }
        
        sliderExercise.frame = CGRect(x: 350.0, y: 350.0, width: Double(sliderLength), height: 20.0)
        
        recordStart()
    }
    
    func randomSlider()
    {
        var random : Double = Double.random(in: -1...1)
        
        sliderExercise.transform = CGAffineTransform(rotationAngle: random * CGFloat.pi)
    }
    
    @IBAction func buttonActionOption(_ sender: Any) {
        let alert = UIAlertController(title: "", message: "Are you sure to end this exercise and back to Main Menu?", preferredStyle: UIAlertController.Style.alert)
        
        alert.addAction(UIAlertAction(title: "Yes", style: UIAlertAction.Style.default, handler: {(action) in
            alert.dismiss(animated: true, completion: nil)
            self.returnToMainMenu()
        }))
        
        alert.addAction(UIAlertAction(title: "No", style: UIAlertAction.Style.default, handler: {(action) in
            alert.dismiss(animated: true, completion: nil)
        }))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    func returnToMainMenu()
    {
        recordEnd()
        performSegue(withIdentifier: "unwindToMainMenu", sender: self)
    }
    
    @IBOutlet var sliderExercise: UISlider!
    @IBAction func onSliderChangeExercise(_ sender: Any) {
        if(Int(sliderExercise.value) == 1)
        {
            sliderExercise.isHidden = true
            sliderExercise.isContinuous = false
            sliderExercise.value = 0
            
            completeCount += 1
            
            recordButtonPress()
    
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5)
            {
                self.sliderExercise.isHidden = false
                self.sliderExercise.isEnabled = true
                
                if(self.randomSliderRotation)
                {
                    self.randomSlider()
                }
            }
            
        }
    }
    
    func recordStart()
    {
        let date = Date()
        let calendar = Calendar.current
        let hour = calendar.component(.hour, from: date)
        let minutes = calendar.component(.minute, from: date)
        let seconds = calendar.component(.second, from: date)
        
        let nowTime : String = "\((hour < 10) ? "0\(hour)" : "\(hour)"):\((minutes < 10) ? "0\(minutes)" : "\(minutes)"):\((seconds < 10) ? "0\(seconds)" : "\(seconds)")"
        
        var action = ActionDetail()
        action.description = "Slider Exercise Start"
        action.actionTime = nowTime
        action.actionType = "start"
        action.buttonCorrect =  -1
        
        exercise.mode = "Slider Exercise"
        exercise.repeatTimes = -1
        exercise.startTime = nowTime
        exercise.endTime = ""
        exercise.completion = -1
        exercise.action.append(action)
        
        let exerciseCollection = db.collection("stroke")
        
        exercise.documentID = exerciseCollection.document().documentID
        
        do
        {
            try exerciseCollection.document(exercise.documentID!).setData(from: exercise) { err in
                if let err = err {
                    print("Error updating document: \(err)")
                } else {
                    print("Document successfully updated")
                }
            }
        } catch {
            print("Error updating document \(error)")
        }
    }
    
    func recordEnd()
    {
        let date = Date()
        let calendar = Calendar.current
        let hour = calendar.component(.hour, from: date)
        let minutes = calendar.component(.minute, from: date)
        let seconds = calendar.component(.second, from: date)
        
        let nowTime : String = "\((hour < 10) ? "0\(hour)" : "\(hour)"):\((minutes < 10) ? "0\(minutes)" : "\(minutes)"):\((seconds < 10) ? "0\(seconds)" : "\(seconds)")"
        
        var action = ActionDetail()
        action.description = "Slide Exercise End"
        action.actionTime = nowTime
        action.actionType = "end"
        action.buttonCorrect = -1
        
        exercise.repeatTimes = completeCount
        exercise.completion = -1
        exercise.endTime = nowTime
        
        exercise.action.append(action)
        
        let exerciseCollection = db.collection("stroke")
        
        do
        {
            try exerciseCollection.document(exercise.documentID!).setData(from: exercise) { err in
                if let err = err {
                    print("Error updating document: \(err)")
                } else {
                    print("Document successfully updated")
                }
            }
        } catch {
            print("Error updating document \(error)")
        }
    }
    
    func recordButtonPress()
    {
        let date = Date()
        let calendar = Calendar.current
        let hour = calendar.component(.hour, from: date)
        let minutes = calendar.component(.minute, from: date)
        let seconds = calendar.component(.second, from: date)
        
        let nowTime : String = "\((hour < 10) ? "0\(hour)" : "\(hour)"):\((minutes < 10) ? "0\(minutes)" : "\(minutes)"):\((seconds < 10) ? "0\(seconds)" : "\(seconds)")"
        
        var action = ActionDetail()
        action.description = "Slider Performed"
        action.actionTime = nowTime
        action.actionType = "slider"
        action.buttonCorrect = 1
        
        exercise.action.append(action)
        
        let exerciseCollection = db.collection("stroke")
        do
        {
            try exerciseCollection.document(exercise.documentID!).setData(from: exercise) { err in
                if let err = err {
                    print("Error updating document: \(err)")
                } else {
                    print("Document successfully updated")
                }
            }
        } catch {
            print("Error updating document \(error)")
        }
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }

}
