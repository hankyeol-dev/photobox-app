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
        
        bindDataAtDidLoad()
        bindAction()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        bindData()
        setNavigation()
    }
    
    func setNavigation() {}
    func bindDataAtDidLoad() {}
    func bindData() {}
    func bindAction() {}
}

extension ViewController {
   
    // navigation goBack button
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
    
    // custom toast generator
    func genToast(for message : String, state: ToastState) {
        let toast = UILabel()
        
        toast.frame = CGRect(x: 0, y: 0, width: 120, height: 36)
        toast.backgroundColor = state.stateColor
        toast.textColor = UIColor.white
        toast.font = .systemFont(ofSize: 14, weight: .semibold)
        toast.textAlignment = .center
        toast.numberOfLines = 0
        toast.text = message
        toast.layer.cornerRadius = 16
        toast.clipsToBounds  =  true
        toast.alpha = 1.0
        
        view.addSubview(toast)
        toast.snp.makeConstraints { make in
            make.bottom.equalTo(view.safeAreaLayoutGuide).inset(80)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(80)
            make.height.equalTo(44)
        }
        
        UIView.animate(withDuration: 3, delay: 0.1, options: .curveLinear, animations: {
            toast.alpha = 0.0
        }, completion: { _ in
            toast.removeFromSuperview()
        })
    }
}
