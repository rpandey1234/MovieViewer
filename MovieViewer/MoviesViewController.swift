//
//  MoviesViewController.swift
//  MovieViewer
//
//  Created by Rahul Pandey on 10/10/16.
//  Copyright © 2016 Rahul Pandey. All rights reserved.
//

import UIKit
import AFNetworking
import MBProgressHUD

class MoviesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var networkErrorLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    var movies: [NSDictionary]?
    var endpoint: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(handleRefresh(_:)), for: UIControlEvents.valueChanged)
        
        tableView.insertSubview(refreshControl, at: 0)
        tableView.dataSource = self
        tableView.delegate = self
        // Do any additional setup after loading the view.
        loadData(refreshControl: nil)
    }
    
    func handleRefresh(_ refreshControl: UIRefreshControl) {
        loadData(refreshControl: refreshControl)
    }
    
    func loadData(refreshControl: UIRefreshControl?) {
        MBProgressHUD.showAdded(to: self.view, animated: true)
        let apiKey = "a07e22bc18f5cb106bfe4cc1f83ad8ed"
        let url = URL(string: "https://api.themoviedb.org/3/movie/\(endpoint!)?api_key=\(apiKey)")
        
        print(self.view)
        print(url)
        let request = URLRequest(url: url!)
        let session = URLSession(configuration: URLSessionConfiguration.default, delegate: nil, delegateQueue: OperationQueue.main)
        let task : URLSessionDataTask = session.dataTask(with: request,
             completionHandler: {(dataOrNil, response, error) in
                MBProgressHUD.hide(for: self.view, animated: true)
                if error != nil {
                    self.networkErrorLabel.isHidden = false
                    return
                }
                self.networkErrorLabel.isHidden = true
                if let data = dataOrNil {
                    if let responseDictionary = try! JSONSerialization.jsonObject(with: data, options:[]) as? NSDictionary {
    //                  NSLog("response: \(responseDictionary)")
                        self.movies = responseDictionary["results"] as? [NSDictionary]
                        self.tableView.reloadData()
                        if let refreshControl = refreshControl {
                            refreshControl.endRefreshing()
                        }
                    }
                }
        })
        task.resume()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let movies = movies {
            return movies.count
        } else {
            return 0
        }
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MovieCell", for: indexPath) as! MovieCell
        
        let movie = movies![(indexPath as NSIndexPath).row]
        let title = movie["title"] as! String
        let overview = movie["overview"] as! String
        let baseUrl = "http://image.tmdb.org/t/p/w500"
        if let posterPath = movie["poster_path"] as? String {
            let imageUrl = URL(string: baseUrl + posterPath)
            cell.posterView.setImageWith(imageUrl!)
        }
        cell.titleLabel.text = title
        cell.overviewLabel.text = overview
        
//        print("row \((indexPath as NSIndexPath).row), index at position \(indexPath.index(atPosition: 2))")
        return cell
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        print("prepare for segue")
        let cell = sender as! UITableViewCell
        let indexPath = tableView.indexPath(for: cell)
        let movie = movies![(indexPath! as NSIndexPath).row]
        let detailViewController = segue.destination as! DetailViewController
        detailViewController.movie = movie
        
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
}
