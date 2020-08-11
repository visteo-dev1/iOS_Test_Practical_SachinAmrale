//
//  DataModel.swift
//  iOSTestProject
//
//  Created by Sachin Amrale on 10/08/20.
//  Copyright © 2020 Sachin Amrale. All rights reserved.
//

import Foundation

struct BankDetails: Codable {
    let data: [AccountDetails]?

    private enum CodingKeys: String, CodingKey {
        case data
    }
}

struct AccountDetails: Codable {
    let allAccount: [Details]?
    let westpac: [Details]?
    let commbank: [Details]?

    private enum CodingKeys: String, CodingKey {
        case allAccount = "All accounts"
        case westpac = "Westpac"
        case commbank = "Commbank"
    }
}

struct Details: Codable {
    let title: String?
    let balance: String?
    let spentAmount: String?
    let time: String?
    let incomeAmount: String?

    private enum CodingKeys: String, CodingKey {
        case title
        case balance = "availabel_balance"
        case spentAmount = "spent_amount"
        case time
        case incomeAmount = "income_amount"
    }
}
