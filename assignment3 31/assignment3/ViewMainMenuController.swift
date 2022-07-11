//
//  ViewMainMenuController.swift
//  assignment3
//
//  Created by mobiledev on 14/5/2022.
//

import UIKit

class ViewMainMenuController: UIViewController {

    @IBOutlet var labelWelcomeName: UILabel!
    
    let preferences = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        //update welcome user text
        updateName()
    }
    
    @IBAction func unwindToMainMenu(sender: UIStoryboardSegue)
    {
        
    }
    
    @IBAction func unwindToMainMenuWithSaveName(sender: UIStoryboardSegue)
    {
        updateName()
    }
    
    func updateName()
    {
        if(preferences.object(forKey: "userName") == nil)
        {
            labelWelcomeName.text = "Welcome, Anonymous user"
        }
        else
        {
            let name : String! = preferences.string(forKey: "userName")
            
            if (name == "")
            {
                labelWelcomeName.text = "Welcome, Anonymous user"
            }
            else
            {
                labelWelcomeName.text = "Welcome, " + name
            }
        }
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        if segue.identifier == "editNameSegue"
        {
            
        }

    }
}
