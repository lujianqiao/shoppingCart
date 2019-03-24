//
//  GoodsTableViewCell.swift
//  ShoppingCart
//
//  Created by lujianqiao on 2019/3/12.
//  Copyright © 2019 NGY. All rights reserved.
//

import UIKit

protocol SPVCCellGoodsDelegate {
    func goodsAddAndReduceCart(cell:GoodsTableViewCell,goods:CartGoodsModel,goodsImg:UIImageView,addOrReduce:Bool)
}

class GoodsTableViewCell: UITableViewCell {

    private var goodsIMG:UIImageView!
    private var goodsName:UILabel!
    private var priceL:UILabel!
    private var addAndReduce:AddAndReduceTool!
    var cellDelegate : SPVCCellGoodsDelegate?
    var cellData = CartGoodsModel()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        selectionStyle = .none
        contentView.backgroundColor = UIColor.white
        
        goodsIMG = UIImageView()
        contentView.addSubview(goodsIMG)
        
        goodsName = UILabel()
        goodsName.textColor = UIColor.kRGBColorFromHex(rgbValue: 0x313131)
        goodsName.font = UIFont(name: "PingFang-SC-Medium", size: 15)
        contentView.addSubview(goodsName)
        
        priceL = UILabel()
        priceL.textColor = UIColor.kRGBColorFromHex(rgbValue: 0xFF1922)
        priceL.font = UIFont(name: "PingFang-SC-Medium", size: 14)
        contentView.addSubview(priceL)
        
        addAndReduce = AddAndReduceTool()
        addAndReduce.addBtn.addTarget(self, action: #selector(addGoods), for: .touchUpInside)
        addAndReduce.reduceBtn.addTarget(self, action: #selector(reduceGoods), for: .touchUpInside)
        contentView.addSubview(addAndReduce)
        
        goodsIMG.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().offset(20)
            make.width.height.equalTo(Screen_Width(intWidth: 75))
        }
        goodsName.snp.makeConstraints { (make) in
            make.left.equalTo(goodsIMG.snp.right).offset(10)
            make.right.equalToSuperview().offset(-10)
            make.top.equalTo(goodsIMG.snp.top)
        }
        priceL.snp.makeConstraints { (make) in
            make.left.equalTo(goodsIMG.snp.right).offset(10)
            make.bottom.equalTo(goodsIMG.snp.bottom)
            make.height.equalTo(16)
        }
        addAndReduce.snp.makeConstraints { (make) in
            make.right.bottom.equalTo(-5)
            make.width.equalTo(100)
            make.height.equalTo(37)
        }
    }
    
    func reloadData(data:CartGoodsModel) -> Void {
        goodsIMG.image = UIImage(named: data.thumbnail ?? "")
        goodsName.text = data.goods_name ?? ""
        priceL.text = "￥" + "\(data.unit_price ?? 0)"
        cellData = data
        
        addAndReduce.refreshNum(num: data.amount ?? 0)
        
    }
    
    @objc func addGoods() -> Void {
        self.cellDelegate?.goodsAddAndReduceCart(cell: self, goods: cellData, goodsImg: self.goodsIMG, addOrReduce: true)
    }
    @objc func reduceGoods() -> Void {
        self.cellDelegate?.goodsAddAndReduceCart(cell: self, goods: cellData, goodsImg: self.goodsIMG, addOrReduce: false)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    

}
