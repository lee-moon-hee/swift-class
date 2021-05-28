//
//  DsSql.swift
//  Swift_Sample_DID
//
//  Created by DaDa on 2021/05/18.
//

import UIKit
import SQLite3


class DaDaSql: NSObject {
    var db:OpaquePointer?
    let TABLE_NAME : String = "DaDaTable"
    
    func createTable(){
        let fileURL = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false).appendingPathComponent("DSDatabase.sqlite")
        
        
        if sqlite3_open(fileURL.path, &db) == SQLITE_OK {
//            print("db open failed")
        }
        
        let CREATE_QUERY_TEXT : String = "CREATE TABLE IF NOT EXISTS \(TABLE_NAME) (id INTEGER PRIMARY KEY AUTOINCREMENT, title TEXT, subline, date TEXT)"

        print(CREATE_QUERY_TEXT)
        if sqlite3_exec(db, CREATE_QUERY_TEXT, nil, nil, nil) != SQLITE_OK {
            let errMsg = String(cString:sqlite3_errmsg(db))
            print("db table create error : \(errMsg)")
        }
    }
    
    
    func insert(_ title : String,_ subline : String, _ date : String ){
        var stmt : OpaquePointer?
        
        let INSERT_QUERY_TEXT : String = "INSERT INTO \(TABLE_NAME) (title, subline, date) Values (?,?,?)"

        if sqlite3_prepare(db, INSERT_QUERY_TEXT, -1, &stmt, nil) != SQLITE_OK {
            let errMsg = String(cString: sqlite3_errmsg(db)!)
            print("error preparing insert:v1 \(errMsg)")
            return
        }
        
        let SQLITE_TRANSIENT = unsafeBitCast(-1, to: sqlite3_destructor_type.self)
        
        if sqlite3_bind_text(stmt, 1, title, -1, SQLITE_TRANSIENT) != SQLITE_OK{
            let errMsg = String(cString : sqlite3_errmsg(db)!)
            print("failture binding name: \(errMsg)")
            return
        }

        if sqlite3_bind_text(stmt, 2, subline, -1, SQLITE_TRANSIENT) != SQLITE_OK{
            let errMsg = String(cString : sqlite3_errmsg(db)!)
            print("failture binding name: \(errMsg)")
            return
        }

        
        if sqlite3_bind_text(stmt, 3, date, -1, SQLITE_TRANSIENT) != SQLITE_OK{
            let errMsg = String(cString : sqlite3_errmsg(db)!)
            print("failture binding name: \(errMsg)")
            return
        }
        
        if sqlite3_step(stmt) != SQLITE_DONE {
            let errMsg = String(cString : sqlite3_errmsg(db)!)
            print("insert fail :: \(errMsg)")
            return
        }
    }
    
    func selectValue(){
        
        let SELECT_QUERY = "SELECT * FROM \(TABLE_NAME)"
        var stmt:OpaquePointer?
        
        
        if sqlite3_prepare(db, SELECT_QUERY, -1, &stmt, nil) != SQLITE_OK{
            let errMsg = String(cString: sqlite3_errmsg(db)!)
            print("error preparing insert: v1\(errMsg)")
            return
        }
        
        while(sqlite3_step(stmt) == SQLITE_ROW){
            let id = sqlite3_column_int(stmt, 0)
            let title = String(cString: sqlite3_column_text(stmt, 1))
            let subline = String(cString: sqlite3_column_text(stmt, 2))
            let date = String(cString: sqlite3_column_text(stmt, 3))
        
            print("read value id : \(id) title : \(title) subline : \(subline) date : \(date)")
        }
  
    }
    
    func update(_ index:String, _ title : String,_ subline : String, _ date : String){
        let UPDATE_QUERY = "UPDATE \(TABLE_NAME) Set title = '\(title)', subline = '\(subline)', date= '\(date)' WHERE id == \(index)"
        var stmt:OpaquePointer?
        print(UPDATE_QUERY)
        if sqlite3_prepare(db, UPDATE_QUERY, -1, &stmt, nil) != SQLITE_OK{
            let errMsg = String(cString: sqlite3_errmsg(db)!)
            print("error preparing update: v1\(errMsg)")
            return
        }
        
        if sqlite3_step(stmt) != SQLITE_DONE {
            let errMsg = String(cString : sqlite3_errmsg(db)!)
            print("update fail :: \(errMsg)")
            return
        }
        
        sqlite3_finalize(stmt)
        print("update success")
               
    }
    
    func delete(_ index:String){
//        readValues()
        let DELETE_QUERY = "DELETE FROM \(TABLE_NAME) WHERE id = \(index)"
        var stmt:OpaquePointer?
        
        print(DELETE_QUERY)
        if sqlite3_prepare_v2(db, DELETE_QUERY, -1, &stmt, nil) != SQLITE_OK{
            let errMsg = String(cString: sqlite3_errmsg(db)!)
            print("error preparing delete: v1\(errMsg)")
            return
        }
        
        if sqlite3_step(stmt) != SQLITE_DONE {
            let errMsg = String(cString : sqlite3_errmsg(db)!)
            print("delete fail :: \(errMsg)")
            return
        }
        sqlite3_finalize(stmt)
                
    }
}
