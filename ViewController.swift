//
//  ViewController.swift
//  TestFirebase
//
//  Created by Tommy Glasser on 5/2/18.
//  Copyright © 2018 Tommy Glasser. All rights reserved.
//

import UIKit
import Firebase
import FirebaseStorage

class ViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    var db: Firestore!;
    var storage: Storage!;
    var images = [Image]()
    let cellIndentifier = "cell"
    
    
    @IBOutlet weak var CollectionView: UICollectionView!
    
    @IBOutlet weak var test: UIImageView!
    @IBOutlet weak var countLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        db = Firestore.firestore();
        storage = Storage.storage();
        DispatchQueue.main.async {
            self.loadData()
        }
        
        // self.CollectionView.register(UINib(nibName: "CollectionViewCell", bundle: nil), forCellWithReuseIdentifier: cellIndentifier)
        self.CollectionView.dataSource = self;
        self.CollectionView.delegate = self;
        
        
        // Do any additional setup after loading the view, typically from a nib.
        
        
    }
    
    override func viewDidLayoutSubviews() {
        CollectionView.reloadData()
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.images.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! CollectionViewCell
        
        
        cell.ImageView.image = images[indexPath.row].ImageView
        cell.ImageLabel.text = images[indexPath.row].ImageName
        return cell
    }
    
    func loadData() {
        let userRef = db.collection("Sitting Poses");
        userRef.getDocuments() { (querySnapshot, err) in
            
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    var name = "";
                    var image: UIImage? = nil;
                    
                    let url = document.get(field: "url") as? String
                    
                    let storageRef = self.storage.reference(forURL: url!)
                    print(storageRef.name)
                    name = storageRef.name
                    storageRef.getData(maxSize: 1 * 1024 * 1024) { data, error in
                        if let error = error {
                            print(error)
                        } else {
                            // Data for "images/island.jpg" is returned
                            // image = UIImage(data: data!)
                            // self.images.append(Image(image: image!, name: name))
                            image = UIImage(data: data!)
                            self.images.append(Image(image: image!, name: name))
                            self.test.image = image
                            self.CollectionView.reloadData()
                        }
                    }
                    
                }
                
            }
        }
    }
    
    public class Image {
        var ImageView: UIImage!;
        var ImageName: String = "";
        
        init(image: UIImage, name: String) {
            self.ImageView = image;
            self.ImageName = name;
        }
    }


}

