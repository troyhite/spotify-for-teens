//
//  BrowseViewController.swift
//  SpotifyForTeens
//
//  Created on 2025-12-29
//

import UIKit

class BrowseViewController: UIViewController {
    
    private let tableView: UITableView = {
        let table = UITableView()
        table.translatesAutoresizingMaskIntoConstraints = false
        table.register(PlaylistCell.self, forCellReuseIdentifier: PlaylistCell.identifier)
        return table
    }()
    
    private var playlists: [Playlist] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        loadContent()
    }
    
    private func setupUI() {
        title = "Browse"
        view.backgroundColor = .systemBackground
        
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private func loadContent() {
        SpotifyManager.shared.getFeaturedPlaylists { [weak self] playlists, error in
            DispatchQueue.main.async {
                if let playlists = playlists {
                    self?.playlists = playlists
                    self?.tableView.reloadData()
                }
            }
        }
    }
}

extension BrowseViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return playlists.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: PlaylistCell.identifier, for: indexPath) as? PlaylistCell else {
            return UITableViewCell()
        }
        cell.configure(with: playlists[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        // Navigate to playlist details
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
}

class PlaylistCell: UITableViewCell {
    static let identifier = "PlaylistCell"
    
    private let playlistImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.backgroundColor = .systemGray5
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .semibold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .regular)
        label.textColor = .secondaryLabel
        label.numberOfLines = 2
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        contentView.addSubview(playlistImageView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(descriptionLabel)
        
        NSLayoutConstraint.activate([
            playlistImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            playlistImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            playlistImageView.widthAnchor.constraint(equalToConstant: 60),
            playlistImageView.heightAnchor.constraint(equalToConstant: 60),
            
            titleLabel.leadingAnchor.constraint(equalTo: playlistImageView.trailingAnchor, constant: 12),
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            
            descriptionLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            descriptionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 4),
            descriptionLabel.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor)
        ])
    }
    
    func configure(with playlist: Playlist) {
        titleLabel.text = playlist.name
        descriptionLabel.text = playlist.description
        // Load image from URL if available
    }
}
