//
//  ViewController.swift
//  MissingPersons
//
//  Created by Darko Spasovski on 6/23/16.
//  Copyright © 2016 Irina Smokvarska. All rights reserved.
//

import UIKit
import ProjectOxfordFace

let baseURL = "http://localhost:6069/img/"

class ViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var selectedImg: UIImageView!
    @IBOutlet weak var textLabela: UILabel!
    
    var selectedPerson: Person?
    var hasSelectedImage: Bool = false
    let imagePicker = UIImagePickerController()
    


    let missingPeople = [
        Person(personImageUrl: "person1.jpg"),
        Person(personImageUrl: "person4.jpg"),
        Person(personImageUrl: "person5.jpg"),
        Person(personImageUrl: "person6.png")
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
       collectionView.delegate = self
        collectionView.dataSource = self
        imagePicker.delegate = self
        
        let tap = UITapGestureRecognizer(target: self, action: Selector("loadPicker:"))
        tap.numberOfTapsRequired = 1
        selectedImg.addGestureRecognizer(tap)
    }

  
 

    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return missingPeople.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
     // so kur da napisam ovde
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("PersonCell", forIndexPath: indexPath) as! PersonCell
        
        let person = missingPeople[indexPath.row]
        cell.configureCell(person)
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
        self.selectedPerson = missingPeople[indexPath.row]
        let cell = collectionView.cellForItemAtIndexPath(indexPath) as! PersonCell
        cell.configureCell(selectedPerson!)
        cell.setSelected()
        
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            selectedImg.image = pickedImage
            hasSelectedImage = true
        }
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func showErrorAlert() {
        let alert = UIAlertController(title: "Select Person & Image", message: "Please select a missing person to check and an image", preferredStyle: UIAlertControllerStyle.Alert)
        
        let ok = UIAlertAction(title: "OK", style: UIAlertActionStyle.Cancel, handler: nil)
        alert.addAction(ok)
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    func loadPicker(gesture: UITapGestureRecognizer) {
        imagePicker.allowsEditing = false
        imagePicker.sourceType = .PhotoLibrary // .Camera
        
        presentViewController(imagePicker, animated: true, completion: nil)
    }
    
    @IBAction func checkMatch(sender: AnyObject) {
        if selectedPerson == nil || !hasSelectedImage {
            showErrorAlert()
        } else {
            if let myImg = selectedImg.image, let imgData = UIImageJPEGRepresentation(myImg, 0.8) {
                
                FaceService.instance.client.detectWithData(imgData, returnFaceId: true, returnFaceLandmarks: false, returnFaceAttributes: nil, completionBlock: { (faces:[MPOFace]!, err: NSError!)  in
                    
                    if err == nil {
                        var faceId: String?
                        for face in faces {
                            faceId = face.faceId
                            break
                        }
                        if faceId != nil {
                            FaceService.instance.client.verifyWithFirstFaceId(self.selectedPerson?.faceId, faceId2: faceId, completionBlock: { (result:MPOVerifyResult!, err:NSError!) in
                                if err == nil {
                                print(result.confidence)
                                print(result.isIdentical)
                                print(result.debugDescription)
                                    if result.isIdentical == true {
                                        self.textLabela.text = "True"
                                    }else if result.isIdentical == false {
                                        self.textLabela.text = "False"
                                    }
                                }else {
                                    print(err.debugDescription)
                                }
                            })
                        }
                    }
                })
            }
        }
    }
    

}

