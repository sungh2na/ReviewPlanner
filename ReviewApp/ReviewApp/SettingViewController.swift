//
//  SettingViewController.swift
//  ReviewApp
//
//  Created by Y on 2020/10/11.
//

import UIKit

class SettingViewController: UIViewController {

//    @IBOutlet weak var tableView: UITableView!
    let settingViewModel = SettingViewModel()
//
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

extension SettingViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "SettingCell", for: indexPath) as? SettingCell else {
            return UITableViewCell()
        }
        var settingInfo: SettingInfo
//        if indexPath.section == 0 {
//            settingInfo = settingViewModel.generalDatas[indexPath.row]
//        } else {
//            settingInfo = settingViewModel.etcDatas[indexPath.row]
//        }
        settingInfo = settingViewModel.settingInfos[indexPath.row]

        cell.updateUI(settingInfo: settingInfo)

        return cell
    }
}

extension SettingViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("---> \(indexPath.row)")
    }
}

class SettingCell: UITableViewCell {
    @IBOutlet weak var settingData: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    func updateUI(settingInfo: SettingInfo) {
        settingData.text = settingInfo.data
    }
}
