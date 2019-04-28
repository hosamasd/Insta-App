//
//  CommentVC.swift
//  Insta App
//
//  Created by hosam on 4/28/19.
//  Copyright © 2019 hosam. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth
class CommentVC: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    var posts:PostModel?
    var commentArray:[CommentModel] = []
    
    fileprivate let cellId = "cellId"
    let textChat:UITextField = { 
     let tx =    UITextField()
        tx.placeholder = "Enter your comment"
        return tx
    }()
    lazy var containerView:UIView = {
        let chatView = UIView()
        chatView.backgroundColor = .white
        chatView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 50)
        
        
        chatView.addSubview(textChat)
        textChat.anchor(top: chatView.topAnchor, leading: chatView.leadingAnchor, bottom: chatView.bottomAnchor, trailing: nil,padding: .init(top: 0, left: 8, bottom: 0, right: 0))
        
        var sendButton = UIButton()
        sendButton.setTitle("Send", for: .normal)
        sendButton.setTitleColor(.black, for: .normal)
        sendButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        sendButton.addTarget(self, action: #selector(handleSend), for: .touchUpInside)
        chatView.addSubview(sendButton)
        sendButton.anchor(top: chatView.topAnchor, leading: textChat.trailingAnchor, bottom: chatView.bottomAnchor, trailing: chatView.trailingAnchor,padding: .init(top: 0, left: 0, bottom: 0, right: 8),size: .init(width: 50, height: 0))
        
        let lineSeparatorView = UIView()
        lineSeparatorView.backgroundColor = UIColor(r: 230, g: 230, b: 230)
        chatView.addSubview(lineSeparatorView)
        lineSeparatorView.anchor(top: chatView.topAnchor, leading: chatView.leadingAnchor ,bottom: nil, trailing: chatView.trailingAnchor,padding: .init(top: 0, left: 0, bottom: 0, right: 0),size: .init(width: 0, height: 0.5))
        
        return chatView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Comments"
        collectionView.backgroundColor = .white
        collectionView?.alwaysBounceVertical = true
        collectionView?.keyboardDismissMode = .interactive
        collectionView.contentInset = UIEdgeInsets(top: 10, left: 0, bottom: -50, right: 0)
        collectionView.scrollIndicatorInsets = UIEdgeInsets(top: 0, left: 0, bottom: -50, right: 0)
        collectionView.register(CommentCell.self, forCellWithReuseIdentifier: cellId)
        
        fetchComments()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = true

    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        tabBarController?.tabBar.isHidden = false
    }
    
    override var inputAccessoryView: UIView?{
        get {
            return containerView
        }
    }
    override var canBecomeFirstResponder: Bool{
        return true
    }
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return commentArray.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! CommentCell
        let comment = commentArray[indexPath.item]
        
        cell.comments = comment
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 50)
        let dummyCell = CommentCell(frame: frame)
        dummyCell.comments = self.commentArray[indexPath.item]
        dummyCell.layoutIfNeeded()
        
        let targetSize = CGSize(width: view.frame.width, height: 1000)
        let estimatedSize = dummyCell.systemLayoutSizeFitting(targetSize)
        
        let height = max(40 + 8 + 8, estimatedSize.height)
        return .init(width: view.frame.width, height: height)
    }
    
    
    @objc func handleSend(){
       guard let text = textChat.text else { return  }
        guard let uids = Auth.auth().currentUser?.uid else { return  }
        let ids = posts?.id ?? ""
        
        let values:[String : Any] = ["text": text,"postId":ids,"uid":uids,"creationDate":Date().timeIntervalSince1970]
        
        Database.database().reference(withPath: "Comments").child(uids).childByAutoId().updateChildValues(values) { (err, ref) in
            if err == nil {
                print("sent")
            }
        }
        
       textChat.text = ""
    }
    
    func fetchComments()  {
        guard let post = posts?.id else { return  }
        guard let uid = Auth.auth().currentUser?.uid else { return  }
        Database.database().reference(withPath: "Comments").child(uid).observe(.childAdded) { (snapshot) in
            guard let dict = snapshot.value as?[String:Any] else {return}
              guard let uid = dict["uid"] as? String  else {return}
            
            Database.database().loadUserInfo(uid: uid, completion: { (user) in
                let comment = CommentModel(user: user, dict: dict)
                self.commentArray.append(comment)
                DispatchQueue.main.async {
                    self.collectionView.reloadData()
                }
            })
            
         }
    }
}
