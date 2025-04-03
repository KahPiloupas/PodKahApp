//
//  PodCastDetailsViewController.swift
//  PodKahApp
//
//  Created by Karina Piloupas on 28/03/25.
//

import UIKit

class PodCastDetailsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    private let podcast: Podcast
    
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(PodCastTableViewCell.self, forCellReuseIdentifier: PodCastTableViewCell.identifier)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    init(podcast: Podcast) {
        self.podcast = podcast
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupUI()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        title = podcast.title
    }
    
    private func setupUI() {
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        ])
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return podcast.episodes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: PodCastTableViewCell.identifier, for: indexPath) as! PodCastTableViewCell
        let episode = podcast.episodes[indexPath.row]
        
        cell.configure(
            with: .init(
                imageURL: episode.imageURL,
                title: episode.title,
                author: podcast.author,
                genre: episode.genre,
                duration: episode.duration
            )
        )
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let episode = podcast.episodes[indexPath.row]
        let playerVC = PodCastPlayerViewController(podcast: podcast, episode: episode)
        navigationController?.pushViewController(playerVC, animated: true)
    }
}
