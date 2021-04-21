//
//  MapAPIData.swift
//  GameStock
//
//  Created by Nahom  Atsbeha on 4/21/21.
//  Copyright © 2021 GameStock. All rights reserved.
//

import Foundation

var mapStructList = [MapDetails]()

var apiKey = "mm26MMKcoLqlS7TkRTPprfPvduyvw09d"

// GETS JSON DATA FROM THE API AND RETURNS DATA?

public func getJsonDataFromApi(apiUrl: String) -> Data? {
 
    var apiQueryUrlStruct: URL?
    
    if let urlStruct = URL(string: apiUrl) {
        apiQueryUrlStruct = urlStruct
    } else {
        return nil
    }
 
    let jsonData: Data?
    do {
        /*
        Try getting the JSON data from the URL and map it into virtual memory, if possible and safe.
        Option mappedIfSafe indicates that the file should be mapped into virtual memory, if possible and safe.
        */
        jsonData = try Data(contentsOf: apiQueryUrlStruct!, options: Data.ReadingOptions.mappedIfSafe)
        return jsonData
       
    } catch {
        return nil
    }
}

func getLatLong(addressInput: String) -> [MapDetails] {
        
    var searchResults = [MapDetails]()
    
    let apiQueryUrlString = "http://www.mapquestapi.com/geocoding/v1/address?key=mm26MMKcoLqlS7TkRTPprfPvduyvw09d&location=\(addressInput)"
    
    let apiQueryUrlStringFixed = apiQueryUrlString.replacingOccurrences(of: " ", with: "%20")
    
    let jsonDataFromApi = getJsonDataFromApi(apiUrl: apiQueryUrlStringFixed)
    
    if(jsonDataFromApi == nil){
        return [MapDetails]()
    }
    
    do{
        
        var location = "", lat = "", lon = ""
        
        let jsonResponse = try JSONSerialization.jsonObject(with: jsonDataFromApi!,
                                                            options: JSONSerialization.ReadingOptions.mutableContainers)
        
        var locationDataDictionary = Dictionary<String, Any>()
        
        if let jsonObject = jsonResponse as? [String: Any] {
            locationDataDictionary = jsonObject
            
            if let resultsDictionary = locationDataDictionary["results"] as? [Dictionary <String, Any>] {
                locationDic = resultsDictionary
                
                if let aDict = locationDic["locations"] as? [[Dictionary <String, Any>]]{
                    print(locationDic)
                }
                
            }
            
        }

        
    } catch{
        print("Failed trying to get API Data")
    }
    
    return searchResults
}

/*
 ["options": {
     ignoreLatLngInput = 0;
     maxResults = "-1";
     thumbMaps = 1;
 }, "info": {
     copyright =     {
         imageAltText = "\U00a9 2021 MapQuest, Inc.";
         imageUrl = "http://api.mqcdn.com/res/mqlogo.gif";
         text = "\U00a9 2021 MapQuest, Inc.";
     };
     messages =     (
     );
     statuscode = 0;
 }, "results": <__NSArrayM 0x282d2de90>(
 {
     locations =     (
                 {
             adminArea1 = US;
             adminArea1Type = Country;
             adminArea3 = VA;
             adminArea3Type = State;
             adminArea4 = Fairfax;
             adminArea4Type = County;
             adminArea5 = Alexandria;
             adminArea5Type = City;
             adminArea6 = "";
             adminArea6Type = Neighborhood;
             displayLatLng =             {
                 lat = "38.824161";
                 lng = "-77.166695";
             };
             dragPoint = 0;
             geocodeQuality = POINT;
             geocodeQualityCode = P1AAA;
             latLng =             {
                 lat = "38.824342";
                 lng = "-77.166648";
             };
             linkId = "r45810450|p197940617|n62412999";
             mapUrl = "http://www.mapquestapi.com/staticmap/v5/map?key=mm26MMKcoLqlS7TkRTPprfPvduyvw09d&type=map&size=225,160&locations=38.824342,-77.166648|marker-sm-50318A-1&scalebar=true&zoom=15&rand=-2146825495";
             postalCode = "22312-3106";
             sideOfStreet = L;
             street = "6575 Bermuda Green Ct";
             type = s;
             unknownInput = "";
         }
     );
     providedLocation =     {
         location = "6575 Bermuda Green Ct";
     };
 }
 )
 ]

 */