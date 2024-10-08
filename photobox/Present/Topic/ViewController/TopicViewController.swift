//
//  TopicViewController.swift
//  photobox
//
//  Created by 강한결 on 7/24/24.
//

import UIKit

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
        
        if let userImage = viewModel.userProfileImage {
            let back = UIView()
            let button = UIButton()
            back.frame = CGRect(x: 0, y: 0, width: 32, height: 32)
            button.frame = CGRect(x: 0, y: 0, width: 32, height: 32)
            back.layer.cornerRadius = 16
            back.clipsToBounds = true
            back.layer.borderColor = UIColor.primary.cgColor
            back.layer.borderWidth = 1
            button.setImage(UIImage(named: userImage), for: .normal)
            
            back.addSubview(button)
            
            button.addTarget(self, action: #selector(goToProfileConfigurePage), for: .touchUpInside)
            
            navigationItem.rightBarButtonItem = UIBarButtonItem(customView: back)
        }
    }
    
    override func bindDataAtDidLoad() {
        super.bindDataAtDidLoad()
        
        viewModel.didLoadInput.value = ()
        viewModel.didLoadOutput.binding { [weak self] output in
            guard let self else { return }
            let row = self.viewModel.selectedIndex.0
            let section = self.viewModel.selectedIndex.1
            if (output.filter { $0.count != 0 }).count != 0 {
                self.mainView.topicTable.reloadData()
            } else if row == -1 || section == -1 {
                self.mainView.topicTable.reloadData()
            } else {
                self.mainView.topicTable.reloadRows(at: [IndexPath(row: row, section: section)], with: .none)
            }
        }
    }
    
    override func bindData() {
        super.bindData()
        
        viewModel.likeButtonOutput.bindingWithoutInitCall { [weak self] output in
            guard let self else { return }
            self.genToast(for: output, state: .success)
            DispatchQueue.main.async {
                self.mainView.topicTable.reloadData()
            }
        }
        viewModel.failureOutput.bindingWithoutInitCall { [weak self] output in
            guard let self else { return }
            self.genToast(for: output, state: .error)
        }
    }
}

extension TopicViewController {
    @objc
    func goToProfileConfigurePage() {
        if let nickname = viewModel.userNickname,
           let profileImage = viewModel.userProfileImage,
           let mbtiString = viewModel.userMbti {
            
            
            let viewModel = ProfileSettingViewModel(
                isInitial: false)
            viewModel.bindUpdateValues(
                profileImageName: profileImage, nickname: nickname, mbti: mbtiString)
            let profileSettingVC = ProfileSettingViewController(
                viewModel: viewModel, mainView: ProfileSettingView()
            )
            
            navigationController?.pushViewController(profileSettingVC, animated: true)
            
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
        
        tableRefreshControl()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.didLoadOutput.value.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TopicTableCell.identifier, for: indexPath) as? TopicTableCell else { return UITableViewCell() }
        
        let collection = cell.sectionCollection
        
        cell.setSectionTitle(for: viewModel.topicTitles[indexPath.row])
        collection.delegate = self
        collection.dataSource = self
        collection.register(ImageCardItem.self, forCellWithReuseIdentifier: ImageCardItem.identifier)
        collection.tag = indexPath.row
        collection.reloadData()
        
        return cell
    }
    
    private func tableRefreshControl() {
        mainView.topicTable.refreshControl = UIRefreshControl() // control 등록
        mainView.topicTable.refreshControl?.addTarget(self, action: #selector(handlerScrollToRefresh), for: .valueChanged)
    }
    
    @objc
    private func handlerScrollToRefresh() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.mainView.topicTable.refreshControl?.endRefreshing()
            self.viewModel.didLoadInput.value = ()
        }
    }
}

extension TopicViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.didLoadOutput.value[collectionView.tag].count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let item = collectionView.dequeueReusableCell(withReuseIdentifier: ImageCardItem.identifier, for: indexPath) as? ImageCardItem else { return UICollectionViewCell() }
        
        let data = viewModel.didLoadOutput.value[collectionView.tag][indexPath.row]
        
        item.setUIWithData(for: data, showLikeCount: true)
        item.isRoundedUI()
        item.likeButtonHandler = { [weak self] in
            guard let self else { return }
            self.viewModel.selectedIndex = (collectionView.tag, indexPath.row)
            self.viewModel.likeButtonInput.value = data
        }
        
        return item
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let vm = DetailViewModel(
            networkManager: NetworkService.shared,
            repository: LikedPhotoRepository.shared,
            fileManager: FileManageService.shared
        )
        vm.didLoadInput.value = viewModel.didLoadOutput.value[collectionView.tag][indexPath.row].photoId
        
        let mv = DetailView()
        
        let detailVC = DetailViewController(viewModel: vm, mainView: mv)
        
        navigationController?.pushViewController(detailVC, animated: true)
    }
}
