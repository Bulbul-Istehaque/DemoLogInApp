//
//  DirectoryManager.swift
//  DemoApp
//
//  Created by Bul on 24/11/23.
//

import Foundation

//MARK: - DirectoryManagerDataSourceProtocol
@objc protocol DirectoryDataSourceProtocol {
    func getUserID() -> String?
}

//MARK: - DirectoryManager
@objc class DirectoryManager: NSObject {
    
    /// Singleton Object
    static let shared = DirectoryManager()
    
    @objc var dataSource: DirectoryDataSourceProtocol?
    
    private override init() {
        super.init()
    }
    
    /// Get Document Directory
    @objc func getDocumentDirectory() -> String {
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        return paths.first!
    }
    
    /// Get Directory For UserID
    
    @objc func getUserDirectory(ForUserID userID: String) -> String? {
                
        let dirPath = getDocumentDirectory()
        
        let userDir = (dirPath as NSString).appendingPathComponent(userID)
        
        let dirExists = FileManager.default.fileExists(atPath: userDir)
        
        // If directory does not exists create
        if dirExists == false {
            do {
                try FileManager.default.createDirectory(atPath: userDir, withIntermediateDirectories: true)
                
                debugPrint("Directory Creation Successful at Path = \(userDir)")
            } catch let error {
                // If directory creation fails return nil
                debugPrint("Directory Creation at Path = \(userDir) Error = \(error.localizedDescription)")
                return nil
            }
        }
        
        return userDir
    }
    
    @objc func getUserDirectory() -> String? {
        
        // If no datasource return  nil
        guard let tempDataSource = self.dataSource else { return nil }
        
        // If user has not logged in return  nil
        guard let userID = tempDataSource.getUserID(), userID.count > 0 else { return nil }
        
        return getUserDirectory(ForUserID: userID)
    }
    
}
