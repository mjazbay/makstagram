//
//  SecondViewController.swift
//  maksat_gram
//
//  Created by Maksat Zhazbayev on 3/10/19.
//  Copyright © 2019 Maksat Zhazbayev. All rights reserved.
//

import UIKit
import Parse
import AlamofireImage

class SecondViewController: UIViewController, UITableViewDelegate, UITableViewDataSource
{
    
    @IBOutlet weak var feedTableView: UITableView!
    var posts = [PFObject]()
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        self.feedTableView.dataSource = self
        self.feedTableView.delegate = self
    }
    
    override func viewDidAppear(_ animated: Bool)
    {
        super.viewDidAppear(true)
        
        let query = PFQuery(className: "Posts")
        query.includeKey("author")
        query.limit = 20
        
        query.findObjectsInBackground
            { (posts, error) in
                if posts != nil
                {
                    self.posts = posts!
                    self.feedTableView.reloadData()
                }
            }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "postCell", for: indexPath) as! postCell
        
        let post = posts[indexPath.row]
        let user = post["author"] as! PFUser
        cell.usernameLabel.text = user.username
        cell.commentLabel.text = (post["comment"] as! String)
        
        let imageFile = post["image"] as! PFFileObject
        let urlString = imageFile.url!
        let url = URL(string: urlString)!
        
        cell.pictureView.af_setImage(withURL: url)
        
        return cell
    }
}

