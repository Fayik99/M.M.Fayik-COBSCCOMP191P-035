//
//  SafeActionsViewController.swift
//  M.M.Fayik-COBSCCOMP191P-035
//
//  Created by Fayik Muzammil on 9/16/20.
//  Copyright © 2020 Fayik Muzammil. All rights reserved.
//

import UIKit

struct safeAction {
    let imgName: String
    let headerText: String
    let description: String
}

class SafeActionsViewController:UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    var myCollectionView: UICollectionView!
    var questionsArray = [safeAction]()
    var score: Int = 0
    var currentQuestionNumber = 1
    
    var window: UIWindow?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title="Safe Actions"
        self.view.backgroundColor = UIColor.white
        
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        layout.itemSize = CGSize(width: self.view.frame.width, height: self.view.frame.height)
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 1
        layout.minimumInteritemSpacing = 1
        
        myCollectionView=UICollectionView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height), collectionViewLayout: layout)
        myCollectionView.delegate=self
        myCollectionView.dataSource=self
        myCollectionView.register(SafeActionsCollectionViewCell.self, forCellWithReuseIdentifier: "Cell")
        myCollectionView.showsHorizontalScrollIndicator = false
        myCollectionView.translatesAutoresizingMaskIntoConstraints=false
        myCollectionView.backgroundColor=UIColor.white
        myCollectionView.isPagingEnabled = true
        
        self.view.addSubview(myCollectionView)
        
        let que1 = safeAction(imgName: "handwashing", headerText: "Wash your hands", description: "Please wash your hands before leaving and when entering the home")
        let que2 = safeAction(imgName: "avoidcrowd", headerText: "Avoid crowd", description: "Please avoid crowdwd places")
        let que3 = safeAction(imgName: "mask", headerText: "Wear facemask", description: "Wearing facemask will save yourself aswell as others from spreading diseases")
        let que4 = safeAction(imgName: "sanitizer", headerText: "Use hand sanitizer", description: "Sanitize your hand frequently")
        let que5 = safeAction(imgName: "socialdis", headerText: "Maintain social distance", description: "Maintain atleast 1 meter gap inbetween yourself and others when going out")
      
        questionsArray = [que1, que2, que3,que4,que5]
        
        setupViews()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return questionsArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell=collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! SafeActionsCollectionViewCell
        cell.question=questionsArray[indexPath.row]
        cell.delegate=self
        return cell
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
    //   setQuestionNumber()
    }
    
//    @objc func navToHome(){
//        let vc = TabBarViewController()
//        vc.modalPresentationStyle = .fullScreen
//        present(vc, animated: true, completion: {
//        })
//
//    }
//
//    @objc func popAlert(){
//        let alert = UIAlertController(title: "Safe Actions", message: "No more actions, please go back to Home", preferredStyle: .alert)
//        alert.addAction(UIAlertAction(title: "Okay", style: .default, handler: {action in  self.navToHome()}))
//        self.present(alert, animated: true)
//    }
    
    @objc func btnPrevNextAction(sender: UIButton) {
        if sender == btnNext && currentQuestionNumber == questionsArray.count {
          //popAlert()
            return
        }
        
        let collectionBounds = self.myCollectionView.bounds
        var contentOffset: CGFloat = 0
        if sender == btnNext {
            contentOffset = CGFloat(floor(self.myCollectionView.contentOffset.x + collectionBounds.size.width))
           currentQuestionNumber += currentQuestionNumber >= questionsArray.count ? 0 : 1
        } else {
            contentOffset = CGFloat(floor(self.myCollectionView.contentOffset.x - collectionBounds.size.width))
        currentQuestionNumber -= currentQuestionNumber <= 0 ? 0 : 1
        }
        self.moveToFrame(contentOffset: contentOffset)
      // lblQueNumber.text = "Question: \(currentQuestionNumber) / \(questionsArray.count)"
    }
    
    func moveToFrame(contentOffset : CGFloat) {
        let frame: CGRect = CGRect(x : contentOffset ,y : self.myCollectionView.contentOffset.y ,width : self.myCollectionView.frame.width,height : self.myCollectionView.frame.height)
        self.myCollectionView.scrollRectToVisible(frame, animated: true)
    }
    
    func setupViews() {
        //        myCollectionView.topAnchor.constraint(equalTo: self.view.topAnchor).isActive=true
        //        myCollectionView.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive=true
        //        myCollectionView.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive=true
        //        myCollectionView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive=true
        
        myCollectionView.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, right: view.rightAnchor, paddingTop: 35)
        
        view.addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0).isActive = true
        
        self.view.addSubview(btnPrev)
        btnPrev.heightAnchor.constraint(equalToConstant: 50).isActive=true
        btnPrev.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 0.5).isActive=true
        btnPrev.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive=true
        btnPrev.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: 0).isActive=true
        
        self.view.addSubview(btnNext)
        btnNext.heightAnchor.constraint(equalTo: btnPrev.heightAnchor).isActive=true
        btnNext.widthAnchor.constraint(equalTo: btnPrev.widthAnchor).isActive=true
        btnNext.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive=true
        btnNext.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: 0).isActive=true
        
        self.view.addSubview(BackButton)
        BackButton.anchor(top: view.safeAreaLayoutGuide.topAnchor,left: view.leftAnchor, paddingTop: 5, paddingLeft: 12, width: 30, height: 25)
        
        //        self.view.addSubview(lblQueNumber)
        //        lblQueNumber.heightAnchor.constraint(equalToConstant: 20).isActive=true
        //        lblQueNumber.widthAnchor.constraint(equalToConstant: 150).isActive=true
        //        lblQueNumber.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 20).isActive=true
        //        lblQueNumber.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -80).isActive=true
        //        lblQueNumber.text = "Question: \(1) / \(questionsArray.count)"
    }
    
    let btnPrev: UIButton = {
        let btn=UIButton()
        btn.setTitle("< Previous", for: .normal)
        btn.setTitleColor(UIColor.white, for: .normal)
        btn.backgroundColor=UIColor.black
        btn.translatesAutoresizingMaskIntoConstraints=false
        btn.addTarget(self, action: #selector(btnPrevNextAction), for: .touchUpInside)
        return btn
    }()
    
    let btnNext: UIButton = {
        let btn=UIButton()
        btn.setTitle("Next >", for: .normal)
        btn.setTitleColor(UIColor.white, for: .normal)
        btn.backgroundColor=UIColor.purple
        btn.translatesAutoresizingMaskIntoConstraints=false
        
        btn.addTarget(self, action: #selector(btnPrevNextAction), for: .touchUpInside)
        return btn
    }()
    
    private let BackButton: UIButton = {
        let button = UIButton()
        // button.setTitle("Back", for: .normal)
        button.setBackgroundImage(#imageLiteral(resourceName: "baseline_arrow_back_black_36dp"), for: .normal)
        button.addTarget(self, action: #selector(showHomeDaseController), for: UIControl.Event.touchUpInside)
        
        return button
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Safe Actions"
        //label.font = UIFont(name: "Avenir-Light", size: 30)
        label.font = UIFont(name:"HelveticaNeue-Bold", size: 27)
        label.textColor = UIColor.black
        
        return label
    }()
}

extension SafeActionsViewController: SafeActionsCollectionViewCellDelegate {
    func didChooseAnswer(btnIndex: Int) {
//        let centerIndex = getCenterIndex()
//        guard let index = centerIndex else { return }
//        questionsArray[index.item].isAnswered=true
//        if questionsArray[index.item].correctAns != btnIndex {
//            questionsArray[index.item].wrongAns = btnIndex
//            score -= 1
//        } else {
//            score += 1
//        }
//        lblScore.text = "Score: \(score) / \(questionsArray.count)"
//        myCollectionView.reloadItems(at: [index])
    }
    
    func getCenterIndex() -> IndexPath? {
        let center = self.view.convert(self.myCollectionView.center, to: self.myCollectionView)
        let index = myCollectionView!.indexPathForItem(at: center)
        print(index ?? "index not found")
        return index
    }
    
    @objc func showHomeDaseController() {
           let back = TabBarViewController()
           back.modalPresentationStyle = .fullScreen
           present(back, animated: true, completion: {
               // Back to home
           })
       }
}





