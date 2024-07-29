//
//  SearchView.swift
//  photobox
//
//  Created by 강한결 on 7/26/24.
//

import UIKit
import SnapKit

final class SearchView: BaseView, MainViewProtocol {
    var sender: ((OrderBy) -> Void)?
    
    let searchBar = UISearchBar()
    let searchFilterMenu = SearchFilterMenu()
    lazy var searchCollection = UICollectionView(frame: .zero, collectionViewLayout: setCollectionLayout())
    private let searchNoneView = UILabel()
    
    override func setSubviews() {
        super.setSubviews()
        self.addSubview(searchBar)
    }
    
    override func setLayout() {
        super.setLayout()
        
        searchBar.snp.makeConstraints { make in
            make.top.equalTo(self.safeAreaLayoutGuide)
            make.horizontalEdges.equalTo(self.safeAreaLayoutGuide).inset(8)
            make.height.equalTo(44)
        }
    }
    
    override func setUI() {
        super.setUI()
        
        searchBar.placeholder = Text.Placeholder.SEARCHFIELD.rawValue
        searchBar.searchBarStyle = .minimal
        
        setPullDownButton()
    }
    
    private func setCollectionLayout() -> UICollectionViewCompositionalLayout {
        
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(0.49), heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalWidth(0.62))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        group.interItemSpacing = NSCollectionLayoutSpacing.flexible(1.0)
        
        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = 4.0
        
        return UICollectionViewCompositionalLayout(section: section)
    }
    
    func onSearchTableView() {
        [searchFilterMenu, searchCollection].forEach {
            self.addSubview($0)
        }
        
        searchFilterMenu.snp.makeConstraints { make in
            make.top.equalTo(searchBar.snp.bottom).offset(4)
            make.horizontalEdges.equalTo(self.safeAreaLayoutGuide)
            make.height.equalTo(36)
        }
        searchCollection.snp.makeConstraints { make in
            make.top.equalTo(searchFilterMenu.snp.bottom).offset(8)
            make.horizontalEdges.equalTo(self.safeAreaLayoutGuide).inset(16)
            make.bottom.equalTo(self.safeAreaLayoutGuide)
        }
    }
    
    func onSearchNoneView() {
        self.addSubview(searchNoneView)
        searchNoneView.snp.makeConstraints { make in
            make.top.equalTo(searchBar.snp.bottom).offset(4)
            make.horizontalEdges.bottom.equalTo(self.safeAreaLayoutGuide)
        }
        
        searchNoneView.backgroundColor = .systemBackground
        searchNoneView.text = Text.Labels.LIST_NO_SEARCHED_PHOTOS.rawValue
        searchNoneView.textAlignment = .center
        searchNoneView.font = .systemFont(ofSize: 16, weight: .semibold)
    }
    
    
    private func setPullDownButton() {
        
        searchFilterMenu.setButtionTitle(for: OrderBy.relevant.byKorean)
        
        let menus = OrderBy.allCases.map { order in
            UIAction(title: order.byKorean) { [weak self] action in
                guard let self else { return }
                self.searchFilterMenu.setButtionTitle(for: order.byKorean)
                self.sender?(order)
            }
        }
       
        searchFilterMenu.sortButton.menu = UIMenu(
            identifier: nil, options: .singleSelection, children: menus)
    }
}

