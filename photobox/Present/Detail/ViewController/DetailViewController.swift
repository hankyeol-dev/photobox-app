//
//  DetailViewController.swift
//  photobox
//
//  Created by 강한결 on 7/27/24.
//

import UIKit

final class DetailViewController: BaseViewController<DetailViewModel, DetailView> {
    override func loadView() {
        self.view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mainView.detailOwnerView.likeButton.addTarget(self, action: #selector(onTouchLikebutton), for: .touchUpInside)
    }
    
    override func bindData() {
        super.bindData()
        
        viewModel.didLoadOutput.binding { [weak self] output in
            guard let self else { return }
            
            if let output {
                mainView.bindView(for: output.photo)
                mainView.detailOwnerView.bindView(for: output)
            }
        }
    }
    
    @objc
    func onTouchLikebutton() {
        viewModel.likeButtonInput.value = ()
    }
}

