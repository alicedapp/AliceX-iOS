//
//  AssetDetailViewController+Segement.swift
//  AliceX
//
//  Created by lmcmz on 4/2/20.
//  Copyright © 2020 lmcmz. All rights reserved.
//

import Foundation
import JXSegmentedView
import PromiseKit

extension AssetDetailViewController: JXPagingViewDelegate {
    func numberOfLists(in _: JXPagingView) -> Int {
        return coins.count
    }

    func tableHeaderViewHeight(in _: JXPagingView) -> Int {
        return JXTableHeaderViewHeight
    }

    func tableHeaderView(in _: JXPagingView) -> UIView {
        return userHeaderContainerView
    }

    func heightForPinSectionHeader(in _: JXPagingView) -> Int {
        return JXheightForHeaderInSection
    }

    func viewForPinSectionHeader(in _: JXPagingView) -> UIView {
        return segmentedView
    }

    func segmentedView(_: JXSegmentedView, didSelectedItemAt index: Int) {
        currentCoin = coins[index]
    }

    func segmentedView(_: JXSegmentedView, didScrollSelectedItemAt _: Int) {}

    func numberOfLists(in _: JXSegmentedListContainerView) -> Int {
        return coins.count
    }

//    func listContainerView(_: JXSegmentedListContainerView, initListAt index: Int) -> JXSegmentedListContainerViewListDelegate {
    ////        let coin = coins[index]
    ////        let vc = ListBaseViewController()
    ////        let view = AssetDetailView.instanceFromNib()
    ////        view.coin = coin
    ////        view.configure()
    ////        view.frame = CGRect(x: 0, y: 0, width: Constant.SCREEN_WIDTH - 20, height: 440)
    ////        vc.view.addSubview(view)
    ////        view.fillSuperview()
    ////        view.layoutIfNeeded()
    ////        return vc
//
//        let list = PagingListBaseView()
//        if index == 0 {
//            list.dataSource = ["橡胶火箭", "橡胶火箭炮", "橡胶机关枪", "橡胶子弹", "橡胶攻城炮", "橡胶象枪", "橡胶象枪乱打", "橡胶灰熊铳", "橡胶雷神象枪", "橡胶猿王枪", "橡胶犀·榴弹炮", "橡胶大蛇炮", "橡胶火箭", "橡胶火箭炮", "橡胶机关枪", "橡胶子弹", "橡胶攻城炮", "橡胶象枪", "橡胶象枪乱打", "橡胶灰熊铳", "橡胶雷神象枪", "橡胶猿王枪", "橡胶犀·榴弹炮", "橡胶大蛇炮"]
//        }else if index == 1 {
//            list.dataSource = ["吃烤肉", "吃鸡腿肉", "吃牛肉", "各种肉"]
//        }else {
//            list.dataSource = ["【剑士】罗罗诺亚·索隆", "【航海士】娜美", "【狙击手】乌索普", "【厨师】香吉士", "【船医】托尼托尼·乔巴", "【船匠】 弗兰奇", "【音乐家】布鲁克", "【考古学家】妮可·罗宾"]
//        }
//        list.beginFirstRefresh()
//        return list
//    }

    func pagingView(_: JXPagingView, initListAtIndex index: Int) -> JXPagingViewListViewDelegate {
        let list = PagingListBaseView()
        if index == 0 {
            list.dataSource = ["橡胶火箭", "橡胶火箭炮", "橡胶机关枪", "橡胶子弹", "橡胶攻城炮", "橡胶象枪", "橡胶象枪乱打", "橡胶灰熊铳", "橡胶雷神象枪", "橡胶猿王枪", "橡胶犀·榴弹炮", "橡胶大蛇炮", "橡胶火箭", "橡胶火箭炮", "橡胶机关枪", "橡胶子弹", "橡胶攻城炮", "橡胶象枪", "橡胶象枪乱打", "橡胶灰熊铳", "橡胶雷神象枪", "橡胶猿王枪", "橡胶犀·榴弹炮", "橡胶大蛇炮"]
        } else if index == 1 {
            list.dataSource = ["吃烤肉", "吃鸡腿肉", "吃牛肉", "各种肉"]
        } else {
            list.dataSource = ["【剑士】罗罗诺亚·索隆", "【航海士】娜美", "【狙击手】乌索普", "【厨师】香吉士", "【船医】托尼托尼·乔巴", "【船匠】 弗兰奇", "【音乐家】布鲁克", "【考古学家】妮可·罗宾"]
        }
        list.beginFirstRefresh()
        return list
    }

    func mainTableViewDidScroll(_ scrollView: UIScrollView) {
        userHeaderView?.scrollViewDidScroll(contentOffsetY: scrollView.contentOffset.y)
    }
}
