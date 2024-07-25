//
//  TopicViewController.swift
//  photobox
//
//  Created by 강한결 on 7/24/24.
//

import UIKit

final class TopicViewController: BaseViewController<TopicViewModel, TopicView> {
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func setNavigation() {
        super.setNavigation()
        title = "토픽 메인 뷰"
    }
}
