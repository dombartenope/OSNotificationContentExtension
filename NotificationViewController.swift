//
//  NotificationViewController.swift
//  OSNotificationContentExtension
//
//  Created by JonF on 11/30/20.
//  Updated 2026
//  Copyright © 2020 OneSignal. All rights reserved.
//

import UIKit
import UserNotifications
import UserNotificationsUI

class NotificationViewController: UIViewController, UNNotificationContentExtension {

    @IBOutlet var collectionView: UICollectionView!
    
       var bestAttemptContent: UNMutableNotificationContent?
        
        var carouselImages : [String] = [String]()
        var currentIndex : Int = 0
        
        override func viewDidLoad() {
            super.viewDidLoad()
            // Do any required interface initialization here.
            print("viewDidLoad")
            self.collectionView.delegate = self
            self.collectionView.dataSource = self
            self.collectionView.contentInset = UIEdgeInsets(top: 10.0, left: 10.0, bottom: 10.0, right: 10.0)
            
        }
        
        override func viewWillAppear(_ animated: Bool) {
            super.viewWillAppear(animated)
            print("viewWillAppear")
        }
        
        override func viewDidAppear(_ animated: Bool) {
            super.viewDidAppear(animated)
            print("viewDidAppear")
        }
        
        struct OSCustomNotification {
            let a: AnyHashable
            let i: String
        }
     
        func didReceive(_ notification: UNNotification) {
            
            self.bestAttemptContent = (notification.request.content.mutableCopy() as? UNMutableNotificationContent)
            
            if let bestAttemptContent =  bestAttemptContent {
                
                if let customOSData = bestAttemptContent.userInfo["custom"] as? NSDictionary{
                    if let additionalData = customOSData["a"] as? NSDictionary{
                        if let carouselImagesURLs = additionalData["images"] as? String {
                            let list = carouselImagesURLs.components(separatedBy: ",")
                            self.carouselImages = list
                            DispatchQueue.main.async {
                                self.collectionView.reloadData()
                            }
                        }
                    }
                }
            }
        }
        
        func didReceive(_ response: UNNotificationResponse, completionHandler completion: @escaping (UNNotificationContentExtensionResponseOption) -> Void) {
            // DEBUG: Update notification title to confirm NCE action handler is firing
            if response.actionIdentifier == "OSNotificationCarousel.next" {
                self.scrollNextItem()
                // self.updateDebugTitle(action: "NEXT")
                completion(UNNotificationContentExtensionResponseOption.doNotDismiss)
            }else if response.actionIdentifier == "OSNotificationCarousel.previous" {
                self.scrollPreviousItem()
                // self.updateDebugTitle(action: "PREV")
                completion(UNNotificationContentExtensionResponseOption.doNotDismiss)
            }else {
                completion(UNNotificationContentExtensionResponseOption.dismissAndForwardAction)
            }
        }

        // DEBUG: Overlay label showing action + index to verify the NCE is handling button taps
        // private lazy var debugLabel: UILabel = {
        //     let label = UILabel()
        //     label.translatesAutoresizingMaskIntoConstraints = false
        //     label.backgroundColor = UIColor.black.withAlphaComponent(0.7)
        //     label.textColor = .white
        //     label.textAlignment = .center
        //     label.font = UIFont.boldSystemFont(ofSize: 14)
        //     label.numberOfLines = 2
        //     label.layer.cornerRadius = 8
        //     label.clipsToBounds = true
        //     self.view.addSubview(label)
        //     NSLayoutConstraint.activate([
        //         label.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 10),
        //         label.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -10),
        //         label.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -10),
        //         label.heightAnchor.constraint(equalToConstant: 44)
        //     ])
        //     return label
        // }()

        // private func updateDebugTitle(action: String) {
        //     let offsetX = self.collectionView.contentOffset.x
        //     debugLabel.text = "\(action) → Image \(self.currentIndex + 1)/\(self.carouselImages.count) | offset.x: \(Int(offsetX))"
        // }
        
    //Current Index
        // Changed: Removed dynamic contentInset mutations that shifted content mid-scroll.
        // Changed: Use .centeredHorizontally so the target cell lands centered regardless of direction.
        private func scrollNextItem(){
            self.currentIndex == (self.carouselImages.count - 1) ? (self.currentIndex = 0) : ( self.currentIndex += 1 )
            let indexPath = IndexPath(row: self.currentIndex, section: 0)
            self.collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        }

        private func scrollPreviousItem(){
            self.currentIndex == 0 ? (self.currentIndex = self.carouselImages.count - 1) : ( self.currentIndex -= 1 )
            let indexPath = IndexPath(row: self.currentIndex, section: 0)
            self.collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        }
        
    }

    extension NotificationViewController : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
        
        //MARK: UICollectionViewDelegate
        
        func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
            
        }
        
        func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
            
        }
        
        //MARK: UICollectionViewDataSource
        
        func numberOfSections(in collectionView: UICollectionView) -> Int {
            return 1
        }
        
        func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
            
            return self.carouselImages.count
        }
        
        func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            
            let identifier = "CarouselNotificationCell"
            self.collectionView.register(UINib(nibName: identifier, bundle: nil), forCellWithReuseIdentifier: identifier)
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath) as! CarouselNotificationCell
            let imagePath = self.carouselImages[indexPath.row]
            cell.configure(imagePath: imagePath)
            cell.layer.cornerRadius = 8.0
            return cell
        }
        
        // Changed: Uniform cell size so scrollToItem lands consistently for every item.
        func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
            let width = self.collectionView.frame.width
            return CGSize(width: width - 20.0, height: width - 20.0)
        }
        
    }
