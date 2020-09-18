//
//  SafeActionsCollectionViewCell.swift
//  M.M.Fayik-COBSCCOMP191P-035
//
//  Created by Fayik Muzammil on 9/16/20.
//  Copyright © 2020 Fayik Muzammil. All rights reserved.
//

import UIKit

protocol SafeActionsCollectionViewCellDelegate: class {
    func didChooseAnswer(btnIndex: Int)
}

class SafeActionsCollectionViewCell: UICollectionViewCell {
    
    var btn1: UIButton!
    var btn2: UIButton!
    // var btnsArray = [UIButton]()
    
    weak var delegate: SafeActionsCollectionViewCellDelegate?
    
    var question: safeAction? {
        didSet {
            guard let unwrappedQue = question else { return }
            imgView.image = UIImage(named: unwrappedQue.imgName)
            lblQue.text = unwrappedQue.headerText
            lblDes.text = unwrappedQue.description
            
            
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupViews()
        // btnsArray = [btn1, btn2]
    }

    func setupViews() {
        addSubview(imgView)
        //        imgView.topAnchor.constraint(equalTo: self.topAnchor, constant: 50).isActive=true
        //        imgView.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive=true
        //        imgView.widthAnchor.constraint(equalToConstant: 150).isActive=true
        //        imgView.heightAnchor.constraint(equalTo: imgView.widthAnchor).isActive=true
        imgView.anchor(top: self.safeAreaLayoutGuide.topAnchor,paddingTop: 80, width: 150, height: 150)
        imgView.centerX(inView: self)
        
        addSubview(lblQue)
        //        lblQue.topAnchor.constraint(equalTo: imgView.bottomAnchor).isActive=true
        //        lblQue.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 12).isActive=true
        //        lblQue.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -12).isActive=true
        //        lblQue.heightAnchor.constraint(equalToConstant: 150).isActive=true
        
        lblQue.anchor(top: imgView.bottomAnchor, left: self.leftAnchor, right: self.rightAnchor, paddingTop: 20, paddingLeft: 12, paddingRight: 12,height: 50)
        
        addSubview(lblDes)
        //        lblDes.topAnchor.constraint(equalTo: lblQue.bottomAnchor,constant:5).isActive=true
        //        lblDes.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 12).isActive=true
        //        lblDes.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -12).isActive=true
        // lblDes.heightAnchor.constraint(equalToConstant: 150).isActive=true
        lblDes.anchor(top: lblQue.bottomAnchor, left: self.leftAnchor, right: self.rightAnchor, paddingTop: 20, paddingLeft: 12,  paddingRight: 12,height: 150)
        
    }
    
    let imgView: UIImageView = {
        let v=UIImageView()
        v.image = #imageLiteral(resourceName: "bell")
        v.contentMode = .scaleAspectFit
        v.translatesAutoresizingMaskIntoConstraints=false
        return v
    }()
    
    let lblQue: UILabel = {
        let lbl=UILabel()
        lbl.text="This is a question and you have to answer it?"
        lbl.textColor=UIColor.black
        lbl.textAlignment = .center
        lbl.font = UIFont.systemFont(ofSize: 26)
        lbl.numberOfLines=4
        lbl.translatesAutoresizingMaskIntoConstraints=false
        return lbl
    }()
    
    let lblDes: UILabel = {
        let lbl=UILabel()
        lbl.text="This is a question and you have to answer it?"
        lbl.textColor=UIColor.black
        lbl.textAlignment = .center
        lbl.font = UIFont.systemFont(ofSize: 20)
        lbl.numberOfLines=4
        lbl.translatesAutoresizingMaskIntoConstraints=false
        return lbl
    }()
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


