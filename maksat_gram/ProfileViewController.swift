//
//  ProfileViewController.swift
//  maksat_gram
//
//  Created by Maksat Zhazbayev on 3/18/19.
//  Copyright © 2019 Maksat Zhazbayev. All rights reserved.
//

import UIKit
import Parse
import AlamofireImage

class ProfileViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    var myPicture = [PFObject]()
    var picture: PFObject!
    
    @IBOutlet weak var profilePicImageView: UIImageView!
    
    @IBAction func uploadProfilePic(_ sender: UITapGestureRecognizer)
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
        
        let image = info[.editedImage] as! UIImage
        let size = CGSize(width: 300, height: 300)
        let scaledImage = image.af_imageAspectScaled(toFill: size)
        
        
        profilePicImageView.image = scaledImage
        
        dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func submitProfilePic(_ sender: Any)
    {
        let profile = PFObject(className: "Profile")
        let pictureData = profilePicImageView.image!.pngData()!
        let file = PFFileObject(data: pictureData)
        
        
        profile["author"] = PFUser.current()
        profile["picture"] = file
        
        profile.saveInBackground { (success, error) in
            if success
            {
                print("picture is saved")
                self.submitIcon.alpha = 0.0
                //fade in
                UIView.animate(withDuration: 3, delay: 0.2, options: .curveLinear, animations: {
                    self.submitIcon.alpha = 1.0
                }) { (finished) in
                    //fade out
                    UIView.animate(withDuration: 3, delay: 0.2, options: .curveEaseOut, animations: {
                        self.submitIcon.alpha = 0.0
                    })
                }
            }
            else
            {
                print("error occured saving \(error)")
            }
        }
    }
    
    @objc func profilePicture()
    {
        let query = PFQuery(className: "Profile")
        query.whereKey("author", equalTo: PFUser.current())

        query.findObjectsInBackground { (pictures, error) in
            if pictures != nil
            {
                self.myPicture = pictures!
                print(self.myPicture)
                print("successfully retrieved \(self.myPicture.count) pictures")
                if self.myPicture.count != 0
                {
                    if self.myPicture.count > 1 {
                         self.picture = self.myPicture[self.myPicture.count-1]
                    } else {
                         self.picture = self.myPicture[0]
                    }
                    
                    let imageFile = self.picture["picture"] as! PFFileObject
                    let urlString = imageFile.url!
                    let url = URL(string: urlString)!
                    
                    self.profilePicImageView.af_setImage(withURL: url)

                }
                
            }
            else
            {
                print(error?.localizedDescription)
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
        //profilePicture()
        //twitter dahidai refresh button salip koi
    }
    
    @IBOutlet weak var submitIcon: UIImageView!
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        self.submitIcon.alpha = 0.0
        profilePicture()
        
        self.title = PFUser.current()?.username
        // Do any additional setup after loading the view.
    }
}
