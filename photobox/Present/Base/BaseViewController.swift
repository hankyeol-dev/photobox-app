//
//  BaseViewController.swift
//  photobox
//
//  Created by 강한결 on 7/22/24.
//

import UIKit

typealias BaseViewController<VM, MV> = ViewController<VM, MV> where VM: ViewModelProtocol, MV: MainViewProtocol

class ViewController<VM, MV>: UIViewController {
    
    let viewModel: VM
    let mainView: MV
    
    init(viewModel: VM, mainView: MV) {
        self.viewModel = viewModel
        self.mainView = mainView
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        bindData()
        setNavigation()
    }
    
    func bindData() {}
    func setNavigation() {}
}

extension ViewController {
    // alert, navigation 관련
    
    func genLeftGoBackButton(target: Any?, action: Selector) -> UIBarButtonItem {
        let leftItem = UIBarButtonItem(
            image: UIImage(systemName: "chevron.left"),
            style: .plain,
            target: target,
            action: action
        )
        leftItem.tintColor = .primary
        
        return leftItem
    }
}
