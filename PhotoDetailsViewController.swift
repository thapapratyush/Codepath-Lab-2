//
//  PhotoDetailsViewController.swift
//  
//
//  Created by Pratyush Thapa on 2/9/17.
//
//

import UIKit

class PhotoDetailsViewController: UIViewController {
    @IBOutlet weak var photoImageView: UIImageView!
    
    var photo: NSDictionary!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let photos = photo["photos"] as? [NSDictionary]{
        
            let imageURLString = photos[0].value(forKeyPath: "original_size.url") as? String
            if let imageUrl = NSURL(string: imageURLString!) {
               photoImageView.setImageWith(imageUrl as URL)
            } else {
                            }
        } else {
                   }

       
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
