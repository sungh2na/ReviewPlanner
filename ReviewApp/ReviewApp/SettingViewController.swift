//
//  SettingViewController.swift
//  ReviewApp
//
//  Created by Y on 2020/10/11.
//

import UIKit

class SettingViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    let settingViewModel = SettingViewModel()
//
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

extension SettingViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 40))      // 뷰 분리하기 어케하냐
        let lbl = UILabel(frame: CGRect(x: 15, y: 0, width: view.frame.width - 15, height: 40))
        guard let section = SettingViewModel.Section(rawValue: section) else {
            return UIView()
        }
        
        lbl.text = section.title
        view.addSubview(lbl)
        return view
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return settingViewModel.numOfSection
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return settingViewModel.generalDatas.count
        } else {
            return settingViewModel.etcDatas.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "SettingCell", for: indexPath) as? SettingCell else {
            return UITableViewCell()
        }
        var settingInfo: SettingInfo
        if indexPath.section == 0 {
            settingInfo = settingViewModel.generalDatas[indexPath.row]
        } else {
            settingInfo = settingViewModel.etcDatas[indexPath.row]
        }
//        settingInfo = settingViewModel.settingInfos[indexPath.row]

        cell.updateUI(settingInfo: settingInfo)

        return cell
    }
}

extension SettingViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("---> \(indexPath.row)")
        switch settingViewModel.generalDatas[indexPath.row].data {
        case "알림 설정" : return
        case "스터디day 설정" : return
        case "오픈소스": return
        case "문의": return
        default: return
        }
        
//        SettingInfo(section: 0, data: "알림 설정"),
//        SettingInfo(section: 0, data: "스터디day 설정"),
//        SettingInfo(section: 1, data: "오픈소스"),
//        SettingInfo(section: 1, data: "문의")
    }
}

class SettingCell: UITableViewCell {
    @IBOutlet weak var settingData: UILabel!

    func updateUI(settingInfo: SettingInfo) {
        settingData.text = settingInfo.data
    }
}
//class SettingView: UIView {
//
//}
