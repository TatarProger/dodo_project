//
//  FeatureToggleCell.swift
//  Dodo
//
//  Created by Rishat Zakirov on 09.01.2025.
//

import UIKit
class FeatureToggleCell: UITableViewCell {
    
    var onSwitch: ((Feature)->())?
    var feature:Feature?
    
    static let reuseId = "FeatureToggleCell"
    
    
    let featureLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    
    let switchLocalFeatureToggle: UISwitch = {
       let toggle = UISwitch()
        toggle.addTarget(nil, action: #selector(switchIsToggle), for: .valueChanged)
        return toggle
    }()
    
    let switchRemoteFeatureToggle: UISwitch = {
        let toggle = UISwitch()
        return toggle
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupViews()
        setupConstraints()
    }
    
    func update(feature: Feature) {
        self.feature = feature
        featureLabel.text = feature.name
        switchLocalFeatureToggle.isOn = feature.enabled
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func switchIsToggle() {
        guard var feature = feature else {return}
        onSwitch?(feature.toggleEnabled)
    }
}

extension FeatureToggleCell {
    func setupViews() {
        contentView.addSubview(featureLabel)
        contentView.addSubview(switchLocalFeatureToggle)
    }
    
    func setupConstraints() {
        
        featureLabel.snp.makeConstraints { make in
            make.left.equalTo(contentView).inset(10)
            make.bottom.top.equalTo(contentView).inset(10)
        }
        
        switchLocalFeatureToggle.snp.makeConstraints { make in
            make.right.equalTo(contentView).inset(10)
            make.bottom.top.equalTo(contentView).inset(10)
        }
    }
}
