//
//  ViewController.swift
//  Meme Maker
//
//  Created by Shubham Nandanwar on 25/10/20.
//  Copyright © 2020 Shubham Nandanwar. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {

    @IBOutlet var imagePickerVIew: UIImageView!
    @IBOutlet var cameraButton: UIBarButtonItem!
    @IBOutlet var topTextField: UITextField!
    @IBOutlet var bottomTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        cameraButton.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)
        let memeTextAttributes: [NSAttributedString.Key: Any] = [
            NSAttributedString.Key.strokeColor: UIColor.white,
            NSAttributedString.Key.foregroundColor: UIColor.black,
            NSAttributedString.Key.font: UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
            NSAttributedString.Key.strokeWidth: 5
        ]
        
        topTextField.textAlignment = .center
        topTextField.defaultTextAttributes = memeTextAttributes
        topTextField.delegate = self
        topTextField.contentVerticalAlignment = UIControl.ContentVerticalAlignment.center

        bottomTextField.textAlignment = .center
        bottomTextField.defaultTextAttributes = memeTextAttributes
        bottomTextField.delegate = self
        bottomTextField.contentVerticalAlignment = UIControl.ContentVerticalAlignment.center

        topTextField.text = "TOP"
        bottomTextField.text = "BOTTOM"
    }

    @IBAction func pickAnImage(_ sender: Any) {
        print("pickAnImage clicked")
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        pickerController.sourceType = .photoLibrary
        present(pickerController, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[.originalImage] as? UIImage {
            imagePickerVIew.image = image
            print("showing image")
        } else {
            print("something went wrong! Focus")
        }
        imagePickerVIew.contentMode = .scaleAspectFit
        picker.dismiss(animated: true, completion: nil)
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField.tag == 0 && textField.text == "TOP" {
            topTextField.text = ""
        } else if textField.tag == 1 && textField.text == "BOTTOM" {
            bottomTextField.text = ""
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true;
    }
    
    @IBAction func pickAnImageFromCamera(_ sender: Any) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .camera
        present(imagePicker, animated: true, completion: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        subscribeToKeyboardNotifications()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        unsubscribeToKeyboardNotifications()
    }
    
    @objc func keyboardWillShow(_ notification:Notification){
        view.frame.origin.y = -getKeyboardHeight(notification)
    }
    
    @objc func keyboardWillHide(_ notification:Notification){
        view.frame.origin.y = 0
    }
    
    func subscribeToKeyboardNotifications(){
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    func unsubscribeToKeyboardNotifications(){
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    func getKeyboardHeight(_ notification:Notification) -> CGFloat{
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! NSValue
        return keyboardSize.cgRectValue.height
    }
    
    func generateMemedImage() -> UIImage {

        // TODO: Hide toolbar and navbar

        // Render view to an image
        UIGraphicsBeginImageContext(self.view.frame.size)
        view.drawHierarchy(in: self.view.frame, afterScreenUpdates: true)
        let memedImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()

        // TODO: Show toolbar and navbar

        return memedImage
    }

}
