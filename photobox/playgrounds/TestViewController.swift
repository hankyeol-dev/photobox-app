//
//  ViewController.swift
//  photobox
//
//  Created by 강한결 on 7/22/24.
//

import UIKit
import SnapKit

final class TestViewController: BaseViewController<TestViewModel, ProfileImageSelectView> {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func loadView() {
        self.view = mainView
    }
    
    override func setNavigation() {
        super.setNavigation()
        
        title = "프로필 생성하기"
    }
}
