//
//  ProductTableViewCell.swift
//  BaseProject
//
//  Created by Paulo Ferreira de Jesus - PFR on 11/11/19.
//  Copyright © 2019 Iteris Consultoria. All rights reserved.
//

import UIKit

class ProductCell: UITableViewCell {

    private let productNameLabel : UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.textAlignment = .left
        return label
    }()

    private let activePrincipleLabel : UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 16)
        label.textAlignment = .left
        return label
    }()

    private let lastUpdateLabel : UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 16)
        label.textAlignment = .left
        return label
    }()

    private let descriptionLabel : UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 16)
        label.textAlignment = .left
        return label
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupUI() {
        self.addSubview(productNameLabel)
        self.addSubview(activePrincipleLabel)
        self.addSubview(lastUpdateLabel)
        self.addSubview(descriptionLabel)

        productNameLabel.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingLeft: 10, width: self.frame.width, height: 40)
    }

    func configure(with product: ProductInformation) {
        productNameLabel.text = product.name
    }
}
