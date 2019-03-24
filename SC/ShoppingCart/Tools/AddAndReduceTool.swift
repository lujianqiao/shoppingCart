//
//  AddAndReduceTool.swift
//  NiuGeYinSwift
//
//  Created by lujianqiao on 2018/8/13.
//  Copyright © 2018年 NGY. All rights reserved.
//

import UIKit

class AddAndReduceTool: UIView {

    var addBtn : UIButton!
    var reduceBtn : UIButton!
    var numL : UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUI()
    }
    
    func setUI(){
        reduceBtn = UIButton()
        reduceBtn.setImage(UIImage(named: "gwc_jian"), for: .normal)
        addSubview(reduceBtn)
        
        numL = UILabel()
        numL.textAlignment = .center
        numL.textColor = UIColor.kRGBColorFromHex(rgbValue: 0x313131)
        numL.font = BlodFont(font: 16)
        addSubview(numL)
        
        addBtn = UIButton()
        addBtn.setImage(UIImage(named: "gwc_jia"), for: .normal)
        addSubview(addBtn)
        
        reduceBtn.snp.makeConstraints { (make) in
            make.left.top.equalTo(5)
            make.bottom.equalTo(-5)
            make.width.equalTo(reduceBtn.snp.height)
        }
        addBtn.snp.makeConstraints { (make) in
            make.top.equalTo(5)
            make.right.bottom.equalTo(-5)
            make.width.equalTo(reduceBtn.snp.height)
        }
        numL.snp.makeConstraints { (make) in
            make.top.bottom.equalTo(0)
            make.left.equalTo(reduceBtn.snp.right)
            make.right.equalTo(addBtn.snp.left)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension AddAndReduceTool {
    //刷新商品数量
    func refreshNum(num:Int64)  {
        if num > 0{
            numL.text = "\(num)"
            reduceBtn.isHidden = false
            numL.isHidden = false
        }else{
            reduceBtn.isHidden = true
            numL.isHidden = true
        }
    }
}
