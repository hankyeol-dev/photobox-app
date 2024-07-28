//
//  RandomViewController.swift
//  photobox
//
//  Created by 강한결 on 7/28/24.
//

import UIKit

final class RandomViewController: BaseViewController<RandomViewModel, RandomView> {
    
    override func loadView() {
        self.view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setCollection()
    }
    
    override func setNavigation() {
        super.setNavigation()
        
        navigationController?.isNavigationBarHidden = true
    }
    
    override func bindData() {
        super.bindData()
        
        viewModel.didLoadInput.value = ()
        viewModel.didLoadOutput.binding { [weak self] _ in
            guard let self else { return }
            DispatchQueue.main.async {
                if self.viewModel.likeButtonIndex == -1 {
                    self.mainView.randomCollection.reloadData()
                } else {
                    self.mainView.randomCollection.reloadItems(at: [IndexPath(row: self.viewModel.likeButtonIndex, section: 0)])
                }
            }
        }
        viewModel.failureOutput.bindingWithoutInitCall { [weak self] message in
            guard let self else  { return }
            self.genToast(for: message, state: .error)
        }
    }
}

extension RandomViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    private func setCollection() {
        let collection = mainView.randomCollection
        
        collection.delegate = self
        collection.dataSource = self
        collection.register(RandomViewItem.self, forCellWithReuseIdentifier: RandomViewItem.identifier)
        collection.isPagingEnabled = true
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.didLoadOutput.value.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let item = collectionView.dequeueReusableCell(withReuseIdentifier: RandomViewItem.identifier, for: indexPath) as? RandomViewItem else {
            return UICollectionViewCell()
        }
        let data = viewModel.didLoadOutput.value
        
        item.setback(
            totalPage: data.count,
            page: indexPath.row,
            data: data[indexPath.row]
        )
        item.owner.likeButton.tag = indexPath.item
        item.owner.likeButton.addTarget(
            self, action: #selector(onTouchLikeButton), for: .touchUpInside)
        
        return item
    }
    
    @objc
    private func onTouchLikeButton(_ sender: UIButton) {
        print(sender.tag)
        viewModel.likeButtonTouchInput.value = sender.tag
    }
}
