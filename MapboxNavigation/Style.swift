import UIKit

/**
 `Style` is a convenient wrapper for styling the appearance of various interface components throughout the Navigation UI.
 
 Styles are applied globally using `UIAppearance`. You should call `Style.apply()` to apply the style to the `NavigationViewController`.
 */
@objc(MBStyle)
open class Style: NSObject {
    
    required public override init() {
        super.init()
        NotificationCenter.default.addObserver(self, selector: #selector(preferredContentSizeChanged(_:)), name: NSNotification.Name.UIContentSizeCategoryDidChange, object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    func preferredContentSizeChanged(_ notification: Notification) {
        apply()
    }
    
    ///  General styling
    
    /**
     Sets the tint color for guidance arrow, highlighted text, progress bar and more.
     */
    public var tintColor: UIColor?
    
    /**
     Sets the status bar style.
     `UIViewControllerBasedStatusBarAppearance` must be set to NO for this property to have any effect.
     */
    public var statusBarStyle: UIStatusBarStyle?
    
    /**
     Sets the font family for all labels.
     */
    public var fontFamily: String?
    
    /**
     Describes the situations in which the style should be used. By default, the style will be used during the daytime.
     */
    public var styleType: StyleType = .dayStyle
    
    /**
     Map style to be used for the style.
     */
    open var mapStyleURL: URL = URL(string: "mapbox://styles/mapbox/navigation-guidance-day-v2")!
    
    /**
     Applies the style for all changed properties.
     */
    open func apply() {
        
    }
}

/**
 :nodoc:
 `MBButton` sets the tintColor according to the style.
 */
@objc(MBButton)
open class Button: StylableButton { }

@objc(MBCancelButton)
open class CancelButton: Button { }

/// :nodoc:
@objc(MBFloatingButton)
open class FloatingButton: Button { }

/// :nodoc:
@objc(MBLanesView)
public class LanesView: UIView { }

/**
 :nodoc:
 `HighlightedButton` sets the button’s titleColor for normal control state according to the style in addition to the styling behavior inherited from
 `Button`.
 */
@objc(MBHighlightedButton)
public class HighlightedButton: Button { }

@IBDesignable
@objc(MBResumeButton)
public class ResumeButton: UIControl {
    public override dynamic var tintColor: UIColor! {
        didSet {
            imageView.tintColor = tintColor
            titleLabel.textColor = tintColor
        }
    }
    
    let imageView = UIImageView(image: UIImage(named: "location", in: .mapboxNavigation, compatibleWith: nil)!.withRenderingMode(.alwaysTemplate))
    let titleLabel = UILabel()
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    public override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        commonInit()
    }
    
    func commonInit() {
        titleLabel.text = NSLocalizedString("RESUME", bundle: .mapboxNavigation, value: "Resume", comment: "Button title for resume tracking")
        titleLabel.sizeToFit()
        addSubview(imageView)
        addSubview(titleLabel)
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        imageView.translatesAutoresizingMaskIntoConstraints = false
        translatesAutoresizingMaskIntoConstraints = false
        
        let views = ["label": titleLabel, "imageView": imageView]
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-8-[imageView]-8-[label]-8-|", options: [], metrics: nil, views: views))
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|->=12-[imageView]->=12-|", options: [], metrics: nil, views: views))
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|->=12-[label]->=12-|", options: [], metrics: nil, views: views))
        setNeedsUpdateConstraints()
        
        applyDefaultCornerRadiusShadow()
    }
}

/// :nodoc:
@objc(MBStylableLabel)
open class StylableLabel : UILabel { }

/// :nodoc:
@objc(MBDistanceLabel)
open class DistanceLabel: StylableLabel { }

/// :nodoc:
@objc(MBDestinationLabel)
open class DestinationLabel: StylableLabel {
    typealias AvailableBoundsHandler = () -> (CGRect)
    var availableBounds: AvailableBoundsHandler!
    var unabridgedText: String? {
        didSet {
            super.text = unabridgedText?.abbreviated(toFit: availableBounds(), font: font)
        }
    }
}

/// :nodoc:
@objc(MBTimeRemainingLabel)
open class TimeRemainingLabel: StylableLabel {
    dynamic public var trafficUnknownColor: UIColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
    dynamic public var trafficLowColor: UIColor = #colorLiteral(red: 0.4666666687, green: 0.7647058964, blue: 0.2666666806, alpha: 1)
    dynamic public var trafficModerateColor: UIColor = #colorLiteral(red:0.95, green:0.65, blue:0.31, alpha:1.0)
    dynamic public var trafficHeavyColor: UIColor = #colorLiteral(red:0.91, green:0.20, blue:0.25, alpha:1.0)
    dynamic public var trafficSevereColor: UIColor = #colorLiteral(red:0.54, green:0.06, blue:0.22, alpha:1.0)
}

/// :nodoc:
@objc(MBDistanceRemainingLabel)
open class DistanceRemainingLabel: StylableLabel { }

/// :nodoc:
@objc(MBArrivalTimeLabel)
open class ArrivalTimeLabel: StylableLabel { }

/// :nodoc:
@objc(MBTitleLabel)
open class TitleLabel: StylableLabel { }

/// :nodoc:
@objc(MBSubtitleLabel)
open class SubtitleLabel: StylableLabel { }

/// :nodoc:
@objc(MBCellTitleLabel)
open class CellTitleLabel: StylableLabel { }

/// :nodoc:
@objc(MBCellSubtitleLabel)
open class CellSubtitleLabel: StylableLabel { }

/// :nodoc:
@objc(MBWayNameLabel)
open class WayNameLabel: StylableLabel { }

@objc(MBWayNameView)
open class WayNameView: UIView {
    
    dynamic public var borderColor: UIColor = .white {
        didSet {
            layer.borderColor = borderColor.cgColor
        }
    }
    
    open override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = bounds.midY
    }
}

/// :nodoc:
@objc(MBProgressBar)
public class ProgressBar: UIView {
    
    let bar = UIView()
    
    dynamic public var barColor: UIColor = #colorLiteral(red: 0.1411764771, green: 0.3960784376, blue: 0.5647059083, alpha: 1) {
        didSet {
            bar.backgroundColor = barColor
        }
    }
    
    // Set the progress between 0.0-1.0
    var progress: CGFloat = 0 {
        didSet {
            UIView.defaultAnimation(0.5, animations: { 
                self.updateProgressBar()
                self.layoutIfNeeded()
            }, completion: nil)
        }
    }
    
    func dock(on view: UIView) {
        translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(self)
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-0-[bar]-0-|", options: [], metrics: nil, views: ["bar": self]))
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[bar(3)]-0-|", options: [], metrics: nil, views: ["bar": self]))
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        
        if bar.superview == nil {
            addSubview(bar)
        }
        
        updateProgressBar()
    }
    
    func updateProgressBar() {
        if let superview = superview {
            bar.frame = CGRect(origin: .zero, size: CGSize(width: superview.bounds.width*progress, height: 3))
        }
    }
}

/// :nodoc:
@objc(MBLineView)
public class LineView: UIView {
    dynamic var lineColor: UIColor = .black {
        didSet {
            setNeedsDisplay()
            setNeedsLayout()
        }
    }
}

/// :nodoc:
@objc(MBSeparatorView)
public class SeparatorView: UIView { }

/// :nodoc:
@objc(MBStylableButton)
open class StylableButton: UIButton {
    dynamic open var textColor: UIColor = .black {
        didSet {
            setTitleColor(textColor, for: .normal)
        }
    }
    
    dynamic open var borderColor: UIColor = .clear {
        didSet {
            layer.borderColor = borderColor.cgColor
        }
    }
    
    dynamic open var borderWidth: CGFloat = 0 {
        didSet {
            layer.borderWidth = borderWidth
        }
    }
    
    dynamic open var cornerRadius: CGFloat = 0 {
        didSet {
            layer.cornerRadius = cornerRadius
        }
    }
}

/// :nodoc:
@objc(MBManeuverView)
public class ManeuverView: UIView { }

/// :nodoc:
@objc(MBManeuverContainerView)
class ManeuverContainerView: UIView {
    @IBOutlet weak var heightConstraint: NSLayoutConstraint!
    
    dynamic var height: CGFloat = 100 {
        didSet {
            heightConstraint.constant = height
            setNeedsUpdateConstraints()
        }
    }
}

/// :nodoc:
@objc(MBStatusView)
public class StatusView: UIView {
    @IBOutlet weak var activityIndicatorView: UIActivityIndicatorView!
    @IBOutlet weak var textLabel: UILabel!
    
    func show(_ title: String, showSpinner: Bool) {
        textLabel.text = title
        activityIndicatorView.hidesWhenStopped = true
        if showSpinner {
            activityIndicatorView.startAnimating()
        } else {
            activityIndicatorView.stopAnimating()
        }
        
        guard isHidden == true else { return }
        
        UIView.defaultAnimation(0.3, animations: {
            self.isHidden = false
        }, completion: nil)
    }
    
    func hide(delay: TimeInterval = 0, animated: Bool = true) {
        
        if animated {
            guard isHidden == false else { return }
            UIView.defaultAnimation(0.3, delay: delay, animations: {
                self.isHidden = true
            }, completion: { (completed) in
                self.activityIndicatorView.stopAnimating()
            })
        } else {
            self.activityIndicatorView.stopAnimating()
            self.isHidden = true
        }
    }
}
