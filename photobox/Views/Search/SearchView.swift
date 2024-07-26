//
//  SearchView.swift
//  photobox
//
//  Created by 강한결 on 7/26/24.
//

import UIKit
import SnapKit

final class SearchView: BaseView, MainViewProtocol {
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
        
        searchBar.placeholder = "사진을 검색해보세요."
        searchBar.searchBarStyle = .minimal
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
        searchNoneView.text = "검색 결과가 없습니다."
        searchNoneView.textAlignment = .center
        searchNoneView.font = .systemFont(ofSize: 16, weight: .semibold)
    }
}

