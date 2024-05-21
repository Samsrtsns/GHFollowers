//
//  UIHelpers.swift
//  GHFollowers2
//
//  Created by Samet KATI on 19.05.2024.
//

import UIKit

struct UIHelper {
    
    static func createThreeColumnFlowLayout(in view : UIView) -> UICollectionViewFlowLayout {
        
        // Ana view'in genişliğini alır
        let width = view.bounds.width
        
        // Hücrelerin etrafındaki boşluk miktarını tanımlar
        let padding: CGFloat = 12
        
        // Hücreler arasındaki minimum boşluk miktarını tanımlar
        let minimumItemSpacing: CGFloat = 10
        
        // Hücrelerin yerleştirileceği kullanılabilir genişliği hesaplar
        let availableWidth = width - (padding * 2) - (minimumItemSpacing * 2)
        
        // Her bir hücrenin genişliğini hesaplar
        let itemWidth = availableWidth / 3

        // Yeni bir akış düzeni (flow layout) oluşturur
        let flowLayout = UICollectionViewFlowLayout()
        
        // Akış düzeninin kenar boşluklarını ayarlar
        flowLayout.sectionInset = UIEdgeInsets(top: padding, left: padding, bottom: padding, right: padding)
        
        // Hücrelerin boyutunu ayarlar
        flowLayout.itemSize = CGSize(width: itemWidth, height: itemWidth + 40)

        return flowLayout
    }
    
}
