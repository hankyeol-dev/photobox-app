//
//  TopicViewController.swift
//  photobox
//
//  Created by 강한결 on 7/24/24.
//

import UIKit
import Toast

final class TopicViewController: BaseViewController<TopicViewModel, TopicView> {
        
    enum SectionKind: String, CaseIterable {
        case golden = "golden-hour"
        case business = "business-work"
        case architect = "architecture-interior"
    }
    
    var topicDatas: [[SearchedPhotoOutput]] = [[], [], []]
    
    
    struct ItemModel: Hashable {
        let urls: String
        let likes: Int
    }
    
    override func loadView() {
        self.view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setTable()
        Task {
            await bindingFetch()
        }
    }
    
    override func setNavigation() {
        super.setNavigation()
        
        if let userImage = UserDefaultsService.shared.getValue(for: .profileImage) {
            mainView.setUserImage(for: userImage)            
        }
    }
    
    override func bindData() {
        super.bindData()
        
        viewModel.likeButtonOutput.bindingWithoutInitCall { [weak self] output in
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
        SectionKind.allCases.enumerated().forEach { (idx, value) in
            Task {
                let output = await NetworkService.shared.fetch(by: .topic(topicName: value.rawValue), of: [Photo].self)
                switch output {
                case .success(let success):
                    topicDatas[idx] = success.map { SearchedPhotoOutput(id: $0.id, url: $0.urls.regular!, likes: $0.likes, isLiked: false) }
                    DispatchQueue.main.async {
                        self.mainView.topicTable.reloadSections(IndexSet(integer: 0), with: .none)
                    }
                case .failure(let failure):
                    print(failure)
                }
            }
        }
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
        return SectionKind.allCases.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TopicTableCell.identifier, for: indexPath) as? TopicTableCell else { return UITableViewCell() }
        
        let collection = cell.sectionCollection
        
        cell.setSectionTitle(for: SectionKind.allCases[indexPath.row].rawValue)
        collection.delegate = self
        collection.dataSource = self
        collection.register(ImageCardItem.self, forCellWithReuseIdentifier: ImageCardItem.identifier)
        collection.tag = indexPath.row
 
        return cell
    }
}

extension TopicViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return topicDatas[collectionView.tag].count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let item = collectionView.dequeueReusableCell(withReuseIdentifier: ImageCardItem.identifier, for: indexPath) as? ImageCardItem else { return UICollectionViewCell() }
        
        let data = topicDatas[collectionView.tag][indexPath.row]
        
        item.setUIWithData(for: data)
        item.likeButtonHandler = { [weak self] in
            guard let self else { return }
            self.viewModel.likeButtonInput.value = data
        }
        
        return item
    }
    
    
}
