//
//  ViewRepetitionExerciseController.swift
//  assignment3
//
//  Created by mobiledev on 17/5/2022.
//

import UIKit
import Firebase
import FirebaseFirestoreSwift

class ViewRepetitionExerciseController: UIViewController {
    
    let preferences = UserDefaults.standard
    
    let db = Firestore.firestore()
    
    var exercise = RepetitionExercise()
    
    var timeLimitMinutes : Int = 0
    var timeLimitSeconds : Int = 0
    var totalSeconds : Int = 0
    var timeTake : Int = 0

    var repeatTime : Int = 0
    var appearButtons : Int = 2
    
    var randomButtonOrder : Bool = false
    var nextButtonIndication : Bool = false
    
    var buttonSizeIndex : Int = 1
    var buttonSize : Double = 0.0
    
    var isFreeplay : Bool = true
    
    var completeCount = 0
    var pressCount = 0
    
    var isStarted = false
    
    var completionText = ""
    
    var timer : Timer? = Timer()
    
    @IBOutlet var buttons: [UIButton]!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        getPreferences()
        debugPreferences()
        
        for i in 0...4
        {
            buttons[i].isHidden = true
        }
        
        switch buttonSizeIndex
        {
        case 0:
            buttonSize = 64.0
        case 1:
            buttonSize = 128.0
        case 2:
            buttonSize = 190.0
        default:
            buttonSize = 0.0
        }
        
        var minutes = (totalSeconds / 60 < 10) ? "0\(totalSeconds / 60)" : "\(totalSeconds / 60)"
        var seconds = (totalSeconds % 60 < 10) ? "0\(totalSeconds % 60)" : "\(totalSeconds % 60)"
        
        labelTimeCounter.text = "Time Left: \(minutes):\(seconds)"
        
        newRound()
    }
    
    func getPreferences()
    {
        timeLimitMinutes = preferences.integer(forKey: "timeLimitMinutes")
        timeLimitSeconds = preferences.integer(forKey: "timeLimitSeconds")
        totalSeconds = timeLimitSeconds + (timeLimitMinutes * 60)
        
        repeatTime = preferences.integer(forKey: "repeatTime")
        appearButtons = preferences.integer(forKey: "appearButtons")
        
        randomButtonOrder = preferences.bool(forKey: "randomButtonOrder")
        nextButtonIndication = preferences.bool(forKey: "nextButtonIndication")
        
        buttonSizeIndex = preferences.integer(forKey: "buttonSize")
        
        isFreeplay = preferences.bool(forKey: "isFreePlay")
    }
    
    func debugPreferences()
    {
        print("second \(timeLimitSeconds)")
        print("minut \(timeLimitMinutes)")
        print("repeat \(repeatTime)")
        print("buttons \(appearButtons)")
        print("random \(randomButtonOrder)")
        print("indication \(nextButtonIndication)")
        print("size \(buttonSizeIndex)")
        print("freeplay \(isFreeplay)")
    }
    
    // MARK: - Record
    func recordStart()
    {
        let date = Date()
        let calendar = Calendar.current
        let hour = calendar.component(.hour, from: date)
        let minutes = calendar.component(.minute, from: date)
        let seconds = calendar.component(.second, from: date)
        
        let nowTime : String = "\((hour < 10) ? "0\(hour)" : "\(hour)"):\((minutes < 10) ? "0\(minutes)" : "\(minutes)"):\((seconds < 10) ? "0\(seconds)" : "\(seconds)")"
        
        var action = ActionDetail()
        action.description = "Exercise Start"
        action.actionTime = nowTime
        action.actionType = "start"
        action.buttonCorrect =  -1
        
        exercise.mode = (isFreeplay) ? "Free-play" : "Repetition"
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
    
    func recordEnd(forceEnd : Bool)
    {
        let date = Date()
        let calendar = Calendar.current
        let hour = calendar.component(.hour, from: date)
        let minutes = calendar.component(.minute, from: date)
        let seconds = calendar.component(.second, from: date)
        
        let nowTime : String = "\((hour < 10) ? "0\(hour)" : "\(hour)"):\((minutes < 10) ? "0\(minutes)" : "\(minutes)"):\((seconds < 10) ? "0\(seconds)" : "\(seconds)")"
        
        var action = ActionDetail()
        action.description = "Exercise End"
        action.actionTime = nowTime
        action.actionType = "end"
        action.buttonCorrect =  -1
        
        exercise.repeatTimes = completeCount
        exercise.endTime = nowTime
    
        if(isFreeplay)
        {
            //completion not apply to free play
            exercise.completion = -1
            completionText = "Congratulation on your Free-play exercise!"
        }
        else
        {
            //repetition with repeat count
            if(repeatTime > 0 && completeCount >= repeatTime)
            {
                exercise.completion = 1
                completionText = "Congratulation on complete the exercise and meet the goal!"
            }
            else
            {
                //repetition with only time limit
                if(repeatTime == 0)
                {
                    exercise.completion = 1
                    completionText = "Great job of this exercise!"
                }
                //repetition with both time limit and repeat goal
                else
                {
                    //time up before completion
                    if(forceEnd)
                    {
                        exercise.completion = 0
                        completionText = "Fail to meet the goal, hope you could do better next time."
                    }
                }
            }
            
            createResultBoard()
        }
        
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
    
    func recordRoundComplete()
    {
        completeCount += 1
        
        let date = Date()
        let calendar = Calendar.current
        let hour = calendar.component(.hour, from: date)
        let minutes = calendar.component(.minute, from: date)
        let seconds = calendar.component(.second, from: date)
        
        let nowTime : String = "\((hour < 10) ? "0\(hour)" : "\(hour)"):\((minutes < 10) ? "0\(minutes)" : "\(minutes)"):\((seconds < 10) ? "0\(seconds)" : "\(seconds)")"
        
        var action = ActionDetail()
        action.description = "Round \(completeCount) Completed"
        action.actionTime = nowTime
        action.actionType = "round"
        action.buttonCorrect =  -1
        
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
        
        if(!isFreeplay && repeatTime > 0)
        {
            if(completeCount >= repeatTime)
            {
                recordEnd(forceEnd: false)
            }
        }
    }
    
    func recordButtonPress(buttonIndex : Int, isCorrect : Bool)
    {
        let date = Date()
        let calendar = Calendar.current
        let hour = calendar.component(.hour, from: date)
        let minutes = calendar.component(.minute, from: date)
        let seconds = calendar.component(.second, from: date)
        
        let nowTime : String = "\((hour < 10) ? "0\(hour)" : "\(hour)"):\((minutes < 10) ? "0\(minutes)" : "\(minutes)"):\((seconds < 10) ? "0\(seconds)" : "\(seconds)")"
        
        var action = ActionDetail()
        action.description = "Button \(buttonIndex + 1) pressed"
        action.actionTime = nowTime
        action.actionType = "buttonPress"
        action.buttonCorrect =  (isCorrect) ? 1 : 0
        
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
    
    @IBOutlet var labelRepeatDone: UILabel!
    func buttonAction(buttonIndex : Int)
    {
        if(buttonIndex == pressCount)
        {
            recordButtonPress(buttonIndex: buttonIndex, isCorrect: true)
            
            if(nextButtonIndication)
            {
                //change current button color
                buttons[buttonIndex].tintColor = UIColor.systemBlue
                //change next button color
                if(appearButtons > buttonIndex + 1)
                {
                    buttons[(buttonIndex + 1)].tintColor = UIColor.systemGreen
                }
            }
            
            pressCount += 1;
            //reset if round end
            if(pressCount == appearButtons)
            {
                print("current press count: \(pressCount) update round")
                pressCount = 0
                recordRoundComplete()
                
                newRound()
                
                labelRepeatDone.text = "Repeat Done: \(completeCount)"
            }
        }
        else
        {
            recordButtonPress(buttonIndex: buttonIndex, isCorrect: false)
        }
    }
    
    func newRound()
    {
        if(nextButtonIndication)
        {
            buttons[0].tintColor = UIColor.systemGreen
        }
        
        if(randomButtonOrder)
        {
            randomButtonPos()
        }
    }
    
    //MARK: - Time counter
    func timeCounterStart()
    {
        if(totalSeconds > 1)
        {
            timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(timeCounterDisplayUpdate), userInfo: nil, repeats: true)
        }
        else
        {
            labelTimeCounter.isHidden = true
        }
    }
    
    @IBOutlet var labelTimeCounter: UILabel!
    @objc func timeCounterDisplayUpdate()
    {
        totalSeconds -= 1
        timeTake += 1
        var minutes = (totalSeconds / 60 < 10) ? "0\(totalSeconds / 60)" : "\(totalSeconds / 60)"
        var seconds = (totalSeconds % 60 < 10) ? "0\(totalSeconds % 60)" : "\(totalSeconds % 60)"
        
        labelTimeCounter.text = "Time Left: \(minutes):\(seconds)"
        
        if(totalSeconds == 0)
        {
            recordEnd(forceEnd: true)
        }
    }
    
    func timeCounterPause()
    {
        timer?.invalidate()
    }
    
    func timeCounterResume()
    {
        //timer = Timer()
        timeCounterStart()
    }
    
    // MARK: - Random button
    func randomButtonPos()
    {
        for i in 0...(appearButtons - 1)
        {
            if(i == 0)
            {
                randomPos(index: i)
            }
            else
            {
                var overLapping = false
                repeat
                {
                    overLapping = false
                    
                    randomPos(index: i)
                    for j in 0...(i - 1)
                    {
                        if(checkButtonOverlap(index1: i, index2: j))
                        {
                            overLapping = true
                            print("\(i) compare with \(j) result \(overLapping)")
                        }
                    }
                } while(overLapping)
            }
        }
    }
    
    func randomPos(index : Int)
    {
        var randomX = Double.random(in: 0..<(1080 - buttonSize))
        var randomY = Double.random(in: 110..<(820 - buttonSize))
        
        buttons[index].frame = CGRect(x: randomX, y: randomY, width: buttonSize, height: buttonSize)
        
        //print("random x: \(randomX)")
        //print("random y: \(randomY)")
        //print("frame x: \(buttons[index].frame.origin.x)")
        //print("frame y: \(buttons[index].frame.origin.y)")
        
        //buttons[4].isHidden = false
        //buttons[4].frame = CGRect(x: randomX + buttonSize, y: randomY, width: buttonSize, height: buttonSize)
    }
    
    func checkButtonOverlap(index1 : Int, index2 : Int) -> Bool
    {
        if(buttons[1].frame.origin.x >= buttons[2].frame.origin.x + buttonSize || buttons[2].frame.origin.x >= buttons[1].frame.origin.x + buttonSize)
        {
            return false
        }
        if(buttons[1].frame.origin.y + buttonSize <= buttons[2].frame.origin.y || buttons[2].frame.origin.y + buttonSize <= buttons[1].frame.origin.y)
        {
            return false
        }
        return true
    }
    
    // MARK: - IBActions
    @IBOutlet var buttonOption: UIButton!
    @IBAction func buttonActionOption(_ sender: Any) {
        if(isStarted)
        {
            timeCounterPause()
            
            createAlert(title: "", message: "Are you sure to end this exercise and back to Main Menu?")
        }
    }
    
    func createResultBoard()
    {
        performSegue(withIdentifier: "EndGameSegue", sender: self)
    }
    
    func createAlert(title: String, message: String)
    {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        
        alert.addAction(UIAlertAction(title: "Yes", style: UIAlertAction.Style.default, handler: {(action) in
            alert.dismiss(animated: true, completion: nil)
            self.returnToMainMenu()
        }))
        
        alert.addAction(UIAlertAction(title: "No", style: UIAlertAction.Style.default, handler: {(action) in
            alert.dismiss(animated: true, completion: nil)
            self.timeCounterStart()
        }))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    func returnToMainMenu()
    {
        recordEnd(forceEnd: true)
        
        performSegue(withIdentifier: "unwindToMainMenu", sender: self)
    }
    
    @IBOutlet var buttonStart: UIButton!
    @IBAction func buttonActionStart(_ sender: Any) {
        isStarted = true
        
        buttonStart.isHidden = true
        
        recordStart()
        
        for i in 0...(appearButtons - 1)
        {
            buttons[i].isHidden = false
        }
        
        //start game
        randomButtonPos()
        
        timeCounterStart()
    }
    
    @IBOutlet var button1: UIButton!
    @IBAction func buttonAction1(_ sender: Any) {
        buttonAction(buttonIndex: 0)
    }
    
    @IBOutlet var button2: UIButton!
    @IBAction func buttonAction2(_ sender: Any) {
        buttonAction(buttonIndex: 1)
    }
        
    @IBOutlet var button3: UIButton!
    @IBAction func buttonAction3(_ sender: Any) {
        buttonAction(buttonIndex: 2)
    }
    
    @IBOutlet var button4: UIButton!
    @IBAction func buttonAction4(_ sender: Any) {
        buttonAction(buttonIndex: 3)
    }
    
    @IBOutlet var button5: UIButton!
    @IBAction func buttonAction5(_ sender: Any) {
        buttonAction(buttonIndex: 4)
    }
    
    // MARK: - Navigation
    @IBAction func unwindToExercise(sender: UIStoryboardSegue)
    {
        
    }
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        super.prepare(for: segue, sender: sender)
        
        if segue.identifier == "EndGameSegue"
        {
            guard let viewResultBoardController = segue.destination as? ViewResultBoardController else
            {
                fatalError("Unexpected sender: \(segue.destination)")
            }
            
            viewResultBoardController.titleText = completionText
            viewResultBoardController.timeText = timeTake
            viewResultBoardController.countText = "Repeat completed: \(completeCount)"
        }
    }

}
