//
//  FeatureToggle.swift
//  Dodo
//
//  Created by Rishat Zakirov on 09.01.2025.
//

import UIKit
class FeatureToggleViewController: UIViewController {
    
    let localFeatureToggles = LocalFeatureToggles()
    let remoteFeatureToggles = RemoteFeatureToggles()
    let featureToggleStorage = FeatureToggleStorage()
    var remoteFeatures:[Feature] = []
    var localFeatures:[Feature] = []
    
    lazy var featuresTableView: UITableView = {
        let table = UITableView()
        
        table.delegate = self
        table.dataSource = self
        
        table.register(FeatureToggleCell.self, forCellReuseIdentifier: FeatureToggleCell.reuseId)
        
        return table
    }()
    
    lazy var remoteFeaturesTableView: UITableView = {
        let table = UITableView()
        table.delegate = self
        table.dataSource = self
        
        table.register(FeatureToggleCell.self, forCellReuseIdentifier: FeatureToggleCell.reuseId)
        
        return table
    }()
    
    let startButton: UIButton = {
        let button = UIButton()
        button.setTitle("Start App", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.layer.cornerRadius = 20
        button.backgroundColor = .orange
        button.addTarget(nil, action: #selector(navigateToTabbar), for: .touchUpInside)
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        //fetchLocalFeauteres()
        //fetchRemoteFeatures()
        setupViews()
        setupConstraints()
        
        handleFeatureToggles()
    }
    
    func handleFeatureToggles() {
        let dispatchGroup = DispatchGroup()
        
        dispatchGroup.enter()
        fetchRemoteFeatures {
            dispatchGroup.leave()
        }
        
        dispatchGroup.enter()
        fetchLocalFeauteres {
            dispatchGroup.leave()
        }
        
        dispatchGroup.notify(queue: DispatchQueue.main) {
            
            self.featuresTableView.reloadData()
            self.remoteFeaturesTableView.reloadData()
        }
        
        //featureListView.reloadData()
    }
    
    func fetchLocalFeauteres(completion: @escaping () -> ()) {
        
        self.localFeatures = localFeatureToggles.load()
        completion()
        
    }
    
    func fetchRemoteFeatures(completion: @escaping ()->()) {
        remoteFeatureToggles.fetchJSON { features in
            self.remoteFeatures = features
            completion()
        }
    }


    
    @objc func navigateToTabbar() {
        let tabBarController = TabBarController()
        tabBarController.modalPresentationStyle = .fullScreen
        present(tabBarController, animated: true, completion: nil)
    }
    
}

extension FeatureToggleViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if tableView == self.featuresTableView {
            return localFeatures.count
        }
        if tableView == self.remoteFeaturesTableView {
            return remoteFeatures.count
        }
        
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == self.featuresTableView {
            guard let cell = featuresTableView.dequeueReusableCell(withIdentifier: FeatureToggleCell.reuseId, for: indexPath) as? FeatureToggleCell else {return UITableViewCell()}
            
            cell.update(feature: localFeatures[indexPath.row])
            
            cell.onSwitch = { feature in
                self.localFeatureToggles.update(feature)
                self.localFeatures = self.localFeatureToggles.fetch()
                self.featuresTableView.reloadData()
                
                //self.featureToggleStorage.update(indexPath.row)
                //print(self.featureToggleStorage.fetch())
            }
            
            return cell
        }
        
        if tableView == self.remoteFeaturesTableView {
            guard let cell = featuresTableView.dequeueReusableCell(withIdentifier: FeatureToggleCell.reuseId, for: indexPath) as? FeatureToggleCell else {return UITableViewCell()}
            
            
            let remoteFeature = remoteFeatures[indexPath.row]
            
            cell.update(feature: remoteFeature)
            
            return cell
        }
        
        return UITableViewCell()
    }
    
    
}

extension FeatureToggleViewController {
    func setupViews() {
        view.backgroundColor = .systemBackground
        view.addSubview(featuresTableView)
        view.addSubview(remoteFeaturesTableView)
        view.addSubview(startButton)
    }
    
    func setupConstraints() {
        startButton.snp.makeConstraints { make in
            make.top.equalTo(featuresTableView.snp.bottom)
            make.left.right.equalTo(view.safeAreaLayoutGuide).inset(10)
            make.bottom.equalTo(view.safeAreaLayoutGuide)
        }
        featuresTableView.snp.makeConstraints { make in
            make.top.left.equalTo(view)
            make.right.equalTo(view).inset(ScreenSize.width/2)
            make.bottom.equalTo(startButton.snp.top)
        }
        remoteFeaturesTableView.snp.makeConstraints { make in
            make.top.right.equalTo(view)
            make.left.equalTo(featuresTableView.snp.right)
            make.bottom.equalTo(startButton.snp.top)
        }
    }
}
