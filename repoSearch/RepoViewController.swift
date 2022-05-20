//
//  RepoViewController.swift
//  repoSearch
//
//  Created by Tetiana Sierikova on 19.05.2022.
//

import UIKit

class RepoViewController: UIViewController {
    
    private let repoOwnerImage: UIImageView = {
        let repoOwnerImage = UIImageView()
        repoOwnerImage.contentMode = .scaleAspectFill
        repoOwnerImage.clipsToBounds = true
        return repoOwnerImage
    }()
    
    private let repoTableView: UITableView = {
        let repoTableView = UITableView(frame: .zero, style: .grouped)
        repoTableView.register(CustomRepoTableViewCell.self, forCellReuseIdentifier: CustomRepoTableViewCell.identifier)
        repoTableView.translatesAutoresizingMaskIntoConstraints = false
        repoTableView.rowHeight = UITableView.automaticDimension
        repoTableView.estimatedRowHeight = 100
        repoTableView.backgroundColor = .white
        repoTableView.separatorStyle = .singleLine
        return repoTableView
    }()
    
    private lazy var shareButton: UIButton = {
        let shareButton = UIButton()
        shareButton.backgroundColor = .systemGray5
        shareButton.setTitle("📤  Share Repo", for: .normal)
        shareButton.titleLabel?.font = .systemFont(ofSize: 20, weight: .medium)
        shareButton.layer.cornerRadius = 15
        shareButton.setTitleColor(.systemBlue, for: .normal)
        shareButton.addTarget(self, action: #selector(shareButtonTapped), for: .touchUpInside)
        shareButton.translatesAutoresizingMaskIntoConstraints = false
        return shareButton
    }()

    private lazy var viewOnlineButton: UIButton = {
        let viewOnlineButton = UIButton()
        viewOnlineButton.setTitle("VIEW ONLINE", for: .normal)
        viewOnlineButton.backgroundColor = .systemGray5
        viewOnlineButton.titleLabel?.font = .systemFont(ofSize: 13, weight: .medium)
        viewOnlineButton.setTitleColor(.systemBlue, for: .normal)
        viewOnlineButton.layer.cornerRadius = 15
        viewOnlineButton.addTarget(self, action: #selector(viewOnlineButtonTapped), for: .touchUpInside)
        viewOnlineButton.translatesAutoresizingMaskIntoConstraints = false
        return viewOnlineButton
    }()
    
    private let repoLabel: UILabel = {
        let repoLabel = UILabel()
        repoLabel.text = "Repo title gdkglaekrgjalkwjrglajewglakrjglkarjgaklrgjakrgnaj,rgna,grga"
        repoLabel.numberOfLines = 0
        repoLabel.adjustsFontSizeToFitWidth = true
        repoLabel.font = .systemFont(ofSize: 20, weight: .medium)
        repoLabel.minimumScaleFactor = 15
        repoLabel.translatesAutoresizingMaskIntoConstraints = false
        return repoLabel
    }()
    
    private let repoBy: UILabel = {
        let repoBy = UILabel()
        repoBy.text = "REPO BY"
        repoBy.font = .systemFont(ofSize: 20, weight: .thin)
        repoBy.textColor = .white
        repoBy.translatesAutoresizingMaskIntoConstraints = false
        return repoBy
    }()
    
    private let repoOwnerName: UILabel = {
        let repoOwnerName = UILabel()
        repoOwnerName.text = "Repo autor name"
        repoOwnerName.textColor = .white
        repoOwnerName.font = .systemFont(ofSize: 30, weight: .heavy)
        repoOwnerName.translatesAutoresizingMaskIntoConstraints = false
        return repoOwnerName
    }()
    
    private let stars: UILabel = {
        let stars = UILabel()
        stars.text = "Number of stars"
        stars.textColor = .white
        stars.font = .systemFont(ofSize: 15, weight: .light)
        stars.translatesAutoresizingMaskIntoConstraints = false
        return stars
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        view.addSubview(repoOwnerImage)
        view.addSubview(shareButton)
        view.addSubview(repoTableView)
        view.addSubview(repoLabel)
        view.addSubview(viewOnlineButton)
        view.addSubview(repoBy)
        view.addSubview(repoOwnerName)
        view.addSubview(stars)
        repoTableView.delegate = self
        repoTableView.dataSource = self

        repoOwnerImage.image = UIImage(named: "Clara")
    }
    
    override func viewWillLayoutSubviews() {
        repoOwnerImage.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height / 3)
        
        NSLayoutConstraint.activate([
            repoBy.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            repoBy.heightAnchor.constraint(equalToConstant: 30),
            repoBy.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0.0),
            repoBy.bottomAnchor.constraint(equalTo: repoOwnerName.topAnchor, constant: -8),
            
            repoOwnerName.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            repoOwnerName.heightAnchor.constraint(equalToConstant: 40),
            repoOwnerName.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0.0),
            repoOwnerName.bottomAnchor.constraint(equalTo: stars.topAnchor, constant: -8),
            
            stars.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            stars.heightAnchor.constraint(equalToConstant: 25),
            stars.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0.0),
            stars.bottomAnchor.constraint(equalTo: repoOwnerImage.bottomAnchor, constant: -20),
            
            repoLabel.topAnchor.constraint(equalTo: repoOwnerImage.bottomAnchor, constant: 20),
            repoLabel.heightAnchor.constraint(equalToConstant: 40),
            repoLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            repoLabel.trailingAnchor.constraint(equalTo: viewOnlineButton.leadingAnchor, constant: -10),
            repoLabel.bottomAnchor.constraint(equalTo: repoTableView.topAnchor, constant: -20),
            
            viewOnlineButton.topAnchor.constraint(equalTo: repoOwnerImage.bottomAnchor, constant: 20),
            viewOnlineButton.widthAnchor.constraint(equalToConstant: 110),
            viewOnlineButton.heightAnchor.constraint(equalToConstant: 40),
            viewOnlineButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            repoTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            repoTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            repoTableView.topAnchor.constraint(equalTo: viewOnlineButton.bottomAnchor, constant: 20.0),
            repoTableView.bottomAnchor.constraint(equalTo: shareButton.topAnchor, constant: -10),
            
            shareButton.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0.0),
            shareButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -50.0),
            shareButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            shareButton.heightAnchor.constraint(equalToConstant: 50),
        ])
    }
    
    @objc func shareButtonTapped(sender: UIButton!) {
      print("Share Button tapped")
    }
    
    
    @objc func viewOnlineButtonTapped(sender: UIButton!) {
      print("View online Button tapped")
    }
    
}

extension RepoViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CustomRepoTableViewCell.identifier, for: indexPath) as? CustomRepoTableViewCell else { return UITableViewCell() }
        cell.numberCommit.text = "1"
        cell.commitAuthorName.text = "Arestovich"
        cell.commitEmail.text = "mercury1663@gmail.com"
        cell.commitMessage.text = "ardgargadrg ergaergqegra aregargag arggb 143 drkjgabrekjgerjgajkrgnajdrg eanrgbargnajdkg rgjakrdngvjkangjadnrg galdnga agrna gtajkgrlksjrg etgjnadg"
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UITableViewHeaderFooterView()
        headerView.translatesAutoresizingMaskIntoConstraints = false
        headerView.backgroundView = {
            let view = UIView()
            view.backgroundColor = .white
            return view
        }()
        let headerLabel = UILabel()
        headerLabel.translatesAutoresizingMaskIntoConstraints = false
        headerLabel.text = "Commits History"
        headerLabel.font = .systemFont(ofSize: 23, weight: .heavy)
        headerView.contentView.addSubview(headerLabel)
        NSLayoutConstraint.activate([
            headerLabel.leadingAnchor.constraint(equalTo: headerView.contentView.leadingAnchor, constant: 0),
            headerLabel.trailingAnchor.constraint(equalTo: headerView.contentView.trailingAnchor, constant: -16),
            headerLabel.topAnchor.constraint(equalTo: headerView.contentView.topAnchor, constant: 12),
            headerLabel.bottomAnchor.constraint(equalTo: headerView.contentView.bottomAnchor, constant: -12)
        ])
        return headerView
    }
}

//TODO: oposite text color on image
