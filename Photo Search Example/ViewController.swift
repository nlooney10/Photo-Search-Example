//
//  ViewController.swift
//  Photo Search Example
//
//  Created by Nicholas Looney on 11/1/15.
//  Copyright © 2015 Nicholas Looney. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UISearchBarDelegate {
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchInstagramByHashtag("dog")
    }
    
    func searchInstagramByHashtag(searchString: String) {
        let manager = AFHTTPRequestOperationManager()
        
        manager.GET( "https://api.instagram.com/v1/tags/\(searchString)/media/recent?client_id=18b31b4307af420f8c364cec1eaf74a6",
            parameters: nil,
            success: { (operation: AFHTTPRequestOperation!,responseObject: AnyObject!) in
                print("JSON: " + responseObject.description)
                
//                if let data = responseObject["data"] as? [[String: AnyObject]]{
//                    for item in data {
//                        if let image = item["images"] as? [String: AnyObject]{
//                            if let standardRes = image["standard_resolution"] as? [String: AnyObject] {
//                                if let url = standardRes["url"] as? String{
//                                    print(url)
//                                }
//                            }
//                        }
//                    }
//                }
                
                // OR add urls to an array like this:
                
                if let dataArray = responseObject["data"] as? [AnyObject] {
                    var urlArray:[String] = []
                    for dataObject in dataArray {
                        if let imageURLString = dataObject.valueForKeyPath("images.standard_resolution.url") as? String {
                            urlArray.append(imageURLString)
                        }
                    }
                    let imageWidth = self.view.frame.width
                    self.scrollView.contentSize = CGSizeMake(imageWidth, imageWidth * CGFloat(dataArray.count))
                    // Display images synchronously
                    
//                    for var i = 0; i < urlArray.count; i++ {
//                        let imageData = NSData(contentsOfURL: NSURL(string: urlArray[i])!)         //1
//                        if let imageDataUnwrapped = imageData {                                    //2
//                            let imageView = UIImageView(image: UIImage(data: imageDataUnwrapped))  //3
//                            imageView.frame = CGRectMake(0, 320 * CGFloat(i), 320, 320)            //4
//                            self.scrollView.addSubview(imageView)                                  //5
//                        }
//                    }
                    // Display images asynchronously
                    
                    for var i = 0; i < urlArray.count; i++ {
                        let imageView = UIImageView(frame: CGRectMake(0, imageWidth * CGFloat(i), imageWidth, imageWidth))     //1
                        if let url = NSURL(string: urlArray[i]) {
                            imageView.setImageWithURL( url)                                             //2
                            self.scrollView.addSubview(imageView)
                        }
                    }
                }
                
            },
            failure: { (operation: AFHTTPRequestOperation?,error: NSError) in
                print("Error: " + error.localizedDescription)
        })
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        for subview in self.scrollView.subviews {
            subview.removeFromSuperview()
        }
        searchBar.resignFirstResponder()
        if var searchText = searchBar.text {
            searchText = searchText.stringByReplacingOccurrencesOfString(" ", withString: "")
            searchInstagramByHashtag(searchText)
        }
    }
    
}

