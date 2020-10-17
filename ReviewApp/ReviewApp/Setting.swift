//
//  Setting.swift
//  ReviewApp
//
//  Created by Y on 2020/10/12.
//
import UIKit

struct SettingInfo {
    let section: Int
    let data: String
    
    init(section: Int, data: String) {
        self.section = section
        self.data = data
    }
}

class SettingViewModel {
    var settingInfos: [SettingInfo] = [
        SettingInfo(section: 0, data: "알림 설정"),
        SettingInfo(section: 0, data: "스터디day 설정"),
        SettingInfo(section: 1, data: "오픈소스"),
        SettingInfo(section: 1, data: "문의")
    ]

    enum Section: Int, CaseIterable {
        case general
        case etc
        
        var title: String {
            switch self {
            case .general: return "일반"
            default: return "기타"
            }
        }
    }

    var generalDatas: [SettingInfo] {
        return settingInfos.filter { $0.section == 0 }
    }
    
    var etcDatas: [SettingInfo] {
        return settingInfos.filter { $0.section == 1 }
    }
    
    var numOfSection: Int {
        return 2
    }
    
    var numOfGeneralData: Int {
        return generalDatas.count
    }
    
    var numOEtcData: Int {
        return etcDatas.count
    }
}

