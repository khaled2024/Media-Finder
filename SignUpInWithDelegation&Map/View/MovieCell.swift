//
//  MovieCell.swift
//  SignUpInWithDelegation&Map
//
//  Created by KhaleD HuSsien on 11/11/2021.
//

import UIKit
import SDWebImage

class MovieCell: UITableViewCell {
    
    //MARK: - variables
    @IBOutlet weak var movieImageView: UIImageView!
    @IBOutlet weak var ArtistNameLabel: UILabel!
    @IBOutlet weak var typeOfMedia: UILabel!
    @IBOutlet weak var TrackNameLabel: UILabel!
    @IBOutlet weak var imageViewBtn: UIButton!
    @IBOutlet weak var DescriptionLabel: UILabel!
    @IBOutlet weak var countryLabel: UILabel!
    @IBOutlet weak var yearOfMovie: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setUpImageLayout()
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    //MARK: - LifeCycle
    private func setUpImageLayout(){
        movieImageView.layer.cornerRadius = (movieImageView.frame.size.width  ) / 7
        movieImageView.clipsToBounds = true
        movieImageView.layer.borderWidth = 4
        movieImageView.layer.borderColor  = #colorLiteral(red: 0.7540688515, green: 0.7540867925, blue: 0.7540771365, alpha: 1)
        imageViewBtn.titleLabel?.text = ""
    }
    //MARK: - Functions
    private func bouncingAnimation(){
        let imageFrameX = movieImageView.frame.origin.x
        self.movieImageView.frame.origin.x += 4
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, animations: {
            self.movieImageView.frame.origin.x -= 10
            self.movieImageView.frame.origin.x = imageFrameX
        }, completion: nil)
    }
    
    private func setData(media: Media){
        let myString = media.releaseDate!
        let mySubstring = myString.prefix(4)
        let myReleaseData = String(mySubstring)
        self.yearOfMovie.text = myReleaseData
        self.movieImageView.sd_setImage(with: URL(string: media.PosterUrl), completed: nil)
        self.countryLabel.text = media.country
        self.typeOfMedia.text = media.typeOfMedia
    }
    
    func setMediaCell(result: String , media: Media){
        if result == ResultSegment.music.rawValue{
            self.ArtistNameLabel.text = media.artistName
            self.DescriptionLabel.text = media.trackName
            setData(media: media)
        }else if result == ResultSegment.tvShow.rawValue{
            self.ArtistNameLabel.text = media.artistName
            self.DescriptionLabel.text = media.longDescription
            setData(media: media)
        }else if result == ResultSegment.movie.rawValue{
            self.ArtistNameLabel.text = media.trackName
            self.DescriptionLabel.text = media.longDescription
            setData(media: media)
        }else if result == ResultSegment.all.rawValue{
            self.ArtistNameLabel.text = media.artistName
            self.ArtistNameLabel.text = media.trackName
            self.DescriptionLabel.text = media.longDescription
            setData(media: media)
        }else{
            print("Error in media Cell ")
        }
    }
    //MARK: - Actions
    @IBAction func mediaImageTapped(_ sender: UIButton) {
        self.bouncingAnimation()
    }
}
