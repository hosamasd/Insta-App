//
//  ContainerTextView.swift
//  Insta App
//
//  Created by hosam on 4/29/19.
//  Copyright © 2019 hosam. All rights reserved.
//

import UIKit

class ContainerTextView: UITextView {
   fileprivate let labels:UILabel = {
       let la = UILabel()
        la.text = "Enter Comment"
        la.textColor = .lightGray
        
        return la
    }()
    
    override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleChangeText), name: UITextView.textDidChangeNotification, object: nil)
        addSubview(labels)
        labels.anchor(top: topAnchor, leading: leadingAnchor, bottom: bottomAnchor, trailing: trailingAnchor,padding: .init(top: 8, left: 8, bottom: 0, right: 0))
    }
    
    func showLabel()  {
        labels.isHidden = false
    }
    @objc func handleChangeText(){
       labels.isHidden = !self.text.isEmpty
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
