//
//  ViewHistoryListDetailController.swift
//  assignment3
//
//  Created by mobiledev on 21/5/2022.
//

import UIKit
import Firebase
import FirebaseFirestoreSwift
import SwiftUI

class ViewHistoryListDetailController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet var tableViewHistoryDetail: UITableView!
    
    let db = Firestore.firestore()
    
    var exercise : [ActionDetail] = []
    var documentID : String = ""
    var exerciseIndex : Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        tableViewHistoryDetail.delegate = self
        tableViewHistoryDetail.dataSource = self
        
        //print(exercise.count)
        
        self.tableViewHistoryDetail.reloadData()
    }
    
    @IBAction func buttonActionDeleteRecord(_ sender: Any) {
        let alert = UIAlertController(title: "", message: "Are you sure to delete this record?", preferredStyle: UIAlertController.Style.alert)
        
        alert.addAction(UIAlertAction(title: "Yes", style: UIAlertAction.Style.default, handler: {(action) in
            alert.dismiss(animated: true, completion: nil)
            self.confirmDelete()
        }))
        
        alert.addAction(UIAlertAction(title: "No", style: UIAlertAction.Style.default, handler: {(action) in
            alert.dismiss(animated: true, completion: nil)
        }))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    func confirmDelete()
    {
        let exerciseCollection = db.collection("stroke")
        
        exerciseCollection.document(documentID).delete() { err in
            if let err = err {
                print("Error removing document: \(err)")
            } else {
                print("Document successfullt removed!")
            }
        }
        
        performSegue(withIdentifier: "returnToHistorySegue", sender: self)
    }
    
    @IBAction func buttonActionShareThis(_ sender: UIButton) {
        let shareData : String = shareFormat()
        
        let shareViewController = UIActivityViewController(activityItems: [shareData], applicationActivities: [])
        
        shareViewController.popoverPresentationController?.sourceView = sender
        
        present(shareViewController, animated: true, completion: nil)
    }
    
    func shareFormat() -> String
    {
        var result = ""
        
        for action in exercise
        {
            var record : String = ""
            
            var description : String = action.description!
            var actionTime : String = action.actionTime!
            var buttonCorrect : String = ""
            switch action.buttonCorrect
            {
            case -1:
                buttonCorrect = ""
            case 0:
                buttonCorrect = "wrong "
            case 1:
                buttonCorrect = "correct "
            default:
                buttonCorrect = ""
            }
            
            record = "\(description) \(buttonCorrect)at \(actionTime).\n"
            result += record
        }
        
        return result
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return exercise.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "HistoryDetailTableViewCell", for: indexPath)
        
        let action = exercise[indexPath.row]
        
        if let actionCell = cell as? HistoryDetailTableViewCell
        {
            actionCell.labelAction.text = action.description
            
            var correctText = ""
            switch action.buttonCorrect
            {
            case -1:
                correctText = ""
            case 0:
                correctText = "Wrong"
                actionCell.labelActionCorrect.textColor = UIColor.systemRed
            case 1:
                correctText = "Correct"
                actionCell.labelActionCorrect.textColor = UIColor.systemGreen
            default:
                correctText = ""
            }
            actionCell.labelActionCorrect.text = correctText
            actionCell.labelActionTime.text = "Time: " + action.actionTime!
        }
        
        return cell
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
