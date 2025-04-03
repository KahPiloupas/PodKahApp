//
//  RSSViewController.swift
//  PodKahApp
//
//  Created by Karina Piloupas on 28/03/25.
//

import UIKit

class RSSViewController: UIViewController {
    
    private var viewModel: PodcastListViewModel = PodcastListViewModel()
    private var podcasts: [Podcast] = []
    
    private let rssStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 16
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private let rssTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Enter your RSSFeed here..."
        textField.borderStyle = .roundedRect
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private let addButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Add", for: .normal)
        button.layer.cornerRadius = 8
        button.backgroundColor = .systemBlue
        button.setTitleColor(.white, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(PodCastTableViewCell.self, forCellReuseIdentifier: PodCastTableViewCell.identifier)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupUI()
        
        addButton.addTarget(self, action: #selector(didTappAddButton), for: .touchUpInside)
        
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    private func setupUI() {
        view.addSubview(rssStackView)
        view.addSubview(tableView)
        
        rssStackView.addArrangedSubview(rssTextField)
        rssStackView.addArrangedSubview(addButton)
        
        NSLayoutConstraint.activate([
            rssStackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            rssStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            rssStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            rssTextField.heightAnchor.constraint(equalToConstant: 40),
            
            addButton.heightAnchor.constraint(equalToConstant: 40),
            addButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 120),
            addButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -120),
            
            tableView.topAnchor.constraint(equalTo: rssStackView.bottomAnchor, constant: 16),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    @objc private func didTappAddButton() {
        guard let value = rssTextField.text, isValidURL(value) else {
            let alertController = UIAlertController(title: "Atention", message: "Enter RSSFeed", preferredStyle: .alert)
            
            let closeAction = UIAlertAction(title: "Close", style: .default, handler: nil)
            alertController.addAction(closeAction)
            
            present(alertController, animated: true)
            return
        }
        
        viewModel.fetchPodcasts(url: value) { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let model):
                print("Podcasts encontrados: \(model.count)")
                for podcast in model {
                    print("Título: \(podcast.title)")
                    print("Autor: \(podcast.author)")
                    print("Descrição: \(podcast.description)")
                    print("Gênero: \(podcast.genre)")
                    print("Número de episódios: \(podcast.episodes.count)")
                    print("---")
                }
                
                DispatchQueue.main.async {
                    self.podcasts = model
                    self.tableView.reloadData()
                }
            case .failure(let error):
                print("Erro ao buscar podcasts: \(error)")
                DispatchQueue.main.async {
                    let alertController = UIAlertController(title: "Atention", message: "Error fetching podcasts", preferredStyle: .alert)
                    
                    let closeAction = UIAlertAction(title: "Close", style: .default, handler: nil)
                    alertController.addAction(closeAction)
                    
                    self.present(alertController, animated: true)
                }
            }
        }
    }
    
    private func isValidURL(_ urlString: String) -> Bool {
        let pattern = "(https?)://[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        
        let regex = try? NSRegularExpression(pattern: pattern, options: .caseInsensitive)
        
        let range = NSRange(location: 0, length: urlString.utf16.count)
        
        return regex?.firstMatch(in: urlString, options: [], range: range) != nil
    }
}

extension RSSViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return podcasts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: PodCastTableViewCell.identifier, for: indexPath) as! PodCastTableViewCell
        let podcast = podcasts[indexPath.row]
        cell.configure(
            with: .init(
                imageURL: podcast.imageURL,
                title: podcast.title,
                author: podcast.author,
                genre: podcast.genre,
                duration: nil
            )
        )
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let selectedPodcast = podcasts[indexPath.row]
        let detailsVC = PodCastDetailsViewController(podcast: selectedPodcast)
        navigationController?.pushViewController(detailsVC, animated: true)
    }
}
