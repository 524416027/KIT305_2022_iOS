//
//  ViewHistoryListController.swift
//  assignment3
//
//  Created by mobiledev on 20/5/2022.
//

import UIKit
import Firebase
import FirebaseFirestoreSwift

class ViewHistoryListController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    let db = Firestore.firestore()
    
    @IBOutlet var tableViewHistory: UITableView!
    
    @IBOutlet var labelTotalCorrectButton: UILabel!
    
    var lastSelectedIndex : Int = 0
    
    var exercisesComplete = [RepetitionExercise]()
    var exercisesInComplete = [RepetitionExercise]()
    var exercises = [RepetitionExercise]()
    
    var filterButtonIndex = 0

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        
        tableViewHistory.delegate = self
        tableViewHistory.dataSource = self
        
        getDataFromDatabase()
    }
    
    func getDataFromDatabase()
    {
        let exerciseCollection = db.collection("stroke")
        
        var correctButtonCount : Int = 0
        
        exerciseCollection.getDocuments() { (result, err) in
            if let err = err
            {
                print("Error getting documents: \(err)")
            }
            else
            {
                self.exercises.removeAll()
                self.exercisesComplete.removeAll()
                self.exercisesInComplete.removeAll()
                
                for document in result!.documents
                {
                    let conversionResult = Result
                    {
                        try document.data(as: RepetitionExercise.self)
                    }
                    
                    switch conversionResult
                    {
                    case .success(let exercise):
                        //print("Exercise: \(exercise)")
                        for action in exercise.action
                        {
                            if(action.buttonCorrect == 1)
                            {
                                //print(correctButtonCount)
                                correctButtonCount += 1
                            }
                        }
                        
                        if(exercise.completion == 0)
                        {
                            self.exercisesInComplete.append(exercise)
                        }
                        
                        if(exercise.completion == 1)
                        {
                            self.exercisesComplete.append(exercise)
                        }
                        
                        self.exercises.append(exercise)
                    case .failure(let error):
                        print("Error decoing exercise: \(error)")
                    }
                }
                
                self.tableViewHistory.reloadData()
            }
            
            self.labelTotalCorrectButton.text = "Total \(correctButtonCount) buttons correctly pressed."
        }
    }

    //MARK: - Share
    @IBAction func buttonActionShareAll(_ sender: UIButton) {
        let shareData : String = shareFormat()
        
        let shareViewController = UIActivityViewController(activityItems: [shareData], applicationActivities: [])
        
        shareViewController.popoverPresentationController?.sourceView = sender
        
        present(shareViewController, animated: true, completion: nil)
    }
    
    func shareFormat() -> String
    {
        var result = ""
        
        for exercise in exercises
        {
            var record : String = ""
            
            var mode : String = exercise.mode!
            var repeatTime : String = exercise.repeatTimes == -1 ? "repeat times not aplied" : "repeat \(exercise.repeatTimes) times"
            var startTime : String = exercise.startTime!
            var endTime : String = exercise.endTime!
            var completion : String = ""
            switch exercise.completion!
            {
            case -1:
                completion = "completion not aplied"
            case 0:
                completion = "not completed"
            case 1:
                completion = "completed"
            default:
                completion = ""
            }
            
            record = "\(mode) Mode \(completion), Start at: \(startTime), End at: \(endTime), with \(repeatTime).\n"
            
            result += record
        }
        
        return result
    }
    
    // MARK: - Filter
    @IBOutlet var buttonFilter: UIButton!
    @IBAction func buttonActionFilter(_ sender: Any) {
        filterButtonIndex += 1
        
        if(filterButtonIndex > 2)
        {
            filterButtonIndex = 0
        }
        
        var configuration = UIButton.Configuration.filled()
        var container = AttributeContainer()
        container.font = UIFont.boldSystemFont(ofSize: 32.0)
        
        switch filterButtonIndex
        {
        case 0:
            container.foregroundColor = UIColor.systemBackground
            buttonFilter.configuration?.attributedTitle = AttributedString("All", attributes: container)
        case 1:
            container.foregroundColor = UIColor.systemGreen
            buttonFilter.configuration?.attributedTitle = AttributedString("Completed", attributes: container)
        case 2:
            container.foregroundColor = UIColor.systemRed
            buttonFilter.configuration?.attributedTitle = AttributedString("In-Completed", attributes: container)
        default:
            container.foregroundColor = UIColor.systemBlue
            buttonFilter.configuration?.attributedTitle = AttributedString("All", attributes: container)
        }
        
        self.tableViewHistory.reloadData()
    }
    
    // MARK: - Table view data source
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        var count = 0
        
        switch filterButtonIndex
        {
        case 0:
            count = exercises.count
        case 1:
            count = exercisesComplete.count
        case 2:
            count = exercisesInComplete.count
        default:
            count = exercises.count
        }
        
        return count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HistoryTableViewCell", for: indexPath)

        // Configure the cell...
        var exercise : RepetitionExercise
        
        switch filterButtonIndex
        {
        case 0:
            exercise = exercises[indexPath.row]
        case 1:
            exercise = exercisesComplete[indexPath.row]
        case 2:
            exercise = exercisesInComplete[indexPath.row]
        default:
            exercise = exercises[indexPath.row]
        }
        
        if let exerciseCell = cell as? HistoryTableViewCell
        {
            exerciseCell.labelMode.text = "Mode: " + exercise.mode!
            exerciseCell.labelRepeatTime.text = "Repeat Times: " + String(exercise.repeatTimes!)	
            exerciseCell.labelStartTime.text = "Start Time: " + exercise.startTime!
            exerciseCell.labelEndTime.text = "End Time: " + exercise.endTime!
        }

        return cell
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        super.prepare(for: segue, sender: sender)
        
        if segue.identifier == "HistoryDetailSegue"
        {
            guard let viewHistoryListDetailController = segue.destination as? ViewHistoryListDetailController else
            {
                fatalError("Unexpected destination: \(segue.destination)")
            }
            
            guard let selectedDetailCell = sender as? HistoryTableViewCell else
            {
                fatalError("Unexpected sender: \(String(describing: sender))")
            }

            guard let indexPath = tableViewHistory.indexPath(for: selectedDetailCell) else
            {
                fatalError("The selected cell is not being displayed by the table")
            }
            
            let selectedExercise = exercises[indexPath.row]
            
            lastSelectedIndex = indexPath.row
            
            viewHistoryListDetailController.exercise = selectedExercise.action
            viewHistoryListDetailController.documentID = selectedExercise.documentID!
            viewHistoryListDetailController.exerciseIndex = indexPath.row
        }
    }
    
    @IBAction func unwindToHistory(sender: UIStoryboardSegue)
    {
        //print("inreload")
        getDataFromDatabase()
    }

}
