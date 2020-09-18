//
//  LocationInputView.swift
//  M.M.Fayik-COBSCCOMP191P-035
//
//  Created by Fayik Muzammil on 8/26/20.
//  Copyright © 2020 Fayik Muzammil. All rights reserved.
//


import UIKit

protocol LocationInputViewDelegate {
    func dismissLocationInputView()
    func executeSearch(query: String)
}

class LocationInputView: UIView {

    // MARK: - Properties
    
    var delegate: LocationInputViewDelegate?

    private let backButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "baseline_arrow_back_black_36dp").withRenderingMode(.alwaysOriginal), for: .normal)
        button.addTarget(self, action: #selector(handleBackTapped), for: .touchUpInside)
        return button
    }()
    
    private var titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .darkGray
        label.text = "Search Places"
        label.font = UIFont.systemFont(ofSize: 16)
        return label
    }()
    
    
    lazy var destinationTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Search the location.."
        tf.backgroundColor = UIColor.rgb(red: 215, green: 215, blue: 215)
        tf.returnKeyType = .search
        tf.font = UIFont.systemFont(ofSize: 14)
        let paddingView = UIView()
        paddingView.setDimensions(height: 30, width: 8)
        tf.leftView = paddingView
        tf.leftViewMode = .always
        tf.delegate = self
        tf.clearButtonMode = .whileEditing
        return tf
    }()
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureViewComponents()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Selectors
    
    @objc func handleBackTapped() {
        delegate?.dismissLocationInputView()
    }
    
    // MARK: - Helper Functions
    
    func configureViewComponents() {
        backgroundColor = .white
        addShadow()
        
        addSubview(backButton)
        backButton.anchor(top: topAnchor, left: leftAnchor, paddingTop: 44,
                          paddingLeft: 12, width: 24, height: 24)
        
        addSubview(titleLabel)
        titleLabel.centerY(inView: backButton)
        titleLabel.centerX(inView: self)
        
        addSubview(destinationTextField)
        destinationTextField.anchor(top: titleLabel.bottomAnchor, left: leftAnchor,
                                    right: rightAnchor, paddingTop: 12, paddingLeft: 40,
                                    paddingRight: 40,height: 30)
    }
}

extension LocationInputView: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        guard let query = textField.text else { return false }
        delegate?.executeSearch(query: query)
        return true
    }
}
