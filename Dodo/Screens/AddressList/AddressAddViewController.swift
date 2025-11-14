//
//  AddressAddViewController.swift
//  Dodo
//
//  Created by Rishat Zakirov on 04.11.2024.
//

import UIKit
class AddressAddViewController: UIViewController {
    let addressStorage = AddressStorage()
    var info = ""
    
    var countryButton: UIButton = {
        let button = UIButton()
        button.setTitle("🇷🇺 Россия", for: .normal)
        button.backgroundColor = UIColor(cgColor: CGColor(red: 242/255, green: 243/255, blue: 248/255, alpha: 1))
        button.setTitleColor(.black, for: .normal)
        button.layer.cornerRadius = 15
        button.contentHorizontalAlignment = .center
        return button
    }()
    
    var addressListButton: UIButton = {
        let button = UIButton()
        button.setTitle("Мои адреса", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.backgroundColor = UIColor(cgColor: CGColor(red: 242/255, green: 243/255, blue: 248/255, alpha: 1))
        button.layer.cornerRadius = 15
        button.contentHorizontalAlignment = .center
        
        button.addTarget(nil, action: #selector(navigateToAddressList), for: .touchUpInside)
        return button
    }()
    
    var addressTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Ваш адрес"
        textField.layer.sublayerTransform = CATransform3DMakeTranslation(12, 0, 0);
        textField.heightAnchor.constraint(equalToConstant: 24).isActive = true
        textField.layer.borderColor = CGColor(red: 214/255, green: 213/255, blue: 219/255, alpha: 1)
        textField.layer.borderWidth = 2
        textField.layer.cornerRadius = 13
        return textField
    }()
    
    var placeNameTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Название места"
        textField.layer.sublayerTransform = CATransform3DMakeTranslation(12, 0, 0);
        textField.heightAnchor.constraint(equalToConstant: 24).isActive = true
        textField.layer.borderColor = CGColor(red: 214/255, green: 213/255, blue: 219/255, alpha: 1)
        textField.layer.borderWidth = 2
        textField.layer.cornerRadius = 13
        return textField
    }()
    
    var enterTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Подъезд"
        textField.layer.sublayerTransform = CATransform3DMakeTranslation(12, 0, 0);
        textField.heightAnchor.constraint(equalToConstant: 24).isActive = true
        textField.layer.borderColor = CGColor(red: 214/255, green: 213/255, blue: 219/255, alpha: 1)
        textField.layer.borderWidth = 2
        textField.layer.cornerRadius = 13
        return textField
    }()
    
    var codeTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Код на двери"
        textField.layer.sublayerTransform = CATransform3DMakeTranslation(12, 0, 0);
        textField.heightAnchor.constraint(equalToConstant: 24).isActive = true
        textField.layer.borderColor = CGColor(red: 214/255, green: 213/255, blue: 219/255, alpha: 1)
        textField.layer.borderWidth = 2
        textField.layer.cornerRadius = 13
        return textField
    }()
    
    var floorTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Этаж"
        textField.layer.sublayerTransform = CATransform3DMakeTranslation(12, 0, 0);
        textField.heightAnchor.constraint(equalToConstant: 24).isActive = true
        textField.layer.borderColor = CGColor(red: 214/255, green: 213/255, blue: 219/255, alpha: 1)
        textField.layer.borderWidth = 2
        textField.layer.cornerRadius = 13
        return textField
    }()
    
    var numberOfFlatTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Квартира"
        textField.layer.sublayerTransform = CATransform3DMakeTranslation(12, 0, 0);
        textField.heightAnchor.constraint(equalToConstant: 24).isActive = true
        textField.layer.borderColor = CGColor(red: 214/255, green: 213/255, blue: 219/255, alpha: 1)
        textField.layer.borderWidth = 2
        textField.layer.cornerRadius = 13
        return textField
    }()
    
    var commentaryTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Комментарий к адресу"
        textField.layer.sublayerTransform = CATransform3DMakeTranslation(12, 0, 0);
        textField.heightAnchor.constraint(equalToConstant: 24).isActive = true
        textField.layer.borderColor = CGColor(red: 214/255, green: 213/255, blue: 219/255, alpha: 1)
        textField.layer.borderWidth = 2
        textField.layer.cornerRadius = 13
        return textField
    }()

    
    let saveButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Сохранить", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .orange
        button.layer.cornerRadius = 15
        button.addTarget(nil, action: #selector(saveButtonTapped), for: .touchUpInside)
        button.heightAnchor.constraint(equalToConstant: 45).isActive = true
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupConstraints()

    }
    
    @objc func saveButtonTapped() {
        info = addressTextField.text!
        let infArr = info.components(separatedBy: " ")
        print(infArr)
        let adress = Address(city: infArr[0], street: infArr[1], numberOfBuilding: infArr[2], numberOfFlat: 0, floor: 0, enter: 0, code: " ", commentary: " ", isSelected: true)
        addressStorage.append(adress)

        print(addressStorage.fetch())

    }
    
    @objc func navigateToAddressList() {
        let addressController = AddressListViewController()
        if let presentationController = addressController.presentationController as? UISheetPresentationController {
            presentationController.detents = [.medium()]
        }
        
        present(addressController, animated: true)
    }
}

extension AddressAddViewController {
    func setupViews() {
        view.backgroundColor = .systemBackground
        view.addSubview(addressTextField)
        view.addSubview(placeNameTextField)
        view.addSubview(enterTextField)
        view.addSubview(codeTextField)
        view.addSubview(floorTextField)
        view.addSubview(numberOfFlatTextField)
        view.addSubview(commentaryTextField)
        view.addSubview(countryButton)
        view.addSubview(addressListButton)
        view.addSubview(saveButton)
    }
    func setupConstraints() {
        countryButton.snp.makeConstraints { make in
            make.left.equalTo(view).offset(25)
            make.top.equalTo(view).offset(10)
            make.right.equalTo(view.snp.left).offset(130)
        }
        
        addressListButton.snp.makeConstraints { make in
            make.right.equalTo(view).inset(25)
            make.top.equalTo(view).offset(10)
            make.left.equalTo(view.snp.right).inset(130)
        }
        
        addressTextField.snp.makeConstraints { make in
            make.height.equalTo(100)
            make.left.right.equalTo(view).inset(25)
            make.top.equalTo(view).offset(50)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.top).offset(100)
            
        }
        
        placeNameTextField.snp.makeConstraints { make in
            make.top.equalTo(addressTextField.snp.bottom).offset(10)
            make.bottom.equalTo(addressTextField).offset(60)
            make.left.right.equalTo(view).inset(25)
        }
        
        enterTextField.snp.makeConstraints { make in
            make.top.equalTo(placeNameTextField.snp.bottom).offset(10)
            make.bottom.equalTo(placeNameTextField).offset(60)
            make.left.equalTo(view).inset(25)
            make.right.equalTo(view.snp.left).offset(190)
        }
        
        codeTextField.snp.makeConstraints { make in
            make.top.equalTo(placeNameTextField.snp.bottom).offset(10)
            make.bottom.equalTo(placeNameTextField).offset(60)
            make.right.equalTo(view).inset(25)
            make.left.equalTo(view.snp.right).inset(190)
        }
        
        floorTextField.snp.makeConstraints { make in
            make.top.equalTo(enterTextField.snp.bottom).offset(10)
            make.bottom.equalTo(enterTextField).offset(60)
            make.left.equalTo(view).inset(25)
            make.right.equalTo(view.snp.left).offset(190)
        }
        
        numberOfFlatTextField.snp.makeConstraints { make in
            make.top.equalTo(codeTextField.snp.bottom).offset(10)
            make.bottom.equalTo(codeTextField).offset(60)
            make.right.equalTo(view).inset(25)
            make.left.equalTo(view.snp.right).inset(190)
        }
        
        commentaryTextField.snp.makeConstraints { make in
            make.top.equalTo(numberOfFlatTextField.snp.bottom).offset(10)
            make.bottom.equalTo(numberOfFlatTextField).offset(60)
            make.left.right.equalTo(view).inset(25)
        }
        
        saveButton.snp.makeConstraints { make in
            make.left.right.equalTo(view).inset(25)
            make.top.equalTo(commentaryTextField.snp.bottom).offset(10)
        }
    }
}
