//
//  SearchViewController.swift
//  SpotifyForTeens
//
//  Created on 2025-12-29
//

import UIKit

class SearchViewController: UIViewController {
    
    private let searchController = UISearchController(searchResultsController: nil)
    
    private let tableView: UITableView = {
        let table = UITableView()
        table.translatesAutoresizingMaskIntoConstraints = false
        table.register(TrackCell.self, forCellReuseIdentifier: TrackCell.identifier)
        return table
    }()
    
    private var tracks: [Track] = []
    private var filteredTracks: [Track] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupSearch()
    }
    
    private func setupUI() {
        title = "Search"
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
    
    private func setupSearch() {
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search for songs"
        navigationItem.searchController = searchController
        definesPresentationContext = true
    }
    
    private func searchTracks(query: String) {
        SpotifyManager.shared.searchTracks(query: query) { [weak self] tracks, error in
            DispatchQueue.main.async {
                if let tracks = tracks {
                    self?.tracks = tracks
                    self?.filterTracks()
                }
            }
        }
    }
    
    private func filterTracks() {
        let filter = ParentalControlsManager.shared.currentFilter
        filteredTracks = tracks.filter { filter.isContentAllowed($0) }
        tableView.reloadData()
    }
}

extension SearchViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let query = searchController.searchBar.text, !query.isEmpty else {
            tracks = []
            filteredTracks = []
            tableView.reloadData()
            return
        }
        
        // Debounce search requests
        NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(performSearch), object: nil)
        perform(#selector(performSearch), with: query, afterDelay: 0.5)
    }
    
    @objc private func performSearch(_ query: String) {
        searchTracks(query: query)
    }
}

extension SearchViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredTracks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TrackCell.identifier, for: indexPath) as? TrackCell else {
            return UITableViewCell()
        }
        cell.configure(with: filteredTracks[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let track = filteredTracks[indexPath.row]
        playTrack(track)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    private func playTrack(_ track: Track) {
        SpotifyManager.shared.playTrack(uri: track.uri) { success, error in
            if !success {
                print("Failed to play track: \(error?.localizedDescription ?? "Unknown error")")
            }
        }
    }
}

class TrackCell: UITableViewCell {
    static let identifier = "TrackCell"
    
    private let albumImageView: UIImageView = {
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
    
    private let artistLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .regular)
        label.textColor = .secondaryLabel
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let durationLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .regular)
        label.textColor = .secondaryLabel
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
        contentView.addSubview(albumImageView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(artistLabel)
        contentView.addSubview(durationLabel)
        
        NSLayoutConstraint.activate([
            albumImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            albumImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            albumImageView.widthAnchor.constraint(equalToConstant: 50),
            albumImageView.heightAnchor.constraint(equalToConstant: 50),
            
            titleLabel.leadingAnchor.constraint(equalTo: albumImageView.trailingAnchor, constant: 12),
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            titleLabel.trailingAnchor.constraint(equalTo: durationLabel.leadingAnchor, constant: -8),
            
            artistLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            artistLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 4),
            artistLabel.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),
            
            durationLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            durationLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
    }
    
    func configure(with track: Track) {
        titleLabel.text = track.name
        artistLabel.text = track.artistNames
        durationLabel.text = track.durationFormatted
        // Load album image from URL if available
    }
}
