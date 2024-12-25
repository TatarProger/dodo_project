//
//  PizzaSizeDoughCell.swift
//  Dodo
//
//  Created by Rishat Zakirov on 04.09.2024.
//

import UIKit

enum SizeType: String, CaseIterable {
    case small = "25 см"
    case middle = "30 см"
    case big = "35 см"
    
    static var allSizes: [String] {
        SizeType.allCases.map { $0.rawValue }
    }

    static func indexBySize(_ item: SizeType) -> Int {
        guard let index = SizeType.allCases.firstIndex(where: { $0 == item }) else { return 0 }
        return index
    }
}

enum DoughType: String, CaseIterable {
    case traditional = "Традиционное"
    case thin = "Тонкое"
    
    static var allDoughs: [String] {
        DoughType.allCases.map { $0.rawValue }
    }
    
    static func indexByDough(_ item: DoughType) -> Int {
        guard let index = DoughType.allCases.firstIndex(where: { $0 == item }) else { return 0 }
        return index
    }
}

class PizzaSizeDoughCell: UITableViewCell {
    
    var onSizeChanged: ((String)->())?
    var onDoughChanged: ((String)->())?

    var sizeSegmentedControl: UISegmentedControl = {
        let control = UISegmentedControl(items: SizeType.allSizes) //["25 см", "30 см", "35 см"]
        control.selectedSegmentIndex = 0
        control.addTarget(nil, action: #selector(sizeSegmentChanged(_:)), for: .valueChanged)
        return control
    }()
    
    var doughSegmentedControl: UISegmentedControl = {
        let control = UISegmentedControl(items: DoughType.allDoughs) //["Традиционное","Тонкое"]
        control.selectedSegmentIndex = 0
        control.addTarget(nil, action: #selector(doughSegmentChanged(_:)), for: .valueChanged)
        return control
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupViews()
        setupConstraints()
    }
    
    override func prepareForReuse() {
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func update(_ product: Product) {
        
        if product.type != "pizza" {
            sizeSegmentedControl.isHidden = true
            doughSegmentedControl.isHidden = true
        }
        
        //String -> SizeType -> Size Index
        if let sizeType = SizeType(rawValue: product.size) {
            let index = SizeType.indexBySize(sizeType)
            sizeSegmentedControl.selectedSegmentIndex = index
        }
      
        //String -> DoughType -> Dough Index
        if let doughType = DoughType(rawValue: product.dough) {
            let index = DoughType.indexByDough(doughType)
            doughSegmentedControl.selectedSegmentIndex = index
        }

    }
    
}

//MARK: - Event Handler
extension PizzaSizeDoughCell {
    @objc func sizeSegmentChanged(_ sender: UISegmentedControl) {
        let size = SizeType.allSizes[sender.selectedSegmentIndex]
        onSizeChanged?(size)
    }
    
    @objc func doughSegmentChanged(_ sender: UISegmentedControl) {
        let dough = DoughType.allDoughs[sender.selectedSegmentIndex]
        onDoughChanged?(dough)
    }
}


extension PizzaSizeDoughCell {
    func setupViews() {
        selectionStyle = .none
        contentView.addSubview(sizeSegmentedControl)
        contentView.addSubview(doughSegmentedControl)
    }
    
    func setupConstraints() {
        sizeSegmentedControl.snp.makeConstraints { make in
            make.left.top.equalTo(contentView).offset(10)
            make.right.equalTo(contentView).inset(10)
        }
        
        doughSegmentedControl.snp.makeConstraints { make in
            make.top.equalTo(sizeSegmentedControl.snp.bottom).offset(10)
            make.bottom.right.equalTo(contentView).inset(10)
            make.left.equalTo(contentView).offset(10)

        }
    }
}
