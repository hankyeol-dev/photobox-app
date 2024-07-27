//
//  TopicViewController.swift
//  photobox
//
//  Created by 강한결 on 7/24/24.
//

import UIKit
import Toast

final class TopicViewController: BaseViewController<TopicViewModel, TopicView> {
        
    override func loadView() {
        self.view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setTable()
    }
    
    override func setNavigation() {
        super.setNavigation()
        
        if let userImage = UserDefaultsService.shared.getValue(for: .profileImage) {
            mainView.setUserImage(for: userImage)            
        }
    }
    
    override func bindData() {
        super.bindData()
        viewModel.didLoadInput.value = ()
        viewModel.didLoadOutput.binding { [weak self] output in
            guard let self else { return }
            if (output.filter { $0.count != 0 }).count != 0 {
                self.mainView.topicTable.reloadData()
            }
        }
        viewModel.likeButtonOutput.bindingWithoutInitCall { [weak self] output in
            guard let self else { return }
            self.mainView.makeToast(output, duration: 1, position: .top)
            DispatchQueue.main.async {
                self.mainView.topicTable.reloadData()
            }
        }
        viewModel.failureOutput.bindingWithoutInitCall { [weak self] output in
            guard let self else { return }
            self.mainView.makeToast(output, duration: 1, position: .top)
        }
    }
}

extension TopicViewController {
    private func bindingAction() {}
    
    @objc
    func goToProfileConfigurePage() { }
    
    private func bindingFetch() async {
        
    }
}

extension TopicViewController: UITableViewDelegate, UITableViewDataSource {
    private func setTable() {
        let table = mainView.topicTable
        table.delegate = self
        table.dataSource = self
        table.register(TopicTableCell.self, forCellReuseIdentifier: TopicTableCell.identifier)
        table.rowHeight = 300
        table.separatorStyle = .none
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.didLoadOutput.value.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TopicTableCell.identifier, for: indexPath) as? TopicTableCell else { return UITableViewCell() }
        
        let collection = cell.sectionCollection
        
        cell.setSectionTitle(for: TopicViewModel.SectionKind.allCases[indexPath.row].rawValue)
        collection.delegate = self
        collection.dataSource = self
        collection.register(ImageCardItem.self, forCellWithReuseIdentifier: ImageCardItem.identifier)
        collection.tag = indexPath.row
        collection.reloadData()
 
        return cell
    }
}

extension TopicViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.didLoadOutput.value[collectionView.tag].count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let item = collectionView.dequeueReusableCell(withReuseIdentifier: ImageCardItem.identifier, for: indexPath) as? ImageCardItem else { return UICollectionViewCell() }
        
        let data = viewModel.didLoadOutput.value[collectionView.tag][indexPath.row]
        
        item.setUIWithData(for: data)
        item.likeButtonHandler = { [weak self] in
            guard let self else { return }
            self.viewModel.likeButtonInput.value = data
        }
        
        return item
    }
    
    
}
