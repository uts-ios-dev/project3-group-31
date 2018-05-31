//
//  ExerciseViewController.swift
//  HealthPlus
//
//  Created by Tabassum Muntarim on 30/5/18.
//  Copyright © 2018 Jack Huggart. All rights reserved.
//

import Foundation
import UIKit
import SceneKit

class ExerciseViewController : UIViewController {
    
    @IBOutlet weak var sceneView: SCNView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let scene = SCNScene()
//        let sceneView = self.view as! SCNView
        let cameraNode = SCNNode()
        cameraNode.position = SCNVector3(x: 0, y: 0, z: 10)
        let lightNode = SCNNode()
        lightNode.light = SCNLight()
        //TODO: add some working lights
        lightNode.light?.type = .ambient
        lightNode.light?.intensity = 500
        lightNode.position = SCNVector3(x: 0, y: -4, z: 1)
        scene.rootNode.addChildNode(lightNode)
        
    //    let stars = SCNParticleSystem(named: "starParticle.scnp", inDirectory: nil)!
        let human = SCNScene(named: "man.obj")!
        let humanNode = SCNNode()
        for child in human.rootNode.childNodes {
            humanNode.addChildNode(child)
        }
        humanNode.scale = SCNVector3(x: 0.05, y: 0.05, z: 0.05)
        humanNode.position = SCNVector3(x: 0, y: -4, z: 0)
        humanNode.rotation = SCNVector4(x: 180, y: 180, z: 180, w: 0)
        let bodyMaterial = SCNMaterial()
        let faceMaterial = SCNMaterial()
        let eyesMaterial = SCNMaterial()
        bodyMaterial.diffuse.contents = UIImage(named: "Man_body_diff.tga")
        faceMaterial.diffuse.contents = UIImage(named: "Man_face_diff.tga")
        eyesMaterial.diffuse.contents = UIImage(named: "Man_eyes_diff.tga")
        
        //Create the the node and apply texture

        humanNode.geometry?.materials = [bodyMaterial]
        scene.rootNode.addChildNode(humanNode)
   //     scene.rootNode.addParticleSystem(stars)
        cameraNode.camera = SCNCamera()
        cameraNode.constraints?.append(SCNLookAtConstraint(target: humanNode))
        scene.rootNode.addChildNode(cameraNode)
        sceneView.scene = scene
        sceneView.backgroundColor = UIColor.black
        sceneView.allowsCameraControl = true
        
    }
    
}
