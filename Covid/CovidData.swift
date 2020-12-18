//
//  CovidData.swift
//  Covid
//
//  Created by Jose Angel Cortes Gomez on 16/12/20.
//

import Foundation

struct CovidData: Codable {
    let country: String
    let countryInfo: CountryInfo
    let cases: Int
    let todayCases: Int
    let deaths: Int
    let todayDeaths: Int
    let recovered: Int
    let todayRecovered: Int
}

struct CountryInfo: Codable {
    let flag: String
}
