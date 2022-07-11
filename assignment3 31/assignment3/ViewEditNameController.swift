//
//  ViewEditNameController.swift
//  assignment3
//
//  Created by mobiledev on 13/5/2022.
//

import UIKit
import Firebase
import FirebaseFirestoreSwift

class ViewEditNameController: UIViewController {

    @IBOutlet var textFieldNameEnter: UITextField!
    
    let preferences = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        let db = Firestore.firestore()
        print("\nINITIALIZED FIRESTORE APP \(db.app.name)\n")
        
        //if preferences for name not exist
        if (preferences.object(forKey: "userName") == nil)
        {
            //create new with key
            preferences.set("", forKey: "userName")
        }
        else
        {
            //if exist and got data
            if(preferences.string(forKey: "userName") != "")
            {
                //load as placeholder to display
                textFieldNameEnter.placeholder = preferences.string(forKey: "userName")
            }
        }
        
    }

    @IBAction func btnConfirmedNameAction(_ sender: Any) {
        //if anything entered
        if(textFieldNameEnter.text != "")
        {
            //save to preferences with key
            preferences.set(textFieldNameEnter.text, forKey: "userName")
        }
    }
    
    
    
}

