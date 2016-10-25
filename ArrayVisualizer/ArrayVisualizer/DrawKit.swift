import UIKit
fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l < r
  case (nil, _?):
    return true
  default:
    return false
  }
}

fileprivate func > <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l > r
  default:
    return rhs < lhs
  }
}


class DrawKit {
    
    class Properties {
        var currentColor = UIColor.white
        var currentItemHeight: Double = 8
        var currentFontHeight: Double = 10
        var barStartX: Double = 0
        func getStringWidth(_ string: NSString) -> Double {
            let size : CGSize = string.size(attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: CGFloat(currentFontHeight))])
            return Double(size.width)
        }
        class Array2D {
            var cellWidth = CGFloat(30)
            var cellHeight = CGFloat(12)
        }
        var array2D = Array2D()
    }
    
    let properties = Properties()
    
    class Utils {
        fileprivate func isObjectANumber(_ object:AnyObject?)->Bool {
            return object is NSNumber
        }
        fileprivate func getPercentageInRange(_ d : Double, min : Double, max : Double) -> Double {
            let delta = max - min
            if delta != 0 {
                let percentage = d / delta
                return percentage
            }
            return 0
        }
        fileprivate func getDoubleForObject(_ object:AnyObject?)->Double? {
            if self.isObjectANumber(object) {
                return object as? Double
            }
            return nil
        }
    }
    let utils = Utils()
    
    internal func drawIndices(_ array: Array<Any?>, _ xPos: Double) {
        let paragraphStyle = NSParagraphStyle.default.mutableCopy() as! NSMutableParagraphStyle
        paragraphStyle.lineBreakMode = NSLineBreakMode.byTruncatingTail
        let textFontAttributes: [String: Any] = [NSFontAttributeName: UIFont.boldSystemFont(ofSize: CGFloat(properties.currentFontHeight)), NSForegroundColorAttributeName: properties.currentColor, NSParagraphStyleAttributeName: paragraphStyle]
        for i in 0..<array.count {
            let y = Double(i) * properties.currentItemHeight
            let indexString = String(i)
            indexString.draw(at: CGPoint(x: CGFloat(xPos), y: CGFloat(y)), withAttributes: textFontAttributes)
        }
    }
    
    fileprivate func objectDescription(_ object:AnyObject?) -> String {
        if object != nil {
            let hasDescription = object!.responds(to: #selector(getter: NSObjectProtocol.description))
            return hasDescription ? object!.description : ""
        }
        return ""
    }
    
    internal func drawObjectDescriptions(_ array: Array<Any?>, _ xPos:Double) {
        for i in 0..<array.count {
            let y = Double(i) * properties.currentItemHeight
            let desc = objectDescription(array[i] as AnyObject?)
            desc.draw(at: CGPoint(x: CGFloat(xPos), y: CGFloat(y)), withAttributes: attributes())
        }
    }
    
    internal func attributes() -> [String: Any] {
        let paragraphStyle = NSParagraphStyle.default.mutableCopy() as! NSMutableParagraphStyle
        paragraphStyle.lineBreakMode = NSLineBreakMode.byTruncatingTail
        let textFontAttributes: [String: Any] = [NSFontAttributeName: UIFont.boldSystemFont(ofSize: CGFloat(properties.currentFontHeight)), NSForegroundColorAttributeName: properties.currentColor, NSParagraphStyleAttributeName: paragraphStyle]
        return textFontAttributes
    }
    
    fileprivate func arrayHasNumber(_ array: Array<Any?>)->Bool {
        for i in 0..<array.count {
            let object : AnyObject? = array[i] as AnyObject?
            if utils.isObjectANumber(object) {
                return true
            }
        }
        return false
    }
    
    fileprivate func getRange(_ array: Array<Any?>) -> (Double,Double) {
        var min : Double?
        var max : Double?
        if arrayHasNumber(array) {
            for i in 0..<array.count {
                let object : AnyObject? = array[i] as AnyObject?
                let d : Double? = utils.getDoubleForObject(object)
                if d != nil && min == nil {
                    min = d
                    max = d
                }
                if ( d < min ) { min = d }
                if ( d > max ) { max = d }
            }
        }
        if ( min == nil ) { min = 0 }
        if ( max == nil ) { max = 0 }
        return (min!,max!)
    }
    
    internal func drawLine(_ x0:Double,y0:Double,x1:Double,y1:Double) {
        let path = UIBezierPath()
        path.move(to: CGPoint(x: CGFloat(x0), y: CGFloat(y0)))
        path.addLine(to: CGPoint(x: CGFloat(x1), y: CGFloat(y1)))
        path.lineWidth = 0.5
        properties.currentColor.setStroke()
        path.stroke()
    }
    
    internal func drawLines(_ array: Array<Any?>, _ viewWidth: Double) {
        for i in 0..<array.count {
            let y = Double(i) * properties.currentItemHeight
            drawLine(0, y0: y, x1: viewWidth, y1: y)
        }
    }
    
    func dimensions(_ array2D: Array<Array<Any?>>) -> CGSize {
        let width = CGFloat(array2D.count) * properties.array2D.cellWidth
        let height = CGFloat(maxLength(array2D)) * properties.array2D.cellHeight
        return CGSize(width: width, height: height)
    }
    
    func maxLength(_ array2D: Array<Array<Any?>>) -> Int {
        var maxHeight = 0
        for column in array2D {
            maxHeight = max(maxHeight, column.count)
        }
        return maxHeight
    }
    
    func minValue(for array2D: Array<Array<Any?>>) -> Int {
        guard array2D.count > 0 else {
            print("minValue exit early 0")
            return 0
        }
        var minValue = Int.max
        for x in 0..<array2D.count {
            for y in 0..<array2D[x].count {
                let value = val(array2D, x: x, y: y)
                minValue = min(minValue, value)
            }
        }
        return minValue
    }
    
    func val(_ array2D: Array<Array<Any?>>, x: Int, y: Int) -> Int {
        let value: Int? = array2D[x][y] as? Int
        return value ?? 0
    }
    
    func limitValue(for array2D: Array<Array<Any?>>, isMax: Bool) -> Int {
        guard array2D.count > 0 else {
            print("maxValue exit early 0")
            return 0
        }
        var limitValue = isMax ? Int.min : Int.max
        for x in 0..<array2D.count {
            for y in 0..<array2D[x].count {
                if let value = array2D[x][y] as? Int {
                    limitValue = isMax ? max(limitValue, value) : min(limitValue, value)
                }
            }
        }
        return limitValue
    }
    
    func color(for array2D: Array<Array<Any?>>, x: Int, y: Int, min: Int, max: Int) -> UIColor {
        let val = array2D[x][y] as? Int ?? 0
        var alpha = CGFloat(0)
        var color = UIColor()
        if val < 0 {
            alpha = CGFloat(-val) / CGFloat(-min)
            //print("\(alpha)")
            color = UIColor(red: 0.5, green: 0, blue: 0, alpha: alpha)
        } else {
            alpha = CGFloat(val) / CGFloat(max)
            //print("\(alpha)")
            color = UIColor(red: 106.0/255.0, green: 172.0/255.0, blue: 218.0/255.0, alpha: alpha)
        }
        return color
    }
    
    func drawCell(for array2D: Array<Array<Any?>>, x: Int, y: Int, min: Int, max: Int, size: CGSize) {
        let width = array2D.count
        let widthPerCell = size.width / CGFloat(width)
        let cellSize = CGSize(width: widthPerCell, height: properties.array2D.cellHeight)

        let x0 = CGFloat(x) * widthPerCell
        let y0 = CGFloat(y) * properties.array2D.cellHeight
        let color = self.color(for: array2D, x: x, y: y, min: min, max: max)
        color.setFill()
        UIRectFill(CGRect(x: x0, y: y0, width: cellSize.width, height: cellSize.height))
        let value = array2D[x][y] as? Int ?? 0
        let desc = "\(value)"
        desc.draw(at: CGPoint(x: x0, y: y0), withAttributes: attributes())
    }
    
    func render2D(_ array2D:Array<Array<Any?>>?) -> UIImage {
        guard let array2D = array2D else {
            return UIImage()
        }
        let height = maxLength(array2D)
        guard height > 0 else {
            return UIImage()
        }

        let size = dimensions(array2D)
        UIGraphicsBeginImageContextWithOptions(size, true, 0)
        UIColor.black.setFill()
        UIRectFill(CGRect(x: 0, y: 0, width: size.width, height: size.height))
        
        let min = limitValue(for: array2D, isMax: false)
        let max = limitValue(for: array2D, isMax: true)
        for x in 0..<array2D.count {
            for y in 0..<array2D[x].count {
                drawCell(for: array2D, x: x, y: y, min: min, max: max, size: size)
            }
        }
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image ?? UIImage()
    }
    
    func render(_ array:Array<Any?>?) -> UIImage {
        guard let array = array else {
            return UIImage()
        }
        properties.currentFontHeight = 10.0
        properties.currentItemHeight = properties.currentFontHeight + 2.0
        let maxCount = array.count
        let viewWidth = 200.0
        let size = CGSize(width: CGFloat(viewWidth),height: CGFloat(Double(maxCount)*properties.currentItemHeight))
        UIGraphicsBeginImageContextWithOptions(size, true, 0)
        UIColor.black.setFill()
        UIRectFill(CGRect(x: 0, y: 0, width: size.width, height: size.height))
        // .....................................................................
        //    |                        |       |
        //    | <-    indexSpace    -> | <- -> |
        //    V                                V
        //  leftMarginX                    objectDescX
        //
        let leftMarginX : Double = 2
        let lastIndexString = "\(maxCount-1)"
        let indexSpace = properties.getStringWidth(lastIndexString as NSString) + 2
        let objectLineX = leftMarginX + indexSpace
        let objectDescX = objectLineX + 2
        properties.currentColor = UIColor.gray
        drawLines(array, viewWidth)
        drawLine( objectLineX, y0: 0, x1:objectLineX, y1: Double(size.height))
        properties.currentColor = UIColor(red: 106.0/255.0, green: 172.0/255.0, blue: 218.0/255.0, alpha: 0.7)
        properties.barStartX = objectDescX
        drawBarsIfNumbers(array, viewWidth)
        properties.currentColor = UIColor.white
        drawIndices(array, leftMarginX)
        drawObjectDescriptions(array, objectDescX)
        properties.currentColor = UIColor(red: 0.2, green: 0.2, blue: 0.7, alpha: 0.5)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image ?? UIImage()
    }
    
    internal func drawBarsIfNumbers(_ array: Array<Any?>, _ viewWidth: Double) {
        if arrayHasNumber(array) {
            var (min,max) = getRange(array)
            if ( min > 0 ) {
                min = 0
            }
            let width : Double = viewWidth - properties.barStartX
            for i in 0..<array.count {
                let y = Double(i) * properties.currentItemHeight
                let barHeight : CGFloat = CGFloat(properties.currentItemHeight - 2)
                let object : AnyObject? = array[i] as AnyObject?
                if object != nil {
                    if utils.isObjectANumber(object) {
                        let d = utils.getDoubleForObject(object)
                        var x0Line : Double = properties.barStartX
                        if ( min < 0 ) {
                            x0Line = properties.barStartX + utils.getPercentageInRange(-min, min: min, max: max) * width
                        }
                        var rectPath : UIBezierPath
                        if ( d > 0 ) {
                            let posBarWidth = utils.getPercentageInRange(d!, min: min, max: max) * width
                            rectPath = UIBezierPath(rect: CGRect(x: CGFloat(x0Line),y: CGFloat(y+1),width: CGFloat(posBarWidth),height: barHeight))
                        } else {
                            let negBarWidth = utils.getPercentageInRange(-d!, min: min, max: max) * width
                            rectPath = UIBezierPath(rect: CGRect(x: CGFloat(x0Line - negBarWidth),y: CGFloat(y+1),width: CGFloat(negBarWidth),height: barHeight))
                        }
                        properties.currentColor.setFill()
                        rectPath.fill()
                    }
                }
            }
        }
    }
}
