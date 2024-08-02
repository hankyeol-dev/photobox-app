//
//  DeatilView.swift
//  photobox
//
//  Created by 강한결 on 7/27/24.
//

import UIKit

import SnapKit
import Kingfisher
import DGCharts

final class DetailView: BaseView, MainViewProtocol {
    let detailOwnerView = DetailOwnerView()
    
    private let detailScroll = UIScrollView()
    private let detailContentView = UIView()
    
    let detailImage = UIImageView()
    let detailInfoBox = BoxWithTitle(for: "정보")
    
    private let chartInfoBox = BoxWithTitle(for: "차트")
    private let chartBackground = UIView()
    let chartSegment = UISegmentedControl(items: ["조회수", "다운로드수"])
    private let chartView = LineChartView()
    
    override func setSubviews() {
        super.setSubviews()
        
        [detailOwnerView, detailScroll].forEach {
            self.addSubview($0)
        }
        
        detailScroll.addSubview(detailContentView)
                
        [detailImage, detailInfoBox, chartInfoBox].forEach {
            detailContentView.addSubview($0)
        }
        
        [chartSegment, chartView].forEach {
            chartBackground.addSubview($0)
        }
    }
    
    override func setLayout() {
        super.setLayout()
        
        let guide = self.safeAreaLayoutGuide
        
        detailOwnerView.snp.makeConstraints { make in
            make.top.horizontalEdges.equalTo(guide)
            make.height.equalTo(56)
        }
        
        detailScroll.snp.makeConstraints { make in
            make.top.equalTo(detailOwnerView.snp.bottom)
            make.horizontalEdges.bottom.equalTo(guide)
            make.bottom.equalTo(guide)
        }
        
        detailContentView.snp.makeConstraints { make in
            make.width.equalToSuperview()
            make.verticalEdges.equalTo(detailScroll)
        }
        
        detailImage.snp.makeConstraints { make in
            make.top.horizontalEdges.equalTo(detailContentView.safeAreaLayoutGuide)
            make.height.lessThanOrEqualTo(500)
        }
        
        detailInfoBox.snp.makeConstraints { make in
            make.top.equalTo(detailImage.snp.bottom).offset(8)
            make.horizontalEdges.equalTo(detailContentView.safeAreaLayoutGuide)
        }
        
        chartInfoBox.snp.makeConstraints { make in
            make.top.equalTo(detailInfoBox.snp.bottom).offset(8)
            make.horizontalEdges.bottom.equalTo(detailContentView.safeAreaLayoutGuide)
        }
        
        chartSegment.snp.makeConstraints { make in
            make.height.equalTo(24)
            make.width.equalTo(180)
            make.top.equalTo(chartBackground.safeAreaLayoutGuide)
            make.leading.equalTo(chartBackground.safeAreaLayoutGuide)
        }
        
        chartView.snp.makeConstraints { make in
            make.top.equalTo(chartSegment.snp.bottom).offset(16)
            make.horizontalEdges.bottom.equalTo(chartBackground.safeAreaLayoutGuide)
            make.height.equalTo(150)
        }
    }
    
    override func setUI() {
        super.setUI()
        
        detailImage.contentMode = .scaleToFill
        chartView.noDataText = "데이터가 없습니다."
        chartView.noDataFont = .systemFont(ofSize: 13)
        chartView.noDataTextColor = .gray_lg
        chartInfoBox.setUpContentsView(by: chartBackground)
    }
    
    func bindView(for photo: Photo) {
        if let url = photo.urls.regular {
            detailImage.kf.setImage(with: URL(string: url))
        }
        
        let infoStack = UIStackView()
        infoStack.axis = .vertical
        infoStack.distribution = .fillEqually
        
        if let views = photo.views, let downloads = photo.downloads {
            let infoDatas = [
                ("크기",  String(photo.width) + "x" + String(photo.height)),
                ("조회수", String(views.formatted())),
                ("다운로드 수", String(downloads.formatted()))
            ]
            
            infoDatas.forEach {
                let item = DetailInfoItem()
                item.bindView(for: $0)
                item.snp.makeConstraints { make in
                    make.height.equalTo(24)
                }
                infoStack.addArrangedSubview(item)
            }
            
            detailInfoBox.setUpContentsView(by: infoStack)
        }
    }
    
    func bindChartView(for statistic: PhotoStatistic) {
        let chartDatas = statistic.historical.values.enumerated().map { index, data in
            ChartDataEntry(x: Double(index), y: Double(data.value))
        }
        let chartDataSet = LineChartDataSet(entries: chartDatas)
        
        setChart(for: chartDataSet, chartView: chartView)
    }
    
    private func setChart(for chartDataSet: LineChartDataSet, chartView: LineChartView) {
        chartDataSet.colors = [.systemGreen]
        chartDataSet.isDrawLineWithGradientEnabled = false
        chartDataSet.drawCircleHoleEnabled = false
        chartDataSet.drawCirclesEnabled = false
        chartDataSet.drawHorizontalHighlightIndicatorEnabled = false
        chartDataSet.drawVerticalHighlightIndicatorEnabled = false
        chartDataSet.label = nil
        chartDataSet.mode = .cubicBezier
        chartDataSet.lineWidth = 3
        chartDataSet.setColor(.systemGreen)
        chartDataSet.fillColor = .systemGreen
        chartDataSet.fillAlpha = 0.6
        chartDataSet.drawFilledEnabled = true
        
        chartView.data = LineChartData(dataSet: chartDataSet)
        chartView.animate(xAxisDuration: 0.5, easingOption: .linear)
        chartView.xAxis.labelPosition = .bottom
        chartView.xAxis.drawGridLinesBehindDataEnabled = false
        chartView.leftAxis.drawGridLinesBehindDataEnabled = false
        chartView.leftAxis.setLabelCount(5, force: true)
        chartView.rightAxis.enabled = false
        chartView.backgroundColor = .systemBackground
        chartView.doubleTapToZoomEnabled = false
    }
}
