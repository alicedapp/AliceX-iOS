//
//  AssetTXViewController.swift
//  AliceX
//
//  Created by lmcmz on 6/2/20.
//  Copyright © 2020 lmcmz. All rights reserved.
//

import ESPullToRefresh
import PromiseKit
import SkeletonView
import UIKit

class AssetTXViewController: UIViewController {
    var tableView: UITableView!
    var listViewDidScrollCallback: ((UIScrollView) -> Void)?
    var data: [AmberdataTXModel] = []
    var page: Int = 0
    var group = [(key: DateComponents, value: [AmberdataTXModel])]()

    var coin: Coin = .coin(chain: .Ethereum)

    override init(nibName: String?, bundle: Bundle?) {
        super.init(nibName: nibName, bundle: bundle)

        tableView = UITableView(frame: view.frame, style: .plain)
        tableView.backgroundColor = UIColor.white
        tableView.tableFooterView = UIView()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UITableViewCell.classForCoder(), forCellReuseIdentifier: "cell")
        view.addSubview(tableView)
        tableView.fillSuperview()

        tableView.delegate = self
        tableView.dataSource = self
        tableView.registerCell(nibName: AssetTXCell.nameOfClass)

        tableView.separatorStyle = .none
//        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 104, right: 0)

        tableView.es.addInfiniteScrolling {
            self.requestData(page: self.page)
        }

//        view.isSkeletonable = true
//        tableView.isSkeletonable = true
        tableView.estimatedRowHeight = 70
    }

    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        if coin.isERC20 || coin == Coin.coin(chain: .Ethereum) {
            if TransactionRecordHelper.shared.list.count > 0 {
                let list = filterERC20(list: Array(TransactionRecordHelper.shared.list))
                group = groupRecordByMonth(list: list)
                tableView.reloadData()
            }
        }

        requestData(page: 0)
    }

    func requestData(page: Int) {
//        if page == 0 {
//            view.showAnimatedGradientSkeleton()
//        }

        if coin == .coin(chain: .Binance) {
            binanceTXRequestData(page: page)
            return
        }

        firstly {
            TransactionRecordHelper.shared.fetchTXHistory(page: page, blockchain: coin.blockchain)
        }.done { list in

            if list.count == 0 {
                self.tableView.es.noticeNoMoreData()
            }

            if self.coin.blockchain == .Ethereum {
                self.group = self.groupRecordByMonth(list: Array(TransactionRecordHelper.shared.list))
            } else {
                self.group = self.groupRecordByMonth(list: list)
            }

//            self.view.hideSkeleton()
            self.tableView.reloadData()
            self.page += 1
        }.ensure {
            self.tableView.es.stopLoadingMore()
//            self.view.hideSkeleton()
        }.catch { error in
            //            print("BBBB")
            print(error.localizedDescription)
        }
    }

    func groupRecordByMonth(list: [AmberdataTXModel]) -> [(key: DateComponents, value: [AmberdataTXModel])] {
        let filterList = filterERC20(list: list)

        data = filterList.compactMap { $0 }.sorted(by: { (model1, model2) -> Bool in
            guard let date1 = model1.timestamp, let date2 = model2.timestamp else {
                return true
            }
            return date1 > date2
        })

        let result = Dictionary(grouping: data) { model -> DateComponents in
            let component = Calendar.current.dateComponents([.year, .month], from: model.timestamp!)
            return component
        }.sorted(by: { (dict1, dict2) -> Bool in
            let key1 = dict1.key
            let key2 = dict2.key

            if key1.year! == key2.year! {
                return key1.month! > key2.month!
            }
            return key1.year! > key2.year!
        })
        return result
    }

    func filterERC20(list: [AmberdataTXModel]) -> [AmberdataTXModel] {
        if coin.isERC20 {
            return list.filter { model in
                guard let fromList = model.from,
                    let from = fromList.first,
                    let toList = model.to,
                    let to = toList.first else {
                    return false
                }

                if from.address.lowercased() == coin.id.lowercased() || to.address.lowercased() == coin.id.lowercased() {
                    return true
                }

                if let tokenTransfers = model.tokenTransfers, let transfer = tokenTransfers.last {
                    return transfer.tokenAddress.lowercased() == coin.id.lowercased()
                }

                return false
            }.compactMap { $0 }
        }

        return list
    }

    // TODO: Temporary Support Multiple Blockchain

    func binanceTXRequestData(page: Int) {
        let nowTime = Date().timeIntervalSince1970
        let threeMonthTime: TimeInterval = 3 * 30 * 24 * 60 * 60

        let endTime = nowTime - Double(page) * threeMonthTime
        let startTime = endTime - threeMonthTime

        firstly { () -> Promise<[BinanceTXModel?]> in
            API(BNBAPI.transactions(address: WalletCore.address(blockchain: .Binance),
                                    startTime: startTime,
                                    endTime: endTime), path: "tx")
        }.done { list in

            if list.count == 0 {
                self.tableView.es.noticeNoMoreData()
            }

            var appendList = self.data + list.compactMap { $0?.convertToAmberdata() }

            self.data = appendList.sorted(by: { (model1, model2) -> Bool in
                guard let date1 = model1.timestamp, let date2 = model2.timestamp else {
                    return true
                }
                return date1 > date2
            })

            self.group = self.groupRecordByMonth(list: self.data)

//            self.view.hideSkeleton()
            self.tableView.reloadData()
            self.page += 1
        }.ensure {
            self.tableView.es.stopLoadingMore()
//            self.view.hideSkeleton()
        }.catch { error in
            //            print("BBBB")
            print(error.localizedDescription)
        }
    }
}

extension AssetTXViewController: UIGestureRecognizerDelegate {
    func gestureRecognizer(_: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith _: UIGestureRecognizer) -> Bool {
        return true
    }
}

// extension AssetTXViewController: SkeletonTableViewDataSource {
//
//    func numSections(in collectionSkeletonView: UITableView) -> Int {
//        return group.count
//    }
//
//    func collectionSkeletonView(_ skeletonView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return group[section].value.count
//    }
//
//    func collectionSkeletonView(_ skeletonView: UITableView, cellIdentifierForRowAt indexPath: IndexPath) -> ReusableCellIdentifier {
//        return AssetTXCell.nameOfClass
//    }
// }

extension AssetTXViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in _: UITableView) -> Int {
        return group.count
    }

    func tableView(_: UITableView, heightForHeaderInSection _: Int) -> CGFloat {
        return 40
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let monthYear = group[section].key
        let months = ["None", "January", "February", "March", "April", "May", "June",
                      "July", "August", "September", "October", "November", "December"]
        let year = Calendar.current.component(.year, from: Date())

        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 40))
        headerView.backgroundColor = AliceColor.white()
        let label = UILabel()
        label.frame = CGRect(x: 15, y: 5, width: headerView.frame.width - 40, height: headerView.frame.height - 5)

        let displayYear = monthYear.year! == year ? "" : String(monthYear.year!)
        label.text = "\(months[monthYear.month!]) \(displayYear)"
        label.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        label.textColor = AliceColor.darkGrey()
        headerView.addSubview(label)
        return headerView
    }

    public func tableView(_: UITableView, numberOfRowsInSection section: Int) -> Int {
        return group[section].value.count
    }

    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: AssetTXCell.nameOfClass, for: indexPath) as! AssetTXCell
        let section = indexPath.section
        let row = indexPath.row
        let tx = group[section].value[row]
        cell.configure(model: tx, coin: coin)
        return cell
    }

    public func tableView(_: UITableView, heightForRowAt _: IndexPath) -> CGFloat {
        return 70
    }

    func tableView(_: UITableView, didSelectRowAt indexPath: IndexPath) {
        let section = indexPath.section
        let row = indexPath.row
        let tx = group[section].value[row]
        let vc = BrowserWrapperViewController.make(urlString: coin.blockchain.txURL(txHash: tx.hash).absoluteString)
        UIApplication.topViewController()?.navigationController?.pushViewController(vc, animated: true)
    }

    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        listViewDidScrollCallback?(scrollView)
    }
}

extension AssetTXViewController: JXPagingViewListViewDelegate {
    public override func listView() -> UIView {
        return view
    }

    public func listViewDidScrollCallback(callback: @escaping (UIScrollView) -> Void) {
        listViewDidScrollCallback = callback
    }

    public func listScrollView() -> UIScrollView {
        return tableView
    }
}
