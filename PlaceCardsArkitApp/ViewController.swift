//
//  ViewController.swift
//  PlaceCardsArkitApp
//
//  Created by Konstantin Kalivod on 4/15/19.
//  Copyright © 2019 Kostya Kalivod. All rights reserved.
//

import UIKit
import SceneKit
import ARKit

class ViewController: UIViewController, ARSCNViewDelegate {

    @IBOutlet var sceneView: ARSCNView!
    
    var pokemonNode: SCNNode?
    var frostmourneNode: SCNNode?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the view's delegate
        sceneView.delegate = self
        
        // Show statistics such as fps and timing information
        sceneView.showsStatistics = true
        let pokemonScene = SCNScene(named: "art.scnassets/Pokemon.scn")
        let frostmourneScene = SCNScene(named: "art.scnassets/frostmourne.scn")
        pokemonNode = pokemonScene?.rootNode
        frostmourneNode = frostmourneScene?.rootNode

        // Create a new scene
        // Set the scene to the view
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARImageTrackingConfiguration()
        if let trackingImages = ARReferenceImage.referenceImages(inGroupNamed: "Cards", bundle: Bundle.main){
            configuration.trackingImages = trackingImages
            configuration.maximumNumberOfTrackedImages = 2
        }
        // Run the view's session
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }

    func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
        let node = SCNNode()
        
        if let imageAnchor = anchor as? ARImageAnchor {
            let size = imageAnchor.referenceImage.physicalSize
            let plane = SCNPlane(width: size.width, height: size.height)
            plane.firstMaterial?.diffuse.contents = UIColor.white.withAlphaComponent(0.5)
            plane.cornerRadius = 0.005
            let planeNode = SCNNode(geometry: plane)
            planeNode.eulerAngles.x = -.pi / 2
            node.addChildNode(planeNode)
            var shapeNode : SCNNode?
            switch imageAnchor.referenceImage.name {
            case CardsType.blackJoker.rawValue:
                shapeNode = frostmourneNode
                shapeNode?.scale = SCNVector3(0.001, 0.001, 0.001)
            case CardsType.colorJoker.rawValue:
                shapeNode = pokemonNode
                shapeNode?.scale = SCNVector3(3, 3, 3)
            default:
                break
            }
            let shapeSpin = SCNAction.rotateBy(x: 0, y: 2 * .pi, z: 0, duration: 10)
            let reapeatSpin = SCNAction.repeatForever(shapeSpin)
            shapeNode?.runAction(reapeatSpin)
            guard let shape = shapeNode else { return nil }
            node.addChildNode(shape)
        }
    return node
    }
    
    enum CardsType : String{
        case blackJoker = "BlackJoker"
        case colorJoker = "ColorJoker"
    }
}
