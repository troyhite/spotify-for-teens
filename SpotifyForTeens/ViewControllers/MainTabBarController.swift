//
//  MainTabBarController.swift
//  SpotifyForTeens
//
//  Created on 2025-12-29
//

import UIKit

class MainTabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTabs()
        setupAppearance()
    }
    
    private func setupTabs() {
        let browseVC = BrowseViewController()
        let browseNav = UINavigationController(rootViewController: browseVC)
        browseNav.tabBarItem = UITabBarItem(title: "Browse", image: UIImage(systemName: "music.note.list"), tag: 0)
        
        let searchVC = SearchViewController()
        let searchNav = UINavigationController(rootViewController: searchVC)
        searchNav.tabBarItem = UITabBarItem(title: "Search", image: UIImage(systemName: "magnifyingglass"), tag: 1)
        
        let playerVC = PlayerViewController()
        let playerNav = UINavigationController(rootViewController: playerVC)
        playerNav.tabBarItem = UITabBarItem(title: "Player", image: UIImage(systemName: "play.circle.fill"), tag: 2)
        
        let settingsVC = ParentalControlsViewController()
        let settingsNav = UINavigationController(rootViewController: settingsVC)
        settingsNav.tabBarItem = UITabBarItem(title: "Controls", image: UIImage(systemName: "lock.shield"), tag: 3)
        
        viewControllers = [browseNav, searchNav, playerNav, settingsNav]
    }
    
    private func setupAppearance() {
        tabBar.tintColor = .systemGreen
        tabBar.backgroundColor = .systemBackground
    }
}
