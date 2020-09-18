//
//  SurveyCollectionViewCell.swift
//  M.M.Fayik-COBSCCOMP191P-035
//
//  Created by Fayik Muzammil on 9/1/20.
//  Copyright © 2020 Fayik Muzammil. All rights reserved.
//

import UIKit

protocol SurveyCollectionViewCellDelegate: class {
    func didChooseAnswer(btnIndex: Int)
}

class SurveyCollectionViewCell: UICollectionViewCell {
    
    var btn1: UIButton!
    var btn2: UIButton!
    
    var btnStack: UIStackView!
    var btnsArray = [UIButton]()
    
    weak var delegate: SurveyCollectionViewCellDelegate?
    
    var question: Question? {
        didSet {
            guard let unwrappedQue = question else { return }
            //   imgView.image = UIImage(named: unwrappedQue.imgName)
            lblQue.text = unwrappedQue.questionText
            btn1.setTitle(unwrappedQue.options[0], for: .normal)
            btn2.setTitle(unwrappedQue.options[1], for: .normal)
            
            if unwrappedQue.isAnswered {
                btnsArray[unwrappedQue.correctAns].backgroundColor=UIColor.red
                if unwrappedQue.wrongAns >= 0 {
                btnsArray[unwrappedQue.wrongAns].backgroundColor=UIColor.white
                }
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupViews()
        btnsArray = [btn1, btn2]
    }
    
    @objc func btnOptionAction(sender: UIButton) {
        guard let unwrappedQue = question else { return }
        if !unwrappedQue.isAnswered {
            delegate?.didChooseAnswer(btnIndex: sender.tag)
        }
    }
    
    override func prepareForReuse() {
        btn1.backgroundColor=UIColor.white
        btn2.backgroundColor=UIColor.white
        //        btn3.backgroundColor=UIColor.white
        //        btn4.backgroundColor=UIColor.white
    }
    
    func setupViews() {
        //        addSubview(imgView)
        //        imgView.topAnchor.constraint(equalTo: self.topAnchor, constant: 50).isActive=true
        //        imgView.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive=true
        //        imgView.widthAnchor.constraint(equalToConstant: 150).isActive=true
        //        imgView.heightAnchor.constraint(equalTo: imgView.widthAnchor).isActive=true
        //
        addSubview(lblQue)
        //  lblQue.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor).isActive=true
        //        lblQue.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 12).isActive=true
        //        lblQue.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -12).isActive=true
        //        lblQue.heightAnchor.constraint(equalToConstant: 150).isActive=true
        
        lblQue.anchor(top:self.safeAreaLayoutGuide.topAnchor,   paddingTop: 200)
        lblQue.centerX(inView: self)
        
        btn1 = getButton(tag: 0)
        btn1.addTarget(self, action: #selector(btnOptionAction), for: .touchUpInside)
        
        btn2 = getButton(tag: 1)
        btn2.addTarget(self, action: #selector(btnOptionAction), for: .touchUpInside)
        
        
        btnStack = UIStackView(arrangedSubviews: [btn1,btn2])
        addSubview(btnStack)
        btnStack.axis = .horizontal
        
        
        btnStack.distribution = .fillEqually
        btnStack.spacing = 15
//        btnStack.anchor(top: lblQue.bottomAnchor,  paddingTop: 50,height: 50, width: 300)
//        btnStack.centerX(inView: self)
        btnStack.anchor(top: lblQue.bottomAnchor, paddingTop: 50, width: 300, height: 50)
        btnStack.centerX(inView: self)
    }
    
    func getButton(tag: Int) -> UIButton {
        let btn=UIButton()
        btn.tag=tag
        btn.setTitle("Option", for: .normal)
        btn.setTitleColor(UIColor.black, for: .normal)
        btn.backgroundColor=UIColor.white
        
        btn.layer.borderWidth=1
        btn.layer.borderColor=UIColor.darkGray.cgColor
        btn.layer.cornerRadius=5
        btn.clipsToBounds=true
        btn.translatesAutoresizingMaskIntoConstraints=false
        return btn
    }
    
    //    let imgView: UIImageView = {
    //        let v=UIImageView()
    //        v.image = #imageLiteral(resourceName: "img2")
    //        v.contentMode = .scaleAspectFit
    //        v.translatesAutoresizingMaskIntoConstraints=false
    //        return v
    //    }()
    
    let lblQue: UILabel = {
        let lbl=UILabel()
        lbl.text="This is a question and you have to answer it?"
        lbl.textColor=UIColor.black
        lbl.textAlignment = .center
        lbl.font = UIFont.systemFont(ofSize: 18)
        lbl.lineBreakMode = .byWordWrapping
        lbl.numberOfLines = 6
        lbl.translatesAutoresizingMaskIntoConstraints=false
        return lbl
    }()
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


