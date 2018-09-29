//
//  ViewController.swift
//  DaySleepersClub
//
//  Created by lydia on 6/4/18.
//  Copyright © 2018 lydia. All rights reserved.
//

import UIKit
import os.log

class MemberViewController: UIViewController, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var editName: UITextField!
    @IBOutlet weak var editTeam: UITextField!
    @IBOutlet weak var editDescription: UITextField!
    @IBOutlet weak var editPhoto: UIImageView!
    @IBOutlet weak var editRating: SleepLevels!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    
    var member:MemberClass?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Adding New Member"
        // Handle the text field’s user input through delegate callbacks.
        editName.delegate = self
        
        
        // Set up views if editing an existing Member.
        if let member = member {
            navigationItem.title = member.name
            editName.text = member.name
            editTeam.text = member.team
            editDescription.text = member.descriptions
            editPhoto.image = member.photo
            editRating.rating = member.rating
        }
        updateSaveButtonState()
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        updateSaveButtonState()
        navigationItem.title = editName.text
    }
    
    //MARK: UIImagePickerControllerDelegate
    // Dismiss the picker if the user canceled.
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        // The info dictionary may contain multiple representations of the image=> use the original.
        guard let selectedImage = info[UIImagePickerControllerOriginalImage] as? UIImage else {
            fatalError("Expected a dictionary containing an image, but was provided the following: \(info)")
        }
        // display the selected image.
        editPhoto.image = selectedImage
        
        // Dismiss the picker.
        dismiss(animated: true, completion: nil)
    }
    
    // MARK: - Action
    
    @IBAction func selectPhoto(_ sender: UIButton) {
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.sourceType = .photoLibrary
        present(imagePickerController, animated: true, completion: nil)
    }
    
    @IBAction func cancelButton(_ sender: UIBarButtonItem) {
        let isPresentingInAddMemberMode = presentingViewController is UINavigationController
        
        if isPresentingInAddMemberMode {
            dismiss(animated: true, completion: nil)
        }
        else if let owningNavigationController = navigationController{
            owningNavigationController.popViewController(animated: true)
        }
        else {
            fatalError("it is not inside a navigation controller.")
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        super.prepare(for: segue, sender: sender)
        
        // Configure the destination view controller only when the save button is pressed.
        guard let button = sender as? UIBarButtonItem, button === saveButton else {
            os_log("The save button was not pressed, cancelling", log: OSLog.default, type: .debug)
            return
        }

        let name = editName.text ?? ""
        let team = editTeam.text ?? "none"
        let des = editDescription.text ?? "none"
        let ava = editPhoto.image
        let rate = editRating.rating 
        
        member = MemberClass(photo: ava, name: name, team: team, descriptions: des, rating: rate)
    }

    // MARK: Private method
    private func updateSaveButtonState() {
        // Disable the Save button if the text field is empty.
        let text = editName.text ?? ""
        saveButton.isEnabled = !text.isEmpty
    }
}
