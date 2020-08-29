//
//  LocationinputActivation.swift
//  M.M.Fayik-COBSCCOMP191P-035
//
//  Created by Fayik Muzammil on 8/26/20.
//  Copyright © 2020 Fayik Muzammil. All rights reserved.
//


import UIKit

protocol LocationInputActivationDelegate: class {
    func presentLocationInputView()
}

class LocationInputActivation: UIView {

   // MARK: - Properties
    
    weak var delegate: LocationInputActivationDelegate?
    
    private let indicatorView: UIView = {
        let view = UIView()
        view.backgroundColor = .black
        
        return view
    }()
    
    private let placeholderLable: UILabel = {
        let label = UILabel()
        label.text = "Search ?"
        label.font = UIFont.systemFont(ofSize: 18)
        label.textColor = .darkGray
        
        return label
    }()
    
   // MARK: - LifeCycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .white
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.45
        layer.shadowOffset = CGSize(width: 0.5, height: 0.5)
        layer.masksToBounds = false
        
        addSubview(indicatorView)
        indicatorView.centerY(inView: self, leftAnchor: leftAnchor, paddingLeft: 16)
        indicatorView.setDimensions(height: 6, width: 6)
        
        addSubview(placeholderLable)
        placeholderLable.centerY(inView: self, leftAnchor: indicatorView.rightAnchor, paddingLeft: 20)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(presentLocationInputView))
        addGestureRecognizer(tap)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Selectors
    
    @objc func presentLocationInputView() {
        delegate?.presentLocationInputView()
    }
    
}
