//
//  AddressPanelView.swift
//  Dodo
//
//  Created by Rishat Zakirov on 02.11.2024.
//

import UIKit
import SnapKit

class AddressPanelView: UIView {
    var onButtonTapped: ((String) -> ())?
    var onAddressChanged: ((String) -> Void)?
    var onAddressButtonTapped: (()->())?
    
    var onSaveButtonTapped: (()->())?
    
    var timer: Timer?
    var delayValue: Double = 2.0
    
    let addressView = AddressView()
    let saveButton = SaveButton()
    
    private let stackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.distribution = .fill
        
        stack.directionalLayoutMargins = NSDirectionalEdgeInsets(top: 8, leading: 8, bottom: 8, trailing: 8)
        stack.isLayoutMarginsRelativeArrangement = true
        return stack
    }()
    
    let addAddressButton: UIButton = {
        let button = UIButton(type: .system)
        
        button.setTitle("+ Добавить Адрес", for: .normal)
        button.backgroundColor = .lightGray.withAlphaComponent(0.5)
        button.setTitleColor(.black, for: .normal)
        button.layer.cornerRadius = 16
        button.contentEdgeInsets = UIEdgeInsets(top: 4, left: 16, bottom: 4, right: 16)
        button.addTarget(nil, action: #selector(addAddressButtonTapped), for: .touchUpInside)
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        setupConstraints()
        
        
        setupObservers()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func update(addressText: String) {
        addressView.addressTextField.text = addressText
    }
    
    func setupObservers() {
        saveButton.addTarget(nil, action: #selector(saveButtonTapped), for: .touchUpInside)
        
        addressView.addressTextField.addTarget(nil, action: #selector(addressTextFieldChanged(_:)), for: .editingChanged)
    }
    
    @objc func addAddressButtonTapped() {
        if let addressText = addressView.addressTextField.text {
            onButtonTapped?(addressText)
        }
        onAddressButtonTapped?()
       
    }
    
    @objc func saveButtonTapped() {
        onSaveButtonTapped?()
    }
    
}


extension AddressPanelView {
    @objc func addressTextFieldChanged(_ sender: UITextField) {
        timer?.invalidate()
        
        timer = Timer.scheduledTimer(timeInterval: delayValue, target: self, selector: #selector(timerAction), userInfo: nil, repeats: false)
    }
    
    @objc func timerAction() {
        if let addressText = addressView.addressTextField.text {
            onAddressChanged?(addressText)
        }
    }
}

extension AddressPanelView {
    func setupViews() {
        backgroundColor = .systemBackground
        self.addSubview(addAddressButton)
        self.addSubview(stackView)
        stackView.addArrangedSubview(addressView)
        stackView.addArrangedSubview(saveButton)
    }
    
    func setupConstraints() {
        addAddressButton.snp.makeConstraints { make in
            make.right.top.equalTo(self).inset(8)
        }
        stackView.snp.makeConstraints { make in
            make.top.equalTo(addAddressButton.snp.bottom).offset(8)
            make.left.right.bottom.equalTo(self)
        }
    }
}
