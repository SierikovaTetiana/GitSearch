//
//  SearchCommits.swift
//  repoSearch
//
//  Created by Tetiana Sierikova on 22.05.2022.
//

import Foundation

struct SearchCommits : Codable {
    let commit : CommitDetails
}

struct CommitDetails : Codable {
    let author : Commit
    let message : String
}

struct Commit : Codable {
    let name : String
    let email : String
}

struct RepoCommits {
    let repoCommit : String?
    let commitEmail : String?
    let commitAuthor : String?
}
