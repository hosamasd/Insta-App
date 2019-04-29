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
    lazy var containerView:CommentView = {
        let frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 50)
        let chatView = CommentView(frame: frame)
        chatView.delgate = self
        return chatView
    }()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Comments"
        setupCollectionView()
        
        fetchComments()
    }
    
    //MARK: - override methods
    
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
    
    //MARK: -  collectionView data source
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return commentArray.count
    }
    
    
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! CommentCell
        let comment = commentArray[indexPath.item]
        
        cell.comments = comment
        return cell
    }
    
    //MARK: -  collectionViewLayoutdelgate
    
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
    
    //MARK: -  user methods
    
    fileprivate func setupCollectionView() {
        collectionView.backgroundColor = .white
        collectionView?.alwaysBounceVertical = true
        collectionView?.keyboardDismissMode = .onDrag
        collectionView.contentInset = UIEdgeInsets(top: 10, left: 0, bottom: -50, right: 0)
        collectionView.scrollIndicatorInsets = UIEdgeInsets(top: 0, left: 0, bottom: -50, right: 0)
        collectionView.register(CommentCell.self, forCellWithReuseIdentifier: cellId)
    }
    
    func fetchComments()  {
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

//MARK: - extensions

extension CommentVC: CommentViewDelgate {
    
    func didWriteComment(for comment: String) {
        guard let uids = Auth.auth().currentUser?.uid else { return  }
        let ids = posts?.id ?? ""
        
        let values:[String : Any] = ["text": comment,"postId":ids,"uid":uids,"creationDate":Date().timeIntervalSince1970]
        
        Database.database().reference(withPath: "Comments").child(uids).childByAutoId().updateChildValues(values) { (err, ref) in
            if err == nil {
                self.containerView.clearText()
            }
        }
        
    }
}
