//
//  DBtool.swift
//  learnios
//
//  Created by Jin on 4/24/18.
//


import Foundation
import FMDB
class DbTool:NSObject {
    static let sharInstance:DbTool = DbTool()
    
    func database()->FMDatabase{
        var path = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)[0]
        path = path + "/db.sqlite"
        print("datebase db.sqlite Path === " + path)
        return FMDatabase.init(path:path)
    }
    
    
    private func createTables(){
        let db = database()
        if db.open() {
            let  sql1 = "CREATE TABLE IF NOT EXISTS ACCOUNTS (id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, account TEXT,password TEXT)"
            let  sqlinit = "INSERT INTO ACCOUNTS(account,password) VALUES(\"mitnickdeng@gmail.com\",\"8401211dfj\")"
            
            do{
                try db.executeUpdate(sql1, values: nil)
                try db.executeUpdate(sqlinit, values: nil)
            }catch{
                print(db.lastErrorMessage())
            }
            db.close()
        }
        
    }
    override init() {
        super.init()
        createTables()
    }
    
    
    func addAcount(ap:AccountPassword)->Bool {
        let db = database()
        if db.open() {
            let  sql1 = "INSERT INTO ACCOUNTS(account,password) VALUES(\"\(ap.account)\",\"\(ap.password)\")"
            
            do{
                try db.executeUpdate(sql1, values: nil)
            }catch{
                print(db.lastErrorMessage())
                return false
            }
            db.close()
            return true
        }
        return false
    }
    
    func accounts()->[AccountPassword] {
        let db = database()
        if db.open() {
            let  sql = "SELECT * FROM ACCOUNTS"
            var aps:[AccountPassword] = []
            do{
                let rs = try db.executeQuery(sql, values: nil)
                while rs.next() {
                    let account  = rs.string(forColumn: "account")
                    let password = rs.string(forColumn: "password")
                    let ap = AccountPassword(account: account!, password: password!)
                    aps.append(ap)
                }
            }catch{
                print(db.lastErrorMessage())
            }
            db.close()
            return aps
        }
        return []
    }
    
    func getOneValidAccount()->AccountPassword {
        let aps = accounts()
        let random = Int(arc4random() % UInt32(aps.count))
        let ap = aps[random]
        return ap
    }
    
    
    
}

