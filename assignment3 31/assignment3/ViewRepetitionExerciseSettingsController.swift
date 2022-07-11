//
//  ViewRepetitionExerciseSettingsController.swift
//  assignment3
//
//  Created by mobiledev on 14/5/2022.
//

import UIKit

class ViewRepetitionExerciseSettingsController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    let preferences = UserDefaults.standard
    
    var timeLimitMinutes : Int = 0
    var timeLimitSeconds : Int = 0
    var pickerViewMinutesData : [Int] = [0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36,37,38,39,40,41,42,43,44,45,46,47,48,49,50,51,52,53,54,55,56,57,58,59]
    var pickerViewSecondsData : [Int] = [0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36,37,38,39,40,41,42,43,44,45,46,47,48,49,50,51,52,53,54,55,56,57,58,59]
    @IBOutlet var pickerViewMinutes: UIPickerView!
    @IBOutlet var pickerViewSeconds: UIPickerView!
    @IBOutlet var labelTimeLimitEnable: UILabel!
    
    var repeatTime : Int = 0
    var appearButtons : Int = 2
    @IBOutlet var sliderRepeatTime: UISlider!
    @IBOutlet var sliderAppearButtons: UISlider!
    @IBOutlet var labelRepeatTimeEnable: UILabel!
    @IBOutlet var labelRepeatTime: UILabel!
    @IBOutlet var labelAppearButtons: UILabel!
    
    var randomButtonOrder : Bool = false
    var nextButtonIndication : Bool = false
    
    var buttonSizeIndex : Int = 1
    
    var isFreeplay : Bool = true
    @IBOutlet var segementControlPlayMode: UISegmentedControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        self.pickerViewMinutes.delegate = self
        self.pickerViewMinutes.dataSource = self
        self.pickerViewSeconds.delegate = self
        self.pickerViewSeconds.dataSource = self
        
        buttonMedium.tintColor = UIColor.systemGreen
        
        let font = UIFont.systemFont(ofSize: 32.0)
        segementControlPlayMode.setTitleTextAttributes([NSAttributedString.Key.font: font], for: .normal)
        
        defaultPreferences()
    }
    
    func defaultPreferences()
    {
        preferences.set(timeLimitMinutes, forKey: "timeLimitMinutes")
        preferences.set(timeLimitSeconds, forKey: "timeLimitSeconds")
        
        preferences.set(repeatTime, forKey: "repeatTime")
        preferences.set(appearButtons, forKey: "appearButtons")
        
        preferences.set(randomButtonOrder, forKey: "randomButtonOrder")
        preferences.set(nextButtonIndication, forKey: "nextButtonIndication")
        
        preferences.set(buttonSizeIndex, forKey: "buttonSize")
        
        preferences.set(isFreeplay, forKey: "isFreePlay")
    }
    
    func ifOnFreeplay()
    {
        if(timeLimitSeconds != 0 || timeLimitMinutes != 0 || repeatTime != 0)
        {
            segementControlPlayMode.selectedSegmentIndex = 0
            isFreeplay = false
            preferences.set(isFreeplay, forKey: "isFreePlay")
        }
        else
        {
            segementControlPlayMode.selectedSegmentIndex = 1
            isFreeplay = true
            preferences.set(isFreeplay, forKey: "isFreePlay")
        }
    }
    
    // MARK: - PickerView
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int
    {
        return 1
    }
    
    //count of element inside the Data array
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int{
        if(pickerView == pickerViewMinutes)
        {
            return pickerViewMinutesData.count
        }
        else
        {
            return pickerViewSecondsData.count
        }
    }
    
    //element of the array by the index
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String?
    {
        if(pickerView == pickerViewMinutes)
        {
            return String(pickerViewMinutesData[row])
        }
        else
        {
            return String(pickerViewSecondsData[row])
        }
    }
    
    //get the data currently selected
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int)
    {
        if(pickerView == pickerViewMinutes)
        {
            timeLimitMinutes = pickerViewMinutesData[row]
            preferences.set(timeLimitMinutes, forKey: "timeLimitMinutes")
        }
        else
        {
            timeLimitSeconds = pickerViewSecondsData[row]
            preferences.set(timeLimitSeconds, forKey: "timeLimitSeconds")
        }
        
        if(timeLimitMinutes == 0 && timeLimitSeconds == 0)
        {
            labelTimeLimitEnable.text = "(Disabled)"
            labelTimeLimitEnable.textColor = UIColor.systemRed
        }
        else
        {
            labelTimeLimitEnable.text = "(Enabaled)"
            labelTimeLimitEnable.textColor = UIColor.systemGreen
        }
        
        ifOnFreeplay()
    }
    
    // MARK: - Slider
    @IBAction func onSliderChangeRepeatTime(_ sender: Any) {
        repeatTime = Int(sliderRepeatTime.value)
        preferences.set(repeatTime, forKey: "repeatTime")
        
        labelRepeatTime.text = "Play " + String(repeatTime) + " Time"
        
        if(repeatTime == 0)
        {
            labelRepeatTimeEnable.text = "(Disabled)"
            labelRepeatTimeEnable.textColor = UIColor.systemRed
        }
        else
        {
            labelRepeatTimeEnable.text = "(Enabled)"
            labelRepeatTimeEnable.textColor = UIColor.systemGreen
        }
        
        ifOnFreeplay()
    }
    
    @IBAction func onSliderChangeAppearButtons(_ sender: Any) {
        appearButtons = Int(sliderAppearButtons.value)
        preferences.set(appearButtons, forKey: "appearButtons")
        
        labelAppearButtons.text = "Appear " + String(appearButtons) + " Buttons"
    }
    
    // MARK: - Button
    @IBOutlet var buttonRandomButton: UIButton!
    @IBAction func buttonActionRandomButton(_ sender: Any) {
        var configuration = UIButton.Configuration.filled()
        var container = AttributeContainer()
        container.font = UIFont.boldSystemFont(ofSize: 32.0)
        
        if(randomButtonOrder)
        {
            randomButtonOrder = false
            
            container.foregroundColor = UIColor.systemRed
            
            buttonRandomButton.configuration?.attributedTitle = AttributedString("Random Button Order OFF", attributes: container)
        }
        else
        {
            randomButtonOrder = true
            
            container.foregroundColor = UIColor.systemGreen
            
            buttonRandomButton.configuration?.attributedTitle = AttributedString("Random Button Order ON", attributes: container)
        }
        
        preferences.set(randomButtonOrder, forKey: "randomButtonOrder")
    }
    
    @IBOutlet var buttonNextIndication: UIButton!
    @IBAction func buttonActionNextIndication(_ sender: Any) {
        var configuration = UIButton.Configuration.filled()
        var container = AttributeContainer()
        container.font = UIFont.boldSystemFont(ofSize: 32.0)
        
        if(nextButtonIndication)
        {
            nextButtonIndication = false
            
            container.foregroundColor = UIColor.systemRed
            
            buttonNextIndication.configuration?.attributedTitle = AttributedString("Next-button Indication OFF", attributes: container)
        }
        else
        {
            nextButtonIndication = true
            
            container.foregroundColor = UIColor.systemGreen
            
            buttonNextIndication.configuration?.attributedTitle = AttributedString("Next-button Indication ON", attributes: container)
        }
        
        preferences.set(nextButtonIndication, forKey: "nextButtonIndication")
    }
    
    
    @IBOutlet weak var buttonSmall: UIButton!
    @IBAction func buttonSmallSelect(_ sender: Any) {
        buttonSizeIndex = 0
        preferences.set(buttonSizeIndex, forKey: "buttonSize")
        
        buttonSmall.tintColor = UIColor.systemGreen
        
        buttonMedium.tintColor = UIColor.systemBlue
        buttonLarge.tintColor = UIColor.systemBlue
    }
    

    @IBOutlet weak var buttonMedium: UIButton!
    @IBAction func buttonMediumSelect(_ sender: Any) {
        buttonSizeIndex = 1
        preferences.set(buttonSizeIndex, forKey: "buttonSize")
        
        buttonMedium.tintColor = UIColor.systemGreen
        
        buttonSmall.tintColor = UIColor.systemBlue
        buttonLarge.tintColor = UIColor.systemBlue
    }
    
    @IBOutlet weak var buttonLarge: UIButton!
    @IBAction func buttonLargeSelect(_ sender: Any) {
        buttonSizeIndex = 2
        preferences.set(buttonSizeIndex, forKey: "buttonSize")
        
        buttonLarge.tintColor = UIColor.systemGreen
        
        buttonSmall.tintColor = UIColor.systemBlue
        buttonMedium.tintColor = UIColor.systemBlue
    }
    
    // MARK: - Segemented Controll
    
    @IBAction func segmentControllActionGameMode(_ sender: Any) {
        switch segementControlPlayMode.selectedSegmentIndex {
        case 0:
            isFreeplay = false
            
            //atleast repeat 1 time
            sliderRepeatTime.value = 1
            repeatTime = 1
            labelRepeatTimeEnable.text = "(Enabled)"
            labelRepeatTimeEnable.textColor = UIColor.systemGreen
            labelRepeatTime.text = "Play " + String(repeatTime) + " Time"
        case 1:
            isFreeplay = true
            
            //disable repeat time
            sliderRepeatTime.value = 0
            repeatTime = 0
            labelRepeatTimeEnable.text = "(Disabled)"
            labelRepeatTimeEnable.textColor = UIColor.systemRed
            labelRepeatTime.text = "Play " + String(repeatTime) + " Time"
            
            //disable time limit
            pickerViewMinutes.selectRow(0, inComponent: 0, animated: true)
            pickerViewSeconds.selectRow(0, inComponent: 0, animated: true)
            timeLimitMinutes = 0
            timeLimitSeconds = 0
            labelTimeLimitEnable.text = "(Disabled)"
            labelTimeLimitEnable.textColor = UIColor.systemRed
        default:
            break
        }
        
        preferences.set(isFreeplay, forKey: "isFreePlay")
        preferences.set(repeatTime, forKey: "repeatTime")
        preferences.set(timeLimitMinutes, forKey: "timeLimitMinutes")
        preferences.set(timeLimitSeconds, forKey: "timeLimitSeconds")
    }


 // MARK: - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
 // Get the new view controller using segue.destination.
 // Pass the selected object to the new view controller.
 }
    
}
