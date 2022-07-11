//
//  ViewEntertainmentExerciseSettingController.swift
//  assignment3
//
//  Created by mobiledev on 23/5/2022.
//

import UIKit

class ViewEntertainmentExerciseSettingController: UIViewController {

    let preferences = UserDefaults.standard
    
    var randomSliderRotation : Bool = false
    var difficultyIndex : Int = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        preferences.set(randomSliderRotation, forKey: "randomSliderRotation")
        preferences.set(difficultyIndex, forKey: "difficultyIndex")
        
        buttonNormal.tintColor = UIColor.systemGreen
    }
    
    
    @IBOutlet var buttonRandomSliderRotation: UIButton!
    @IBAction func buttonActionRandomSliderRotation(_ sender: Any) {
        var configuration = UIButton.Configuration.filled()
        var container = AttributeContainer()
        container.font = UIFont.boldSystemFont(ofSize: 32.0)
        
        if(randomSliderRotation)
        {
            randomSliderRotation = false
            
            container.foregroundColor = UIColor.systemRed
            buttonRandomSliderRotation.configuration?.attributedTitle = AttributedString("Random Slider Rotation OFF", attributes: container)
        }
        else
        {
            randomSliderRotation = true
            
            container.foregroundColor = UIColor.systemGreen
            buttonRandomSliderRotation.configuration?.attributedTitle = AttributedString("Random Slider Rotation ON", attributes: container)
        }
        
        preferences.set(randomSliderRotation, forKey: "randomSliderRotation")
    }
    
    @IBOutlet var buttonEasy: UIButton!
    @IBAction func buttonActionEasy(_ sender: Any) {
        difficultyIndex = 0
        preferences.set(difficultyIndex, forKey: "difficultyIndex")
        
        buttonEasy.tintColor = UIColor.systemGreen
        
        buttonNormal.tintColor = UIColor.systemBlue
        buttonHard.tintColor = UIColor.systemBlue
    }
    
    @IBOutlet var buttonNormal: UIButton!
    @IBAction func buttonActionMedium(_ sender: Any) {
        difficultyIndex = 1
        preferences.set(difficultyIndex, forKey: "difficultyIndex")
        
        buttonNormal.tintColor = UIColor.systemGreen
        
        buttonEasy.tintColor = UIColor.systemBlue
        buttonHard.tintColor = UIColor.systemBlue
    }
    
    @IBOutlet var buttonHard: UIButton!
    @IBAction func buttonActionHard(_ sender: Any) {
        difficultyIndex = 2
        preferences.set(difficultyIndex, forKey: "difficultyIndex")
        
        buttonHard.tintColor = UIColor.systemGreen
        
        buttonEasy.tintColor = UIColor.systemBlue
        buttonNormal.tintColor = UIColor.systemBlue
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
