//
//  SQLiteTool.swift
//  NiuGeYinSwift
//
//  Created by lujianqiao on 2018/8/10.
//  Copyright © 2018年 NGY. All rights reserved.
//

import Foundation
import SQLite
import AudioToolbox

class SQLiteTool {
    
    static let shared = SQLiteTool()
    var db: Connection!
    
    let TABLE_LAMP = Table("table_lamp") // 表名称
    let TABLE_LAMP_ID = Expression<Int64>("lamp_id") // 列表项及项类型
    
    //商品信息
    let TABLE_goods_id = Expression<Int64>("goods_id")
    let TABLE_goods_name = Expression<String>("goods_name")
    let TABLE_unit_price = Expression<Double>("unit_price")
    let TABLE_thumbnail = Expression<String>("thumbnail")
    let TABLE_amount = Expression<Int64>("amount")
    
    private init() {
        // 单例模式，防止出现多个实例
        connectDatabase()
        tableLampCreate()
    }
    
    private func connectDatabase(filePath: String = "/Documents") -> Void {
        
        let sqlFilePath = NSHomeDirectory() + filePath + "/db.sqlite3"
        
        do { // 与数据库建立连接
            db = try Connection(sqlFilePath)
            print("与数据库建立连接 成功")
        } catch {
            print("与数据库建立连接 失败：\(error)")
        }
        
    }
    
    
    
   private func tableLampCreate() -> Void {
        do { // 创建表TABLE_LAMP
            try db.run(TABLE_LAMP.create { table in
                table.column(TABLE_LAMP_ID, primaryKey: .autoincrement) // 主键自加且不为空
                
                table.column(TABLE_goods_id)
                table.column(TABLE_goods_name)
                table.column(TABLE_unit_price)
                table.column(TABLE_thumbnail)
                table.column(TABLE_amount)

            })
            print("创建表 TABLE_LAMP 成功")
        } catch {
            print("创建表 TABLE_LAMP 失败：\(error)")
        }
    }
    
    // 插入
    private func tableLampInsertItem(goods_id: Int64, goods_name: String, unit_price: Double, thumbnail:String, amount:Int64) -> Bool {
        let insert = TABLE_LAMP.insert(TABLE_goods_id <- goods_id, TABLE_goods_name <- goods_name, TABLE_unit_price <- unit_price, TABLE_thumbnail <- thumbnail, TABLE_amount <- amount)
        do {
            let rowid = try db.run(insert)
            print("插入数据成功 id: \(rowid)")
            return true
        } catch {
            print("插入数据失败: \(error)")
            return false
        }
    }
    
    // 遍历
    private func queryTableLamp() -> Array<CartGoodsModel> {
        
        var dataArr = [CartGoodsModel]()
        
        
        for item in (try! db.prepare(TABLE_LAMP)) {
            
            let model = CartGoodsModel()
            model.goods_id = item[TABLE_goods_id]
            model.goods_name = item[TABLE_goods_name]
            model.unit_price = item[TABLE_unit_price]
            model.thumbnail = item[TABLE_thumbnail]
            model.amount = item[TABLE_amount]
            dataArr.append(model)
        }
        
        return dataArr
    }
    // 读取
    private func readTableLampItem(goods_id: Int64) -> CartGoodsModel {
        
        var dataArr = [CartGoodsModel]()
        
        for item in try! db.prepare(TABLE_LAMP.filter(TABLE_goods_id == goods_id)) {
            
            let model = CartGoodsModel()
            model.goods_id = item[TABLE_goods_id]
            model.goods_name = item[TABLE_goods_name]
            model.unit_price = item[TABLE_unit_price]
            model.thumbnail = item[TABLE_thumbnail]
            model.amount = item[TABLE_amount]
            
            dataArr.append(model)
            
        }
        
        if dataArr.count>0 {
            return dataArr.first! //goods_id&&repoId确定唯一商品
        }else{
            return CartGoodsModel()
        }
        
    }
    // 更新
    private func tableLampUpdateItem(data:CartGoodsModel) -> Bool {
        let item = TABLE_LAMP.filter(TABLE_goods_id == data.goods_id!)
        do {
            
            let goods_id = data.goods_id ?? 0
            let goods_name = data.goods_name ?? ""
            let unit_price = data.unit_price ?? 0
            let thumbnail = data.thumbnail ?? ""
            let amount = data.amount ?? 0
            
            if try db.run(item.update(TABLE_goods_id <- goods_id, TABLE_goods_name <- goods_name, TABLE_unit_price <- unit_price, TABLE_thumbnail <- thumbnail, TABLE_amount <- amount)) > 0 {
                print("更新成功")
                return true
            } else {
                print("没有发现该商品")
                return false
            }
        } catch {
            print("更新失败")
            return false
        }
    }
    // 删除
    private func tableLampDeleteItem(goods_id: Int64) -> Bool {
        let item = TABLE_LAMP.filter(TABLE_goods_id == goods_id)
        do {
            if try db.run(item.delete()) > 0 {
                print(" 删除成功")
                return true
            } else {
                print("没有发现商品)")
                return false
            }
        } catch {
            print("删除失败")
            return false
        }
    }

}
extension SQLiteTool {
    
    //添加商品
    func addGoodsToShoppingCart(goods:CartGoodsModel) -> Bool {
        
        let cartModel = readTableLampItem(goods_id: goods.goods_id!)
        var result : Bool
        
        if (cartModel.goods_id != nil) {//更新商品
            cartModel.amount = cartModel.amount! + Int64(1)
            result =  tableLampUpdateItem(data: cartModel)
            if result {
                getGoodsNum()
            }
        }else{ //添加商品
            let goods_id = goods.goods_id ?? 0
            let goods_name = goods.goods_name ?? ""
            let unit_price = goods.unit_price ?? 0
            let thumbnail = goods.thumbnail ?? ""
            let amount = Int64(1)
            
            result = tableLampInsertItem(goods_id: goods_id, goods_name: goods_name, unit_price: unit_price, thumbnail: thumbnail, amount: amount)
            if result {
                getGoodsNum()
            }
        }
        if result == true {
            AudioServicesPlaySystemSound(1520)
        }
        return result
    }
    
    //减少商品
    func reduceGoodsToShoppingCart(goods:CartGoodsModel) -> Bool {
        
        let cartModel = readTableLampItem(goods_id: goods.goods_id!)
        
        
        if (cartModel.goods_id != nil) {//更新商品
            cartModel.amount = cartModel.amount! - Int64(1)
            if cartModel.amount!>0{
                if tableLampUpdateItem(data: cartModel) {
                    getGoodsNum()
                    return true
                }else{
                    return false
                }
            }else{ //直接删除
                if tableLampDeleteItem(goods_id: goods.goods_id ?? 0) {
                    getGoodsNum()
                    return true
                }else{
                    return false
                }
            }
            
        }else{ //商品不存在
            return false
        }
        
    }
    //删除商品
    func deleteGoodsToShoppingCart(goods:CartGoodsModel) -> Bool {
        if tableLampDeleteItem(goods_id: goods.goods_id ?? 0) {
            getGoodsNum()
            return true
        }else{
            return false
        }
    }
    //查询
    func readGoodsFromSQLite(goodsID:Int64) -> CartGoodsModel {
        return readTableLampItem(goods_id: goodsID)
    }
    //遍历购物车
    func getAllGoods() -> Array<CartGoodsModel> {
        return queryTableLamp()
    }
    //状态栏商品总数量
    func getGoodsNum()  {
        let vc = topViewController()
        let tabbarItem = vc?.tabBarController?.tabBar.items![1]
        
        var goodsNum : Int64 = 0
        
        if SQLiteTool.shared.getAllGoods().count > 0{
            
            for model  in SQLiteTool.shared.getAllGoods(){
                
                goodsNum = model.amount! + goodsNum
                
            }
            
        }else{
            goodsNum = 0
        }
        
        if goodsNum > 0 {
            tabbarItem?.badgeValue = "\(goodsNum)"
        }else{
            tabbarItem?.badgeValue = nil
        }
        
    }
        
    //获取当前控制器
     func topViewController() -> UIViewController? {
        return self.topViewControllerWithRootViewController(viewController: self.getCurrentWindow()?.rootViewController)
    }
    
     func getCurrentWindow() -> UIWindow? {
        // 找到当前显示的UIWindow
        var window: UIWindow? = UIApplication.shared.keyWindow
        /**
         window有一个属性：windowLevel
         当 windowLevel == UIWindowLevelNormal 的时候，表示这个window是当前屏幕正在显示的window
         */
        if window?.windowLevel != UIWindow.Level.normal {
            for tempWindow in UIApplication.shared.windows {
                if tempWindow.windowLevel == UIWindow.Level.normal {
                    window = tempWindow
                    break
                }
            }
        }
        return window
    }
      func topViewControllerWithRootViewController(viewController :UIViewController?) -> UIViewController? {
        if viewController == nil {
            return nil
        }
        if viewController?.presentedViewController != nil {
            return self.topViewControllerWithRootViewController(viewController: viewController?.presentedViewController!)
        }
        else if viewController?.isKind(of: UITabBarController.self) == true {
            return self.topViewControllerWithRootViewController(viewController: (viewController as! UITabBarController).selectedViewController)
        }
        else if viewController?.isKind(of: UINavigationController.self) == true {
            return self.topViewControllerWithRootViewController(viewController: (viewController as! UINavigationController).visibleViewController)
        }else {
            return viewController
        }
    }
}
