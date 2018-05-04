//
//  ARSKViewController.swift
//  SKViewTest
//
//  Created by Zhang xiaosong on 2018/5/4.
//  Copyright © 2018年 Zhang xiaosong. All rights reserved.
//

import UIKit
import ARKit
import SpriteKit


/// 处理ARSKView的基类

class ARSKViewController: UIViewController {
    
    var gameView: ARSKView! //场景
    var sessionConfiguration: ARConfiguration! //会话配置
    var maskView: UIView!//遮罩视图
    var alertLabel: UILabel! //提示信息

    /// MARK: - life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupInterface()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupSession()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        gameView.session.pause()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    /// MARK: - private methods
    
    /// 初始化子视图
    private func setupInterface() {
        gameView = ARSKView(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height))
        gameView.delegate = self
        gameView.showsNodeCount = true
        self.view.addSubview(gameView)
        
        let scene = SKScene(fileNamed: "GameScene.sks")
        gameView.presentScene(scene)
        
        maskView = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height))
        maskView.backgroundColor = UIColor.white
        maskView.alpha = 0.5
        self.view.addSubview(maskView)
        
        alertLabel = UILabel(frame: CGRect(x: 0, y: 20, width: self.view.frame.size.width, height: 30))
        alertLabel.textColor = UIColor.blue
        self.view.addSubview(alertLabel)
        
    }
    
    // 配置会话
    private func setupSession() {
        if ARWorldTrackingConfiguration.isSupported {//判断是否支持6个自由度
            let worldTracking = ARWorldTrackingConfiguration()
//            worldTracking.planeDetection = .//平面检测
            worldTracking.isLightEstimationEnabled = true //光估计
            sessionConfiguration = worldTracking
        }
        else{
            let orientationTracking = AROrientationTrackingConfiguration()//3DOF
            sessionConfiguration = orientationTracking
        }
        gameView.session.run(sessionConfiguration)
    }


}

// MARK: - ARSKViewDelegate

extension ARSKViewController: ARSKViewDelegate {
    
    //    MARK: 相机状态变化
    func session(_ session: ARSession, cameraDidChangeTrackingState camera: ARCamera) {
        
        //判断状态
        switch camera.trackingState{
        case .notAvailable:
            alertLabel.text = "跟踪不可用 "
            UIView.animate(withDuration: 0.5) {
                self.maskView.alpha = 0.5
            }
        case .limited(ARCamera.TrackingState.Reason.initializing):
            let title = "有限的跟踪 ，原因是："
            let desc = "正在初始化，请稍后"
            alertLabel.text = title + desc
            UIView.animate(withDuration: 0.5) {
                self.maskView.alpha = 0.5
            }
        case .limited(ARCamera.TrackingState.Reason.relocalizing):
            alertLabel.text = "有限的跟踪，原因是：重新初始化"
            UIView.animate(withDuration: 0.5) {
                self.maskView.alpha = 0.5
            }
        case .limited(ARCamera.TrackingState.Reason.excessiveMotion):
            alertLabel.text = "有限的跟踪，原因是：设备移动过快请注意"
            UIView.animate(withDuration: 0.5) {
                self.maskView.alpha = 0.5
            }
        case .limited(ARCamera.TrackingState.Reason.insufficientFeatures):
            alertLabel.text = "有限的跟踪，原因是：提取不到足够的特征点，请移动设备"
            UIView.animate(withDuration: 0.5) {
                self.maskView.alpha = 0.5
            }
        case .normal:
            alertLabel.text = "跟踪正常"
            UIView.animate(withDuration: 0.5) {
                self.maskView.alpha = 0.0
            }
            
        }
        
        
        
    }
    
    
    //    MARK: 会话被中断
    func sessionWasInterrupted(_ session: ARSession) {
        alertLabel.text = "会话中断"
    }
    
    
    //    MARK: 会话中断结束
    func sessionInterruptionEnded(_ session: ARSession) {
        alertLabel.text = "会话中断结束，已重置会话"
        gameView.session.run(self.sessionConfiguration, options: .resetTracking)
    }
    
    //    MARK: 会话失败
    func session(_ session: ARSession, didFailWithError error: Error) {
        alertLabel.text = error.localizedDescription
    }
    
}
