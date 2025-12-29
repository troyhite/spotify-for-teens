//
//  PlayerViewController.swift
//  SpotifyForTeens
//
//  Created on 2025-12-29
//

import UIKit

class PlayerViewController: UIViewController {
    
    private let albumArtImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.backgroundColor = .systemGray5
        imageView.layer.cornerRadius = 12
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let trackTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "No track playing"
        label.font = .systemFont(ofSize: 24, weight: .bold)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let artistLabel: UILabel = {
        let label = UILabel()
        label.text = ""
        label.font = .systemFont(ofSize: 18, weight: .regular)
        label.textColor = .secondaryLabel
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let progressSlider: UISlider = {
        let slider = UISlider()
        slider.minimumValue = 0
        slider.maximumValue = 100
        slider.translatesAutoresizingMaskIntoConstraints = false
        return slider
    }()
    
    private let currentTimeLabel: UILabel = {
        let label = UILabel()
        label.text = "0:00"
        label.font = .systemFont(ofSize: 12)
        label.textColor = .secondaryLabel
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let remainingTimeLabel: UILabel = {
        let label = UILabel()
        label.text = "0:00"
        label.font = .systemFont(ofSize: 12)
        label.textColor = .secondaryLabel
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let playPauseButton: UIButton = {
        let button = UIButton(type: .system)
        let config = UIImage.SymbolConfiguration(pointSize: 60, weight: .regular)
        button.setImage(UIImage(systemName: "play.circle.fill", withConfiguration: config), for: .normal)
        button.tintColor = .systemGreen
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let previousButton: UIButton = {
        let button = UIButton(type: .system)
        let config = UIImage.SymbolConfiguration(pointSize: 40, weight: .regular)
        button.setImage(UIImage(systemName: "backward.fill", withConfiguration: config), for: .normal)
        button.tintColor = .label
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let nextButton: UIButton = {
        let button = UIButton(type: .system)
        let config = UIImage.SymbolConfiguration(pointSize: 40, weight: .regular)
        button.setImage(UIImage(systemName: "forward.fill", withConfiguration: config), for: .normal)
        button.tintColor = .label
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private var isPlaying = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupActions()
    }
    
    private func setupUI() {
        title = "Now Playing"
        view.backgroundColor = .systemBackground
        
        view.addSubview(albumArtImageView)
        view.addSubview(trackTitleLabel)
        view.addSubview(artistLabel)
        view.addSubview(progressSlider)
        view.addSubview(currentTimeLabel)
        view.addSubview(remainingTimeLabel)
        view.addSubview(playPauseButton)
        view.addSubview(previousButton)
        view.addSubview(nextButton)
        
        NSLayoutConstraint.activate([
            albumArtImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 40),
            albumArtImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            albumArtImageView.widthAnchor.constraint(equalToConstant: 280),
            albumArtImageView.heightAnchor.constraint(equalToConstant: 280),
            
            trackTitleLabel.topAnchor.constraint(equalTo: albumArtImageView.bottomAnchor, constant: 32),
            trackTitleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            trackTitleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            artistLabel.topAnchor.constraint(equalTo: trackTitleLabel.bottomAnchor, constant: 8),
            artistLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            artistLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            progressSlider.topAnchor.constraint(equalTo: artistLabel.bottomAnchor, constant: 32),
            progressSlider.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            progressSlider.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40),
            
            currentTimeLabel.topAnchor.constraint(equalTo: progressSlider.bottomAnchor, constant: 8),
            currentTimeLabel.leadingAnchor.constraint(equalTo: progressSlider.leadingAnchor),
            
            remainingTimeLabel.topAnchor.constraint(equalTo: progressSlider.bottomAnchor, constant: 8),
            remainingTimeLabel.trailingAnchor.constraint(equalTo: progressSlider.trailingAnchor),
            
            playPauseButton.topAnchor.constraint(equalTo: currentTimeLabel.bottomAnchor, constant: 40),
            playPauseButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            previousButton.centerYAnchor.constraint(equalTo: playPauseButton.centerYAnchor),
            previousButton.trailingAnchor.constraint(equalTo: playPauseButton.leadingAnchor, constant: -40),
            
            nextButton.centerYAnchor.constraint(equalTo: playPauseButton.centerYAnchor),
            nextButton.leadingAnchor.constraint(equalTo: playPauseButton.trailingAnchor, constant: 40)
        ])
    }
    
    private func setupActions() {
        playPauseButton.addTarget(self, action: #selector(playPauseTapped), for: .touchUpInside)
        previousButton.addTarget(self, action: #selector(previousTapped), for: .touchUpInside)
        nextButton.addTarget(self, action: #selector(nextTapped), for: .touchUpInside)
    }
    
    @objc private func playPauseTapped() {
        isPlaying.toggle()
        let config = UIImage.SymbolConfiguration(pointSize: 60, weight: .regular)
        let imageName = isPlaying ? "pause.circle.fill" : "play.circle.fill"
        playPauseButton.setImage(UIImage(systemName: imageName, withConfiguration: config), for: .normal)
    }
    
    @objc private func previousTapped() {
        // Implement previous track functionality
    }
    
    @objc private func nextTapped() {
        // Implement next track functionality
    }
}
