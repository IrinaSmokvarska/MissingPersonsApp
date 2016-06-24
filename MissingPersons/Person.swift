//
//  Person.swift
//  MissingPersons
//
//  Created by Darko Spasovski on 6/24/16.
//  Copyright © 2016 Irina Smokvarska. All rights reserved.
//

import UIKit
import ProjectOxfordFace

class Person {
    var faceId: String?
    var personImage: UIImage?
    var personImageUrl: String?
    var isSelected: Bool!
    
    init(personImageUrl: String) {
        self.personImageUrl = personImageUrl
        isSelected = false
    }
    
    func downloadFaceId() {
        if let img = personImage, let imgData = UIImageJPEGRepresentation(img, 0.8) {
            FaceService.instance.client.detectWithData(imgData, returnFaceId: true, returnFaceLandmarks: false, returnFaceAttributes: nil, completionBlock: { (faces:[MPOFace]!, err:NSError!) in
           
            
            if err == nil {
                var faceId: String?
                for face in faces {
                    faceId = face.faceId
                    print("Face Id: \(faceId)")
                    break
                }
                
                self.faceId = faceId
            }
                 })
            
        }
    }
}