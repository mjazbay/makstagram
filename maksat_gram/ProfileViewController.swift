//
//  ProfileViewController.swift
//  maksat_gram
//
//  Created by Maksat Zhazbayev on 3/18/19.
//  Copyright © 2019 Maksat Zhazbayev. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
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
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
}
