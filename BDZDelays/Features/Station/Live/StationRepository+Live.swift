//
//  StationRepository+Live.swift
//  BDZDelays
//
//  Created by Alexander Ignatov on 22.04.23.
//

import Foundation
import Dependencies

fileprivate typealias Train = StationReducer.State.TrainAtStation

extension StationRepository: DependencyKey {
    static let liveValue: Self = {
        
        @Dependency(\.date.now) var now
        @Dependency(\.calendar) var calendar
        // TODO: make the scraper a dependency too
        
        let cache = CacheActor()
        
        return Self(
            fetchTrainsAtStation: { station -> [Train] in
                let stationId = station.apiID
                
                let cacheEntry = await cache.retrieve(for: stationId)
                let isInTheSameMinute = cacheEntry
                    .map {
                        let components: Set<Calendar.Component> = [.day, .hour, .minute]
                        let entryComponents = calendar.dateComponents(components, from: $0.date)
                        let nowComponents = calendar.dateComponents(components, from: now)
                        return entryComponents == nowComponents
                    }
                
                if let entry = cacheEntry, isInTheSameMinute == true {
                    // ROVR updates the available data every whole minute
                    // so there is no point in refetching for the same minute.
                    return entry.trains
                }
                
                let rawData = try await RovrDownloader.downloadPageData(stationId: stationId)
                let htmlString = try RovrHTMLScraper.decode(pageData: rawData)
                let scrapedTrains = try RovrHTMLScraper.parseHTML(htmlString)
                let result = try scrapedTrains.map { try Train($0, station: station) }
                
                await cache.updateValue(.init(date: now, trains: result), forKey: stationId)
                
                return result
            }
        )
    }()
}

// MARK: - Cache

fileprivate actor CacheActor {
    private var cache: [Int: Entry] = [:]
    
    func retrieve(for key: Int) -> Entry? {
        return cache[key]
    }
    
    func updateValue(_ value: Entry?, forKey key: Int) {
        cache[key] = value
    }
}

extension CacheActor {
    struct Entry {
        let date: Date
        let trains: [Train]
    }
}

// MARK: - Convertions

fileprivate extension StationReducer.State.TrainAtStation {
    init(_ data: RovrHTMLScraper.TrainData, station: BGStation) throws {
        self.init(
            number: TrainNumber(
                type: try TrainType(data.type),
                number: Int(data.number) ?? 0
            ),
            from: data.from.map(Station.init) ?? .bulgarian(station),
            to: Station(data.to),
            schedule: try .init(data),
            delay: data.delayMinutes.map { Duration.seconds($0 * 60) },
            movement: .init(data)
        )
    }
}

fileprivate let dateFormatter: DateFormatter = {
    let result = DateFormatter()
    result.dateFormat = "HH:mm"
    result.timeZone = TimeZone(identifier: "Europe/Sofia")
    return result
}()

fileprivate extension String {
    func asDate() throws -> Date {
        guard let date = dateFormatter.date(from: self) else {
            throw StationRepositoryError.invalidData
        }
        
        return date
    }
}

fileprivate extension StationReducer.State.TrainAtStation.Schedule {
    init(_ data: RovrHTMLScraper.TrainData) throws {
        switch (data.arrival, data.departure) {
        case let (.some(arrival), .some(departure)):
            self = .full(arrival: try arrival.asDate(), departure: try departure.asDate())
        case let (.some(arrival), .none):
            self = .arrivalOnly(try arrival.asDate())
        case let (.none, .some(departure)):
            self = .departureOnly(try departure.asDate())
        case (.none, .none):
            throw StationRepositoryError.invalidData
        }
    }
}

fileprivate extension StationReducer.State.TrainAtStation.MovementState {
    init(_ data: RovrHTMLScraper.TrainData) {
        if data.isOperating {
            self = .inOperation
        } else if data.isAboutToLeave {
            self = .doorsOpen
        } else if data.hasLeft {
            self = .leavingStation
        } else if data.hasArrived {
            self = .stopped
        } else {
            self = .notYetOperating
        }
    }
}

fileprivate extension TrainType {
    init(_ string: String) throws {
        switch string {
        case "КПВ": self = .suburban
        case "ПВ": self = .normal
        case "БВ": self = .fast
        case "МБВ": self = .international
        default: self = .other(string)
        }
    }
}


fileprivate extension Station {
    init(_ string: String) {
        guard let bgStation = BGStation(string) else {
            self = .other(string)
            return
        }
        
        self = .bulgarian(bgStation)
    }
}

fileprivate extension BGStation {
    init?(_ string: String) {
        switch string {
        case "Аврамово": self = .avramovo
        case "Айтос": self = .aytos
        case "Алдомировци": self = .aldomirovci
        case "Алфатар": self = .alfatar
        case "Антон": self = .anton
        case "Асеновград": self = .asenovgrad
        case "Аспарухово": self = .asparuhovo
        case "Банкя": self = .bankya
        case "Банско": self = .bansko
        case "Баня": self = .banya
        case "Батановци": self = .batanovci
        case "Безмер": self = .bezmer
        case "Бели извор": self = .beliIzvor
        case "Белица": self = .belica
        case "Белово": self = .belovo
        case "Белозем": self = .belozem
        case "Белослав": self = .beloslav
        case "Берковица": self = .berkovica
        case "Благоевград": self = .blagoevgrad
        case "Бобошево": self = .boboshevo
        case "Бов": self = .bov
        case "Бойчиновци": self = .boychinovci
        case "Борово": self = .borovo
        case "Ботев": self = .botev
        case "Ботунец": self = .botunec
        case "Брацигово": self = .bracigovo
        case "Бригадир": self = .brigadir
        case "Брусарци": self = .brusarci
        case "Буново": self = .bunovo
        case "Бургас": self = .burgas
        case "Българово": self = .bulgarovo
        case "Бяла": self = .byala
        case "Вакарел": self = .vakarel
        case "Варвара": self = .varvara
        case "Варна": self = .varna
        case "Варна ферибоот.": self = .varnaFerry
        case "Велико търново": self = .velikoTarnovo
        case "Велинград": self = .velingrad
        case "Величково": self = .velichkovo
        case "Веринско": self = .verinsko
        case "Ветово": self = .vetovo
        case "Видин пътн.": self = .vidinPassenger
        case "Видин товарна": self = .vidinCargo
        case "Висока поляна": self = .visokaPolyana
        case "Вл.тричков": self = .vlTrichkov
        case "Владая": self = .vladaya
        case "Владимир павлов": self = .ВvladimirPavlov
        case "Волуяк": self = .voluyak
        case "Враца": self = .vraca
        case "Вълчи дол": self = .valchiDol
        case "Габрово": self = .gabrovo
        case "Гавраилово": self = .gavrailovo
        case "Ген.тодоров": self = .genTodorov
        case "Ген.тошев": self = .genToshev
        case "Голямо село": self = .bigVillage
        case "Гор прием.парк": self = .gorPriemPark
        case "Горна баня": self = .gornaBanya
        case "Горна баня сп": self = .gornaBanyaSp
        case "Горна оряховица": self = .gornaOryahovitsa
        case "Горни дъбник": self = .gorniDabnik
        case "Граф игнатиево": self = .grafIgnatievo
        case "Гурково": self = .gurkovo
        case "Гюешево": self = .gyueshevo
        case "Дамяница": self = .damyanica
        case "Даскалово": self = .daskalovo
        case "Две могили": self = .dveMogili
        case "Дебелец": self = .debelec
        case "Девня": self = .devnya
        case "Делян": self = .delyan
        case "Джулюница": self = .dzhulyunica
        case "Димитровград": self = .dimitrovgrad
        case "Димитровград св": self = .dimitrovgradSv
        case "Димово": self = .dimovo
        case "Добринище": self = .dobrinishte
        case "Добрич": self = .dobrich
        case "Дойренци": self = .doyranci
        case "Долапите": self = .dolapite
        case "Долене": self = .dyulene
        case "Долна махала": self = .dolnaMahala
        case "Долна митропол.": self = .dolnaMitropoliya
        case "Долни дъбник": self = .dolniDabnik
        case "Долни раковец": self = .dolniRakovec
        case "Долно езер.": self = .dolnoEzer
        case "Долно камарци": self = .dolnoKamarci
        case "Драгичево": self = .dragichevo
        case "Драгоман": self = .dragoman
        case "Дралфа": self = .dralfa
        case "Дреновец": self = .drenovec
        case "Дружба": self = .druzhba
        case "Дряново": self = .dryanovo
        case "Дулово": self = .dulovo
        case "Дунавци": self = .dunavci
        case "Дупница": self = .dupnica
        case "Дъбово": self = .dabovo
        case "Дългопол": self = .dalgopol
        case "Дъскотна": self = .daskotna
        case "Дяково": self = .dyakovo
        case "Езерово": self = .ezerovo
        case "Елин пелин": self = .elinPelin
        case "Елисейна": self = .eliseyna
        case "Желю войвода": self = .zhelyuVoyvoda
        case "Завет": self = .zavet
        case "Завой": self = .zavoy
        case "Захарна фабрика": self = .zaharnaFabrika
        case "Зверино": self = .zverino
        case "Земен": self = .zemen
        case "Зимница": self = .zimnica
        case "Златица": self = .zlatica
        case "Змейово": self = .zmeyovo
        case "Иваново": self = .ivanovo
        case "Илиянци": self = .iliyanci
        case "Искър": self = .iskar
        case "Искърско шосе": self = .iskarskoShose
        case "Исперих": self = .isperih
        case "Ихтиман": self = .ithiman
        case "Казанлък": self = .kazanlak
        case "Казичене": self = .kazichene
        case "Калитиново": self = .kalitinovo
        case "Калотина": self = .kalotina
        case "Калотина запад": self = .kalotinaZapad
        case "Калофер": self = .kalofer
        case "Калояновец": self = .kaloyanovec
        case "Калояново": self = .kaloyanovo
        case "Капъ куле": self = .kapiKule
        case "Караджалово": self = .karadzhalovo
        case "Кардам": self = .kardam
        case "Карлово": self = .karlovo
        case "Карлуково": self = .karlukovo
        case "Карнобат": self = .karnobat
        case "Каспичан": self = .kaspichan
        case "Катуница": self = .katunica
        case "Кермен": self = .kermen
        case "Клисура": self = .klisura
        case "Козаревец": self = .kozarevec
        case "Комунари": self = .komunari
        case "Коньово": self = .horsovo
        case "Копривщица": self = .koprivshtica
        case "Костандово": self = .kostandovo
        case "Костенец": self = .kostenec
        case "Костинброд": self = .kostinbrod
        case "Кочериново": self = .kocherinovo
        case "Кракра": self = .krakra
        case "Кремиковци": self = .kremikovci
        case "Кресна": self = .kresna
        case "Криводол": self = .krivodol
        case "Кричим": self = .krichim
        case "Крумово": self = .krumovo
        case "Кръстец": self = .krastec
        case "Кулата": self = .kulata
        case "Кунино": self = .kunino
        case "Курило": self = .kurilo
        case "Кърджали": self = .kardzhali
        case "Кюстендил": self = .kyustendil
        case "Лакатник": self = .lakatnik
        case "Левски": self = .levski
        case "Ловеч": self = .lovech
        case "Ловеч север рп": self = .lovechSeverRp
        case "Лозарево": self = .lozarevo
        case "Лом": self = .lom
        case "Любеново пред.": self = .lyubenovoPred
        case "Любимец": self = .lyubimec
        case "Люляково рп": self = .lyulyakovoRp
        case "Макоцево": self = .makocevo
        case "Маноле": self = .manole
        case "Медковец": self = .medkovec
        case "Мездра": self = .mezdra
        case "Мездра юг": self = .mezdraYug
        case "Меричлери": self = .mericleri
        case "Метал спирка": self = .metalStop
        case "Мирково": self = .mirkovo
        case "Михайлово": self = .mihaylovo
        case "Момин проход": self = .mominProhod
        case "Момчилград": self = .momchilGrad
        case "Монтана": self = .montana
        case "Моруница": self = .morunica
        case "Мост": self = .most
        case "Мусачево рп": self = .musachevoRp
        case "Мърчево": self = .murchevo
        case "Мътница": self = .mutnica
        case "Нова загора": self = .novaZagora
        case "Нова надежда": self = .novaNadezhda
        case "Обединена": self = .obedinena
        case "Образцов чифлик": self = .obrazvocChiflik
        case "Огняново": self = .ognyanovo
        case "Ореш": self = .oresh
        case "Орешец": self = .oreshec
        case "Оризово": self = .orizovo
        case "Павел баня": self = .pavelBanya
        case "Павликени": self = .pavlikeni
        case "Пазарджик": self = .pazardzhik
        case "Панагюрище": self = .panagyurishte
        case "Пейо яворов": self = .peyoYavorov
        case "Перник": self = .pernik
        case "Перник разпред.": self = .pernikRazpred
        case "Петко каравелов": self = .petkoKaravelov
        case "Петрич": self = .petrich
        case "Петърч": self = .peturch
        case "Пещера": self = .peshtera
        case "Пирдоп": self = .pirdop
        case "Плачковци": self = .plachkovci
        case "Плевен": self = .pleven
        case "Плевен запад": self = .plevenZapad
        case "Плиска": self = .pliska
        case "Пловдив": self = .plovdiv
        case "Пловдив разпр.": self = .plovdivRazpred
        case "Побит камък": self = .pobitKamak
        case "Повеляново": self = .povelyanovo
        case "Подвис": self = .podvis
        case "Подкова": self = .podkova
        case "Подуяне пътн.": self = .poduyanePatn
        case "Поликраище": self = .polikraishte
        case "Полски тръмбеш": self = .polskiTrambesh
        case "Поповица": self = .popovica
        case "Попово": self = .popovo
        case "Пордим": self = .pordim
        case "Прилеп рп": self = .prileprp
        case "Провадия": self = .provadiya
        case "Просторно": self = .prostorno
        case "Първомай": self = .parvomay
        case "Раднево": self = .radnevo
        case "Радомир": self = .radomir
        case "Радунци": self = .radunci
        case "Раждавица": self = .razdhavica
        case "Разград": self = .razgrad
        case "Разделна": self = .razdelna
        case "Разлог": self = .razlog
        case "Разменна": self = .razmenna
        case "Реброво": self = .rebrovo
        case "Ресен": self = .resen
        case "Роман": self = .roman
        case "Русе": self = .ruse
        case "Русе запад": self = .ruseZapad
        case "Русе разпредел.": self = .ruseRazpred
        case "Русе север": self = .ruseSever
        case "Руска бяла": self = .ruskaByala
        case "Садово": self = .sadovo
        case "Самоводене": self = .samovodene
        case "Самуил": self = .samuil
        case "Сандански": self = .sandanski
        case "Саранци": self = .saranci
        case "Сахране": self = .sahrene
        case "Световрачене": self = .svetovrachene
        case "Свиленград": self = .svilengrad
        case "Свищов": self = .svishtov
        case "Свобода": self = .svoboda
        case "Своге": self = .svoge
        case "Сеново": self = .senovo
        case "Септември": self = .septemvri
        case "Силистра": self = .silistra
        case "Симеоновград": self = .simeonovgrad
        case "Симитли": self = .simitli
        case "Синдел": self = .sindel
        case "Скутаре": self = .skutare
        case "Славяново": self = .slavyanovo
        case "Сливен": self = .sliven
        case "Сливница": self = .slivnica
        case "Смядово": self = .smyadovo
        case "Сомовит": self = .somovit
        case "Сопот": self = .sopot
        case "София": self = .sofia
        case "София север": self = .sofiaSever
        case "Срацимир": self = .sracimir
        case "Стамболийски": self = .stamboliyski
        case "Станянци": self = .stanyanci
        case "Стара загора": self = .staraZagora
        case "Столник": self = .stolnik
        case "Стражица": self = .strazhica
        case "Стралджа": self = .straldzha
        case "Стрелча": self = .strelcha
        case "Струмяни": self = .strumyani
        case "Стряма": self = .stryama
        case "Суворово": self = .suvorovo
        case "Съединение": self = .saedinenie
        case "Твърдица": self = .tvardica
        case "Телиш": self = .telish
        case "Тодор каблешков": self = .todorKableshkov
        case "Тополите": self = .topolite
        case "Тракия": self = .trakia
        case "Троян": self = .troyan
        case "Труд": self = .trud
        case "Трявна": self = .tryavna
        case "Тулово": self = .tulovo
        case "Тъжа": self = .tazha
        case "Търговище": self = .targovishte
        case "Търнак": self = .tarnak
        case "Филипово": self = .filipovo
        case "Хан аспарух": self = .hanAsparuh
        case "Хан крум": self = .hanKrum
        case "Харманли": self = .harmanli
        case "Хасково": self = .haskovo
        case "Хисар": self = .hisar
        case "Хитрино": self = .hitrino
        case "Храбърско": self = .hrabarsko
        case "Христо даново": self = .hristoDanovo
        case "Цар.ливада": self = .carLivada
        case "Цветино": self = .cvetino
        case "Церковски": self = .cerkovski
        case "Червен бряг": self = .chervenBryag
        case "Черганово": self = .cherganovo
        case "Черквица": self = .cherkvica
        case "Черна гора": self = .chernaGora
        case "Черниче": self = .cherniche
        case "Черноград": self = .chernograd
        case "Чирпан": self = .chirpan
        case "Чукурово": self = .chukurovo
        case "Шивачево": self = .shivachevo
        case "Шумен": self = .shumen
        case "Юнак": self = .yunak
        case "Ябълково": self = .yabalkovo
        case "Якоруда": self = .yakoruda
        case "Ямбол": self = .yambol
        case "Яна": self = .yana
        case "Янтра": self = .yantra
        case "Ясен": self = .yasen

        default: return nil
        }
    }
    
    // MARK: - IDs
    
    var apiID: Int {
        switch self {
        case .avramovo: return 141
        case .aytos: return 817
        case .aldomirovci: return 8
        case .alfatar: return 925
        case .anton: return 434
        case .asenovgrad: return 166
        case .asparuhovo: return 501
        case .bankya: return 109
        case .bansko: return 152
        case .banya: return 857
        case .batanovci: return 638
        case .bezmer: return 809
        case .beliIzvor: return 734
        case .belica: return 147
        case .belovo: return 45
        case .belozem: return 788
        case .beloslav: return 285
        case .berkovica: return 774
        case .blagoevgrad: return 661
        case .boboshevo: return 657
        case .bov: return 182
        case .boychinovci: return 740
        case .borovo: return 531
        case .botev: return 446
        case .botunec: return 416
        case .bracigovo: return 162
        case .brigadir: return 697
        case .brusarci: return 745
        case .bunovo: return 427
        case .burgas: return 830
        case .bulgarovo: return 820
        case .byala: return 534
        case .vakarel: return 31
        case .varvara: return 126
        case .varna: return 293
        case .varnaFerry: return 405
        case .velikoTarnovo: return 550
        case .velingrad: return 134
        case .velichkovo: return 504
        case .verinsko: return 32
        case .vetovo: return 894
        case .vidinPassenger: return 762
        case .vidinCargo: return 761
        case .visokaPolyana: return 902
        case .vlTrichkov: return 174
        case .vladaya: return 628
        case .ВvladimirPavlov: return 829
        case .voluyak: return 14
        case .vraca: return 732
        case .valchiDol: return 387
        case .gabrovo: return 625
        case .gavrailovo: return 474
        case .genTodorov: return 676
        case .genToshev: return 397
        case .bigVillage: return 681
        case .gorPriemPark: return 547
        case .gornaBanya: return 627
        case .gornaBanyaSp: return 633
        case .gornaOryahovitsa: return 238
        case .gorniDabnik: return 214
        case .grafIgnatievo: return 848
        case .gurkovo: return 466
        case .gyueshevo: return 728
        case .damyanica: return 675
        case .daskalovo: return 630
        case .dveMogili: return 529
        case .debelec: return 552
        case .devnya: return 381
        case .delyan: return 648
        case .dzhulyunica: return 241
        case .dimitrovgrad: return 77
        case .dimitrovgradSv: return 579
        case .dimovo: return 754
        case .dobrinishte: return 154
        case .dobrich: return 392
        case .doyranci: return 352
        case .dolapite: return 524
        case .dyulene: return 131
        case .dolnaMahala: return 851
        case .dolnaMitropoliya: return 328
        case .dolniDabnik: return 215
        case .dolniRakovec: return 643
        case .dolnoEzer: return 825
        case .dolnoKamarci: return 426
        case .dragichevo: return 629
        case .dragoman: return 6
        case .dralfa: return 253
        case .drenovec: return 747
        case .druzhba: return 822
        case .dryanovo: return 556
        case .dulovo: return 922
        case .dunavci: return 458
        case .dupnica: return 653
        case .dabovo: return 463
        case .dalgopol: return 503
        case .daskotna: return 496
        case .dyakovo: return 650
        case .ezerovo: return 288
        case .elinPelin: return 27
        case .eliseyna: return 189
        case .zhelyuVoyvoda: return 478
        case .zavet: return 492
        case .zavoy: return 811
        case .zaharnaFabrika: return 626
        case .zverino: return 191
        case .zemen: return 711
        case .zimnica: return 479
        case .zlatica: return 431
        case .zmeyovo: return 571
        case .ivanovo: return 526
        case .iliyanci: return 170
        case .iskar: return 23
        case .iskarskoShose: return 946
        case .isperih: return 916
        case .ithiman: return 35
        case .kazanlak: return 460
        case .kazichene: return 25
        case .kalitinovo: return 800
        case .kalotina: return 3
        case .kalotinaZapad: return 2
        case .kalofer: return 449
        case .kaloyanovec: return 796
        case .kaloyanovo: return 849
        case .kapiKule: return 92
        case .karadzhalovo: return 72
        case .kardam: return 398
        case .karlovo: return 444
        case .karlukovo: return 207
        case .karnobat: return 483
        case .kaspichan: return 270
        case .katunica: return 66
        case .kermen: return 807
        case .klisura: return 437
        case .kozarevec: return 240
        case .komunari: return 377
        case .horsovo: return 806
        case .koprivshtica: return 435
        case .kostandovo: return 133
        case .kostenec: return 41
        case .kostinbrod: return 12
        case .kocherinovo: return 659
        case .krakra: return 636
        case .kremikovci: return 415
        case .kresna: return 670
        case .krivodol: return 736
        case .krichim: return 159
        case .krumovo: return 64
        case .krastec: return 565
        case .kulata: return 679
        case .kunino: return 206
        case .kurilo: return 172
        case .kardzhali: return 599
        case .kyustendil: return 718
        case .lakatnik: return 184
        case .levski: return 225
        case .lovech: return 357
        case .lovechSeverRp: return 355
        case .lozarevo: return 486
        case .lom: return 780
        case .lyubenovoPred: return 868
        case .lyubimec: return 87
        case .lyulyakovoRp: return 494
        case .makocevo: return 424
        case .manole: return 787
        case .medkovec: return 744
        case .mezdra: return 198
        case .mezdraYug: return 196
        case .mericleri: return 577
        case .metalStop: return 631
        case .mirkovo: return 428
        case .mihaylovo: return 573
        case .mominProhod: return 40
        case .momchilGrad: return 602
        case .montana: return 768
        case .morunica: return 532
        case .most: return 589
        case .musachevoRp: return 512
        case .murchevo: return 741
        case .mutnica: return 267
        case .novaZagora: return 805
        case .novaNadezhda: return 81
        case .obedinena: return 514
        case .obrazvocChiflik: return 891
        case .ognyanovo: return 53
        case .oresh: return 341
        case .oreshec: return 751
        case .orizovo: return 790
        case .pavelBanya: return 455
        case .pavlikeni: return 229
        case .pazardzhik: return 51
        case .panagyurishte: return 846
        case .peyoYavorov: return 668
        case .pernik: return 635
        case .pernikRazpred: return 632
        case .petkoKaravelov: return 539
        case .petrich: return 688
        case .peturch: return 11
        case .peshtera: return 163
        case .pirdop: return 433
        case .plachkovci: return 562
        case .pleven: return 219
        case .plevenZapad: return 218
        case .pliska: return 908
        case .plovdiv: return 60
        case .plovdivRazpred: return 164
        case .pobitKamak: return 28
        case .povelyanovo: return 283
        case .podvis: return 489
        case .podkova: return 606
        case .poduyanePatn: return 20
        case .polikraishte: return 235
        case .polskiTrambesh: return 536
        case .popovica: return 69
        case .popovo: return 248
        case .pordim: return 222
        case .prileprp: return 490
        case .provadiya: return 275
        case .prostorno: return 897
        case .parvomay: return 71
        case .radnevo: return 871
        case .radomir: return 641
        case .radunci: return 567
        case .razdhavica: return 714
        case .razgrad: return 899
        case .razdelna: return 282
        case .razlog: return 151
        case .razmenna: return 689
        case .rebrovo: return 176
        case .resen: return 233
        case .roman: return 204
        case .ruse: return 522
        case .ruseZapad: return 887
        case .ruseRazpred: return 520
        case .ruseSever: return 909
        case .ruskaByala: return 730
        case .sadovo: return 67
        case .samovodene: return 548
        case .samuil: return 901
        case .sandanski: return 674
        case .saranci: return 422
        case .sahrene: return 456
        case .svetovrachene: return 412
        case .svilengrad: return 88
        case .svishtov: return 338
        case .svoboda: return 794
        case .svoge: return 179
        case .senovo: return 896
        case .septemvri: return 47
        case .silistra: return 928
        case .simeonovgrad: return 83
        case .simitli: return 664
        case .sindel: return 280
        case .skutare: return 786
        case .slavyanovo: return 246
        case .sliven: return 476
        case .slivnica: return 10
        case .smyadovo: return 372
        case .somovit: return 336
        case .sopot: return 443
        case .sofia: return 18
        case .sofiaSever: return 169
        case .sracimir: return 756
        case .stamboliyski: return 56
        case .stanyanci: return 100
        case .staraZagora: return 572
        case .stolnik: return 419
        case .strazhica: return 243
        case .straldzha: return 480
        case .strelcha: return 845
        case .strumyani: return 672
        case .stryama: return 436
        case .suvorovo: return 385
        case .saedinenie: return 838
        case .tvardica: return 468
        case .telish: return 213
        case .todorKableshkov: return 58
        case .topolite: return 290
        case .trakia: return 831
        case .troyan: return 368
        case .trud: return 847
        case .tryavna: return 560
        case .tulovo: return 462
        case .tazha: return 452
        case .targovishte: return 257
        case .tarnak: return 499
        case .filipovo: return 784
        case .hanAsparuh: return 803
        case .hanKrum: return 262
        case .harmanli: return 85
        case .haskovo: return 583
        case .hisar: return 860
        case .hitrino: return 904
        case .hrabarsko: return 699
        case .hristoDanovo: return 439
        case .carLivada: return 558
        case .cvetino: return 138
        case .cerkovski: return 482
        case .chervenBryag: return 209
        case .cherganovo: return 461
        case .cherkvica: return 337
        case .chernaGora: return 791
        case .cherniche: return 665
        case .chernograd: return 814
        case .chirpan: return 793
        case .chukurovo: return 123
        case .shivachevo: return 470
        case .shumen: return 265
        case .yunak: return 507
        case .yabalkovo: return 75
        case .yakoruda: return 144
        case .yambol: return 810
        case .yana: return 417
        case .yantra: return 542
        case .yasen: return 216

        }
    }
}
