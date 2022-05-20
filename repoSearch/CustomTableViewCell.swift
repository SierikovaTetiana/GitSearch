//
//  CustomTableViewCell.swift
//  repoSearch
//
//  Created by Tetiana Sierikova on 16.05.2022.
//

import UIKit

class CustomTableViewCell: UITableViewCell {
    
    static let identifier = "cell"
    
    lazy var ownerRepoImage: UIImageView = {
        let ownerRepoImage = UIImageView(frame: CGRect(x: 10, y: 10, width: 90, height: 90))
        ownerRepoImage.contentMode = .scaleAspectFill
        ownerRepoImage.layer.cornerRadius = 15
        ownerRepoImage.clipsToBounds = true
        return ownerRepoImage
    }()
    lazy var namelbl: UILabel = {
        let namelbl = UILabel()
        namelbl.textAlignment = .left
        namelbl.font = UIFont.boldSystemFont(ofSize: 18)
        namelbl.translatesAutoresizingMaskIntoConstraints = false
        return namelbl
    }()
    lazy var starlbl: UILabel = {
        let starlbl = UILabel()
        starlbl.textAlignment = .left
        starlbl.textColor = .gray
        starlbl.translatesAutoresizingMaskIntoConstraints = false
        return starlbl
    }()
    lazy private var pointer: UIImageView = {
        let pointer = UIImageView()
        let arrow = UIImage(systemName: "chevron.right")
        pointer.tintColor = .darkGray
        pointer.image = arrow
        pointer.translatesAutoresizingMaskIntoConstraints = false
        return pointer
    }()
    lazy var backView: UIButton = {
        let backView = UIButton(frame: CGRect(x: 10, y: 6, width: contentView.frame.size.width - 20, height: 110))
        backView.backgroundColor = .systemGray5
        backView.layer.cornerRadius = 10
        backView.clipsToBounds = true
        return backView
    }()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        backView.frame = CGRect(x: 20, y: 6, width: contentView.frame.size.width - 40, height: 110)
        
        NSLayoutConstraint.activate([
            pointer.centerYAnchor.constraint(equalTo: backView.centerYAnchor, constant: 0.0),
            pointer.leadingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -50.0),
            
            namelbl.trailingAnchor.constraint(equalTo: pointer.leadingAnchor, constant: -10.0),
            namelbl.leadingAnchor.constraint(equalTo: ownerRepoImage.trailingAnchor, constant: 10.0),
            namelbl.centerYAnchor.constraint(equalTo: backView.centerYAnchor, constant: -15.0),
            
            starlbl.trailingAnchor.constraint(equalTo: pointer.leadingAnchor, constant: -10.0),
            starlbl.leadingAnchor.constraint(equalTo: ownerRepoImage.trailingAnchor, constant: 10.0),
            starlbl.centerYAnchor.constraint(equalTo: backView.centerYAnchor, constant: 10.0)
        ])
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(backView)
        backView.addSubview(ownerRepoImage)
        backView.addSubview(namelbl)
        backView.addSubview(starlbl)
        backView.addSubview(pointer)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
