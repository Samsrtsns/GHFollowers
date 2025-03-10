//
//  GFRepoItemVC.swift
//  GHFollowers2
//
//  Created by Samet KATI on 5.06.2024.
//

import UIKit

class GFRepoItemVC : GFItemInfoVC {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureItems()
    }
    
    private func configureItems(){
        itemInfoViewOne.set(itemInfoType: .repos, withCount: user.publicRepos)
        itemInfoViewTwo.set(itemInfoType: .gists, withCount: user.publicGists)
        actionButton.set(backgroundColor: .systemPurple, title: "Github Profile")
    }
    
    // Communication was established through Delegate and the function was accessed
    override func actionButtonTapped() {
        delegete.didTapGitHubProfile(for: user)
    }
}
