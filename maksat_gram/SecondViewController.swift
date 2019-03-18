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
import MessageInputBar


class SecondViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, MessageInputBarDelegate
{
    
    @IBOutlet weak var feedTableView: UITableView!
    let commentBar = MessageInputBar()
    var posts = [PFObject]()
    var showsCommentBar = false
    var selectedPost: PFObject!
    
    override var inputAccessoryView: UIView?
    {
        return commentBar
    }
    override var canBecomeFirstResponder: Bool
    {
        return showsCommentBar
    }
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        self.commentBar.delegate = self
        commentBar.inputTextView.placeholder = "Add a comment..."
        commentBar.sendButton.title = "Post"
        
        self.feedTableView.dataSource = self
        self.feedTableView.delegate = self
        
        feedTableView.keyboardDismissMode = .interactive
        
        let center = NotificationCenter.default
        center.addObserver(self, selector: #selector(keyboardWillBeHiddin(note:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    override func viewDidAppear(_ animated: Bool)
    {
        super.viewDidAppear(true)
        
        let query = PFQuery(className: "Posts")
        query.includeKeys(["author", "comments", "comments.author"])
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
        let post = posts[section]
        let comments = (post["comments"] as? [PFObject]) ?? []
        return comments.count + 2
    }
    
    func numberOfSections(in tableView: UITableView) -> Int
    {
        return posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let post = posts[indexPath.section]
        let comments = (post["comments"] as? [PFObject]) ?? []
        
        
        if indexPath.row == 0
        {
            let cell = feedTableView.dequeueReusableCell(withIdentifier: "postCell") as! postCell
            
            let user = post["author"] as! PFUser
            cell.usernameLabel.text = String(user.username!) + ": "
            cell.commentLabel.text = (post["comment"] as! String)
            
            let imageFile = post["image"] as! PFFileObject
            let urlString = imageFile.url!
            let url = URL(string: urlString)!
            
            cell.pictureView.af_setImage(withURL: url)
            
            return cell
        }
        else if indexPath.row <= comments.count
        {
            let cell = feedTableView.dequeueReusableCell(withIdentifier: "CommentCell") as! CommentCell
            
            let comment = comments[indexPath.row - 1]
            cell.commentLabel.text = comment["text"] as? String
            
            let user = comment["author"] as! PFUser
            cell.commentatorLabel.text = user.username
            
            return cell
        }
        else
        {
            let cell = feedTableView.dequeueReusableCell(withIdentifier: "AddComment") as! AddCommentCell
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        let post = posts[indexPath.section]
        
        let comments = (post["comments"] as? [PFObject]) ?? []
        
        if indexPath.row == comments.count + 1
        {
            showsCommentBar = true
            becomeFirstResponder()
            commentBar.inputTextView.becomeFirstResponder()
            
            selectedPost = post
        }
    }
    
    @objc func keyboardWillBeHiddin(note: Notification)
    {
        commentBar.inputTextView.text = nil
        showsCommentBar = false
        becomeFirstResponder()
    }
    
    func messageInputBar(_ inputBar: MessageInputBar, didPressSendButtonWith text: String) {
        //Create the comment
        let comment = PFObject(className: "comments")
        
        comment["text"] = text
        comment["post"] = selectedPost
        comment["author"] = PFUser.current()
        
        
        //    adding comments to the array
        selectedPost.add(comment, forKey: "comments")
        
        selectedPost.saveInBackground { (success, error) in
            if success
            {
                print("The comment is saved")
            }
            else
            {
                print("error saving the comment \(error)")
            }
        }
        
        feedTableView.reloadData()
        
        //Clear and dismiss the input bar
        commentBar.inputTextView.text = nil
        showsCommentBar = false
        becomeFirstResponder()
        commentBar.inputTextView.resignFirstResponder()
    }
    
    
    @IBAction func logOutButton(_ sender: Any)
    {
        PFUser.logOut()
        //self.dismiss(animated: true, completion: nil)
        let main = UIStoryboard(name: "Main", bundle: nil)
        let loginViewController = main.instantiateViewController(withIdentifier: "LoginViewController")
        
        let delegate = UIApplication.shared.delegate as! AppDelegate
        delegate.window?.rootViewController = loginViewController
    }
    
    
}

