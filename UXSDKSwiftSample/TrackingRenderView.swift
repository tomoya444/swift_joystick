//  Converted to Swift 5.9 by Swiftify v5.9.21072 - https://swiftify.com/
//
//  TrackingRenderView.swift
//  P4MissionsDemo
//
//  Created by DJI on 16/2/26.
//  Copyright © 2016年 DJI. All rights reserved.
//
/*
import UIKit

@objc protocol TrackingRenderViewDelegate: NSObjectProtocol {
    @objc optional func renderViewDidTouch(at point: CGPoint)
    @objc optional func renderViewDidMove(to endPoint: CGPoint, from startPoint: CGPoint, isFinished finished: Bool)
}

class TrackingRenderView: UIView {
    weak var delegate: TrackingRenderViewDelegate?
    var trackingRect = CGRect.zero
    var isDottedLine = false

    private var _text: String?
    var text: String? {
        get {
            _text
        }
        set(text) {
            if _text == text {
                return
            }

            _text = text
            setNeedsDisplay()
        }
    }
    private var fillColor: UIColor?
    private var startPoint = CGPoint.zero
    private var endPoint = CGPoint.zero
    private var isMoved = false

    // MARK: - UIResponder Methods

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        isMoved = false
        startPoint = touches.first?.location(in: self) ?? CGPoint.zero
    }

    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        isMoved = true
        endPoint = touches.first?.location(in: self) ?? CGPoint.zero
        if delegate != nil && delegate?.responds(to: #selector(ActiveTrackViewController.renderViewDidMove(to:from:isFinished:))) ?? false {
            delegate?.renderViewDidMove?(to: endPoint, from: startPoint, isFinished: false)
        }
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        endPoint = touches.first?.location(in: self) ?? CGPoint.zero
        if isMoved {
            if delegate != nil && delegate?.responds(to: #selector(ActiveTrackViewController.renderViewDidMove(to:from:isFinished:))) ?? false {
                delegate?.renderViewDidMove?(to: endPoint, from: startPoint, isFinished: true)
            }
        } else {
            if delegate != nil && delegate?.responds(to: #selector(ActiveTrackViewController.renderViewDidTouch(at:))) ?? false {
                delegate?.renderViewDidTouch?(at: startPoint)
            }
        }
    }

    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        endPoint = touches.first?.location(in: self) ?? CGPoint.zero
        if isMoved {
            if delegate != nil && delegate?.responds(to: #selector(ActiveTrackViewController.renderViewDidMove(to:from:isFinished:))) ?? false {
                delegate?.renderViewDidMove?(to: endPoint, from: startPoint, isFinished: true)
            }
        }
    }

    func update(_ rect: CGRect, fill fillColor: UIColor?) {
        if rect.equalTo(trackingRect) {
            return
        }

        self.fillColor = fillColor
        trackingRect = rect
        setNeedsDisplay()
    }

    override func draw(_ rect: CGRect) {
        super.draw(rect)

        if trackingRect.equalTo(CGRectNull) {
            return
        }

        let context = UIGraphicsGetCurrentContext()
        let strokeColor = UIColor.gray
        context?.setStrokeColor(strokeColor.cgColor)
        let fillColor = self.fillColor
        if let CGColor = fillColor?.cgColor {
            context?.setFillColor(CGColor)
        } //Fill Color
        context?.setLineWidth(1.8) //Width of line

        if isDottedLine {
            let lenghts = [10, 10]
            context?.setLineDash(phase: 0, lengths: lenghts)
        }

        context?.addRect(trackingRect)
        context?.drawPath(using: .fillStroke)

        if let text {
            let origin_x = trackingRect.origin.x + 0.5 * trackingRect.size.width - 0.5 * Double(TEXT_RECT_WIDTH)
            let origin_y = trackingRect.origin.y + 0.5 * trackingRect.size.height - 0.5 * Double(TEXT_RECT_HEIGHT)
            let textRect = CGRect(x: origin_x, y: origin_y, width: CGFloat(TEXT_RECT_WIDTH), height: CGFloat(TEXT_RECT_HEIGHT))
            let paragraphStyle = NSParagraphStyle.default as? NSMutableParagraphStyle
            paragraphStyle?.lineBreakMode = .byCharWrapping
            paragraphStyle?.alignment = .center
            let font = UIFont.boldSystemFont(ofSize: 35)
            var dic: [NSAttributedString.Key : UIFont]?
            if let paragraphStyle {
                dic = [
                    NSAttributedString.Key.font: font,
                    NSAttributedString.Key.paragraphStyle: paragraphStyle,
                    NSAttributedString.Key.foregroundColor: UIColor.white
                ]
            }
            text.draw(in: textRect, withAttributes: dic)
        }
    }
}

let TEXT_RECT_WIDTH = 40
let TEXT_RECT_HEIGHT = 40
*/
