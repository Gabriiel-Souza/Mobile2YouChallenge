//
//  SimilarMoviesTableViewCell.swift
//  Mobile2YouChallenge
//
//  Created by Gabriel Souza de Araujo on 04/01/22.
//

import UIKit

class SimilarMoviesTableViewCell: UITableViewCell {
    
    static let reuseIdentifier = "SimilarMoviesTableViewCell"
    
    private let movieImageView = FetchableImageView()
    private let likedImageView = UIImageView()
    private let titleLabel = UILabel()
    private let informationLabel = UILabel()
    private lazy var MovieLabelStackView: UIStackView = {
        let stackView = createStackView(with: [titleLabel, informationLabel],
                                        axis: .vertical)
        return stackView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .default, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        backgroundColor = .systemBackground
        clipsToBounds = true
        
        // Subviews
        contentView.addSubview(movieImageView)
        contentView.addSubview(likedImageView)
        contentView.addSubview(MovieLabelStackView)
        
        // Initial Configuration
        configureImage()
        configureLikedImageView()
        configureMovieLabels()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupMovieData(movie: SimilarMovie?, isFavorite: Bool) {
        guard let movie = movie else { return }
        likedImageView.isHidden = !isFavorite
        
        let movieYear = movie.release_date.components(separatedBy: "-").first
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.titleLabel.text = movie.title
            
            var genresID = [Int]()
            for i in 0..<min(movie.genre_ids.count-1, 3) {
                genresID.append(movie.genre_ids[i])
            }
            
            var genres = [Genre]()
            genresID.forEach { id in
                let validGenre = MovieDB.shared.genres.first { genre in
                    genre.id == id
                }
                if let validGenre = validGenre {
                    genres.append(validGenre)
                }
            }
            
            var element = 0
            var genresDescription = ""
            genres.forEach { genre in
                if element > 0 {
                    genresDescription += ", "
                }
                genresDescription += genre.name
                element += 1
            }
            
            
            self.informationLabel.text = "\(movieYear ?? "") \(genresDescription)"
        }
        
        if let imagePath = movie.poster_path {
            movieImageView.getImage(from: imagePath, isMainMovie: false)
        }
    }
}

// MARK: - Constraints/Configs
extension SimilarMoviesTableViewCell {
    private func configureImage() {
        movieImageView.translatesAutoresizingMaskIntoConstraints = false
        movieImageView.contentMode = .scaleAspectFill
        
        NSLayoutConstraint.activate([
            movieImageView.topAnchor.constraint(equalTo: topAnchor, constant: 9),
            movieImageView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -9),
            movieImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 9),
            movieImageView.widthAnchor.constraint(equalTo: movieImageView.heightAnchor, multiplier: 1.0/1.4)
        ])
    }
    
    private func configureMovieLabels() {
        MovieLabelStackView.alignment = .leading
        
        titleLabel.font = UIFont.preferredFont(forTextStyle: .body).bold
        titleLabel.numberOfLines = 2
        titleLabel.adjustsFontSizeToFitWidth = true
        titleLabel.tintColor = .label
        
        informationLabel.font = UIFont.preferredFont(forTextStyle: .caption1)
        informationLabel.tintColor = .label
        
        NSLayoutConstraint.activate([
            MovieLabelStackView.centerYAnchor.constraint(equalTo: centerYAnchor),
            MovieLabelStackView.leadingAnchor.constraint(equalTo: movieImageView.trailingAnchor, constant: 12),
            MovieLabelStackView.trailingAnchor.constraint(equalTo: likedImageView.leadingAnchor, constant: -8)
        ])
    }
    
    private func configureLikedImageView() {
        likedImageView.translatesAutoresizingMaskIntoConstraints = false
        let image = UIImage(systemName: "suit.heart.fill")
        
        likedImageView.image = image
        likedImageView.tintColor = .label
        NSLayoutConstraint.activate([
            likedImageView.topAnchor.constraint(equalTo: topAnchor, constant: 12),
            likedImageView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -12),
            likedImageView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.2),
            likedImageView.widthAnchor.constraint(equalTo: likedImageView.heightAnchor)
        ])
    }
}
