//
//  DialogInGameMenuController.swift
//  assignment3
//
//  Created by mobiledev on 22/5/2022.
//

import UIKit

class ViewResultBoardController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet var labelResultTitle: UILabel!
    @IBOutlet var labelResultTime: UILabel!
    @IBOutlet var labelResultCount: UILabel!
    
    var titleText : String?
    var timeText : Int?
    var countText : String?
    
    var selectedPicture = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        labelResultTitle.text = titleText
        
        var timeCount : String = ""
        
        if(timeText != 0)
        {
            let minutes = timeText! / 60
            let seconds = timeText! % 60
            
            timeCount = "Time taken: \((minutes < 10) ? "0\(minutes)" : "\(minutes)"):\((seconds < 10) ? "0\(seconds)" : "\(seconds)")"
        }
        
        labelResultTime.text = timeCount
        labelResultCount.text = countText
    }
    
    @IBAction func buttonActionReturnToMenu(_ sender: Any) {
        //upload
        if(selectedPicture)
        {
            print("have image")
        }
        else
        {
            print("no image")
        }
    }
    
    @IBAction func buttonActionTakePhoto(_ sender: Any) {
        if UIImagePickerController.isSourceTypeAvailable(.camera)
        {
            let imagePickerController = UIImagePickerController()
            imagePickerController.delegate = self
            imagePickerController.sourceType = .camera
            
            self.present(imagePickerController, animated: true, completion: nil)
        }
        else
        {
            let alert = UIAlertController(title: "", message: "No camera available", preferredStyle: UIAlertController.Style.alert)
            
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: {(action) in
                alert.dismiss(animated: true, completion: nil)
            }))
            
            self.present(alert, animated: true,completion: nil)
        }
    }
    
    @IBAction func buttonActionSelectPicture(_ sender: Any) {
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary)
        {
            let imagePickerController = UIImagePickerController()
            imagePickerController.delegate = self
            imagePickerController.sourceType = .photoLibrary
            imagePickerController.allowsEditing = true
            
            self.present(imagePickerController, animated: true, completion: nil)
        }
    }
    @IBOutlet var imageView: UIImageView!
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        selectedPicture = true
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
        {
            imageView.image = image
            dismiss(animated: true, completion: nil)
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        selectedPicture = false
        dismiss(animated: true, completion: nil)
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
