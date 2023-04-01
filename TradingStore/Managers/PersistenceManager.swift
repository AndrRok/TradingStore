//
//  PersistenceManager.swift
//  TradingStore
//
//  Created by ARMBP on 3/23/23.
//

import Foundation
import RealmSwift

class UserRealm: Object{
    @Persisted dynamic var firstName: String
    @Persisted dynamic var lastName: String
    @Persisted dynamic var email: String
    @Persisted dynamic var imageIdentifier: String
    @Persisted dynamic var favorites: List<String>
    @Persisted dynamic var cart: List<String>
    @Persisted dynamic var idOfUser: String//primary key (not for sorting)
    override static func primaryKey() -> String? { return "idOfUser" }
}


class PersistenceManager{
    static let sharedRealm = PersistenceManager()
    private let realm = try! Realm()
    
    
    var usersList: Results<UserRealm> {return realm.objects(UserRealm.self)}//sorting
    
    func userExist(primaryKey: String) -> Bool {//check if object already exists
        return realm.object(ofType: UserRealm.self, forPrimaryKey: primaryKey) != nil
    }
    
    
    func favoriteObjectExist(primaryKey: String, imageIdentifier: String )-> Bool{
        let data = realm.object(ofType: UserRealm.self, forPrimaryKey: primaryKey)
        var array: [String] = []
        for i in data!.favorites{
            array.append(i)
        }
        return userExist(primaryKey: primaryKey) && array.contains(imageIdentifier) //{
    }
    
    
    func getUserById(primaryKey: String )-> UserRealm{
        let user = realm.object(ofType: UserRealm.self, forPrimaryKey: primaryKey)
        return user!
    }
    
    
    func addUser(firstName: String, lastName: String, email: String){
        let user = UserRealm()
        user.firstName = firstName
        user.lastName = lastName
        user.email = email
        user.idOfUser = firstName //we can use firstName+Password as primaryKey if we set password in sign in vc
        try! realm.write{ realm.add(user) }
    }
    
    
    func editUserPhoto(idUserForEdit: String, imageIdentifier: String){
        let realm = try! Realm()
        let data = realm.object(ofType: UserRealm.self, forPrimaryKey: idUserForEdit)
        if data != nil{
            try! realm.write {
                data?.imageIdentifier = imageIdentifier
            }
        }
    }
    
    
    func editUserFavorites(idUserForEdit: String, imageIdentifier: String, add: Bool){
        let realm = try! Realm()
        let data = realm.object(ofType: UserRealm.self, forPrimaryKey: idUserForEdit)
        if data != nil{
            try! realm.write {
                switch add {
                case true:
                    data?.favorites.append(imageIdentifier)
                default:
                    let index = data?.favorites.firstIndex(of: imageIdentifier)
                    data?.favorites.remove(at: index!)
                }
            }
        }
    }
    
}

