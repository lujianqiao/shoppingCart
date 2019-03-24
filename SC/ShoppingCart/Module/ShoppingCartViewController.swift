//
//  ShoppingCartViewController.swift
//  ShoppingCart
//
//  Created by lujianqiao on 2019/3/11.
//  Copyright © 2019 NGY. All rights reserved.
//

import UIKit

class ShoppingCartViewController: UIViewController {

    private var tableview: UITableView!
    private var data = [CartGoodsModel]()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getAllGoods()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        

        // Do any additional setup after loading the view.
    }
    
    //数据获取
    func getAllGoods() {
        data.removeAll()
        for model in SQLiteTool.shared.getAllGoods() {
            data.append(model)
        }
        tableview.reloadData()
    }
    
    func setUI() -> Void {
        tableview = UITableView(frame: CGRect(x: 0, y: 0, width: ScreenWidth, height: ScreenHeight ))
        tableview.delegate = self
        tableview.dataSource = self
        tableview.estimatedRowHeight = 0
        tableview.estimatedSectionFooterHeight = 0
        tableview.estimatedSectionHeaderHeight = 0
        tableview.tableFooterView = UIView()
        tableview.backgroundColor = UIColor.kRGBColorFromHex(rgbValue: 0xF5F5F5)
        tableview.register(GoodsTableViewCell.self, forCellReuseIdentifier: "GoodsTableViewCell")
        view.addSubview(tableview)
    }

}


extension ShoppingCartViewController: UITableViewDelegate,UITableViewDataSource,SPVCCellGoodsDelegate{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "GoodsTableViewCell") as! GoodsTableViewCell
        cell.cellDelegate = self
        let model = data[indexPath.row]
        cell.reloadData(data: model)
        
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return Screen_Width(intWidth: 100)
    }
    func goodsAddAndReduceCart(cell: GoodsTableViewCell, goods: CartGoodsModel, goodsImg: UIImageView, addOrReduce: Bool) {
        
        if addOrReduce == true {//加
            if SQLiteTool.shared.addGoodsToShoppingCart(goods: goods){
                
                let X = self.tableview.convert(cell.frame, to: self.view).origin.x
                let Y = self.tableview.convert(cell.frame, to: self.view).origin.y
                
                let imageViewRect = CGRect(x: X, y: Y, width: goodsImg.frame.width, height: goodsImg.frame.height)
                ShoppingCartAnimatioTool().startAnimation(view: goodsImg, andRect: imageViewRect, andFinishedRect: CGPoint(x:ScreenWidth/4*3,  y:ScreenHeight-(TabbarHeight)), andFinishBlock: { (finished : Bool) in
                    
                    
                })
            }
        }else{//减
            if SQLiteTool.shared.reduceGoodsToShoppingCart(goods: goods){
                
            }
        }
        getAllGoods()
    }
    
}

//UIColor
extension UIColor {
    
    //十六进制颜色
    class func kRGBColorFromHex(rgbValue: Int) -> (UIColor) {
        
        return UIColor(red: ((CGFloat)((rgbValue & 0xFF0000) >> 16)) / 255.0,
                       green: ((CGFloat)((rgbValue & 0xFF00) >> 8)) / 255.0,
                       blue: ((CGFloat)(rgbValue & 0xFF)) / 255.0,
                       alpha: 1.0)
    }
    
}
