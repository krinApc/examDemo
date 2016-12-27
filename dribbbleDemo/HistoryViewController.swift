//
//  HistoryViewController.swift
//  dribbbleDemo
//
//  Created by rin on 2016/12/21.
//  Copyright © 2016年 rin. All rights reserved.
//

import UIKit
import Kingfisher
import RealmSwift

class HistoryViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var results:Results<ItemModel>? = nil
    var urlString:String = ""
    var images:Array<[String : Any]> = []
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let realm = try! Realm()
        
        results = realm.objects(ItemModel.self)
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        images = [];
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "historyDetail" {
            let nextViewController: DetailViewController = segue.destination as! DetailViewController
            nextViewController.urlString = urlString
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (results?.count)!;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "Cell"
//        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier)
//            ?? UITableViewCell(style: .subtitle, reuseIdentifier: cellIdentifier)
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: cellIdentifier)
        
        configureCell(cell: cell, atIndexPath: indexPath)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80.0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = results?[indexPath.row]
        
        urlString = ""
        if let url = item?.html_url {
            urlString = url
        }
        
        self.performSegue(withIdentifier: "historyDetail", sender: self)
    }
    
    func configureCell(cell: UITableViewCell, atIndexPath indexPath: IndexPath) {
        let item = results?[indexPath.row]
        
        cell.textLabel?.text = item?.title
        cell.detailTextLabel?.text = Utils.stringFromDate(date: (item?.read_date)!, format: "yyyy年MM月dd日 HH時mm分ss秒")
        
        if let imageUrl = item?.normal {
            
            let urlArray = images.map{$0["url"]! as! String}
            
            if urlArray.contains(imageUrl) {
                if let index = urlArray.index(of: imageUrl) {
                    let dic = images[index]
                    let image = dic["image"] as! UIImage!
                    cell.imageView?.image = image
                }
            } else {
                if let image = Utils.readImage(name: imageUrl.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.alphanumerics)!) {
                    cell.imageView?.image = image
                    
                    let dic = ["url":imageUrl, "image":image] as [String : Any]
                    images.append(dic)
                } else {
                    let url = NSURL(string: imageUrl)! as URL
                    
                    cell.imageView!.kf.setImage(with: url,
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
    }
}
