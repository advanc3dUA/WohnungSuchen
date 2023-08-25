//
//  UISwitch+publisher.swift
//  DetectChanges
//
//  Created by Yuriy Gudimov on 27.04.2023.
//

import UIKit
import Combine

extension UISwitch {
    var switchPublisher: AnyPublisher<Bool, Never> {
        UISwitchPublisher(control: self)
            .eraseToAnyPublisher()
    }
}

final class UISwitchPublisher: Publisher {
    typealias Output = Bool
    typealias Failure = Never

    private let control: UISwitch

    init(control: UISwitch) {
        self.control = control
    }

    func receive<S>(subscriber: S) where S: Subscriber, S.Failure == Never, S.Input == Bool {
        let subscription = UISwitchSubscription(subscriber: subscriber, control: control)
        subscriber.receive(subscription: subscription)
    }
}

final class UISwitchSubscription<S: Subscriber>: Subscription where S.Input == Bool, S.Failure == Never {
    private var subscriber: S?
    private let control: UISwitch

    init(subscriber: S, control: UISwitch) {
        self.subscriber = subscriber
        self.control = control
        control.addTarget(self, action: #selector(onValueChanged), for: .valueChanged)
    }

    func request(_ demand: Subscribers.Demand) {

    }

    func cancel() {
        subscriber = nil
    }

    @objc func onValueChanged() {
        _ = subscriber?.receive(control.isOn)
    }
}
