//
//  GFFollowerItemVC.swift
//  GHFollowers2
//
//  Created by Samet KATI on 5.06.2024.
//

import UIKit

class GFFollowerItemVC : GFItemInfoVC {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureItems()
    }
    
    private func configureItems(){
        itemInfoViewOne.set(itemInfoType: .followers, withCount: user.followers)
        itemInfoViewTwo.set(itemInfoType: .following, withCount: user.following)
        actionButton.set(backgroundColor: .systemGreen, title: "Get Followers")
    }
    
    override func actionButtonTapped() {
        delegete.didTapGetFollowers(for: user)
    }
    
}

