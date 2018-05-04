//
//  ViewController.swift
//  SKViewTest
//
//  Created by Zhang xiaosong on 2018/5/4.
//  Copyright © 2018年 Zhang xiaosong. All rights reserved.
//

import UIKit
import ARKit
import SpriteKit

class ViewController: ARSKViewController {
    
    var num_index = 0
    

    /// MARK: - life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        for _ in 0..<6 {
            addRandomNumberNodeToGameScene()
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        // 获取点击坐标点
        let touch = touches.first
        // 获取场景坐标
        let gamePoint = touch?.location(in: gameView.scene!)
        // 获取屏幕坐标
//        let screenPoint = touch?.location(in: self.gameView)
        
        if let node = self.gameView.scene?.nodes(at: gamePoint!).first {
            let imageName = "num_\(num_index)"
            if imageName == node.name {
                node.removeFromParent()
                num_index += 1
            }
        }
        
    }
    
    //    MARK: - private methods

    private func addRandomNumberNodeToGameScene() {
//        x轴y轴随机渲染角度
        let random = Float((arc4random() % 100)) / 100.0

        
        let rotateX = simd_float4x4(SCNMatrix4MakeRotation(2.0 * .pi * random, 1, 0, 0))
        let rotateY = simd_float4x4(SCNMatrix4MakeRotation(2.0 * .pi * random, 0, 1, 0))
        let rotation = matrix_multiply(rotateX, rotateY)
        
        //z轴规定距离
        var translation = matrix_identity_float4x4
        translation.columns.3.z = -1.0 - random
        
        //生成位姿矩阵
        let transform = matrix_multiply(rotation, translation)
        
        //创建锚点并添加到会话中
        let anchor = ARAnchor(transform: transform)
        self.gameView.session.add(anchor: anchor)
        
    }
    
    //  MARK: - ARSKViewDelegate
    
    func view(_ view: ARSKView, nodeFor anchor: ARAnchor) -> SKNode? {
        num_index += 1
        let imageName = "num_\(num_index)"
        let node = SKSpriteNode(imageNamed: imageName)
        node.name = imageName
        if num_index == 6 {
            num_index = 1
        }
        return node
    }
    

}




