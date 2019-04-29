//
//  CommentView.swift
//  Insta App
//
//  Created by hosam on 4/29/19.
//  Copyright © 2019 hosam. All rights reserved.
//

import UIKit

protocol CommentViewDelgate {
    func didWriteComment(for comment:String)
}

class CommentView: UIView {
    var delgate:CommentViewDelgate?
    
   lazy var sendButton: UIButton =  {
        let se = UIButton()
        se.setTitle("Send", for: .normal)
        se.setTitleColor(.black, for: .normal)
        se.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        se.addTarget(self, action: #selector(handleSend), for: .touchUpInside)
        return se
    }()
    let textChat:ContainerTextView = {
        let tx =    ContainerTextView()
        tx.isScrollEnabled = false
        tx.font = UIFont.systemFont(ofSize: 18)
        return tx
    }()
    let lineSeparatorView: UIView = {
        let vi = UIView()
        vi.backgroundColor = UIColor(r: 230, g: 230, b: 230)
        return vi
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        
//        backgroundColor = .red
        
        autoresizingMask = .flexibleHeight
        addSubview(textChat)
        addSubview(sendButton)
        addSubview(lineSeparatorView)
        
         sendButton.anchor(top: topAnchor, leading: nil, bottom: nil, trailing: trailingAnchor,padding: .init(top: 0, left: 0, bottom: 0, right: 8),size: .init(width: 50, height: 50))
        textChat.anchor(top: topAnchor, leading: leadingAnchor, bottom: safeAreaLayoutGuide.bottomAnchor, trailing: sendButton.leadingAnchor,padding: .init(top: 8, left: 8, bottom: 8, right: 8))

       
        
        lineSeparatorView.anchor(top: topAnchor, leading: leadingAnchor ,bottom: nil, trailing: trailingAnchor,padding: .init(top: 0, left: 0, bottom: 0, right: 0),size: .init(width: 0, height: 0.5))
    }
    
    override var intrinsicContentSize: CGSize{
        return .zero
    }
    
    func clearText()  {
        textChat.text = nil
        self.textChat.showLabel()
    }
    
    @objc func handleSend(){
        guard let comment = textChat.text else { return  }
        delgate?.didWriteComment(for: comment)
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
