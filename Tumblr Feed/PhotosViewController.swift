//
//  PhotosViewController.swift
//  Tumblr Feed
//
//  Created by Pratyush Thapa on 1/31/17.
//  Copyright © 2017 Pratyush Thapa. All rights reserved.
//

import UIKit
import AFNetworking

class PhotosViewController: UIViewController, UITableViewDataSource, UITableViewDelegate ,UIScrollViewDelegate {
    
    var posts: [NSDictionary] = []
    
    @IBOutlet weak var photosTableView: UITableView!
    
    var isMoreDataLoading = false
    var loadingMoreView:InfiniteScrollActivityView?
    let refreshControl = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        let frame = CGRect(x: 0, y: photosTableView.contentSize.height, width: photosTableView.bounds.size.width, height: InfiniteScrollActivityView.defaultHeight)
        loadingMoreView = InfiniteScrollActivityView(frame: frame)
        loadingMoreView?.isHidden = true
        photosTableView.addSubview(loadingMoreView!)
        
        var insets = photosTableView.contentInset;
        insets.bottom += InfiniteScrollActivityView.defaultHeight;
        photosTableView.contentInset = insets
        
        // Do any additional setup after loading the view.
        photosTableView.delegate = self
        photosTableView.dataSource = self
        
        photosTableView.rowHeight = 240;
        
    
        refreshControl.addTarget(self, action: #selector(refreshControlAction(_:)), for: UIControlEvents.valueChanged)
        // add refresh control to table view
        photosTableView.insertSubview(refreshControl, at: 0)
        refreshControlAction(refreshControl)

    }
    
    
        func loadData(offset: String = "0", refresh: Bool = true) {
         let url = URL(string:"https://api.tumblr.com/v2/blog/humansofnewyork.tumblr.com/posts/photo?api_key=Q6vHoaVm5L1u2ZAW1fqv3Jw48gFzYVg9P0vH0VHl3GVy6quoGV")
        let request = URLRequest(url: url!)
        let session = URLSession(
            configuration: URLSessionConfiguration.default,
            delegate:nil,
            delegateQueue:OperationQueue.main
        )
        
        let task : URLSessionDataTask = session.dataTask(
            with: request as URLRequest,
            completionHandler: { (data, response, error) in
                if let data = data {
                    if let responseDictionary = try! JSONSerialization.jsonObject(
                        with: data, options:[]) as? NSDictionary {
                        //print("responseDictionary: \(responseDictionary)")
                        
                        // Recall there are two fields in the response dictionary, 'meta' and 'response'.
                        // This is how we get the 'response' field
                        let responseFieldDictionary = responseDictionary["response"] as! NSDictionary
                        
                        // This is where you will store the returned array of posts in your posts property
                        self.posts = responseFieldDictionary["posts"] as! [NSDictionary]
                        self.photosTableView.reloadData()
                        self.loadingMoreView!.stopAnimating()
                        self.isMoreDataLoading = false
                    }
                }
        });
        task.resume()
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if (!isMoreDataLoading) {
            // Calculate the position of one screen length before the bottom of the results
            let scrollViewContentHeight = photosTableView.contentSize.height
            let scrollOffsetThreshold = scrollViewContentHeight - photosTableView.bounds.size.height
            let offset = String(posts.count) as String!
            // When the user has scrolled past the threshold, start requesting
            if(scrollView.contentOffset.y > scrollOffsetThreshold && photosTableView.isDragging) {
                isMoreDataLoading = true
                let frame = CGRect(x: 0, y: photosTableView.contentSize.height, width: photosTableView.bounds.size.width, height: InfiniteScrollActivityView.defaultHeight)
                loadingMoreView?.frame = frame
                loadingMoreView!.startAnimating()
                
                loadData(offset: offset!, refresh: false)
            }
        }
    }
    
    
    
    func refreshControlAction(_ refreshControl: UIRefreshControl) {
        
        
        // Reload the tableView now that there is new data
        self.photosTableView.reloadData()
        
        // Tell the refreshControl to stop spinning
        refreshControl.endRefreshing()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("\(posts.count)")
        return posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cell = photosTableView.dequeueReusableCell(withIdentifier: "PhotoCell") as! PhotoCell
        let post = posts[indexPath.row]
        if let photos = post.value(forKeyPath: "photos") as? [NSDictionary] {
            let imageUrlString = photos[0].value(forKeyPath: "original_size.url") as? String
            if let imageUrl = URL(string: imageUrlString!) {
                cell.photoView.setImageWith(imageUrl)
                print("image set")
            } else {
            }
        } else {
        }
        
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let cell = sender as! UITableViewCell
        let indexPath = photosTableView.indexPath(for: cell)
        let post = posts[indexPath!.row]
        let detailViewController = segue.destination as! PhotoDetailsViewController
        detailViewController.photo = post
            }
        func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
