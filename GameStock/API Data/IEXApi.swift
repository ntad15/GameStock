//
//  IEXApi.swift
//  GameStock
//
//  Created by CS3714 on 4/21/21.
//  Copyright © 2021 GameStock. All rights reserved.
//
import SwiftUI
import CoreData


import Foundation
var secretAPIToken = "sk_c0b797b55c3f43308c995a689ca8829b"
var publicAPIToken = "pk_735b57c54441439d8db9c5ccffb3e3aa"
var stockSymbols = [String]()

func api() {
    apiGetSymbols()
    //for symbol in stockSymbols {
    //    apiGetStockData(stockSymbol: symbol)
    //}
    apiGetStockData(stockSymbol: "googl")
}
func apiGetSymbols() {
    
    let apiUrl = "https://cloud.iexapis.com/ref-data/symbols?token=\(publicAPIToken)"
    
    
    let jsonDataFromApi = getJsonDataFromApi(apiUrl: apiUrl)
    
    if(jsonDataFromApi == nil){
        return
    }
    do {
        let jsonResponse = try JSONSerialization.jsonObject(with: jsonDataFromApi!,
                                                            options: JSONSerialization.ReadingOptions.mutableContainers)
        
        if let data = jsonResponse as? [[String : Any]] {
            for stock in data {
                if let symbol = stock["symbol"] {
                    stockSymbols.append(symbol as? String ?? "")
                }
            }
        }
    } catch{
        print("Failed trying to get API Data")
    }
}


func apiGetStockData(stockSymbol: String) -> StockStruct {
    let managedObjectContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    let StockEntity = Stock(context: managedObjectContext)
    let CompanyEntitry = Company(context: managedObjectContext)
    let PhotoEntity = Photo(context: managedObjectContext)
   
    //let apiUrl = "https://cloud.iexapis.com/stable/tops?token=\(publicAPIToken)&symbols=\(stockSymbol)"
    let apiUrlMain = "https://cloud.iexapis.com/stable/stock/aapl/quote/latestPrices?token=\(publicAPIToken)"
    
    let jsonDataFromApiMain = getJsonDataFromApi(apiUrl: apiUrlMain)
    
    if(jsonDataFromApiMain == nil){
        return StockStruct(id: UUID(), high: 0.0, low: 0.0, percentChange: 0.0, isMarketOpen: false, label: "", latestPrice: 0.0, primaryExchange: "", symbol: "", name: "", imgURL: "", latitude: 0.0, longitude: 0.0)
    }
    
    do {
        let jsonResponseMain = try JSONSerialization.jsonObject(with: jsonDataFromApiMain!,
                           options: JSONSerialization.ReadingOptions.mutableContainers)
        
        var high = 0.0
        var low = 0.0
        var percentChange = 0.0
        var isMarketOpen = false
        var label = ""
        var latestPrice = 0.0
        var primaryExchange = ""
        var symbol = ""
        var address = ""
        var companyName = ""
        var hqLatitude = 0.0
        var hqLongitude = 0.0
        var logoUrl = ""

        if let dataMain = jsonResponseMain as? [String : Any] {
            if let newHigh = dataMain["high"] {
                high = newHigh as? Double ?? 0.0
            }
            if let newLow = dataMain["low"] {
                low = newLow as? Double ?? 0.0
            }
            if let newPercentChange = dataMain["changePercent"] {
                percentChange = newPercentChange as? Double ?? 0.0
            }
            if let newIsMarketOpen = dataMain["isUSMarketOpen"] {
                isMarketOpen = newIsMarketOpen as? Bool ?? false
            }
            if let newLabel = dataMain["label"] {
                label = newLabel as? String ?? ""
            }
            if let newLatestPrice = dataMain["latestPrice"] {
                latestPrice = newLatestPrice as? Double ?? 0.0
            }
            if let newPrimaryExchange = dataMain["primaryExchange"] {
                primaryExchange = newPrimaryExchange as? String ?? ""
            }
            if let newSymbol = dataMain["symbol"] {
                symbol = newSymbol as? String ?? ""
            }
            
            //Retrieves necessary company info for a company core data model
            
            let apiUrlCompany = "https://cloud.iexapis.com/stable/stock/\(symbol)/company?token=\(publicAPIToken)"
            
            let jsonDataFromApiCompany = getJsonDataFromApi(apiUrl: apiUrlCompany)
            
            if(jsonDataFromApiCompany == nil){
                return StockStruct(id: UUID(), high: 0.0, low: 0.0, percentChange: 0.0, isMarketOpen: false, label: "", latestPrice: 0.0, primaryExchange: "", symbol: "", name: "", imgURL: "", latitude: 0.0, longitude: 0.0)
            }
            do {
                let jsonResponseCompany = try JSONSerialization.jsonObject(with: jsonDataFromApiCompany!,
                                   options: JSONSerialization.ReadingOptions.mutableContainers)
                
                
                
                if let dataCompany = jsonResponseCompany as? [String : Any] {
                    if let newAddress = dataCompany["address"] {
                        address = newAddress as? String ?? ""
                    }
                    if let newCompanyName = dataCompany["companyName"] {
                        companyName = newCompanyName as? String ?? ""
                    }
                }
                let mapDetails = getLatLong(addressInput: address)
                hqLatitude = mapDetails[0].latitude
                hqLongitude = mapDetails[0].longitude
                
                    
            } catch {
                print("Failed trying to get API Company Data")
            }
            
            //Retrieves the logo for the company
            
            let apiUrlLogo = "https://cloud.iexapis.com/stable/stock/\(symbol)/logo?token=\(publicAPIToken)"
            
            let jsonDataFromApiLogo = getJsonDataFromApi(apiUrl: apiUrlLogo)
            
            if(jsonDataFromApiLogo == nil){
                
                return StockStruct(id: UUID(), high: 0.0, low: 0.0, percentChange: 0.0, isMarketOpen: false, label: "", latestPrice: 0.0, primaryExchange: "", symbol: "", name: "", imgURL: "", latitude: 0.0, longitude: 0.0)
            }
            do {
                let jsonResponseLogo = try JSONSerialization.jsonObject(with: jsonDataFromApiLogo!,
                                   options: JSONSerialization.ReadingOptions.mutableContainers)
                
                
                
                if let dataLogo = jsonResponseLogo as? [String : Any] {
                    if let newLogoUrl = dataLogo["url"] {
                        logoUrl = newLogoUrl as? String ?? ""
                    }
                }
                    
            } catch {
                print("Failed trying to get API Logo Data")
            }

        }
        
        StockEntity.high = high as NSNumber
        StockEntity.low = low as NSNumber
        StockEntity.percentChange = percentChange as NSNumber
        StockEntity.isMarketOpen = isMarketOpen as NSNumber
        StockEntity.label = label
        StockEntity.latestPrice = latestPrice as NSNumber
        StockEntity.primaryExchange = primaryExchange
        StockEntity.symbol = symbol
        
        CompanyEntitry.hqLatitude = hqLatitude as NSNumber
        CompanyEntitry.hqLongitude = hqLongitude as NSNumber
        CompanyEntitry.name = companyName as String
        
        PhotoEntity.imageUrl = logoUrl
        
        StockEntity.company = CompanyEntitry
        CompanyEntitry.stock = StockEntity
        CompanyEntitry.photo = PhotoEntity
        PhotoEntity.company = CompanyEntitry
    
        let nStock = StockStruct(id: UUID(), high: high, low: low, percentChange: percentChange, isMarketOpen: isMarketOpen, label: label, latestPrice: latestPrice, primaryExchange: primaryExchange, symbol: symbol, name: companyName, imgURL: logoUrl, latitude: hqLatitude, longitude: hqLongitude)
        
        return nStock
        
        // ❎ CoreData Save operation
        do {
            try managedObjectContext.save()
        } catch {
            return StockStruct(id: UUID(), high: 0.0, low: 0.0, percentChange: 0.0, isMarketOpen: false, label: "", latestPrice: 0.0, primaryExchange: "", symbol: "", name: "", imgURL: "", latitude: 0.0, longitude: 0.0)
        }
        
        
        
        
    } catch {
        print("Failed trying to get API Main Data")
    }
    return StockStruct(id: UUID(), high: 0.0, low: 0.0, percentChange: 0.0, isMarketOpen: false, label: "", latestPrice: 0.0, primaryExchange: "", symbol: "", name: "", imgURL: "", latitude: 0.0, longitude: 0.0)
}


//func getStockItem(stockSymbol: String) {
//    let managedObjectContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
//    let StockEntity = Stock(context: managedObjectContext)
//    let CompanyEntitry = Company(context: managedObjectContext)
//    let PhotoEntity = Photo(context: managedObjectContext)
//
//    //let apiUrl = "https://cloud.iexapis.com/stable/tops?token=\(publicAPIToken)&symbols=\(stockSymbol)"
//    let apiUrlMain = "https://cloud.iexapis.com/stable/stock/aapl/quote/latestPrices?token=\(publicAPIToken)"
//
//    let jsonDataFromApiMain = getJsonDataFromApi(apiUrl: apiUrlMain)
//
//    if(jsonDataFromApiMain == nil){
//        return
//    }
//
//    do {
//        let jsonResponseMain = try JSONSerialization.jsonObject(with: jsonDataFromApiMain!,
//                           options: JSONSerialization.ReadingOptions.mutableContainers)
//
//        var high = 0.0
//        var low = 0.0
//        var percentChange = 0.0
//        var isMarketOpen = false
//        var label = ""
//        var latestPrice = 0.0
//        var primaryExchange = ""
//        var symbol = ""
//        var address = ""
//        var companyName = ""
//        var hqLatitude = 0.0
//        var hqLongitude = 0.0
//        var logoUrl = ""
//
//        if let dataMain = jsonResponseMain as? [String : Any] {
//            if let newHigh = dataMain["high"] {
//                high = newHigh as? Double ?? 0.0
//            }
//            if let newLow = dataMain["low"] {
//                low = newLow as? Double ?? 0.0
//            }
//            if let newPercentChange = dataMain["changePercent"] {
//                percentChange = newPercentChange as? Double ?? 0.0
//            }
//            if let newIsMarketOpen = dataMain["isUSMarketOpen"] {
//                isMarketOpen = newIsMarketOpen as? Bool ?? false
//            }
//            if let newLabel = dataMain["label"] {
//                label = newLabel as? String ?? ""
//            }
//            if let newLatestPrice = dataMain["latestPrice"] {
//                latestPrice = newLatestPrice as? Double ?? 0.0
//            }
//            if let newPrimaryExchange = dataMain["primaryExchange"] {
//                primaryExchange = newPrimaryExchange as? String ?? ""
//            }
//            if let newSymbol = dataMain["symbol"] {
//                symbol = newSymbol as? String ?? ""
//            }
//
//            //Retrieves necessary company info for a company core data model
//
//            let apiUrlCompany = "https://cloud.iexapis.com/stable/stock/\(symbol)/company?token=\(publicAPIToken)"
//
//            let jsonDataFromApiCompany = getJsonDataFromApi(apiUrl: apiUrlCompany)
//
//            if(jsonDataFromApiCompany == nil){
//                return
//            }
//            do {
//                let jsonResponseCompany = try JSONSerialization.jsonObject(with: jsonDataFromApiCompany!,
//                                   options: JSONSerialization.ReadingOptions.mutableContainers)
//
//
//
//                if let dataCompany = jsonResponseCompany as? [String : Any] {
//                    if let newAddress = dataCompany["address"] {
//                        address = newAddress as? String ?? ""
//                    }
//                    if let newCompanyName = dataCompany["companyName"] {
//                        companyName = newCompanyName as? String ?? ""
//                    }
//                }
//                let mapDetails = getLatLong(addressInput: address)
//                hqLatitude = mapDetails[0].latitude
//                hqLongitude = mapDetails[0].longitude
//
//
//            } catch {
//                print("Failed trying to get API Company Data")
//            }
//
//            //Retrieves the logo for the company
//
//            let apiUrlLogo = "https://cloud.iexapis.com/stable/stock/\(symbol)/logo?token=\(publicAPIToken)"
//
//            let jsonDataFromApiLogo = getJsonDataFromApi(apiUrl: apiUrlLogo)
//
//            if(jsonDataFromApiLogo == nil){
//                return
//            }
//            do {
//                let jsonResponseLogo = try JSONSerialization.jsonObject(with: jsonDataFromApiLogo!,
//                                   options: JSONSerialization.ReadingOptions.mutableContainers)
//
//
//
//                if let dataLogo = jsonResponseLogo as? [String : Any] {
//                    if let newLogoUrl = dataLogo["url"] {
//                        logoUrl = newLogoUrl as? String ?? ""
//                    }
//                }
//
//            } catch {
//                print("Failed trying to get API Logo Data")
//            }
//
//        }
//
//        StockEntity.high = high as NSNumber
//        StockEntity.low = low as NSNumber
//        StockEntity.percentChange = percentChange as NSNumber
//        StockEntity.isMarketOpen = isMarketOpen as NSNumber
//        StockEntity.label = label
//        StockEntity.latestPrice = latestPrice as NSNumber
//        StockEntity.primaryExchange = primaryExchange
//        StockEntity.symbol = symbol
//
//        CompanyEntitry.hqLatitude = hqLatitude as NSNumber
//        CompanyEntitry.hqLongitude = hqLongitude as NSNumber
//        CompanyEntitry.name = companyName as String
//
//        PhotoEntity.imageUrl = logoUrl
//
//        StockEntity.company = CompanyEntitry
//        CompanyEntitry.stock = StockEntity
//        CompanyEntitry.photo = PhotoEntity
//        PhotoEntity.company = CompanyEntitry
//
//
//
//        // ❎ CoreData Save operation
//        do {
//            try managedObjectContext.save()
//        } catch {
//            return
//        }
//
//
//
//
//    } catch {
//        print("Failed trying to get API Main Data")
//    }
//
//}
