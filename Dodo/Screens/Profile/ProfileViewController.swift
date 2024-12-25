//
//  ProfileViewController.swift
//  Dodo
//
//  Created by Rishat Zakirov on 11.12.2024.
//

import UIKit
class ProfileViewController: UIViewController {
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
        setupConstraints()
    }
    
    
    lazy var tableView: UITableView = {
        let table = UITableView()
        table.delegate = self
        table.dataSource = self
        table.registerCell(PersonalDataContainerCell.self)
        table.registerCell(PersonalOffersContainerCell.self)
        table.registerCell(MissionsContainerCell.self)
        return table
    }()
    
    let closeButton: UIButton = {
        let button = UIButton(type: .system)
        let configuration = UIImage.SymbolConfiguration(pointSize: 20)
        button.setImage(UIImage(systemName: "xmark", withConfiguration: configuration), for: .normal)
        button.tintColor = .black
        button.heightAnchor.constraint(equalToConstant: 50).isActive = true
        button.widthAnchor.constraint(equalToConstant: 50).isActive = true
        button.layer.cornerRadius = 25
        button.backgroundColor = .white
        button.setTitleColor(.black, for: .normal)
        
        button.addTarget(nil, action: #selector(closeButtonTapped), for: .touchUpInside)
        return button
    }()
    
    @objc func closeButtonTapped() {
        self.dismiss(animated: true)
    }
}


//MARK: Layout
extension ProfileViewController {
    func setupViews() {
        view.backgroundColor = .white
        view.addSubview(closeButton)
        view.addSubview(tableView)
    }
    
    func setupConstraints() {
        closeButton.snp.makeConstraints { make in
            make.top.equalTo(view).inset(5)
            make.left.equalTo(view).inset(5)
        }
        
        tableView.snp.makeConstraints { make in
            make.top.equalTo(closeButton.snp.bottom).offset(10)
            make.left.right.bottom.equalTo(view)
        }

    }
}


extension ProfileViewController: UITableViewDelegate, UITableViewDataSource {
    enum ProfileSections: Int, CaseIterable {
        case personalData
        case personalOffers
        case missions
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ProfileSections.allCases.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let sectionType = ProfileSections(rawValue: indexPath.row) {
            switch sectionType {
            case .personalData:
                let cell = tableView.dequeueReusableCell(withIdentifier: PersonalDataContainerCell.reuseId) as! PersonalDataContainerCell
                return cell
            case .personalOffers:
                let cell = tableView.dequeueReusableCell(withIdentifier: PersonalOffersContainerCell.reuseId) as! PersonalOffersContainerCell
                return cell
            case .missions:
                let cell = tableView.dequeueReusableCell(withIdentifier: MissionsContainerCell.reuseId) as! MissionsContainerCell
                return cell
            }
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if let sectionType = ProfileSections(rawValue: indexPath.row) {
            switch sectionType {
            case .personalData:
                return 250
            case .personalOffers:
                return 250
            case .missions:
                return 400
            }
            
        }
        return 300
    }
    
    
}
