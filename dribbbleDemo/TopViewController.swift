//
//  TopViewController.swift
//  dribbbleDemo
//
//  Created by rin on 2016/12/21.
//  Copyright © 2016年 rin. All rights reserved.
//

import UIKit
import SwiftyJSON
import Kingfisher
import RealmSwift

class TopViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    var results:Array<Any> = []
    var urlString:String = ""
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let nib = UINib(nibName:"ItemCollectionViewCell", bundle: nil)
        collectionView.register(nib, forCellWithReuseIdentifier: "ItemCollectionViewCell")
        
        ApiHandler.fetchDribbble().responseJSON{response in
            if let data: AnyObject = response.result.value as AnyObject? {
                self.results = data as! Array<Any>
                self.collectionView.reloadData()
            }
            
            if let resError = response.result.error {
                print("Connection failed.\(resError.localizedDescription)")
                print("Failure:\(ApiHandler.urlPath)")
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "detail" {
            let nextViewController: DetailViewController = segue.destination as! DetailViewController
            nextViewController.urlString = urlString
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return results.count;
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell:ItemCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "ItemCollectionViewCell", for: indexPath) as! ItemCollectionViewCell
        
        configureCell(cell: cell, atIndexPath: indexPath)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (view.frame.size.width - 26) / 2
        let returnSize = CGSize(width: width, height: (width/9) * 16)
        
        return returnSize
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let item = JSON(results[indexPath.row])
        
        //add to history
        let tappedItem = ItemModel()
        
        if let imageUrl = item["images"]["normal"].string {
            tappedItem.normal = imageUrl
        }
        
        if let title = item["title"].string {
            tappedItem.title = title
        }
        
        if let avatarUrl = item["user"]["avatar_url"].string {
            tappedItem.avatar_url = avatarUrl
        }
        
        if let userName = item["user"]["name"].string {
            tappedItem.name = userName
        }
        
        urlString = ""
        if let url = item["html_url"].string {
            urlString = url
            tappedItem.html_url = url
        }
        
        tappedItem.read_date = NSDate()
        
        let realm = try! Realm()
        
        do {
            try realm.write {
                realm.add(tappedItem)
            }
        } catch {
            // Error handling...
            print("ADD ITEM FAILED")
        }
        
        self.performSegue(withIdentifier: "detail", sender: self)
    }
    
    func configureCell(cell: ItemCollectionViewCell, atIndexPath indexPath: IndexPath) {
        let item = JSON(results[indexPath.row])
        
        if let imageUrl = item["images"]["normal"].string {
            
            if let image = Utils.readImage(name: imageUrl.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.alphanumerics)!) {
                cell.thumbImageView.image = image
            } else {
                let url = NSURL(string: imageUrl)! as URL
                
                cell.thumbImageView!.kf.setImage(with: url,
                                                 placeholder: nil,
                                                 options: [.transition(ImageTransition.fade(1))],
                                                 progressBlock: { receivedSize, totalSize in
//                                                    print("\(indexPath.row + 1): \(receivedSize)/\(totalSize)")
                },
                                                 completionHandler: { image, error, cacheType, imageURL in
                                                    Utils.saveImage(image: image!, name: imageUrl.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.alphanumerics)!)

                })
            }
        }
        
        if let title = item["title"].string {
            cell.itemTitleLabel.text = title
        }
        
        if let avatarUrl = item["user"]["avatar_url"].string {
            
            if let image = Utils.readImage(name: avatarUrl.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.alphanumerics)!) {
                cell.avatarImageView.image = image
            } else {
                let url = NSURL(string: avatarUrl)! as URL
                
                cell.avatarImageView!.kf.setImage(with: url,
                                                  placeholder: nil,
                                                  options: [.transition(ImageTransition.fade(1))],
                                                  progressBlock: { receivedSize, totalSize in
//                                                    print("\(indexPath.row + 1): \(receivedSize)/\(totalSize)")
                },
                                                  completionHandler: { image, error, cacheType, imageURL in
                                                    Utils.saveImage(image: image!, name: avatarUrl.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.alphanumerics)!)
                                                    
                })
            }
        }
        
        if let userName = item["user"]["name"].string {
            cell.editorNameLabel.text = userName
        }
    }
}
