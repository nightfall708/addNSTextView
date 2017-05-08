//
//  NSTextView+Rx.swift
//  RxCocoa
//
//  Created by Tal Shrestha on 5/8/17.
//  Copyright © 2015 Tal Shrestha. All rights reserved.
//

#if os(macOS)
    
    import Cocoa
#if !RX_NO_MODULE
    import RxSwift
#endif
    
    /// Delegate proxy for `NSTextView`.
    ///
    /// For more information take a look at `DelegateProxyType`.
    public class RxTextViewDelegateProxy
        : DelegateProxy
        , NSTextViewDelegate
    , DelegateProxyType {
        
        fileprivate let textSubject = PublishSubject<String?>()
        
        /// Typed parent object.
        public weak private(set) var textView: NSTextView?
        
        /// Initializes `RxTextViewDelegateProxy`
        ///
        /// - parameter parentObject: Parent object for delegate proxy.
        public required init(parentObject: AnyObject) {
            self.textView = castOrFatalError(parentObject)
            super.init(parentObject: parentObject)
        }
        
        // MARK: Delegate methods
        
        public override func controlTextDidChange(_ notification: Notification) {
            let textView: NSTextView = castOrFatalError(notification.object)
            let nextValue = textView.stringValue
            self.textSubject.on(.next(nextValue))
        }
        
        // MARK: Delegate proxy methods
        
        /// For more information take a look at `DelegateProxyType`.
        public override class func createProxyForObject(_ object: AnyObject) -> AnyObject {
            let control: NSTextView = castOrFatalError(object)
            return control.createRxDelegateProxy()
        }
        
        /// For more information take a look at `DelegateProxyType`.
        public class func currentDelegateFor(_ object: AnyObject) -> AnyObject? {
            let textView: NSTextView = castOrFatalError(object)
            return textView.delegate
        }
        
        /// For more information take a look at `DelegateProxyType`.
        public class func setCurrentDelegate(_ delegate: AnyObject?, toObject object: AnyObject) {
            let textView: NSTextView = castOrFatalError(object)
            textView.delegate = castOptionalOrFatalError(delegate)
        }
        
    }
    
    extension NSTextView {
        
        /// Factory method that enables subclasses to implement their own `delegate`.
        ///
        /// - returns: Instance of delegate proxy that wraps `delegate`.
        public func createRxDelegateProxy() -> RxTextViewDelegateProxy {
            return RxtextViewDelegateProxy(parentObject: self)
        }
    }
    
    extension Reactive where Base: NSTextView {
        
        /// Reactive wrapper for `delegate`.
        ///
        /// For more information take a look at `DelegateProxyType` protocol documentation.
        public var delegate: DelegateProxy {
            return RxtextViewDelegateProxy.proxyForObject(base)
        }
        
        /// Reactive wrapper for `text` property.
        public var text: ControlProperty<String?> {
            let delegate = RxtextViewDelegateProxy.proxyForObject(base)
            
            let source = Observable.deferred { [weak textView = self.base] in
                delegate.textSubject.startWith(textView?.stringValue)
                }.takeUntil(deallocated)
            
            let observer = UIBindingObserver(UIElement: base) { (control, value: String?) in
                control.stringValue = value ?? ""
            }
            
            return ControlProperty(values: source, valueSink: observer.asObserver())
        }
        
    }
    
#endif
