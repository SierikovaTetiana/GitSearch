//
//  CustomRepoTableViewCell.swift
//  repoSearch
//
//  Created by Tetiana Sierikova on 19.05.2022.
//

import UIKit

class CustomRepoTableViewCell: UITableViewCell {

    static let identifier = "repoCell"
    
    lazy var commitAuthorName: UILabel = {
        let commitAuthorName = UILabel()
        commitAuthorName.textAlignment = .left
        commitAuthorName.font = UIFont.boldSystemFont(ofSize: 18)
        commitAuthorName.textColor = .systemBlue
        commitAuthorName.numberOfLines = 0
        commitAuthorName.adjustsFontSizeToFitWidth = true
        commitAuthorName.minimumScaleFactor = 10
        commitAuthorName.clipsToBounds = true
        commitAuthorName.translatesAutoresizingMaskIntoConstraints = false
        return commitAuthorName
    }()
    
    lazy var commitEmail: UILabel = {
        let commitEmail = UILabel()
        commitEmail.textAlignment = .left
        commitEmail.clipsToBounds = true
        commitEmail.font = UIFont.boldSystemFont(ofSize: 18)
        commitEmail.translatesAutoresizingMaskIntoConstraints = false
        return commitEmail
    }()
    
    lazy var commitMessage: UILabel = {
        let commitMessage = UILabel()
        commitMessage.textAlignment = .left
        commitMessage.font = .systemFont(ofSize: 18, weight: .regular)
        commitMessage.textColor = .gray
        commitMessage.numberOfLines = 0
        commitMessage.translatesAutoresizingMaskIntoConstraints = false
        return commitMessage
    }()
    
    lazy var numberCommit: UILabel = {
        let numberCommit = UILabel()
        numberCommit.textAlignment = .center
        numberCommit.backgroundColor = .systemGray5
        numberCommit.clipsToBounds = true
        numberCommit.layer.cornerRadius = 25
        numberCommit.font = UIFont.boldSystemFont(ofSize: 25)
        numberCommit.translatesAutoresizingMaskIntoConstraints = false
        return numberCommit
    }()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        NSLayoutConstraint.activate([
            numberCommit.centerYAnchor.constraint(equalTo: commitAuthorName.centerYAnchor, constant: 25),
            numberCommit.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 0),
            numberCommit.widthAnchor.constraint(equalToConstant: 50),
            numberCommit.heightAnchor.constraint(equalToConstant: 50),
            
            commitMessage.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: 0),
            commitMessage.leadingAnchor.constraint(equalTo: numberCommit.trailingAnchor, constant: 30),
            commitMessage.topAnchor.constraint(equalTo: commitEmail.bottomAnchor, constant: 5),
            commitMessage.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),
                        
            commitEmail.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: 0),
            commitEmail.leadingAnchor.constraint(equalTo: numberCommit.trailingAnchor, constant: 30),

            commitAuthorName.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10.0),
            commitAuthorName.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: 0),
            commitAuthorName.leadingAnchor.constraint(equalTo: numberCommit.trailingAnchor, constant: 30),
            commitAuthorName.bottomAnchor.constraint(equalTo: commitEmail.topAnchor, constant: -5),
        ])
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(false, animated: false)
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(numberCommit)
        contentView.addSubview(commitMessage)
        contentView.addSubview(commitEmail)
        contentView.addSubview(commitAuthorName)
        layoutSubviews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
