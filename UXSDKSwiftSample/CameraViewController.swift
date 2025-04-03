//
//  CameraViewController.swift
//  UXSDKSwiftSample
//
//  Created by Tomoya Usui on 2023/10/10.
//  Copyright © 2023 DJI. All rights reserved.
//

import UIKit
import DJIUXSDK

class CameraViewController: DUXDefaultLayoutViewController {
    var cameraView: DUXDefaultLayoutViewController?

    override func viewDidLoad() {
        super.viewDidLoad()
        // カメラビューを作成
        cameraView = DUXDefaultLayoutViewController()
        
        // カメラビューを表示
        addChild(cameraView!)
        view.addSubview(cameraView!.view)
        cameraView!.didMove(toParent: self)
    }
}
