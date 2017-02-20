//
//  TableMenuVC.swift
//  torch
//
//  Created by 张俊凯 on 2017/2/20.
//  Copyright © 2017年 张俊凯. All rights reserved.
//

import UIKit
let identifier = "cell"

//主方法
class TableMenuVC: UITableViewController {
    var titles:Array<String>?

    override func viewDidLoad() {
        super.viewDidLoad()

        //设置背景图片
        let bgImageView = UIImageView(image: UIImage(named: "push_bg"))
        tableView.backgroundView = bgImageView
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: identifier)
        tableView.tableFooterView = UIView(frame: CGRect.zero)
        tableView.isScrollEnabled = false
        tableView.separatorStyle = UITableViewCellSeparatorStyle.none
        
        // 菜单标题
        titles = ["振动开关","灯光在开始时亮起","灯光只在长按时亮起"]
        
        //设置左边的按钮
        title = "设置"
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "完成", style: UIBarButtonItemStyle.done, target: self, action: #selector(self.dismissViewController))
    }
    
    
    //弹出页面消失
    func dismissViewController(){
        navigationController?.dismiss(animated: true, completion: nil)
    }

}



//数据源方法
extension TableMenuVC{
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath)
        
        cell.textLabel?.text = titles?[indexPath.row]
        cell.textLabel?.textColor = UIColor.white
        cell.textLabel?.font = UIFont.boldSystemFont(ofSize: 22)
        cell.backgroundColor = UIColor.clear
        cell.selectionStyle = UITableViewCellSelectionStyle.none
        let width:CGFloat = 80
        let btn = UIButton(frame:CGRect(x: cell.contentView.width - width, y: 0, width: width, height: cell.contentView.height))
        cell.contentView.addSubview(btn)
        btn.setImage(UIImage(named:"push_setup_off"), for: UIControlState.normal)
        btn.setImage(UIImage(named:"push_setup_on"), for: UIControlState.selected)
        btn.tag = indexPath.row
        btn.addTarget(self, action: #selector(self.btnClick(_:)), for: UIControlEvents.touchUpInside)
        let defaults = UserDefaults.standard
        let isSelected = defaults.object(forKey: String(btn.tag))
        if isSelected != nil {
            btn.isSelected = isSelected as! Bool
        }
        return cell
    }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
   

}


//按钮的点击事件
extension TableMenuVC{
    
    func btnClick(_ btn:UIButton){
         btn.isSelected == true ? (btn.isSelected = false) : (btn.isSelected = true)
        
        //本地存储开关状态
        let status = btn.isSelected
        let defaults = UserDefaults.standard
        defaults.set(status, forKey: String(btn.tag))
        defaults.synchronize()
    }
}
