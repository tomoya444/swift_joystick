//
//  RectangleView.swift
//  UXSDKSwiftSample
//
//  Created by Tomoya Usui on 2023/10/10.
//  Copyright © 2023 DJI. All rights reserved.
//

import UIKit
import DJISDK
import DJIUXSDK

class RectangleView: UIView {
    /*
    // アクティブトラックミッションオペレーターを取得
    var activeTrackMissionOperator = DJISDKManager.missionControl()?.activeTrackMissionOperator
    // プロパティを初期化する
    var activeTrackMission = DJIActiveTrackMission()
    var currentState: DJIActiveTrackMissionState?
    var trackingMode: DJIActiveTrackMode?
    
    var targetRect: CGRect = CGRect(x: 0, y: 0, width: 100, height: 100)
    //var targetRect: CGRect = CGRect.zero
    private var selectedCorner: CGPoint?
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupPinchGesture() // ピンチジェスチャーを設定
        setupTapGesture()
        self.isUserInteractionEnabled = true // ユーザーインタラクションを有効にする
        print("isUserInteractionEnabled: \(isUserInteractionEnabled)")
        self.isUserInteractionEnabled = true
        self.backgroundColor = UIColor.clear // 背景を透明にする
        
        
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupPinchGesture() // ピンチジェスチャーを設定
        setupTapGesture()
        self.isUserInteractionEnabled = true // ユーザーインタラクションを有効にする
    }
    
    private func commonInit() {
        self.isUserInteractionEnabled = true
        print("isUserInteractionEnabled: \(isUserInteractionEnabled)")
        self.isUserInteractionEnabled = true
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        let context = UIGraphicsGetCurrentContext()
        
        self.isUserInteractionEnabled = true
        
        
        // 四角形の描画
        context?.setStrokeColor(UIColor.red.withAlphaComponent(1.0).cgColor)
        context?.setFillColor(UIColor.clear.cgColor)  // 背景を透明に設定
        context?.setLineWidth(2.0)
        context?.addRect(targetRect)
        context?.drawPath(using: .stroke)
    }
    
    // 2本の指でのタッチを検出するためのプロパティ
    var twoFingerTouch = false
    
    // タッチジェスチャーハンドリング
    /*
     override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
     print("View Controller touchesMoved")
     if twoFingerTouch { // 2本の指でのタッチの場合
     print("touch two finger")
     if let touch = touches.first {
     let location = touch.location(in: self)
     // 四角形の位置を更新
     targetRect.origin = location
     setNeedsDisplay()
     }
     }
     }
     */
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if touches.count == 2 {
            // 2本の指でタッチしている場合
            let touchArray = Array(touches) // SetをArrayに変換
            if touchArray.count >= 2 {
                // タッチ位置を取得
                let touch1 = touchArray[0]
                let touch2 = touchArray[1]
                let location1 = touch1.location(in: self)
                let location2 = touch2.location(in: self)
                
                // 四角形の角を動かす
                targetRect.origin = CGPoint(x: min(location1.x, location2.x), y: min(location1.y, location2.y))
                targetRect.size.width = abs(location2.x - location1.x)
                targetRect.size.height = abs(location2.y - location1.y)
                
                setNeedsDisplay()
            }
        }
    }
    
    func setupTapGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTapGesture(_:)))
        self.addGestureRecognizer(tapGesture)
    }
    
    func start(_ mission: DJIActiveTrackMission?, withCompletion completion: DJICompletionBlock) {
        activeTrackMissionOperator!().start(activeTrackMission) { error in
            if let error {
                //wekReturn(target)
                //target.renderView.isDottedLine = false
                //target.renderView.updateRect(CGRectNull, fillColor: nil)
                print("Start Mission Error:%@: \(error.localizedDescription)")

            } else {
                print("Start Mission Success")
            }
            
        }
    }
    
    
    
    @objc func handleTapGesture(_ gesture: UITapGestureRecognizer) {
        // タップされた位置を取得
        let location = gesture.location(in: self)
        
        // タップされた位置を中心とした四角形のサイズを変更
        let newSize = CGSize(width: targetRect.size.width, height: targetRect.size.height) // 任意のサイズに変更
        targetRect = CGRect(origin: CGPoint(x: location.x - newSize.width / 2, y: location.y - newSize.height / 2), size: newSize)
        
        // 画面外に出ないように制限をかける（必要に応じて）
        let boundsRect = self.bounds
        targetRect.origin.x = max(boundsRect.minX, min(targetRect.origin.x, boundsRect.maxX - targetRect.width))
        targetRect.origin.y = max(boundsRect.minY, min(targetRect.origin.y, boundsRect.maxY - targetRect.height))
        
        setNeedsDisplay()
        /*
        if let currentState = currentState {
            print("Current State: \(currentState.rawValue)")
        } else {
            print("Current State is nil")
        }
         */


        if gesture.state == .ended {
            // タップ位置を取得
            let location = gesture.location(in: self)
            
            // タップ位置が四角形内であるか確認
            if targetRect.contains(location) {
                print("四角形であることを確認")
                // 四角形がタップされた場合、その位置をトラッキング対象として設定
                activeTrackMission.targetRect = targetRect
                if let currentState = currentState {
                    print("Current State: \(currentState.rawValue)")
                } else {
                    print("Current State is nil")
                }
                
                // アクティブトラックミッションを開始
                start(activeTrackMission) { error in
                    if let error = error {
                        print("アクティブトラックミッションの開始に失敗しました: \(error.localizedDescription)")
                    } else {
                        print("アクティブトラックミッションを開始しました")
                    }
                }
            }
        }
    }
    
    // ピンチジェスチャーを作成し、ビューに追加する
    func setupPinchGesture() {
        let pinchGesture = UIPinchGestureRecognizer(target: self, action: #selector(handlePinchGesture(_:)))
        self.addGestureRecognizer(pinchGesture)
    }
    
    // ピンチジェスチャーのハンドラー
    @objc func handlePinchGesture(_ gesture: UIPinchGestureRecognizer) {
        if gesture.state == .changed {
            // ピンチジェスチャーが変更されたときの処理
            let scale = gesture.scale
            // 四角形のサイズを調整
            targetRect.size.width *= scale
            targetRect.size.height *= scale
            setNeedsDisplay()
            gesture.scale = 1.0 // リセット
        }
    }
    
    
    */
}
