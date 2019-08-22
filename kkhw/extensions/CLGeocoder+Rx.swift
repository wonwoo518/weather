//
//  CLGeocoder+Rx.swift
//
//  Created by Daniel Tartaglia on 5/7/16.
//  Copyright © 2018 Daniel Tartaglia. MIT License.
//

import RxSwift
import CoreLocation
import Contacts

public extension Reactive where Base: CLGeocoder {

    func reverseGeocodeLocation(location: CLLocation) -> Observable<[CLPlacemark]> {
        return Observable<[CLPlacemark]>.create { observer in
            semaphore.wait()
            geocodeHandler(observer: observer, geocode: curry2(self.base.reverseGeocodeLocation(_: completionHandler:), location))
            return Disposables.create(with: cancel(self.base))
        }
        .subscribeOn(scheduler)
    }

    @available(iOS, introduced: 5.0, deprecated: 11.0, message: "Use -geocodePostalAddress:")
    func geocodeAddressDictionary(_ addressDictionary: [NSObject : AnyObject]) -> Observable<[CLPlacemark]> {
        return Observable<[CLPlacemark]>.create { observer in
            semaphore.wait()
            geocodeHandler(observer: observer, geocode: curry2(self.base.geocodeAddressDictionary(_: completionHandler:), addressDictionary))
            return Disposables.create(with: cancel(self.base))
        }
        .subscribeOn(scheduler)
    }

    @available(iOS 11.0, *)
    func geocodePostalAddress(_ postalAddress: CNPostalAddress) -> Observable<[CLPlacemark]> {
        return Observable<[CLPlacemark]>.create { observer in
            semaphore.wait()
            geocodeHandler(observer: observer, geocode: curry2(self.base.geocodePostalAddress(_: completionHandler:), postalAddress))
            return Disposables.create(with: cancel(self.base))
        }
        .subscribeOn(scheduler)
    }

    func geocodeAddressString(_ addressString: String) -> Observable<[CLPlacemark]> {
        return Observable<[CLPlacemark]>.create { observer in
            semaphore.wait()
            geocodeHandler(observer: observer, geocode: curry2(self.base.geocodeAddressString(_: completionHandler:), addressString))
            return Disposables.create(with: cancel(self.base))
        }
        .subscribeOn(scheduler)
    }

    func geocodeAddressString(_ addressString: String, in region: CLRegion?) -> Observable<[CLPlacemark]> {
        return Observable<[CLPlacemark]>.create { observer in
            semaphore.wait()
            geocodeHandler(observer: observer, geocode: curry3(self.base.geocodeAddressString(_: in: completionHandler:), addressString, region))
            return Disposables.create(with: cancel(self.base))
        }
        .subscribeOn(scheduler)
    }
}

private let semaphore = DispatchSemaphore(value: 1)
private let scheduler = SerialDispatchQueueScheduler(internalSerialQueueName: "CLGeocoderRx")

private func curry2<A, B, C>(_ f: @escaping (A, B) -> C, _ a: A) -> (B) -> C {
    return { b in f(a, b) }
}

private func curry3<A, B, C, D>(_ f: @escaping (A, B, C) -> D, _ a: A, _ b: B) -> (C) -> D {
    return { c in f(a, b, c) }
}

private func geocodeHandler(observer: AnyObserver<[CLPlacemark]>, geocode: @escaping (@escaping CLGeocodeCompletionHandler) -> Void) {
    geocode { placemarks, error in
        if let placemarks = placemarks {
            observer.onNext(placemarks)
            observer.onCompleted()
        }
        else if let error = error {
            observer.onError(error)
        }
        else {
            observer.onError(RxError.unknown)
        }
    }
}

private func cancel(_ geocoder: CLGeocoder) -> () -> Void {
    return {
        geocoder.cancelGeocode()
        semaphore.signal()
    }
}
