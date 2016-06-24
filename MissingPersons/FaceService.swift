//
//  FaceService.swift
//  MissingPersons
//
//  Created by Darko Spasovski on 6/24/16.
//  Copyright © 2016 Irina Smokvarska. All rights reserved.
//

import Foundation
import ProjectOxfordFace

class FaceService {
    static let instance = FaceService()
    
    let client = MPOFaceServiceClient(subscriptionKey: "71af2282c97540e2adea3c20b725b636")
}