//
//  ViewController.swift
//  repoSearch
//
//  Created by Tetiana Sierikova on 16.05.2022.
//

import UIKit

class SearchViewController: UIViewController {
    
    private let labelHeaderSection = UILabel()
    private let tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.register(CustomTableViewCell.self, forCellReuseIdentifier: CustomTableViewCell.identifier)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = .white
        tableView.separatorStyle = .none
        return tableView
    }()
    private lazy var searchController: UISearchController = {
        let searchController = UISearchController(searchResultsController: nil)
        //        searchController.searchResultsUpdater = self
        searchController.delegate = self
        searchController.searchBar.delegate = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search something..."
        searchController.searchBar.showsCancelButton = false
        searchController.searchBar.autocapitalizationType = .allCharacters
        definesPresentationContext = true
        return searchController
    }()
    private lazy var headerView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: tableView.frame.width, height: 50))
    private var isSearching = true
    private var searchQuery: String = ""
    private var userArr = [RepoModal]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        self.title = "Search"
        //        navigationController?.hidesBarsOnSwipe = true
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        hideKeyboardWhenTappedAround()
        userArr.append(RepoModal(userImage: UIImage(named: "Clara")!, name: "Marcus", stars: "3"))
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0)
        ])
        labelHeaderSection.frame = CGRect.init(x: 20, y: 0, width: headerView.frame.width - 10, height: headerView.frame.height - 10)
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
            searchInGit()
        }
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchQuery = searchText
    }
    
    private func searchInGit() {
    }
}

extension SearchViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CustomTableViewCell.identifier, for: indexPath) as? CustomTableViewCell else { return UITableViewCell() }
        cell.namelbl.text = userArr[indexPath.row].name
        cell.ownerRepoImage.image = userArr[indexPath.row].userImage
        cell.starlbl.text = userArr[indexPath.row].stars
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 123
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        headerView.backgroundColor = .white
        labelHeaderSection.frame = CGRect.init(x: 17, y: 0, width: headerView.frame.width - 10, height: headerView.frame.height - 10)
        labelHeaderSection.text = "Repositories"
        labelHeaderSection.textAlignment = .left
        labelHeaderSection.font = .systemFont(ofSize: 25, weight: .heavy)
        labelHeaderSection.textColor = .black
        headerView.addSubview(labelHeaderSection)
        return headerView
    }
}

//TODO: view for header in section in landscape leading == tableviewcell.leading
//TODO: search in GIT func
//TODO: show nav bar when scrolling up
