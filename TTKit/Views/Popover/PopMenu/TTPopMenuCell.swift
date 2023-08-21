import UIKit
#if canImport(SwiftTheme)
import SwiftTheme
#endif

class TTPopMenuCell: UITableViewCell {

    fileprivate lazy var iconImageView: UIImageView = {
        let imageView = UIImageView(frame: CGRect.zero)
        imageView.backgroundColor = UIColor.clear
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()

    fileprivate lazy var nameLabel: UILabel = {
        let label = UILabel(frame: CGRect.zero)
        label.backgroundColor = .clear
        return label
    }()

    func setupCellWith(menuItem: TTMenuObjectType, isSelected: Bool, configuration: TTPopMenuConfiguration) {
        self.backgroundColor = UIColor.clear
        
        nameLabel.font = configuration.textFont
        
        switch configuration.textColor {
        case .color(let color):
            nameLabel.textColor  = color
        #if canImport(SwiftTheme)
        case .themeColor(let themeColor):
            nameLabel.theme_textColor = themeColor
        #endif
        }
        
        if (isSelected) {
            switch configuration.selectedTextColor {
            case .color(let color):
                nameLabel.textColor = color
            #if canImport(SwiftTheme)
            case .themeColor(let themeColor):
                nameLabel.theme_textColor = themeColor
            #endif
            }
            
            switch configuration.selectedCellBackgroundColor {
            case .color(let color):
                self.backgroundColor = color
            #if canImport(SwiftTheme)
            case .themeColor(let themeColor):
                self.theme_backgroundColor = themeColor
            #endif
            }
        }
        
        
        switch menuItem {
        case .icon(let icon):
            self.contentView.addSubview(iconImageView)
            iconImageView.image = configuration.ignoreImageOriginalColor ? icon.withRenderingMode(UIImage.RenderingMode.alwaysTemplate) : icon
            
            switch configuration.contentDistribution {
            case .leading, .spaceBetween:
                iconImageView.frame = CGRect(x: configuration.cellMargin, y: (configuration.menuRowHeight - configuration.menuIconSize)/2, width: configuration.menuIconSize, height: configuration.menuIconSize)
            case .center:
                iconImageView.frame = CGRect(x: (configuration.menuWidth - configuration.menuIconSize)/2, y: (configuration.menuRowHeight - configuration.menuIconSize)/2, width: configuration.menuIconSize, height: configuration.menuIconSize)
            case .trailing:
                iconImageView.frame = CGRect(x: configuration.menuWidth - configuration.cellMargin - configuration.menuIconSize, y: (configuration.menuRowHeight - configuration.menuIconSize)/2, width: configuration.menuIconSize, height: configuration.menuIconSize)
            }

        case .text(let text, let specifyColor):
            self.contentView.addSubview(nameLabel)
            nameLabel.text = text
            
            if let specifyColor = specifyColor {
                switch specifyColor {
                case .color(let color):
                    nameLabel.textColor  = color
                #if canImport(SwiftTheme)
                case .themeColor(let themeColor):
                    nameLabel.theme_textColor = themeColor
                #endif
                }
            }
            
            nameLabel.frame = CGRect(x: configuration.cellMargin, y: 0, width: configuration.menuWidth - configuration.cellMargin*2, height: configuration.menuRowHeight)

            switch configuration.contentDistribution {
            case .leading, .spaceBetween:
                nameLabel.textAlignment = .left
            case .center:
                nameLabel.textAlignment = .center
            case .trailing:
                nameLabel.textAlignment = .right
            }

        case .icon_text(let icon, let text, let specifyColor):
            self.contentView.addSubview(iconImageView)
            self.contentView.addSubview(nameLabel)
            iconImageView.image = configuration.ignoreImageOriginalColor ? icon.withRenderingMode(UIImage.RenderingMode.alwaysTemplate) : icon
            nameLabel.text = text
            
            if let specifyColor = specifyColor {
                switch specifyColor {
                case .color(let color):
                    nameLabel.textColor  = color
                #if canImport(SwiftTheme)
                case .themeColor(let themeColor):
                    nameLabel.theme_textColor = themeColor
                #endif
                }
            }

            let textSize = kSingleLineTextSize(text: text, font: configuration.textFont)
            
            switch configuration.contentDistribution {
            case .leading:
                iconImageView.frame = CGRect(x: configuration.cellMargin, y: (configuration.menuRowHeight - configuration.menuIconSize)/2, width: configuration.menuIconSize, height: configuration.menuIconSize)
                nameLabel.frame = CGRect(x: iconImageView.frame.maxX + configuration.iconTextSpace, y: 0, width: textSize.width, height: configuration.menuRowHeight)
            case .center:
                iconImageView.frame = CGRect(x: (configuration.menuWidth - configuration.menuIconSize - configuration.iconTextSpace - textSize.width)/2, y: (configuration.menuRowHeight - configuration.menuIconSize)/2, width: configuration.menuIconSize, height: configuration.menuIconSize)
                nameLabel.frame = CGRect(x: iconImageView.frame.maxX + configuration.iconTextSpace, y: 0, width: textSize.width, height: configuration.menuRowHeight)
            case .trailing:
                iconImageView.frame = CGRect(x: configuration.menuWidth - configuration.cellMargin - configuration.menuIconSize - configuration.iconTextSpace - configuration.menuIconSize, y: (configuration.menuRowHeight - configuration.menuIconSize)/2, width: configuration.menuIconSize, height: configuration.menuIconSize)
                nameLabel.frame = CGRect(x: iconImageView.frame.maxX + configuration.iconTextSpace, y: 0, width: textSize.width, height: configuration.menuRowHeight)
            case .spaceBetween:
                iconImageView.frame = CGRect(x: configuration.cellMargin, y: (configuration.menuRowHeight - configuration.menuIconSize)/2, width: configuration.menuIconSize, height: configuration.menuIconSize)
                nameLabel.frame = CGRect(x: configuration.menuWidth - configuration.cellMargin - textSize.width, y: 0, width: textSize.width, height: configuration.menuRowHeight)
            }

        case .text_icon(let text, let icon, let specifyColor):
            self.contentView.addSubview(nameLabel)
            self.contentView.addSubview(iconImageView)
            nameLabel.text = text
            iconImageView.image = configuration.ignoreImageOriginalColor ? icon.withRenderingMode(UIImage.RenderingMode.alwaysTemplate) : icon
            
            if let specifyColor = specifyColor {
                switch specifyColor {
                case .color(let color):
                    nameLabel.textColor  = color
                #if canImport(SwiftTheme)
                case .themeColor(let themeColor):
                    nameLabel.theme_textColor = themeColor
                #endif
                }
            }
            
            let textSize = kSingleLineTextSize(text: text, font: configuration.textFont)
            
            switch configuration.contentDistribution {
            case .leading:
                nameLabel.frame = CGRect(x: configuration.cellMargin, y: 0, width: textSize.width, height: configuration.menuRowHeight)
                iconImageView.frame = CGRect(x: nameLabel.frame.maxX + configuration.iconTextSpace, y: (configuration.menuRowHeight - configuration.menuIconSize)/2, width: configuration.menuIconSize, height: configuration.menuIconSize)
            case .center:
                nameLabel.frame = CGRect(x: (configuration.menuWidth - configuration.menuIconSize - configuration.iconTextSpace - textSize.width)/2, y: 0, width: textSize.width, height: configuration.menuRowHeight)
                iconImageView.frame = CGRect(x: nameLabel.frame.maxX + configuration.iconTextSpace, y: (configuration.menuRowHeight - configuration.menuIconSize)/2, width: configuration.menuIconSize, height: configuration.menuIconSize)
            case .trailing:
                nameLabel.frame = CGRect(x: configuration.menuWidth - configuration.cellMargin - configuration.menuIconSize - configuration.iconTextSpace - configuration.menuIconSize, y: 0, width: textSize.width, height: configuration.menuRowHeight)
                iconImageView.frame = CGRect(x: nameLabel.frame.maxX + configuration.iconTextSpace, y: (configuration.menuRowHeight - configuration.menuIconSize)/2, width: configuration.menuIconSize, height: configuration.menuIconSize)
            case .spaceBetween:
                nameLabel.frame = CGRect(x: configuration.cellMargin, y: 0, width: textSize.width, height: configuration.menuRowHeight)
                iconImageView.frame = CGRect(x: configuration.menuWidth - configuration.cellMargin - configuration.menuIconSize, y: (configuration.menuRowHeight - configuration.menuIconSize)/2, width: configuration.menuIconSize, height: configuration.menuIconSize)
            }
        }
    }
}
