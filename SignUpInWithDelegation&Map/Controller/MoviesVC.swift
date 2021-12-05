//
//  MoviesVC.swift
//  SignUpInWithDelegation&Map
//
//  Created by KhaleD HuSsien on 11/11/2021.
//

import UIKit
import AVKit

class MoviesVC: UIViewController{
    //MARK: - outlets
    @IBOutlet weak var typeSegmentController: UISegmentedControl!
    @IBOutlet weak var tabelView: UITableView!
    @IBOutlet weak var serchBar: UISearchBar!
    @IBOutlet weak var emptyWallpaper: UIImageView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!

    //MARK: - variables
    private var arrOfMedia: [Media] = [Media]()
    private var resultSegment: String! = ResultSegment.all.rawValue
    private let email = UserDefultsManager.shared().email
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        UserDefaults.standard.set(true, forKey: UserDefultsKeys.isLoggedIn)
        setUp()
        setNavigationBar()
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if let media = CoderManager.shared().encodeMedia(media: self.arrOfMedia){
            if self.arrOfMedia.count > 0 {
                SqlManager.shared().insertMedia(email: self.email, mediaData: media, type: self.resultSegment)
            }
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getDataFromDB()
        setSegmanet()
    }
    
    //MARK: - functions
    private func getDataFromDB(){
        guard let data = SqlManager.shared().getMedia(email: email)?.0 else { return }
        let type = SqlManager.shared().getMedia(email: email)?.1
        if let media = CoderManager.shared().decodeMedia(mediaData: (data)){
            do {
                arrOfMedia = media
                resultSegment = type
                self.tabelView.reloadData()
            }
        }
    }
    
    private func setUp(){
        tabelView.delegate = self
        tabelView.dataSource = self
        serchBar.delegate = self
        tabelView.register(UINib(nibName: Cells.movieCell, bundle: nil), forCellReuseIdentifier: Cells.movieCell)
        
    }
    
    private func getMediaFromApi(searchName: String , type: String){
        ApiManager.loadMediaArr(term: searchName, media: type) { error, mediaArr in
            if let  error = error{
               print(error)
            } else if let mediaArr = mediaArr {
                self.arrOfMedia = mediaArr
                self.tabelView.reloadData()
            }
        }
    }
   
    
    private func setNavigationBar(){
        navigationItem.title = "Media List"
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "person.fill"), style: .plain, target: self, action: #selector(goToProfile))
        navigationItem.rightBarButtonItem?.tintColor = UIColor(named: "ColorApp")
    }
    
    private func playVideo(url: URL) {
        let player = AVPlayer(url: url)
        let vc = AVPlayerViewController()
        vc.player = player
        self.present(vc, animated: true) { vc.player?.play() }
    }
    
    @objc func goToProfile(){
        let sb = UIStoryboard(name: ViewContollers.main, bundle: nil)
        let profileVC = sb.instantiateViewController(withIdentifier: ViewContollers.profileVC)as! ProfileVC
        self.navigationController?.pushViewController(profileVC, animated: true)
        SqlManager.shared().getAllMedia()
    }
    
    private func setSegmanet() {
        
        switch self.resultSegment {
        case ResultSegment.music.rawValue:
            typeSegmentController.selectedSegmentIndex = 1
        case ResultSegment.tvShow.rawValue:
            typeSegmentController.selectedSegmentIndex = 2
        case ResultSegment.movie.rawValue:
            typeSegmentController.selectedSegmentIndex = 3
        default:
            typeSegmentController.selectedSegmentIndex = 0
        }
    }
    private func setUpActivityIndecator(){
        activityIndicator.center = self.view.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.style = .large
        activityIndicator.color = UIColor(named: "ColorApp")
        view.addSubview(activityIndicator)
    }
    
    //MARK: - Actions
    
    @IBAction func setMediaType(_ sender: UISegmentedControl) {
        let segmentIndex = typeSegmentController.selectedSegmentIndex
        switch typeSegmentController.selectedSegmentIndex {
        case 0:
            resultSegment =  typeSegmentController.titleForSegment(at: segmentIndex)!
        case 1:
            resultSegment =  typeSegmentController.titleForSegment(at: segmentIndex)!
        case 2:
            resultSegment =  typeSegmentController.titleForSegment(at: segmentIndex)!
        case 3:
            resultSegment =  typeSegmentController.titleForSegment(at: segmentIndex)!
        default:
            resultSegment = ResultSegment.all.rawValue
        }
    }
}

//MARK: - UITableViewDelegate, UITableViewDataSource
extension MoviesVC: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrOfMedia.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Cells.movieCell, for: indexPath)as! MovieCell
        let media = arrOfMedia[indexPath.row]
        cell.setMediaCell(result: resultSegment, media: media)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let movie = arrOfMedia[indexPath.row].trailer!
        if  let movieUrl = URL(string: movie){
            playVideo(url: movieUrl)
        }
    }
}
extension MoviesVC: UISearchBarDelegate{
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if let searchName = searchBar.text , !searchName.isEmpty , let type = resultSegment , !type.isEmpty{
            emptyWallpaper.isHidden = true
            tabelView.isHidden = false
            self.getMediaFromApi(searchName: searchBar.text!, type: resultSegment)
            searchBar.endEditing(true)
        }else{
            emptyWallpaper.isHidden = false
            activityIndicator.isHidden = true
            tabelView.isHidden = true
            searchBar.endEditing(true)
        }
        
    }
}
//self.activityIndicator.startAnimating()
//self.view.isUserInteractionEnabled = false
//self.activityIndicator.stopAnimating()
//self.view.isUserInteractionEnabled = true
