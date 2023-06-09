//
//  Station+name.swift
//  BDZDelays
//
//  Created by Alexander Ignatov on 22.04.23.
//

import Foundation

extension Station {
    var name: String {
        switch self {
        case .bulgarian(let bGStation):
            return bGStation.name
        case .other(let string):
            return string
        }
    }
}

extension BGStation {
    var name: String {
        switch self {
        case .avramovo: return "Аврамово"
        case .aytos: return "Айтос"
        case .aldomirovci: return "Алдомировци"
        case .alfatar: return "Алфатар"
        case .anton: return "Антон"
        case .asenovgrad: return "Асеновград"
        case .asparuhovo: return "Аспарухово"
        case .bankya: return "Банкя"
        case .bansko: return "Банско"
        case .banya: return "Баня"
        case .batanovci: return "Батановци"
        case .bezmer: return "Безмер"
        case .beliIzvor: return "Бели извор"
        case .belica: return "Белица"
        case .belovo: return "Белово"
        case .belozem: return "Белозем"
        case .beloslav: return "Белослав"
        case .berkovica: return "Берковица"
        case .blagoevgrad: return "Благоевград"
        case .boboshevo: return "Бобошево"
        case .bov: return "Бов"
        case .boychinovci: return "Бойчиновци"
        case .borovo: return "Борово"
        case .botev: return "Ботев"
        case .botunec: return "Ботунец"
        case .bracigovo: return "Брацигово"
        case .brigadir: return "Бригадир"
        case .brusarci: return "Брусарци"
        case .bunovo: return "Буново"
        case .burgas: return "Бургас"
        case .bulgarovo: return "Българово"
        case .byala: return "Бяла"
        case .vakarel: return "Вакарел"
        case .varvara: return "Варвара"
        case .varna: return "Варна"
        case .varnaFerry: return "Варна ферибоот."
        case .velikoTarnovo: return "Велико търново"
        case .velingrad: return "Велинград"
        case .velichkovo: return "Величково"
        case .verinsko: return "Веринско"
        case .vetovo: return "Ветово"
        case .vidinPassenger: return "Видин пътн."
        case .vidinCargo: return "Видин товарна"
        case .visokaPolyana: return "Висока поляна"
        case .vlTrichkov: return "Вл.тричков"
        case .vladaya: return "Владая"
        case .ВvladimirPavlov: return "Владимир павлов"
        case .voluyak: return "Волуяк"
        case .vraca: return "Враца"
        case .valchiDol: return "Вълчи дол"
        case .gabrovo: return "Габрово"
        case .gavrailovo: return "Гавраилово"
        case .genTodorov: return "Ген.тодоров"
        case .genToshev: return "Ген.тошев"
        case .bigVillage: return "Голямо село"
        case .gorPriemPark: return "Гор прием.парк"
        case .gornaBanya: return "Горна баня"
        case .gornaBanyaSp: return "Горна баня сп"
        case .gornaOryahovitsa: return "Горна Оряховица"
        case .gorniDabnik: return "Горни дъбник"
        case .grafIgnatievo: return "Граф игнатиево"
        case .gurkovo: return "Гурково"
        case .gyueshevo: return "Гюешево"
        case .damyanica: return "Дамяница"
        case .daskalovo: return "Даскалово"
        case .dveMogili: return "Две могили"
        case .debelec: return "Дебелец"
        case .devnya: return "Девня"
        case .delyan: return "Делян"
        case .dzhulyunica: return "Джулюница"
        case .dimitrovgrad: return "Димитровград"
        case .dimitrovgradSv: return "Димитровград св"
        case .dimovo: return "Димово"
        case .dobrinishte: return "Добринище"
        case .dobrich: return "Добрич"
        case .doyranci: return "Дойренци"
        case .dolapite: return "Долапите"
        case .dyulene: return "Долене"
        case .dolnaMahala: return "Долна махала"
        case .dolnaMitropoliya: return "Долна митропол."
        case .dolniDabnik: return "Долни дъбник"
        case .dolniRakovec: return "Долни раковец"
        case .dolnoEzer: return "Долно езер."
        case .dolnoKamarci: return "Долно камарци"
        case .dragichevo: return "Драгичево"
        case .dragoman: return "Драгоман"
        case .dralfa: return "Дралфа"
        case .drenovec: return "Дреновец"
        case .druzhba: return "Дружба"
        case .dryanovo: return "Дряново"
        case .dulovo: return "Дулово"
        case .dunavci: return "Дунавци"
        case .dupnica: return "Дупница"
        case .dabovo: return "Дъбово"
        case .dalgopol: return "Дългопол"
        case .daskotna: return "Дъскотна"
        case .dyakovo: return "Дяково"
        case .ezerovo: return "Езерово"
        case .elinPelin: return "Елин пелин"
        case .eliseyna: return "Елисейна"
        case .zhelyuVoyvoda: return "Желю войвода"
        case .zavet: return "Завет"
        case .zavoy: return "Завой"
        case .zaharnaFabrika: return "Захарна фабрика"
        case .zverino: return "Зверино"
        case .zemen: return "Земен"
        case .zimnica: return "Зимница"
        case .zlatica: return "Златица"
        case .zmeyovo: return "Змейово"
        case .ivanovo: return "Иваново"
        case .iliyanci: return "Илиянци"
        case .iskar: return "Искър"
        case .iskarskoShose: return "Искърско шосе"
        case .isperih: return "Исперих"
        case .ithiman: return "Ихтиман"
        case .kazanlak: return "Казанлък"
        case .kazichene: return "Казичене"
        case .kalitinovo: return "Калитиново"
        case .kalotina: return "Калотина"
        case .kalotinaZapad: return "Калотина запад"
        case .kalofer: return "Калофер"
        case .kaloyanovec: return "Калояновец"
        case .kaloyanovo: return "Калояново"
        case .kapiKule: return "Капъ куле"
        case .karadzhalovo: return "Караджалово"
        case .kardam: return "Кардам"
        case .karlovo: return "Карлово"
        case .karlukovo: return "Карлуково"
        case .karnobat: return "Карнобат"
        case .kaspichan: return "Каспичан"
        case .katunica: return "Катуница"
        case .kermen: return "Кермен"
        case .klisura: return "Клисура"
        case .kozarevec: return "Козаревец"
        case .komunari: return "Комунари"
        case .horsovo: return "Коньово"
        case .koprivshtica: return "Копривщица"
        case .kostandovo: return "Костандово"
        case .kostenec: return "Костенец"
        case .kostinbrod: return "Костинброд"
        case .kocherinovo: return "Кочериново"
        case .krakra: return "Кракра"
        case .kremikovci: return "Кремиковци"
        case .kresna: return "Кресна"
        case .krivodol: return "Криводол"
        case .krichim: return "Кричим"
        case .krumovo: return "Крумово"
        case .krastec: return "Кръстец"
        case .kulata: return "Кулата"
        case .kunino: return "Кунино"
        case .kurilo: return "Курило"
        case .kardzhali: return "Кърджали"
        case .kyustendil: return "Кюстендил"
        case .lakatnik: return "Лакатник"
        case .levski: return "Левски"
        case .lovech: return "Ловеч"
        case .lovechSeverRp: return "Ловеч север рп"
        case .lozarevo: return "Лозарево"
        case .lom: return "Лом"
        case .lyubenovoPred: return "Любеново пред."
        case .lyubimec: return "Любимец"
        case .lyulyakovoRp: return "Люляково рп"
        case .makocevo: return "Макоцево"
        case .manole: return "Маноле"
        case .medkovec: return "Медковец"
        case .mezdra: return "Мездра"
        case .mezdraYug: return "Мездра юг"
        case .mericleri: return "Меричлери"
        case .metalStop: return "Метал спирка"
        case .mirkovo: return "Мирково"
        case .mihaylovo: return "Михайлово"
        case .mominProhod: return "Момин проход"
        case .momchilGrad: return "Момчилград"
        case .montana: return "Монтана"
        case .morunica: return "Моруница"
        case .most: return "Мост"
        case .musachevoRp: return "Мусачево рп"
        case .murchevo: return "Мърчево"
        case .mutnica: return "Мътница"
        case .novaZagora: return "Нова загора"
        case .novaNadezhda: return "Нова надежда"
        case .obedinena: return "Обединена"
        case .obrazvocChiflik: return "Образцов чифлик"
        case .ognyanovo: return "Огняново"
        case .oresh: return "Ореш"
        case .oreshec: return "Орешец"
        case .orizovo: return "Оризово"
        case .pavelBanya: return "Павел баня"
        case .pavlikeni: return "Павликени"
        case .pazardzhik: return "Пазарджик"
        case .panagyurishte: return "Панагюрище"
        case .peyoYavorov: return "Пейо яворов"
        case .pernik: return "Перник"
        case .pernikRazpred: return "Перник разпред."
        case .petkoKaravelov: return "Петко каравелов"
        case .petrich: return "Петрич"
        case .peturch: return "Петърч"
        case .peshtera: return "Пещера"
        case .pirdop: return "Пирдоп"
        case .plachkovci: return "Плачковци"
        case .pleven: return "Плевен"
        case .plevenZapad: return "Плевен запад"
        case .pliska: return "Плиска"
        case .plovdiv: return "Пловдив"
        case .plovdivRazpred: return "Пловдив разпр."
        case .pobitKamak: return "Побит камък"
        case .povelyanovo: return "Повеляново"
        case .podvis: return "Подвис"
        case .podkova: return "Подкова"
        case .poduyanePatn: return "Подуяне пътн."
        case .polikraishte: return "Поликраище"
        case .polskiTrambesh: return "Полски тръмбеш"
        case .popovica: return "Поповица"
        case .popovo: return "Попово"
        case .pordim: return "Пордим"
        case .prileprp: return "Прилеп рп"
        case .provadiya: return "Провадия"
        case .prostorno: return "Просторно"
        case .parvomay: return "Първомай"
        case .radnevo: return "Раднево"
        case .radomir: return "Радомир"
        case .radunci: return "Радунци"
        case .razdhavica: return "Раждавица"
        case .razgrad: return "Разград"
        case .razdelna: return "Разделна"
        case .razlog: return "Разлог"
        case .razmenna: return "Разменна"
        case .rebrovo: return "Реброво"
        case .resen: return "Ресен"
        case .roman: return "Роман"
        case .ruse: return "Русе"
        case .ruseZapad: return "Русе запад"
        case .ruseRazpred: return "Русе разпредел."
        case .ruseSever: return "Русе север"
        case .ruskaByala: return "Руска бяла"
        case .sadovo: return "Садово"
        case .samovodene: return "Самоводене"
        case .samuil: return "Самуил"
        case .sandanski: return "Сандански"
        case .saranci: return "Саранци"
        case .sahrene: return "Сахране"
        case .svetovrachene: return "Световрачене"
        case .svilengrad: return "Свиленград"
        case .svishtov: return "Свищов"
        case .svoboda: return "Свобода"
        case .svoge: return "Своге"
        case .senovo: return "Сеново"
        case .septemvri: return "Септември"
        case .silistra: return "Силистра"
        case .simeonovgrad: return "Симеоновград"
        case .simitli: return "Симитли"
        case .sindel: return "Синдел"
        case .skutare: return "Скутаре"
        case .slavyanovo: return "Славяново"
        case .sliven: return "Сливен"
        case .slivnica: return "Сливница"
        case .smyadovo: return "Смядово"
        case .somovit: return "Сомовит"
        case .sopot: return "Сопот"
        case .sofia: return "София"
        case .sofiaSever: return "София север"
        case .sracimir: return "Срацимир"
        case .stamboliyski: return "Стамболийски"
        case .stanyanci: return "Станянци"
        case .staraZagora: return "Стара загора"
        case .stolnik: return "Столник"
        case .strazhica: return "Стражица"
        case .straldzha: return "Стралджа"
        case .strelcha: return "Стрелча"
        case .strumyani: return "Струмяни"
        case .stryama: return "Стряма"
        case .suvorovo: return "Суворово"
        case .saedinenie: return "Съединение"
        case .tvardica: return "Твърдица"
        case .telish: return "Телиш"
        case .todorKableshkov: return "Тодор каблешков"
        case .topolite: return "Тополите"
        case .trakia: return "Тракия"
        case .troyan: return "Троян"
        case .trud: return "Труд"
        case .tryavna: return "Трявна"
        case .tulovo: return "Тулово"
        case .tazha: return "Тъжа"
        case .targovishte: return "Търговище"
        case .tarnak: return "Търнак"
        case .filipovo: return "Филипово"
        case .hanAsparuh: return "Хан аспарух"
        case .hanKrum: return "Хан крум"
        case .harmanli: return "Харманли"
        case .haskovo: return "Хасково"
        case .hisar: return "Хисар"
        case .hitrino: return "Хитрино"
        case .hrabarsko: return "Храбърско"
        case .hristoDanovo: return "Христо даново"
        case .carLivada: return "Цар.ливада"
        case .cvetino: return "Цветино"
        case .cerkovski: return "Церковски"
        case .chervenBryag: return "Червен бряг"
        case .cherganovo: return "Черганово"
        case .cherkvica: return "Черквица"
        case .chernaGora: return "Черна гора"
        case .cherniche: return "Черниче"
        case .chernograd: return "Черноград"
        case .chirpan: return "Чирпан"
        case .chukurovo: return "Чукурово"
        case .shivachevo: return "Шивачево"
        case .shumen: return "Шумен"
        case .yunak: return "Юнак"
        case .yabalkovo: return "Ябълково"
        case .yakoruda: return "Якоруда"
        case .yambol: return "Ямбол"
        case .yana: return "Яна"
        case .yantra: return "Янтра"
        case .yasen: return "Ясен"

        }
    }
}
