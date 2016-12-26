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
    var images:Array<[String : Any]> = []
    var avatars:Array<[String : Any]> = []
    
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
            
            let urlArray = images.map{$0["url"]! as! String}
            
            if urlArray.contains(imageUrl) {
                if let index = urlArray.index(of: imageUrl) {
                    let dic = images[index]
                    let image = dic["image"] as! UIImage!
                    cell.thumbImageView.image = image
                }
            } else {
                if let image = Utils.readImage(name: imageUrl.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.alphanumerics)!) {
                    cell.thumbImageView.image = image
                    
                    let dic = ["url":imageUrl, "image":image] as [String : Any]
                    images.append(dic)
                } else {
                    let url = NSURL(string: imageUrl)! as URL
                    
                    cell.thumbImageView!.kf.setImage(with: url,
                                                     placeholder: nil,
                                                     options: [.transition(ImageTransition.fade(1))],
                                                     progressBlock: nil,
                                                     completionHandler: { image, error, cacheType, imageURL in
                                                        Utils.saveImage(image: image!, name: imageUrl.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.alphanumerics)!)
                                                        let dic = ["url":imageUrl, "image":image!] as [String : Any]
                                                        self.images.append(dic)
                                                        
                    })
                }
            }
        }
        
        if let title = item["title"].string {
            cell.itemTitleLabel.text = title
        }
        
        if let avatarUrl = item["user"]["avatar_url"].string {
            
            let urlArray = avatars.map{$0["url"]! as! String}
            
            if urlArray.contains(avatarUrl) {
                if let index = urlArray.index(of: avatarUrl) {
                    let dic = avatars[index]
                    let image = dic["image"] as! UIImage!
                    cell.avatarImageView.image = image
                }
            } else {
                if let image = Utils.readImage(name: avatarUrl.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.alphanumerics)!) {
                    cell.avatarImageView.image = image
                    
                    let dic = ["url":avatarUrl, "image":image] as [String : Any]
                    avatars.append(dic)
                } else {
                    let url = NSURL(string: avatarUrl)! as URL
                    
                    cell.avatarImageView!.kf.setImage(with: url,
                                                      placeholder: nil,
                                                      options: [.transition(ImageTransition.fade(1))],
                                                      progressBlock: nil,
                                                      completionHandler: { image, error, cacheType, imageURL in
                                                        Utils.saveImage(image: image!, name: avatarUrl.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.alphanumerics)!)
                                                        let dic = ["url":avatarUrl, "image":image!] as [String : Any]
                                                        self.avatars.append(dic)
                                                        
                    })
                }
            }
        }
        
        if let userName = item["user"]["name"].string {
            cell.editorNameLabel.text = userName
        }
    }
}
