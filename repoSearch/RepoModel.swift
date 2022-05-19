//
//  UserModel.swift
//  repoSearch
//
//  Created by Tetiana Sierikova on 18.05.2022.
//

import UIKit

struct Root : Codable {
    let items : [Repository]
}

struct Repository : Codable {
    let name : String
    let stargazers_count : Int
    let owner : Owner
}

struct Owner : Codable {
    let login : String
    let avatar_url : String
}

struct Repo {
    let repoName : String?
    let repoStars : Int?
    let repoOwner : String?
    let repoOwnerAvatar : UIImage?
}
