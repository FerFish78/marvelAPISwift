//
//  Extensions.swift
//  WebTests
//
//  Created by Fer Fish on 30/11/2018.
//  Copyright © 2018 Dev1. All rights reserved.
//

import UIKit

extension UIImage {
   func resizeImage(newWidth:CGFloat) -> UIImage? {
      let scale = newWidth / self.size.width
      let newHeight = self.size.height * scale
      let newSize = CGSize(width: newWidth, height: newHeight)
      UIGraphicsBeginImageContext(newSize)
      self.draw(in: CGRect(origin: CGPoint.zero, size: newSize))
      let newImage = UIGraphicsGetImageFromCurrentImageContext()
      UIGraphicsEndImageContext()
      return newImage
   }
}

