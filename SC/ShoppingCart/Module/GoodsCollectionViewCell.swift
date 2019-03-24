//
//  GoodsCollectionViewCell.swift
//  ShoppingCart
//
//  Created by lujianqiao on 2019/3/11.
//  Copyright © 2019 NGY. All rights reserved.
//

import UIKit
import SnapKit

protocol cellGoodsAddDelegate {
    func goodsAddToCart(cell:GoodsCollectionViewCell, data:CartGoodsModel, goodsImg:UIImageView)
}

class GoodsCollectionViewCell: UICollectionViewCell {
    
    var goodImg : UIImageView!
    var goodName : UILabel!
    var goodPrice : UILabel!
    var addBtn : UIButton!
    var cellData = CartGoodsModel()
    var cellDelegate : cellGoodsAddDelegate?
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        goodImg = UIImageView()
        contentView.addSubview(goodImg)
        
        goodName = UILabel()
        goodName.textColor = UIColor.black
        goodName.font = UIFont(name: "PingFang-SC-Medium", size: 13)
        contentView.addSubview(goodName)
        
        goodPrice = UILabel()
        goodPrice.textColor = UIColor.red
        goodPrice.font = UIFont(name: "PingFang-SC-Medium", size: 13)
        contentView.addSubview(goodPrice)
        
        addBtn = UIButton()
        addBtn.setImage(UIImage(named: "gwc_jia"), for: .normal)
        contentView.addSubview(addBtn)
        addBtn.addTarget(self, action: #selector(addGoodsToSP), for: .touchUpInside)
        
        goodImg.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalTo(10)
            make.width.height.equalTo(Screen_Width(intWidth: 95))
        }
        goodName.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.width.equalTo(Screen_Width(intWidth: 95))
            make.top.equalTo(goodImg.snp.bottom).offset(10)
        }
        goodPrice.snp.makeConstraints { (make) in
            make.left.equalTo(goodImg.snp.left)
            make.bottom.equalToSuperview().offset(-20)
            make.height.equalTo(13)
        }
        addBtn.snp.makeConstraints { (make) in
            make.right.equalToSuperview().offset(-5)
            make.bottom.equalToSuperview().offset(-8)
            make.width.height.equalTo(30)
        }
    }
    
    func reloadData(data:CartGoodsModel) -> Void {
        goodImg.image = UIImage(named: data.thumbnail ?? "")
        goodName.text = data.goods_name ?? ""
        goodPrice.text = "￥" + "\(data.unit_price ?? 0)"
        cellData = data
    }
    
    @objc func addGoodsToSP(){
        self.cellDelegate?.goodsAddToCart(cell: self, data: cellData, goodsImg: goodImg)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
