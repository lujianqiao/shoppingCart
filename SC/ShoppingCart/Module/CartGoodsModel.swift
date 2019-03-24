//
//  CartGoodsModel.swift
//  ShoppingCart
//
//  Created by lujianqiao on 2019/3/12.
//  Copyright © 2019 NGY. All rights reserved.
//

import UIKit
import HandyJSON

class CartGoodsModel: HandyJSON {

    /** 商品id */
    var goods_id : Int64?
    /** 商品名称 */
    var goods_name : String?
    /** 商品原价 */
    var unit_price : Double?
    /** 商品图片 */
    var thumbnail : String?
    /** 商品购买数量*/
    var amount : Int64?
    
    required init() {}
}
