//
//  HomeViewController.swift
//  ShoppingCart
//
//  Created by lujianqiao on 2019/3/11.
//  Copyright © 2019 NGY. All rights reserved.
//

import UIKit

// 屏幕的宽度
let ScreenWidth = UIScreen.main.bounds.width
// 屏幕的高度
let ScreenHeight = UIScreen.main.bounds.height

func Screen_Width(intWidth: CGFloat) -> CGFloat {
    return ScreenWidth*intWidth/375
}
func isIPhoneX() -> Bool {
    if UIApplication.shared.statusBarFrame.size.height == 44 {
        return true
    }else{
        return false
    }
}
let TabbarHeight:CGFloat = isIPhoneX() == true ? 83:49
//字体
func BlodFont(font: CGFloat) -> UIFont {
    return UIFont(name: "PingFangSC-Semibold", size: font)!
}


class HomeViewController: UIViewController {

    private var collection : UICollectionView!
    lazy private var data : [CartGoodsModel] = {
        //此处数据为自己写的数据(便于展示)，可自行替换为网络数据
        let dataJsonString : String? = "[{\"goods_id\":1,\"goods_name\":\"大白兔奶糖\",\"unit_price\":10,\"thumbnail\":\"dabaitu\"},{\"goods_id\":2,\"goods_name\":\"牛奶\",\"unit_price\":2.5,\"thumbnail\":\"niunai\"},{\"goods_id\":3,\"goods_name\":\"薯片\",\"unit_price\":5.5,\"thumbnail\":\"shupian\"},{\"goods_id\":4,\"goods_name\":\"大白兔奶糖\",\"unit_price\":10,\"thumbnail\":\"timg\"},{\"goods_id\":5,\"goods_name\":\"牛奶\",\"unit_price\":2.5,\"thumbnail\":\"timg-1\"},{\"goods_id\":6,\"goods_name\":\"薯片\",\"unit_price\":5.5,\"thumbnail\":\"timg (1)\"}]"
        let datas = [CartGoodsModel].deserialize(from: dataJsonString)
        
        return datas! as! [CartGoodsModel]
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        SQLiteTool.shared.getGoodsNum()
        // Do any additional setup after loading the view.
    }
    
    func setUI() -> Void {
        let layout = UICollectionViewFlowLayout()
        collection = UICollectionView(frame: CGRect(x: 0, y: 0, width: ScreenWidth, height: ScreenHeight), collectionViewLayout: layout)
        collection.backgroundColor = UIColor.white;
        collection.delegate = self;
        collection.dataSource = self;
        collection.register(GoodsCollectionViewCell.self, forCellWithReuseIdentifier: "GoodsCollectionViewCell")
        view.addSubview(collection)
    }
    
    
    
}

extension HomeViewController : UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,cellGoodsAddDelegate {
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return data.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "GoodsCollectionViewCell", for: indexPath) as! GoodsCollectionViewCell
        let model = data[indexPath.row]
        cell.reloadData(data: model)
        cell.cellDelegate = self
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        var size = CGSize.zero
        size = CGSize(width: ScreenWidth/3, height: Screen_Width(intWidth: 180))
        return size
        
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    func goodsAddToCart(cell: GoodsCollectionViewCell, data: CartGoodsModel, goodsImg: UIImageView) {
        
        if SQLiteTool.shared.addGoodsToShoppingCart(goods: data){
            let X = self.collection.convert(cell.frame, to: self.view).origin.x
            let Y = self.collection.convert(cell.frame, to: self.view).origin.y
            
            let imageViewRect = CGRect(x: X, y: Y, width: goodsImg.frame.width, height: goodsImg.frame.height)
            
            ShoppingCartAnimatioTool().startAnimation(view: goodsImg, andRect: imageViewRect, andFinishedRect: CGPoint(x:ScreenWidth/4*3,  y:ScreenHeight-(TabbarHeight)), andFinishBlock: { (finished : Bool) in
                print("加入成功")
            })
        }
    }
}
