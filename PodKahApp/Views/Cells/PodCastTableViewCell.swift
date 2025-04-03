//
//  PodCastTableViewCell.swift
//  PodKahApp
//
//  Created by Karina Piloupas on 02/04/25.
//
import UIKit

class PodCastTableViewCell: UITableViewCell {
    struct DataModel {
        let imageURL: String
        let title: String
        let author: String
        let genre: String
        let duration: String?
    }
    
    static let identifier = "PodCastTableViewCell"
    private var task: URLSessionDataTask?
    private var cacheImage = ImageCache.shared
    
    private let podCastStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 8
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private let podCastImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 8
        imageView.widthAnchor.constraint(equalToConstant: 80).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: 80).isActive = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let infoStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 8
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16)
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let authorLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 8)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let durationLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 8)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let genreLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 8)
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
        contentView.addSubview(podCastStackView)
        podCastStackView.addArrangedSubview(podCastImageView)
        podCastStackView.addArrangedSubview(infoStackView)
        
        infoStackView.addArrangedSubview(titleLabel)
        infoStackView.addArrangedSubview(authorLabel)
        infoStackView.addArrangedSubview(durationLabel)
        infoStackView.addArrangedSubview(genreLabel)
        
        NSLayoutConstraint.activate([
            podCastStackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            podCastStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16),
            podCastStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            podCastStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16)
        ])
    }
    
    func configure(with model: DataModel) {
        titleLabel.text = model.title
        if let duration = model.duration {
            durationLabel.text = "Duration: \(duration)"
        } else {
            durationLabel.text = nil
        }
        
        if model.author.isEmpty {
            authorLabel.text = "Author: Unknown"
        } else {
            authorLabel.text = "Author: \(model.author)"
        }
        
        if model.genre.isEmpty {
            genreLabel.text = "Genre: Unknown"
        } else {
            genreLabel.text = "Genre: \(model.genre)"
        }
        
        
        podCastImageView.image = nil
        if let cacheImage = cacheImage.image(forKey: model.imageURL) {
            podCastImageView.image = cacheImage
        } else {
            if let imageURL = URL(string: model.imageURL) {
                task = URLSession.shared.dataTask(with: imageURL) { [weak self] data, response, error in
                    guard let self = self,
                          let data = data,
                          let image = UIImage(data: data) else { return }
                    self.cacheImage.saveImage(image, forKey: model.imageURL)
                    DispatchQueue.main.async {
                        self.podCastImageView.image = image
                    }
                }
                task?.resume()
            }
        }
    }
}
