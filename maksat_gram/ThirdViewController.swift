//
//  ThirdViewController.swift
//  maksat_gram
//
//  Created by Maksat Zhazbayev on 3/10/19.
//  Copyright © 2019 Maksat Zhazbayev. All rights reserved.
//

import UIKit
import AlamofireImage
import Parse

class ThirdViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate
{
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var commentTextField: UITextField!
    

    
    @IBAction func submitButton(_ sender: Any)
    {
        let post = PFObject(className: "Posts")
        post["comment"] = commentTextField.text!
        post["author"] = PFUser.current()!
        
        let imageData = imageView .image!.pngData()!
        let file = PFFileObject(data: imageData)
        
        post["image"] = file
        
        post.saveInBackground
        { (success, error) in
            if success
            {
                print("Saved")
                self.savedView.alpha = 0.0
                //fade in
                UIView.animate(withDuration: 3, delay: 0.2, options: .curveLinear, animations: {
                    self.savedView.alpha = 1.0
                }) { (finished) in
                    //fade out
                    UIView.animate(withDuration: 3, delay: 0.2, options: .curveEaseOut, animations: {
                        self.savedView.alpha = 0.0
                    })
                }
               // self.dismiss(animated: true, completion: nil)
            
            }
            else
            {
                print("Error Saving: \(error?.localizedDescription)")
            }
        }
    }
    
    @IBAction func importImage(_ sender: Any)
    {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.allowsEditing = true
    
        if UIImagePickerController.isSourceTypeAvailable(.camera)
        {
            picker.sourceType = .camera
        }
        else
        {
            picker.sourceType = .photoLibrary
        }
        present(picker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any])
    {
        //RESIZING the IMAGE USING ALAMO FIRE IMAGE
        let image = info[.editedImage] as! UIImage
        let size = CGSize(width: 300, height: 300)
        let scaledImage = image.af_imageAspectScaled(toFill: size)
        
        imageView.image = scaledImage 
        
        dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func backButton(_ sender: Any)
    {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    
    @IBOutlet weak var savedView: UIImageView!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.savedView.alpha = 0.0
        
    }
}
