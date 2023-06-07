//
//  BGStation+fromName.swift
//  DelaysWidgetExtension
//
//  Created by AI on 30.05.23.
//

import SharedModels

extension BGStation {
    init?(name: String) {
        switch name {
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
        case "Горна Оряховица": self = .gornaOryahovitsa
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
}
