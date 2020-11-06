//
//  TableViewController.swift
//  StockUpdate
//
//  Created by Ashisish on 10/8/20.
//

import UIKit
import SwiftSpinner
import Alamofire
import SwiftyJSON
import RealmSwift

class TableViewController: UITableViewController, UISearchBarDelegate {

    var textField = UITextField()
    var arr = [StockData]()
    var search = [StockData]()
    
    @IBOutlet var tblView: UITableView!
    
    let refresh = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        arr.append( StockData(symbol: "AAPL", price: -1, volume: 800779844))
//        arr.append( StockData(symbol: "AMZN", price: -1, volume: 3081230))
//        arr.append( StockData(symbol: "FB", price: -1, volume: 15796018))
//        arr.append( StockData(symbol: "MSFT", price: -1, volume: 19113992))
//        arr.append( StockData(symbol: "NFLX", price: -1, volume: 5241962))
//        arr.append( StockData(symbol: "TSLA", price: -1, volume: 39656006))
        
        if #available(iOS 10.0, *) {
            tblView.refreshControl = refresh
        } else {
            tblView.addSubview(refresh)
        }
        refresh.addTarget(self, action: #selector(refreshStockData(_:)), for: .valueChanged)
        refresh.tintColor = UIColor(red:0.25, green:0.72, blue:0.85, alpha:1.0)
        refresh.attributedTitle = NSAttributedString(string: "Fetching Stock Data")
        
        //refreshStocks()
        
        print(Realm.Configuration.defaultConfiguration.fileURL)
        
        LoadValuesFromDB()
    }
    
    @objc private func refreshStockData(_ sender: Any) {
        // Fetch stock Data
        refreshStocks()
    }

    
    
    
    func refreshStocks() {
        
        let url = GetURL()
        getStockValue(stockURL: url)
        
        
    }
    
    func getStockValue(stockURL : String!)  {
        //SwiftSpinner.show("Getting Stock Values")
        AF.request(stockURL).responseJSON {(response) in
            //SwiftSpinner.hide()
            self.refresh.endRefreshing()
            if response.error == nil{
                guard let jsonString = response.data else { return }
                
                guard let stockJSON: [JSON] = JSON(jsonString).array else { return }
                
                if stockJSON.count < 1 { return }
                
                self.arr.removeAll()
                self.search.removeAll()
                for stock in stockJSON {
                    guard let symbol = stock["symbol"].rawString() else { return }
                    guard let price = stock["price"].double  else { return }
                    guard let volume = stock["volume"].int64  else { return }

                    self.arr.append(StockData(symbol: symbol, price: price, volume: volume))
                }
                self.search = self.arr
                
                DispatchQueue.main.async{
                    self.tblView.reloadData()
                }
                
            }
        }
    }
    
    func GetURL() -> String{
            
        let realm = try! Realm()
        let stocks = realm.objects(StockData.self)
        if(stocks.count == 0 ){
            return ""
        }
            
        var url = "https://financialmodelingprep.com/api/v3/quote-short/"
        for stock in stocks{
            url.append(stock.symbol + ",")
        }
        url = String(url.dropLast())
        url.append("?apikey=\(apiKey)")
        return url
    }
    
    
    
    func getStockURL() -> String {
       // var url = "\(apiURL)\(stockName)?apikey=\(apiKey)"
        var url = apiURL
        
        for stock in arr {
            url.append("\(stock.symbol!),")
        }
        url = String(url.dropLast())
        url.append("?apikey=\(apiKey)")
        return url
        
    }


    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arr.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = Bundle.main.loadNibNamed("TableViewCell", owner: self, options: nil)?.first as! TableViewCell
        
        cell.lblStockName.text = arr[indexPath.row].symbol
        cell.lblStockPrice.text = "\(arr[indexPath.row].price)"


        return cell
    }
    
    func DeleteStockFromDB(stock: StockData){
        let realm = try! Realm()
         try! realm.write {
            realm.delete(stock)
        }
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let stock = arr[indexPath.row]
            DeleteStockFromDB(stock: stock)
            arr.remove(at: indexPath.row)
            search.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    @IBAction func AddStock(_ sender: Any) {
        
        let alert = UIAlertController(title: "Add Stock", message: "Type Stock Symbol", preferredStyle: .alert)
                           
        let OK = UIAlertAction(title: "OK", style: .default) { (action) in
            
            let symbol = self.textField.text!
            // if stock is already added
            if(self.IsStockAdded(symbol: symbol)){
                return
            }
            
            self.GetStockValue(symbol: symbol)
            
        }
                   
        let Cancel = UIAlertAction(title: "Cancel", style: .cancel) { (action) in
            print("Cancel Pressed")
        }
                   
        alert.addTextField { (addTextField) in
            addTextField.placeholder = "Stock Symbol"
            self.textField = addTextField
        }
        alert.addAction(Cancel)
        alert.addAction(OK)
               
                   
        self.present(alert, animated: true, completion: nil)
        
    }
    
    func IsStockAdded(symbol: String) -> Bool{
        let realm = try! Realm()
        if realm.object(ofType: StockData.self, forPrimaryKey: symbol) != nil{
            return true
        }
       return false
    }
    
    func LoadValuesFromDB(){
        do{
            let realm = try Realm()
            let stocks = realm.objects(StockData.self)
            
            for stock in stocks{
                arr.append(stock)
            }
            search = arr

        }catch{
            print("Error in Loading \(error)")
        }
    }
    
    func AddStockToDB(stock: StockData){
        do{
            let realm = try Realm()
            try realm.write {
                realm.add(stock, update: Realm.UpdatePolicy.all)
            }

        }catch{
            print("Error in Adding Stock to DB \(error)")
        }
    }
    
    func GetStockValue(symbol: String){
            
        let url = "https://financialmodelingprep.com/api/v3/quote-short/\(symbol)?apikey=\(apiKey)"
        print(url)
        AF.request(url).responseJSON { (response) in
            if response.error == nil{
                let stockJSON: JSON = JSON(response.data!)
                print(stockJSON)
                let result = stockJSON[0]["symbol"].rawString()
                if result! == "null" {
                    return
                }
                
                let stock = StockData()
                stock.symbol = stockJSON[0]["symbol"].rawString()!
                stock.price = stockJSON[0]["price"].double!
                //stock.companyInfo = ""
                self.arr.append(stock)
                self.search = self.arr
                self.AddStockToDB(stock: stock)
                self.tableView.reloadData()
                
            
            }
            
        }
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        guard !searchBar.text!.isEmpty else {
            arr = search
            tableView.reloadData()
            return
        }
        
        arr = search.filter({ (stock) -> Bool in
            stock.symbol.lowercased().contains(searchText.lowercased())
        })
        tableView.reloadData()
    }

    

}
