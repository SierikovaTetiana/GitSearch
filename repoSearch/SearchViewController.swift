//
//  ViewController.swift
//  repoSearch
//
//  Created by Tetiana Sierikova on 16.05.2022.
//

import UIKit

class SearchViewController: UIViewController {
    
    private lazy var searchController: UISearchController = {
        let searchController = UISearchController(searchResultsController: nil)
        searchController.delegate = self
        searchController.searchBar.delegate = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search repositiry..."
        searchController.searchBar.showsCancelButton = false
        searchController.searchBar.autocapitalizationType = .allCharacters
        definesPresentationContext = true
        return searchController
    }()
    private let tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.register(CustomTableViewCell.self, forCellReuseIdentifier: CustomTableViewCell.identifier)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = .white
        tableView.allowsSelection = true
        tableView.separatorStyle = .none
        return tableView
    }()
    private let headerView: UIView = {
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: 300, height: 50))
        headerView.backgroundColor = .white
        return headerView
    }()
    private let labelHeaderSection: UILabel = {
        let labelHeaderSection = UILabel()
        labelHeaderSection.textAlignment = .left
        labelHeaderSection.font = .systemFont(ofSize: 25, weight: .heavy)
        labelHeaderSection.textColor = .black
        return labelHeaderSection
    }()
    private let nothingFoundPlaceholder: UIImageView = {
        let nothingFoundPlaceholder = UIImageView()
        nothingFoundPlaceholder.image = UIImage(named: "NothingFound")
        nothingFoundPlaceholder.contentMode = .scaleAspectFill
        return nothingFoundPlaceholder
    }()
    private let backBarButtonItem: UIBarButtonItem = {
        let backBarButtonItem = UIBarButtonItem(title: "Back", style: .plain, target: nil, action: nil)
        backBarButtonItem.tintColor = .white
        return backBarButtonItem
    }()
    private let searchUrlString = "https://api.github.com/search/repositories?q=stars:%3E1&sort=stars&page=1"
    private let repoVC = RepoViewController()
    private var userToken: String = ""
    //    private var adminSecrets = Secrets()
    private var searchWithLimits = true
    private var isSearching = false
    private var searchQuery: String = ""
    private var displCells = 0
    private var currentSearchPage = 1
    private var currentPopularPage = 1
    private var repos = [Repo]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Search"
        self.view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        navigationItem.backBarButtonItem = backBarButtonItem
        searchController.hidesNavigationBarDuringPresentation = false
        hideKeyboardWhenTappedAround()
        askForToken(titleAlert: "Ask for TOKEN", messageAlert: "Please provide a GitHub personal access token to avoid API limitations.")
        searchInGit(indexPath: IndexPath(row: 0, section: 0), searchUrlString: searchUrlString)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0)
        ])
        labelHeaderSection.frame = CGRect(x: 20, y: 0, width: 300, height: 50)
        nothingFoundPlaceholder.frame = CGRect(x: tableView.frame.midX, y: tableView.frame.midY, width: view.frame.size.width/4, height: view.frame.height/4)
        nothingFoundPlaceholder.center = tableView.center
    }
    
    private func hideKeyboardWhenTappedAround() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        searchController.searchBar.endEditing(true)
    }
    
    private func askForToken(titleAlert: String, messageAlert: String) {
        let dialogMessage = UIAlertController(title: titleAlert, message: messageAlert, preferredStyle: .alert)
        dialogMessage.addTextField(configurationHandler: { textField in
            textField.placeholder = "your token" })
        let enterToken = UIAlertAction(title: "Enter Token", style: .default, handler: { (action) -> Void in
            self.userToken = dialogMessage.textFields![0].text!
            self.searchWithLimits = false
            self.searchInGit(indexPath: IndexPath(row: 0, section: 0), searchUrlString: self.searchUrlString)
        })
        let useLimits = UIAlertAction(title: "Use with limits", style: .cancel) { (action) -> Void in
            self.searchWithLimits = true
        }
        dialogMessage.addAction(enterToken)
        dialogMessage.addAction(useLimits)
        self.present(dialogMessage, animated: true, completion: nil)
    }
}

extension SearchViewController: UISearchControllerDelegate, UISearchBarDelegate {
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        if searchQuery != "" {
            nothingFoundPlaceholder.removeFromSuperview()
            self.repos.removeAll()
            self.tableView.reloadData()
            isSearching = true
            guard let safeSearchUrlString = "https://api.github.com/search/repositories?q=is:public \(searchQuery)&page=\(currentSearchPage)".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else { return }
            searchInGit(indexPath: IndexPath(row: 0, section: 0), searchUrlString: safeSearchUrlString)
        } else {
            isSearching = false
            nothingFoundPlaceholder.removeFromSuperview()
            self.repos.removeAll()
            self.tableView.reloadData()
            searchInGit(indexPath: IndexPath(row: 0, section: 0), searchUrlString: searchUrlString)
        }
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchQuery = searchText
    }
    
    private func searchInGit(indexPath: IndexPath, searchUrlString: String) {
        self.tableView.tableFooterView = spinerFooter()
        currentSearchPage = 1
        let searchUrl = URL(string: searchUrlString)
        guard let url = searchUrl else { return }
        var session = URLSession.shared
        let conf = URLSessionConfiguration.default
        if !searchWithLimits && userToken != "" {
            conf.httpAdditionalHeaders = ["Authorization": "token \(userToken)"]
            session = URLSession(configuration: conf)
        }
        let task = session.dataTask(with: url) { data, response, error in
            if let httpResponse = response as? HTTPURLResponse {
                print(httpResponse.statusCode)
                if httpResponse.statusCode == 403 {
                    DispatchQueue.main.async {
                        self.askForToken(titleAlert: "You have reached the API limits", messageAlert: "Please provide a valid GitHub personal access token")
                    }
                } else if httpResponse.statusCode == 401 {
                    DispatchQueue.main.async {
                        self.askForToken(titleAlert: "Your Token is not valid.", messageAlert: "Please provide a valid GitHub personal access token")
                    }
                }
            }
            if let error = error {
                DispatchQueue.main.async {
                    self.tableView.tableFooterView = nil
                    self.view.addSubview(self.nothingFoundPlaceholder)
                }
                print(error)
                return
            }
            do {
                let decoder = JSONDecoder()
                guard let safeData = data else { return }
                let json = try decoder.decode(Root.self, from: safeData)
                for item in json.items {
                    guard let repoOwnerAvatarUrl = URL(string: item.owner.avatar_url) else { return }
                    if let imageData = try? Data(contentsOf: repoOwnerAvatarUrl) {
                        if let loadedImage = UIImage(data: imageData) {
                            self.repos.append(Repo(repoName: item.name, repoStars: item.stargazers_count, repoOwner: item.owner.login, repoOwnerAvatar: loadedImage, repoUrl: item.html_url))
                        }
                    } else {
                        self.repos.append(Repo(repoName: item.name, repoStars: item.stargazers_count, repoOwner: item.owner.login, repoOwnerAvatar: nil, repoUrl: item.html_url))
                    }
                }
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                    if self.repos.isEmpty {
                        self.tableView.tableFooterView = nil
                        self.view.addSubview(self.nothingFoundPlaceholder)
                    } else {
                        self.displCells = self.tableView.visibleCells.count
                        if self.tableView.indexPathExists(indexPath: IndexPath(row: indexPath.row, section: indexPath.section)) {
                            self.tableView.scrollToRow(at: indexPath, at: .none, animated: true)
                        }
                        self.tableView.tableFooterView = nil
                    }
                }
            } catch {
                DispatchQueue.main.async {
                    self.tableView.tableFooterView = nil
                }
                print("Error during JSON serialization SearchVC: \(searchUrlString) ", error)
            }
        }
        task.resume()
    }
}

extension SearchViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if repos.isEmpty {
            return 0
        } else {
            return repos.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CustomTableViewCell.identifier, for: indexPath) as? CustomTableViewCell else { return UITableViewCell() }
        if !repos.isEmpty {
            cell.namelbl.text = repos[indexPath.row].repoName
            cell.ownerRepoImage.image = repos[indexPath.row].repoOwnerAvatar
            if let stars = repos[indexPath.row].repoStars {
                cell.starlbl.text = "☆ \(stars)"
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let navController = self.navigationController else { return }
        if !(navController.viewControllers.contains(self.repoVC)) {
            self.repoVC.repoDetails.removeAll()
            self.repoVC.commitDetails.removeAll()
            self.repoVC.repoDetails.append(Repo(repoName: self.repos[indexPath.row].repoName, repoStars: self.repos[indexPath.row].repoStars, repoOwner: self.repos[indexPath.row].repoOwner, repoOwnerAvatar: self.repos[indexPath.row].repoOwnerAvatar, repoUrl: self.repos[indexPath.row].repoUrl))
            self.navigationController?.pushViewController(self.repoVC, animated:true)
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if repos.count != displCells {
            if indexPath.row == repos.count - 1 {
                if isSearching {
                    currentSearchPage += 1
                    guard let searchUrlString = "https://api.github.com/search/repositories?q=\(searchQuery)&page=\(currentSearchPage)".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else { return }
                    searchInGit(indexPath: indexPath, searchUrlString: searchUrlString)
                } else {
                    currentPopularPage += 1
                    let searchUrlString = "https://api.github.com/search/repositories?q=stars:%3E1&sort=stars&page=\(currentPopularPage)"
                    searchInGit(indexPath: indexPath, searchUrlString: searchUrlString)
                }
            }
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 123
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if isSearching {
            labelHeaderSection.text = "Repositories"
        } else {
            labelHeaderSection.text = "Popular repositories"
        }
        headerView.addSubview(labelHeaderSection)
        return headerView
    }
}

extension UIViewController {
    func spinerFooter() -> UIView {
        let footerView = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: 100))
        let spiner = UIActivityIndicatorView()
        spiner.center = footerView.center
        spiner.startAnimating()
        footerView.addSubview(spiner)
        return footerView
    }
}

extension UITableView {
    func indexPathExists(indexPath:IndexPath) -> Bool {
        if indexPath.section >= self.numberOfSections {
            return false
        }
        if indexPath.row >= self.numberOfRows(inSection: indexPath.section) {
            return false
        }
        return true
    }
}
