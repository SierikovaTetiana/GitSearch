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
    
    private var isSearching = false
    private var searchQuery: String = ""
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
        searchController.hidesNavigationBarDuringPresentation = false
        hideKeyboardWhenTappedAround()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let searchUrlString = "https://api.github.com/search/repositories?q=stars:%3E1&sort=stars&per_page=30&page=1"
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
    }
    
    private func hideKeyboardWhenTappedAround() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        searchController.searchBar.endEditing(true)
    }
}

extension SearchViewController: UISearchControllerDelegate, UISearchBarDelegate {
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        if searchQuery != "" {
            isSearching = true
            self.repos.removeAll()
            guard let searchUrlString = "https://api.github.com/search/repositories?q=\(searchQuery)&per_page=30&page=\(currentSearchPage)".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else { return }
            searchInGit(indexPath: IndexPath(row: 0, section: 0), searchUrlString: searchUrlString)
        }
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchQuery = searchText
    }
    
    private func searchInGit(indexPath: IndexPath, searchUrlString: String) {
        self.tableView.tableFooterView = createSpinerFooter()
        let searchUrl = URL(string: searchUrlString)
        let session = URLSession.shared
        guard let url = searchUrl else { return }
        let task = session.dataTask(with: url) { data, response, error in
            if let error = error {
                print(error)
                return
            }
            do {
                let decoder = JSONDecoder()
                let json = try decoder.decode(Root.self, from: data!)
                for item in json.items {
                    
                    guard let repoOwnerAvatarUrl = URL(string: item.owner.avatar_url) else { return }
                    if let imageData = try? Data(contentsOf: repoOwnerAvatarUrl) {
                        if let loadedImage = UIImage(data: imageData) {
                            self.repos.append(Repo(repoName: item.name, repoStars: item.stargazers_count, repoOwner: nil, repoOwnerAvatar: loadedImage))
                        }
                    } else {
                        self.repos.append(Repo(repoName: item.name, repoStars: item.stargazers_count, repoOwner: nil, repoOwnerAvatar: nil))
                    }
                }
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                    self.tableView.scrollToRow(at: indexPath, at: .none, animated: true)
                    self.tableView.tableFooterView = nil
                }
            } catch {
                print("Error during JSON serialization: \(self.searchQuery)", error)
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
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == repos.count - 1 {
            if isSearching {
                currentSearchPage += 1
                guard let searchUrlString = "https://api.github.com/search/repositories?q=\(searchQuery)&per_page=30&page=\(currentSearchPage)".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else { return }
                searchInGit(indexPath: indexPath, searchUrlString: searchUrlString)
            } else {
                currentPopularPage += 1
                let searchUrlString = "https://api.github.com/search/repositories?q=stars:%3E1&sort=stars&per_page=30&page=\(currentPopularPage)"
                searchInGit(indexPath: indexPath, searchUrlString: searchUrlString)
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
    func createSpinerFooter() -> UIView {
        let footerView = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: 100))
        let spiner = UIActivityIndicatorView()
        spiner.center = footerView.center
        spiner.startAnimating()
        footerView.addSubview(spiner)
        return footerView
    }
}

//TODO: view for header in section in landscape leading == tableviewcell.leading
