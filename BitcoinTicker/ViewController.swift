//
//  ViewController.swift
//  BitcoinTicker
//
//  Created by Angela Yu on 23/01/2016.
//  Copyright © 2016 London App Brewery. All rights reserved.
//

import Foundation
import UIKit
import Alamofire
import SwiftyJSON

class ViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    
    let baseURL = "https://apiv2.bitcoinaverage.com/indices/global/ticker/BTC"
    let currencyArray = ["AUD", "BRL","CAD","CNY","EUR","GBP","HKD","IDR","ILS","INR","JPY","MXN","NOK","NZD","PLN","RON","RUB","SEK","SGD","USD","ZAR"]
    var finalURL = ""
    let currencySymbol = ["$", "R$", "$", "¥", "€", "£", "$", "Rp", "₪", "₹", "¥", "$", "kr", "$", "zł", "lei", "₽", "kr", "$", "$", "R"]

    //Pre-setup IBOutlets
    @IBOutlet weak var bitcoinPriceLabel: UILabel!
    @IBOutlet weak var currencyPicker: UIPickerView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        currencyPicker.delegate = self
        currencyPicker.dataSource = self
        finalURL = baseURL + currencyArray[0]
        getBitcoinPrice(url: finalURL, index: 0)
    }
    
    //MARK: - Networking
    //    /***************************************************************/
    func getBitcoinPrice(url: String, index: Int) {
        Alamofire.request(url, method: .get)
            .responseJSON { response in
                if response.result.isSuccess {
                    let priceJSON: JSON = JSON(response.result.value!)
                    print(type(of: priceJSON))
                    //Updating labelJ
                    print(priceJSON)
                    if priceJSON["last"] != JSON.null {
                        let price = priceJSON["last"].float
                        let commaPrice = self.addCommas(number: price!)
                        let text = self.currencySymbol[index] + " " + commaPrice
                        self.bitcoinPriceLabel.text = text;
                    } else {
                        self.bitcoinPriceLabel.text = "Error"
                    }
                    self.updatePrice(json: priceJSON)
                } else {
                    print("Error: \(response.result.error!)")
                    self.bitcoinPriceLabel.text = "Connection Issues"
                }
        }
    }
    
    func addCommas(number: Float) -> String {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = NumberFormatter.Style.decimal
        guard let formattedNumber = numberFormatter.string(from: NSNumber(value:number)) else {
                print("Error with adding commas")
                return String(number)
            }
        return formattedNumber
    }
    
    //    //MARK: - JSON Parsing
    //    /***************************************************************/
    func updatePrice(json: JSON){
//        if let tempResult = json["main"] {
//            //change
//        } else {
//            //there was an error
//        }
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return currencyArray.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return currencyArray[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        finalURL = baseURL + currencyArray[row]
        getBitcoinPrice(url: finalURL, index: row)
        
    }

    


//    
//    func updateWeatherData(json : JSON) {
//        
//        if let tempResult = json["main"]["temp"].double {
//        
//        weatherData.temperature = Int(round(tempResult!) - 273.15)
//        weatherData.city = json["name"].stringValue
//        weatherData.condition = json["weather"][0]["id"].intValue
//        weatherData.weatherIconName =    weatherData.updateWeatherIcon(condition: weatherData.condition)
//        }
//        
//        updateUIWithWeatherData()
//    }
//    




}

