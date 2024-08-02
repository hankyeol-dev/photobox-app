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
        
        addActions()
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
    
    override func setNavigation() {
        super.setNavigation()
        
        navigationItem.leftBarButtonItem = genLeftGoBackButton(target: self, action: #selector(goBack))
    }
}

extension DetailViewController {
    private func addActions() {
        mainView.detailOwnerView.likeButton.addTarget(self, action: #selector(onTouchLikebutton), for: .touchUpInside)
        mainView.chartSegment.addTarget(self, action: #selector(onTouchChartSegment), for: .valueChanged)
    }
    
    @objc
    private func onTouchLikebutton() {
        viewModel.likeButtonInput.value = ()
    }
    
    @objc
    private func goBack() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc
    private func onTouchChartSegment(_ sender: UISegmentedControl) {
        guard let statisticData = viewModel.didLoadStatisticOutput.value else { return }
        if sender.selectedSegmentIndex == 0 {
            mainView.bindChartView(for: statisticData.views)
        } else {
            mainView.bindChartView(for: statisticData.downloads)
        }
    }
}
