//
//  myPostsViewController.swift
//  maksat_gram
//
//  Created by Maksat Zhazbayev on 3/21/19.
//  Copyright © 2019 Maksat Zhazbayev. All rights reserved.
//

import UIKit
import Parse
import AlamofireImage

class myPostsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    @IBOutlet weak var myPostsTableView: UITableView!
    var myPosts = [PFObject]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.myPostsTableView.delegate = self
        self.myPostsTableView.dataSource = self
        
    }
    


//    override func viewDidAppear(_ animated: Bool) {
//        super.viewDidAppear(true)
//        print("coming from viewDidAppear")
//        query_myPosts()
//    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        query_myPosts()
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("coming from numberOfRowsInSection \(myPosts.count)")
        return myPosts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = myPostsTableView.dequeueReusableCell(withIdentifier: "myPostsCell") as! myPostsCell
        let cell = myPostsTableView.dequeueReusableCell(withIdentifier: "myPostsCell", for: indexPath) as! myPostsCell
        let myPost = myPosts[indexPath.row]
        let imageFile = myPost["image"] as! PFFileObject
        let urlString = imageFile.url!
        let url = URL(string: urlString)!

        cell.myPostImageView.af_setImage(withURL: url)

        return cell
    }
    
    
    func query_myPosts()
    {
        let query = PFQuery(className: "Posts")
        query.whereKey("author", equalTo: PFUser.current())
        query.findObjectsInBackground { (images, error) in
            if images != nil
            {
                self.myPosts = images!
                self.myPostsTableView.reloadData()
                print(self.myPosts.count)
            }
            else
            {
                print(error?.localizedDescription)
            }
        }
    }
}
