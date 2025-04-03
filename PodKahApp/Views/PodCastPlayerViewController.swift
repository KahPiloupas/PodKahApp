//
//  PodCastPlayerViewController.swift
//  PodKahApp
//
//  Created by Karina Piloupas on 28/03/25.
//

import UIKit
import AVFoundation

class PodCastPlayerViewController: UIViewController {
    
    private var episode: Episode?
    private var podcast: Podcast?
    private let playerViewModel = PlayerViewModel()
    
    private let headerStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 16
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private let infoStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.alignment = .leading
        stackView.axis = .vertical
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private let podcastImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 16
        imageView.backgroundColor = .systemGray6
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 24, weight: .bold)
        label.textColor = .label
        label.numberOfLines = 2
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let authorsLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .medium)
        label.textColor = .secondaryLabel
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let genreLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .medium)
        label.textColor = .secondaryLabel
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let durationLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .medium)
        label.textColor = .secondaryLabel
        return label
    }()
    
    private let descriptionTextView: UITextView = {
        let textView = UITextView()
        textView.isEditable = false
        textView.font = .systemFont(ofSize: 16)
        textView.textColor = .secondaryLabel
        textView.translatesAutoresizingMaskIntoConstraints = false
        return textView
    }()
    
    private let progressView: UIProgressView = {
        let progress = UIProgressView(progressViewStyle: .default)
        progress.progressTintColor = .systemBlue
        progress.trackTintColor = .systemGray5
        progress.translatesAutoresizingMaskIntoConstraints = false
        return progress
    }()
    
    private let progressStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .equalSpacing
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private let timeStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .equalSpacing
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private let durationTimeLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12)
        label.textColor = .secondaryLabel
        return label
    }()
    
    private let currentTimeLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12)
        label.textColor = .secondaryLabel
        label.text = "00:00"
        return label
    }()
    
    private let controlsStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.distribution = .equalSpacing
        stack.alignment = .center
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    private let skipBackwardButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "gobackward"), for: .normal)
        button.tintColor = .systemBlue
        return button
    }()
    
    private let backButton: UIButton = {
        let button = UIButton(type: .system)
        let config = UIImage.SymbolConfiguration(pointSize: 16, weight: .medium)
        let image = UIImage(systemName: "backward.fill", withConfiguration: config)
        button.setImage(image, for: .normal)
        button.tintColor = .systemBlue
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let playPauseButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "play.circle.fill"), for: .normal)
        button.tintColor = .systemBlue
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let forwardButton: UIButton = {
        let button = UIButton(type: .system)
        let config = UIImage.SymbolConfiguration(pointSize: 16, weight: .medium)
        let image = UIImage(systemName: "forward.fill", withConfiguration: config)
        button.setImage(image, for: .normal)
        button.tintColor = .systemBlue
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let skipForwardButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "goforward"), for: .normal)
        button.tintColor = .systemBlue
        return button
    }()
    
    init(podcast: Podcast, episode: Episode) {
        self.podcast = podcast
        self.episode = episode
        super.init(nibName: nil, bundle: nil)
        playerViewModel.setEpisodes(episodes: podcast.episodes)
        playerViewModel.setCurrentEpisode(episode: episode)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupUI()
        configure()
        setupActions()
        
        playerViewModel.onProgressUpdate = { [weak self] progress, currentTime, duration in
            self?.progressView.progress = progress
            self?.currentTimeLabel.text = self?.formatTime(currentTime)
            
            self?.updatePlayPauseButton()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        playerViewModel.pause()
    }
    
    private func setupUI() {
        view.addSubview(headerStackView)
        headerStackView.addArrangedSubview(podcastImageView)
        headerStackView.addArrangedSubview(infoStackView)
        
        infoStackView.addArrangedSubview(titleLabel)
        infoStackView.addArrangedSubview(authorsLabel)
        infoStackView.addArrangedSubview(durationLabel)
        infoStackView.addArrangedSubview(genreLabel)
        
        view.addSubview(descriptionTextView)
        
        view.addSubview(progressStackView)
        progressStackView.addArrangedSubview(progressView)
        progressStackView.addArrangedSubview(timeStackView)
        timeStackView.addArrangedSubview(currentTimeLabel)
        timeStackView.addArrangedSubview(durationTimeLabel)
        
        view.addSubview(controlsStackView)
        controlsStackView.addArrangedSubview(skipBackwardButton)
        controlsStackView.addArrangedSubview(backButton)
        controlsStackView.addArrangedSubview(playPauseButton)
        controlsStackView.addArrangedSubview(forwardButton)
        controlsStackView.addArrangedSubview(skipForwardButton)
        
        
        setupConstraints()
        setupActions()
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            headerStackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            headerStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            headerStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            podcastImageView.heightAnchor.constraint(equalToConstant: 160),
            podcastImageView.widthAnchor.constraint(equalToConstant: 160),
            
            descriptionTextView.topAnchor.constraint(equalTo: headerStackView.bottomAnchor, constant: 16),
            descriptionTextView.leadingAnchor.constraint(equalTo: headerStackView.leadingAnchor),
            descriptionTextView.trailingAnchor.constraint(equalTo: headerStackView.trailingAnchor),
            
            progressStackView.topAnchor.constraint(equalTo: descriptionTextView.bottomAnchor, constant: 16),
            progressStackView.leadingAnchor.constraint(equalTo: headerStackView.leadingAnchor),
            progressStackView.trailingAnchor.constraint(equalTo: headerStackView.trailingAnchor),
            
            controlsStackView.topAnchor.constraint(equalTo: timeStackView.bottomAnchor, constant: 8),
            controlsStackView.leadingAnchor.constraint(equalTo: headerStackView.leadingAnchor),
            controlsStackView.trailingAnchor.constraint(equalTo: headerStackView.trailingAnchor),
            controlsStackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            
            playPauseButton.widthAnchor.constraint(equalToConstant: 32),
            playPauseButton.heightAnchor.constraint(equalToConstant: 32)
        ])
    }
    
    private func setupActions() {
        playPauseButton.addTarget(self, action: #selector(playPauseAction), for: .touchUpInside)
        backButton.addTarget(self, action: #selector(previousEpisodeAction), for: .touchUpInside)
        forwardButton.addTarget(self, action: #selector(nextEpisodeAction), for: .touchUpInside)
        skipBackwardButton.addTarget(self, action: #selector(skipBackwardAction), for: .touchUpInside)
        skipForwardButton.addTarget(self, action: #selector(skipForwardAction), for: .touchUpInside)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(progressBarTapped))
        progressView.addGestureRecognizer(tapGesture)
    }
    
    private func updatePlayPauseButton() {
        if playerViewModel.isPlaying {
            playPauseButton.setImage(UIImage(systemName: "pause.circle.fill"), for: .normal)
        } else {
            playPauseButton.setImage(UIImage(systemName: "play.circle.fill"), for: .normal)
        }
    }
    
    private func resetForNewEpisode() {
        playerViewModel.pause()
        
        progressView.progress = 0.0
        currentTimeLabel.text = "00:00"
        
        self.updatePlayPauseButton()
    }
    
    @objc private func previousEpisodeAction() {
        playerViewModel.goToPreviousEpisode()
        resetForNewEpisode()
        configure()
    }
    
    @objc private func nextEpisodeAction() {
        playerViewModel.goToNextEpisode()
        resetForNewEpisode()
        configure()
    }
    
    @objc private func playPauseAction() {
        playerViewModel.togglePlayPause()
        updatePlayPauseButton()
    }
    
    @objc private func skipForwardAction() {
        playerViewModel.skipForward()
    }
    
    @objc private func skipBackwardAction() {
        playerViewModel.skipBackward()
    }
    
    @objc private func progressBarTapped(_ gestureRecognizer: UITapGestureRecognizer) {
        let point = gestureRecognizer.location(in: progressView)
        let width = progressView.bounds.width
        let percentage = Float(point.x / width)
        
        playerViewModel.seekTo(progress: percentage)
    }
    
    private func configure() {
        guard let episode = playerViewModel.getCurrentEpisode() else { return }
        
        titleLabel.text = episode.title
        title = episode.title
        
        if let imageURL = URL(string: episode.imageURL) {
            URLSession.shared.dataTask(with: imageURL) { [weak self] data, response, error in
                if let data = data, let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self?.podcastImageView.image = image
                    }
                }
            }.resume()
        }
        
        if let podcast = podcast, !podcast.author.isEmpty {
            authorsLabel.text = "Author: \(podcast.author)"
        } else {
            authorsLabel.text = "Author: Unknown"
        }
        
        descriptionTextView.text = "Description:\n\(episode.description)"
        durationLabel.text = "Duration: \(episode.duration)"
        
        if let podcast = podcast, !podcast.genre.isEmpty {
            genreLabel.text = "Genre: \(podcast.genre)"
        } else {
            genreLabel.text = "Genre: Unknown"
        }
        
        durationTimeLabel.text = episode.duration
        
        playerViewModel.onProgressUpdate = { [weak self] progress, currentTime, duration in
            self?.progressView.progress = progress
            self?.currentTimeLabel.text = self?.formatTime(currentTime)
        }
    }
    
    private func formatTime(_ timeInSeconds: Double) -> String {
        let minutes = Int(timeInSeconds) / 60
        let seconds = Int(timeInSeconds) % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
}
