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
        repoLabel.text = "Repo title"
        repoLabel.numberOfLines = 0
        repoLabel.font = .systemFont(ofSize: 20, weight: .heavy)
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
        repoOwnerName.text = "Repo author name"
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
    var repoDetails = [Repo]()
    var commitDetails = [RepoCommits]()
    
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
    }
    
    override func viewWillAppear(_ animated: Bool) {
        repoTableView.reloadData()
        searchCommitsInGit()
        if !repoDetails.isEmpty {
            repoOwnerImage.image = repoDetails[0].repoOwnerAvatar
            if let numberOfStars = repoDetails[0].repoStars {
                stars.text = "★ Number of Stars (\(numberOfStars))"
            }
            repoOwnerName.text = repoDetails[0].repoOwner
            repoLabel.text = repoDetails[0].repoName
        } else {
            repoOwnerImage.image = UIImage(named: "photoOwnerNotFound")
            stars.text = "★ Number of Stars (↻)"
            repoOwnerName.text = "Repo owner"
            repoLabel.text = "Repo name"
        }
    }
    
    override func viewWillLayoutSubviews() {
        repoOwnerImage.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height / 3)
        
        NSLayoutConstraint.activate([
            repoBy.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            repoBy.heightAnchor.constraint(equalToConstant: 30),
            repoBy.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0),
            repoBy.bottomAnchor.constraint(equalTo: repoOwnerName.topAnchor, constant: -8),
            
            repoOwnerName.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            repoOwnerName.heightAnchor.constraint(equalToConstant: 40),
            repoOwnerName.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0),
            repoOwnerName.bottomAnchor.constraint(equalTo: stars.topAnchor, constant: -8),
            
            stars.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            stars.heightAnchor.constraint(equalToConstant: 25),
            stars.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0),
            stars.bottomAnchor.constraint(equalTo: repoOwnerImage.bottomAnchor, constant: -20),
            
            repoLabel.topAnchor.constraint(equalTo: repoOwnerImage.bottomAnchor, constant: 20),
            repoLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            repoLabel.trailingAnchor.constraint(equalTo: viewOnlineButton.leadingAnchor, constant: -10),
            repoLabel.bottomAnchor.constraint(greaterThanOrEqualTo: repoTableView.topAnchor, constant: -20),
            
            viewOnlineButton.topAnchor.constraint(equalTo: repoOwnerImage.bottomAnchor, constant: 20),
            viewOnlineButton.widthAnchor.constraint(equalToConstant: 110),
            viewOnlineButton.heightAnchor.constraint(equalToConstant: 40),
            viewOnlineButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            repoTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            repoTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            repoTableView.topAnchor.constraint(equalTo: viewOnlineButton.bottomAnchor, constant: 20),
            repoTableView.bottomAnchor.constraint(equalTo: shareButton.topAnchor, constant: -10),
            
            shareButton.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0.0),
            shareButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -50),
            shareButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            shareButton.heightAnchor.constraint(equalToConstant: 50),
        ])
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        repoDetails.removeAll()
        commitDetails.removeAll()
    }
    
    @objc func shareButtonTapped(sender: UIButton!) {
        if let strRepoUrl = repoDetails[0].repoUrl, let repoName = repoDetails[0].repoName {
            let shareButtonVc = UIActivityViewController(activityItems: [repoName, strRepoUrl], applicationActivities: nil)
            shareButtonVc.title = repoName
            shareButtonVc.popoverPresentationController?.sourceView = self.view
            self.present(shareButtonVc, animated: true, completion: nil)
        }
    }
    
    @objc func viewOnlineButtonTapped(sender: UIButton!) {
        if let strRepoUrl = repoDetails[0].repoUrl {
            if let appURL = URL(string: strRepoUrl) {
                UIApplication.shared.open(appURL, options: [:])
            }
        }
    }
    
    private func searchCommitsInGit() {
        repoTableView.tableFooterView = spinerFooter()
        if !repoDetails.isEmpty {
            if let author = repoDetails[0].repoOwner, let repositoryName = repoDetails[0].repoName {
                let searchUrl = URL(string: "https://api.github.com/repos/\(author)/\(repositoryName)/commits?&page=1&per_page=3")
                let session = URLSession.shared
                guard let url = searchUrl else { return }
                let task = session.dataTask(with: url) { data, response, error in
                    if let error = error {
                        print(error)
                        return
                    }
                    do {
                        let decoder = JSONDecoder()
                        guard let safeData = data else { return }
                        let json = try decoder.decode([SearchCommits].self, from: safeData)
                        for item in json {
                            self.commitDetails.append(RepoCommits(repoCommit: item.commit.message, commitEmail: item.commit.author.email, commitAuthor: item.commit.author.name))
                        }
                        DispatchQueue.main.async {
                            self.repoTableView.reloadData()
                            self.repoTableView.tableFooterView = nil
                        }
                    } catch {
                        print("Error during JSON serialization: ", error)
                    }
                }
                task.resume()
            }
        }
    }
}

// MARK: - TableView delegate
extension RepoViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return commitDetails.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CustomRepoTableViewCell.identifier, for: indexPath) as? CustomRepoTableViewCell else { return UITableViewCell() }
        if !commitDetails.isEmpty {
            cell.numberCommit.text = "\(indexPath.row + 1)"
            if let author = commitDetails[indexPath.row].commitAuthor {
                cell.commitAuthorName.text = author.uppercased()
            }
            cell.commitEmail.text = commitDetails[indexPath.row].commitEmail
            cell.commitMessage.text = commitDetails[indexPath.row].repoCommit
        }
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
            headerLabel.topAnchor.constraint(equalTo: headerView.contentView.topAnchor, constant: 30),
            headerLabel.bottomAnchor.constraint(equalTo: headerView.contentView.bottomAnchor, constant: -12)
        ])
        return headerView
    }
}
