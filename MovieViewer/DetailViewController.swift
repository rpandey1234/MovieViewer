//
//  DetailViewController.swift
//  MovieViewer
//
//  Created by Rahul Pandey on 10/13/16.
//  Copyright © 2016 Rahul Pandey. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

    @IBOutlet weak var posterImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var overviewLabel: UILabel!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var infoView: UIView!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var releaseLabel: UILabel!
    
    var movie: NSDictionary!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        scrollView.contentSize = CGSize(width: scrollView.frame.size.width, height: infoView.frame.origin.y + infoView.frame.size.height)
        
        let title = movie["title"] as? String
        titleLabel.text = title
        
        let overview = movie["overview"] as? String
        overviewLabel.text = overview
        overviewLabel.sizeToFit()
        
        let releaseDate = movie["release_date"] as? String
        if let releaseDate = releaseDate {
            releaseLabel.text = "Date: " + String(describing: releaseDate)
        } else {
            releaseLabel.text = ""
        }

        let ratingAverage = movie["vote_average"] as? Double
        if let ratingAverage = ratingAverage {
             ratingLabel.text = "Rating: " + String(describing: ratingAverage)
        } else {
            ratingLabel.text = "Rating: N/A"
        }
        let baseUrl = "http://image.tmdb.org/t/p/w500"
        if let posterPath = movie["poster_path"] as? String {
            let posterUrl = URL(string: baseUrl + posterPath)
            let imageRequest = URLRequest(url: posterUrl!)
            posterImageView.setImageWith(posterUrl!)
            posterImageView.setImageWith(imageRequest,
             placeholderImage: UIImage(named: "placeholder"),
             success: { (imageRequest, imageResponse, image) in
                print("success network request")
                if imageResponse != nil {
                    self.posterImageView.alpha = 0.0
                    self.posterImageView.image = image
                    UIView.animate(withDuration: 0.3, animations: {
                        self.posterImageView.alpha = 1.0
                    })
                } else {
                    self.posterImageView.image = image
                }
},
             failure: { (imageResquest, imageResponse, error) in
                // do something for failure condition
                self.posterImageView.image = UIImage(named: "placeholder")
            })
        }
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
