//
//  ViewController.swift
//  ImageGuyDemo
//
//  Created by 兰轩轩 on 2016/10/21.
//  Copyright © 2016年 兰轩轩. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let vc = ImageGuyViewController(urlStrings: [
            "http://tse1.mm.bing.net/th?id=OIP.M798d6b715a30f5eac40989d9171ab123o0&pid=15.1",
            "http://img2.3lian.com/2014/f5/165/d/118.jpg",
            "http://img.cxdq.com/d1/file/2010/06-22/d8d7f58e1e2363d48eb4256a8b7174aa.jpg",
            "http://img.cxdq.com/d1/file/2010/06-22/9fc70fdef3e1b0b9205d9717cbf2db0c.jpg",
            "http://img.cxdq.com/d1/file/2010/06-22/78dc87139b1799654dd6fc2524eb749a.jpg",
            "http://img.funshion.com/pictures/605/159/605159.jpg",
            "http://img.zcool.cn/community/0101f856cfff206ac7252ce6214470.jpg"
            ], currentIndex: 3)
        present(vc, animated: true, completion: nil)
    }

   
}

