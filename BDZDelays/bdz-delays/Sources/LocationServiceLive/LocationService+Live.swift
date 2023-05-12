//
//  LocationService+Live.swift
//  BDZDelays
//
//  Created by Alexander Ignatov on 2.05.23.
//

import Foundation
import CoreLocation

import LocationService
import ROVR
import SharedModels

import Dependencies

private let coordTolerance = 0.001

#if os(iOS)
private let authorizedStatuses: [CLAuthorizationStatus] = [.authorizedAlways, .authorizedWhenInUse]
#elseif os(macOS)
private let authorizedStatuses: [CLAuthorizationStatus] = [.authorized]
#else
private let authorizedStatuses: [CLAuthorizationStatus] = []
#endif


extension LocationService: DependencyKey {
    public static let liveValue: Self = {
        return Self(
            statusStream: {
                let stream = await LocationManagerActor.shared.status
                return stream.map {
                    (authStatus, locationMaybe) -> LocationStatus in
                    
                    switch authStatus {
                    case .notDetermined:
                        return .notYetAskedForAuthorization
                    case .denied:
                        return .denied
                    case .restricted:
                        return .unableToUseLocation
                    case .authorizedAlways, .authorizedWhenInUse:
                        guard let location = locationMaybe else {
                            return .determining
                        }
                        
                        guard let data = try? await RovrDownloader.downloadProximityData(to: .init(
                            latitude: location.latitude, longitude: location.longitude
                        )) else {
                            return .authorized(nearestStation: nil)
                        }
                        
                        guard let id = try? RovrDecoder.decodeStationId(fromLocationData: data)
                        else {
                            return .authorized(nearestStation: nil)
                        }
                        
                        return .authorized(nearestStation: BGStation(id: id))
                        
                    @unknown default:
                        return .unableToUseLocation
                    }
                }.eraseToStream()
            },
            requestAuthorization: {
                await LocationManagerActor.shared.requestAuth()
            }
        )
    }()
}

// "Configuration of your location manager object must always occur on a thread
// with an active run loop, such as your application’s main thread."
@MainActor
private struct LocationManagerActor {
    
    private(set) static var shared = Self()  // bug: https://stackoverflow.com/a/69264293
    
    let status: AsyncStream<(CLAuthorizationStatus, CLLocationCoordinate2D?)>
    
    private let manager: CLLocationManager
    private let delegate: ManagerDelegate
    
    private init() {
        let manager = CLLocationManager()
        
        let status = manager.authorizationStatus
        let delegate = ManagerDelegate(status: status)
        
        self.status = AsyncStream { cont in
            let location = authorizedStatuses.contains(status)
                ? manager.location?.coordinate
                : nil
            
            cont.yield((status, location))
            
            delegate.onStatusUpdate = { [weak delegate] in
                guard let delegate = delegate else { return }
                
                if authorizedStatuses.contains($0) {
                    manager.startMonitoringVisits()  // it is okay to duplicate these calls
                    cont.yield(($0, manager.location?.coordinate))
                } else {
                    cont.yield(($0, delegate.location))
                }
            }
            
            delegate.onLocationUpdate = { [weak delegate] in
                guard let delegate = delegate else { return }
                cont.yield((delegate.status, $0))
            }
        }
        
        self.manager = manager
        self.delegate = delegate
        
        manager.delegate = delegate
        
        if authorizedStatuses.contains(status) {
            manager.startMonitoringVisits()
        }
    }
    
    func requestAuth() {
        guard case .notDetermined = manager.authorizationStatus else { return }
        manager.requestWhenInUseAuthorization()
    }
}

extension LocationManagerActor {
    class ManagerDelegate: NSObject, CLLocationManagerDelegate {
        
        private(set) var status: CLAuthorizationStatus {
            didSet {
                guard oldValue != status else { return }
                onStatusUpdate?(status)
            }
        }
        
        private(set) var location: CLLocationCoordinate2D? {
            didSet {
                guard !oldValue.isApproximatelyEqualTo(location) else { return }
                onLocationUpdate?(location)
            }
        }
        
        var onStatusUpdate: ((CLAuthorizationStatus) -> Void)?
        var onLocationUpdate: ((CLLocationCoordinate2D?) -> Void)?
        
        init(
            status: CLAuthorizationStatus,
            location: CLLocationCoordinate2D? = nil,
            onStatusUpdate: ((CLAuthorizationStatus) -> Void)? = nil,
            onLocationUpdate: ((CLLocationCoordinate2D?) -> Void)? = nil
        ) {
            self.status = status
            self.location = location
            self.onStatusUpdate = onStatusUpdate
            self.onLocationUpdate = onLocationUpdate
        }
            
        func locationManager(_ manager: CLLocationManager, didVisit visit: CLVisit) {
            location = visit.coordinate
        }
        
        func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
            status = manager.authorizationStatus
        }
    }
}

fileprivate extension Optional where Wrapped == CLLocationCoordinate2D {
    func isApproximatelyEqualTo(_ other: CLLocationCoordinate2D?) -> Bool {
        guard let c1 = self, let c2 = other else {
            return self == nil && other == nil
        }
        
        return abs(c1.latitude - c2.latitude) <= coordTolerance
        && abs(c1.longitude - c2.longitude) <= coordTolerance
    }
}

// TODO: combine with the other extension
fileprivate extension BGStation {
    init?(id: Int) {
        switch id {
        case 141: self = .avramovo
        case 817: self = .aytos
        case 8: self = .aldomirovci
        case 925: self = .alfatar
        case 434: self = .anton
        case 166: self = .asenovgrad
        case 501: self = .asparuhovo
        case 109: self = .bankya
        case 152: self = .bansko
        case 857: self = .banya
        case 638: self = .batanovci
        case 809: self = .bezmer
        case 734: self = .beliIzvor
        case 147: self = .belica
        case 45: self = .belovo
        case 788: self = .belozem
        case 285: self = .beloslav
        case 774: self = .berkovica
        case 661: self = .blagoevgrad
        case 657: self = .boboshevo
        case 182: self = .bov
        case 740: self = .boychinovci
        case 531: self = .borovo
        case 446: self = .botev
        case 416: self = .botunec
        case 162: self = .bracigovo
        case 697: self = .brigadir
        case 745: self = .brusarci
        case 427: self = .bunovo
        case 830: self = .burgas
        case 820: self = .bulgarovo
        case 534: self = .byala
        case 31: self = .vakarel
        case 126: self = .varvara
        case 293: self = .varna
        case 405: self = .varnaFerry
        case 550: self = .velikoTarnovo
        case 134: self = .velingrad
        case 504: self = .velichkovo
        case 32: self = .verinsko
        case 894: self = .vetovo
        case 762: self = .vidinPassenger
        case 761: self = .vidinCargo
        case 902: self = .visokaPolyana
        case 174: self = .vlTrichkov
        case 628: self = .vladaya
        case 829: self = .ВvladimirPavlov
        case 14: self = .voluyak
        case 732: self = .vraca
        case 387: self = .valchiDol
        case 625: self = .gabrovo
        case 474: self = .gavrailovo
        case 676: self = .genTodorov
        case 397: self = .genToshev
        case 681: self = .bigVillage
        case 547: self = .gorPriemPark
        case 627: self = .gornaBanya
        case 633: self = .gornaBanyaSp
        case 238: self = .gornaOryahovitsa
        case 214: self = .gorniDabnik
        case 848: self = .grafIgnatievo
        case 466: self = .gurkovo
        case 728: self = .gyueshevo
        case 675: self = .damyanica
        case 630: self = .daskalovo
        case 529: self = .dveMogili
        case 552: self = .debelec
        case 381: self = .devnya
        case 648: self = .delyan
        case 241: self = .dzhulyunica
        case 77: self = .dimitrovgrad
        case 579: self = .dimitrovgradSv
        case 754: self = .dimovo
        case 154: self = .dobrinishte
        case 392: self = .dobrich
        case 352: self = .doyranci
        case 524: self = .dolapite
        case 131: self = .dyulene
        case 851: self = .dolnaMahala
        case 328: self = .dolnaMitropoliya
        case 215: self = .dolniDabnik
        case 643: self = .dolniRakovec
        case 825: self = .dolnoEzer
        case 426: self = .dolnoKamarci
        case 629: self = .dragichevo
        case 6: self = .dragoman
        case 253: self = .dralfa
        case 747: self = .drenovec
        case 822: self = .druzhba
        case 556: self = .dryanovo
        case 922: self = .dulovo
        case 458: self = .dunavci
        case 653: self = .dupnica
        case 463: self = .dabovo
        case 503: self = .dalgopol
        case 496: self = .daskotna
        case 650: self = .dyakovo
        case 288: self = .ezerovo
        case 27: self = .elinPelin
        case 189: self = .eliseyna
        case 478: self = .zhelyuVoyvoda
        case 492: self = .zavet
        case 811: self = .zavoy
        case 626: self = .zaharnaFabrika
        case 191: self = .zverino
        case 711: self = .zemen
        case 479: self = .zimnica
        case 431: self = .zlatica
        case 571: self = .zmeyovo
        case 526: self = .ivanovo
        case 170: self = .iliyanci
        case 23: self = .iskar
        case 946: self = .iskarskoShose
        case 916: self = .isperih
        case 35: self = .ithiman
        case 460: self = .kazanlak
        case 25: self = .kazichene
        case 800: self = .kalitinovo
        case 3: self = .kalotina
        case 2: self = .kalotinaZapad
        case 449: self = .kalofer
        case 796: self = .kaloyanovec
        case 849: self = .kaloyanovo
        case 92: self = .kapiKule
        case 72: self = .karadzhalovo
        case 398: self = .kardam
        case 444: self = .karlovo
        case 207: self = .karlukovo
        case 483: self = .karnobat
        case 270: self = .kaspichan
        case 66: self = .katunica
        case 807: self = .kermen
        case 437: self = .klisura
        case 240: self = .kozarevec
        case 377: self = .komunari
        case 806: self = .horsovo
        case 435: self = .koprivshtica
        case 133: self = .kostandovo
        case 41: self = .kostenec
        case 12: self = .kostinbrod
        case 659: self = .kocherinovo
        case 636: self = .krakra
        case 415: self = .kremikovci
        case 670: self = .kresna
        case 736: self = .krivodol
        case 159: self = .krichim
        case 64: self = .krumovo
        case 565: self = .krastec
        case 679: self = .kulata
        case 206: self = .kunino
        case 172: self = .kurilo
        case 599: self = .kardzhali
        case 718: self = .kyustendil
        case 184: self = .lakatnik
        case 225: self = .levski
        case 357: self = .lovech
        case 355: self = .lovechSeverRp
        case 486: self = .lozarevo
        case 780: self = .lom
        case 868: self = .lyubenovoPred
        case 87: self = .lyubimec
        case 494: self = .lyulyakovoRp
        case 424: self = .makocevo
        case 787: self = .manole
        case 744: self = .medkovec
        case 198: self = .mezdra
        case 196: self = .mezdraYug
        case 577: self = .mericleri
        case 631: self = .metalStop
        case 428: self = .mirkovo
        case 573: self = .mihaylovo
        case 40: self = .mominProhod
        case 602: self = .momchilGrad
        case 768: self = .montana
        case 532: self = .morunica
        case 589: self = .most
        case 512: self = .musachevoRp
        case 741: self = .murchevo
        case 267: self = .mutnica
        case 805: self = .novaZagora
        case 81: self = .novaNadezhda
        case 514: self = .obedinena
        case 891: self = .obrazvocChiflik
        case 53: self = .ognyanovo
        case 341: self = .oresh
        case 751: self = .oreshec
        case 790: self = .orizovo
        case 455: self = .pavelBanya
        case 229: self = .pavlikeni
        case 51: self = .pazardzhik
        case 846: self = .panagyurishte
        case 668: self = .peyoYavorov
        case 635: self = .pernik
        case 632: self = .pernikRazpred
        case 539: self = .petkoKaravelov
        case 688: self = .petrich
        case 11: self = .peturch
        case 163: self = .peshtera
        case 433: self = .pirdop
        case 562: self = .plachkovci
        case 219: self = .pleven
        case 218: self = .plevenZapad
        case 908: self = .pliska
        case 60: self = .plovdiv
        case 164: self = .plovdivRazpred
        case 28: self = .pobitKamak
        case 283: self = .povelyanovo
        case 489: self = .podvis
        case 606: self = .podkova
        case 20: self = .poduyanePatn
        case 235: self = .polikraishte
        case 536: self = .polskiTrambesh
        case 69: self = .popovica
        case 248: self = .popovo
        case 222: self = .pordim
        case 490: self = .prileprp
        case 275: self = .provadiya
        case 897: self = .prostorno
        case 71: self = .parvomay
        case 871: self = .radnevo
        case 641: self = .radomir
        case 567: self = .radunci
        case 714: self = .razdhavica
        case 899: self = .razgrad
        case 282: self = .razdelna
        case 151: self = .razlog
        case 689: self = .razmenna
        case 176: self = .rebrovo
        case 233: self = .resen
        case 204: self = .roman
        case 522: self = .ruse
        case 887: self = .ruseZapad
        case 520: self = .ruseRazpred
        case 909: self = .ruseSever
        case 730: self = .ruskaByala
        case 67: self = .sadovo
        case 548: self = .samovodene
        case 901: self = .samuil
        case 674: self = .sandanski
        case 422: self = .saranci
        case 456: self = .sahrene
        case 412: self = .svetovrachene
        case 88: self = .svilengrad
        case 338: self = .svishtov
        case 794: self = .svoboda
        case 179: self = .svoge
        case 896: self = .senovo
        case 47: self = .septemvri
        case 928: self = .silistra
        case 83: self = .simeonovgrad
        case 664: self = .simitli
        case 280: self = .sindel
        case 786: self = .skutare
        case 246: self = .slavyanovo
        case 476: self = .sliven
        case 10: self = .slivnica
        case 372: self = .smyadovo
        case 336: self = .somovit
        case 443: self = .sopot
        case 18: self = .sofia
        case 169: self = .sofiaSever
        case 756: self = .sracimir
        case 56: self = .stamboliyski
        case 100: self = .stanyanci
        case 572: self = .staraZagora
        case 419: self = .stolnik
        case 243: self = .strazhica
        case 480: self = .straldzha
        case 845: self = .strelcha
        case 672: self = .strumyani
        case 436: self = .stryama
        case 385: self = .suvorovo
        case 838: self = .saedinenie
        case 468: self = .tvardica
        case 213: self = .telish
        case 58: self = .todorKableshkov
        case 290: self = .topolite
        case 831: self = .trakia
        case 368: self = .troyan
        case 847: self = .trud
        case 560: self = .tryavna
        case 462: self = .tulovo
        case 452: self = .tazha
        case 257: self = .targovishte
        case 499: self = .tarnak
        case 784: self = .filipovo
        case 803: self = .hanAsparuh
        case 262: self = .hanKrum
        case 85: self = .harmanli
        case 583: self = .haskovo
        case 860: self = .hisar
        case 904: self = .hitrino
        case 699: self = .hrabarsko
        case 439: self = .hristoDanovo
        case 558: self = .carLivada
        case 138: self = .cvetino
        case 482: self = .cerkovski
        case 209: self = .chervenBryag
        case 461: self = .cherganovo
        case 337: self = .cherkvica
        case 791: self = .chernaGora
        case 665: self = .cherniche
        case 814: self = .chernograd
        case 793: self = .chirpan
        case 123: self = .chukurovo
        case 470: self = .shivachevo
        case 265: self = .shumen
        case 507: self = .yunak
        case 75: self = .yabalkovo
        case 144: self = .yakoruda
        case 810: self = .yambol
        case 417: self = .yana
        case 542: self = .yantra
        case 216: self = .yasen
        default: return nil
        }
    }
}
