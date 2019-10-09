//
//  GraphView.swift
//  iosTestApp
//
//  Created by Hanjun Ko on 09/10/2019.
//  Copyright © 2019 Hanjun Ko. All rights reserved.
//

import Foundation
import UIKit

@IBDesignable class GraphView: UIView {
  
  // 1
    @IBInspectable var startColor: UIColor = .red
    @IBInspectable var endColor: UIColor = .green
    
//    var graphPoints = [4.5, 2.3, 6.1, 4.6, 5.8, 8.6, 3.3]
    var graphPoints:[Float] = [0.0]

    override func draw(_ rect: CGRect) {
        
        let width = rect.width
        let height = rect.height
        
        // 2
        let context = UIGraphicsGetCurrentContext()!
        let colors = [startColor.cgColor, endColor.cgColor]

        // 3
        let colorSpace = CGColorSpaceCreateDeviceRGB()

        // 4
        let colorLocations: [CGFloat] = [0.0, 1.0]

        // 5
        let gradient = CGGradient(colorsSpace: colorSpace,
                                     colors: colors as CFArray,
                                  locations: colorLocations)!

        // 6
        let startPoint = CGPoint.zero
        let endPoint = CGPoint(x: 0, y: bounds.height)
        context.drawLinearGradient(gradient, start: startPoint, end: endPoint, options: [])
        
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: .allCorners, cornerRadii: Constants.cornerRadiusSize)
        path.addClip()
        
        // calculate the x point
        let margin = Constants.margin
        let graphWidth = width - margin * 2 - 4
        let columnXPoint = { (column: Int) -> CGFloat in
          //Calculate the gap between points
          let spacing = graphWidth / CGFloat(self.graphPoints.count - 1)
          return CGFloat(column) * spacing + margin + 2
        }
        
        // calculate the y point
        let topBorder = Constants.topBorder
        print("top", topBorder)
        let bottomBorder = Constants.bottomBorder
        print("bottom", bottomBorder)
        let graphHeight = height - topBorder - bottomBorder
        print("graphHeight", graphHeight)
        let maxValue = graphPoints.max()!
        print("max", maxValue)
        let columnYPoint = { (graphPoint: Int) -> CGFloat in
          let y = CGFloat(graphPoint) / CGFloat(maxValue) * graphHeight
          return graphHeight + topBorder - y // Flip the graph
        }
        // draw the line graph

        UIColor.white.setFill()
        UIColor.white.setStroke()
            
        // set up the points line
        let graphPath = UIBezierPath()

        // go to start of line
//        graphPath.move(to: CGPoint(x: columnXPoint(0), y: columnYPoint(graphPoints[0])))
        graphPath.move(to: CGPoint(x: columnXPoint(0), y: columnYPoint(Int(graphPoints[0]))))
            
        // add points for each item in the graphPoints array
        // at the correct (x, y) for the point
        for i in 1..<graphPoints.count {
//            let nextPoint = CGPoint(x: columnXPoint(i), y: columnYPoint(graphPoints[i]))
            let nextPoint = CGPoint(x: columnXPoint(i), y: columnYPoint(Int(graphPoints[i])))
          graphPath.addLine(to: nextPoint)
        }
//
//
//
        graphPath.stroke()
//
//
//
        //Draw horizontal graph lines on the top of everything
        let linePath = UIBezierPath()

        //top line
        linePath.move(to: CGPoint(x: margin, y: topBorder))
        linePath.addLine(to: CGPoint(x: width - margin, y: topBorder))

        //center line
        linePath.move(to: CGPoint(x: margin, y: graphHeight/2 + topBorder))
        linePath.addLine(to: CGPoint(x: width - margin, y: graphHeight/2 + topBorder))

        //bottom line
        linePath.move(to: CGPoint(x: margin, y:height - bottomBorder))
        linePath.addLine(to: CGPoint(x:  width - margin, y: height - bottomBorder))
        let color = UIColor(white: 1.0, alpha: Constants.colorAlpha)
        color.setStroke()
            
        linePath.lineWidth = 1.0
        linePath.stroke()
    }
    
    private struct Constants {
      static let cornerRadiusSize = CGSize(width: 8.0, height: 8.0)
      static let margin: CGFloat = 20.0
      static let topBorder: CGFloat = 60
      static let bottomBorder: CGFloat = 50
      static let colorAlpha: CGFloat = 0.3
      static let circleDiameter: CGFloat = 5.0
    }
}
