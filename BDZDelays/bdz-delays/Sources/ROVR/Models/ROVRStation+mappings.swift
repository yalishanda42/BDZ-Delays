import SharedModels

public extension ROVRStation {
    init(_ bgStation: BGStation) {
        switch bgStation {
        case .avramovo: self = .avramovo
        case .aytos: self = .aytos
        case .aldomirovci: self = .aldomirovci
        case .alfatar: self = .alfatar
        case .anton: self = .anton
        case .asenovgrad: self = .asenovgrad
        case .asparuhovo: self = .asparuhovo
        case .bankya: self = .bankya
        case .bansko: self = .bansko
        case .banya: self = .banya
        case .batanovci: self = .batanovci
        case .bezmer: self = .bezmer
        case .beliIzvor: self = .beliIzvor
        case .belica: self = .belica
        case .belovo: self = .belovo
        case .belozem: self = .belozem
        case .beloslav: self = .beloslav
        case .berkovica: self = .berkovica
        case .blagoevgrad: self = .blagoevgrad
        case .boboshevo: self = .boboshevo
        case .bov: self = .bov
        case .boychinovci: self = .boychinovci
        case .borovo: self = .borovo
        case .botev: self = .botev
        case .botunec: self = .botunec
        case .bracigovo: self = .bracigovo
        case .brigadir: self = .brigadir
        case .brusarci: self = .brusarci
        case .bunovo: self = .bunovo
        case .burgas: self = .burgas
        case .bulgarovo: self = .bulgarovo
        case .byala: self = .byala
        case .vakarel: self = .vakarel
        case .varvara: self = .varvara
        case .varna: self = .varna
        case .varnaFerry: self = .varnaFerry
        case .velikoTarnovo: self = .velikoTarnovo
        case .velingrad: self = .velingrad
        case .velichkovo: self = .velichkovo
        case .verinsko: self = .verinsko
        case .vetovo: self = .vetovo
        case .vidinPassenger: self = .vidinPassenger
        case .vidinCargo: self = .vidinCargo
        case .visokaPolyana: self = .visokaPolyana
        case .vlTrichkov: self = .vlTrichkov
        case .vladaya: self = .vladaya
        case .ВvladimirPavlov: self = .ВvladimirPavlov
        case .voluyak: self = .voluyak
        case .vraca: self = .vraca
        case .valchiDol: self = .valchiDol
        case .gabrovo: self = .gabrovo
        case .gavrailovo: self = .gavrailovo
        case .genTodorov: self = .genTodorov
        case .genToshev: self = .genToshev
        case .bigVillage: self = .bigVillage
        case .gorPriemPark: self = .gorPriemPark
        case .gornaBanya: self = .gornaBanya
        case .gornaBanyaSp: self = .gornaBanyaSp
        case .gornaOryahovitsa: self = .gornaOryahovitsa
        case .gorniDabnik: self = .gorniDabnik
        case .grafIgnatievo: self = .grafIgnatievo
        case .gurkovo: self = .gurkovo
        case .gyueshevo: self = .gyueshevo
        case .damyanica: self = .damyanica
        case .daskalovo: self = .daskalovo
        case .dveMogili: self = .dveMogili
        case .debelec: self = .debelec
        case .devnya: self = .devnya
        case .delyan: self = .delyan
        case .dzhulyunica: self = .dzhulyunica
        case .dimitrovgrad: self = .dimitrovgrad
        case .dimitrovgradSv: self = .dimitrovgradSv
        case .dimovo: self = .dimovo
        case .dobrinishte: self = .dobrinishte
        case .dobrich: self = .dobrich
        case .doyranci: self = .doyranci
        case .dolapite: self = .dolapite
        case .dyulene: self = .dyulene
        case .dolnaMahala: self = .dolnaMahala
        case .dolnaMitropoliya: self = .dolnaMitropoliya
        case .dolniDabnik: self = .dolniDabnik
        case .dolniRakovec: self = .dolniRakovec
        case .dolnoEzer: self = .dolnoEzer
        case .dolnoKamarci: self = .dolnoKamarci
        case .dragichevo: self = .dragichevo
        case .dragoman: self = .dragoman
        case .dralfa: self = .dralfa
        case .drenovec: self = .drenovec
        case .druzhba: self = .druzhba
        case .dryanovo: self = .dryanovo
        case .dulovo: self = .dulovo
        case .dunavci: self = .dunavci
        case .dupnica: self = .dupnica
        case .dabovo: self = .dabovo
        case .dalgopol: self = .dalgopol
        case .daskotna: self = .daskotna
        case .dyakovo: self = .dyakovo
        case .ezerovo: self = .ezerovo
        case .elinPelin: self = .elinPelin
        case .eliseyna: self = .eliseyna
        case .zhelyuVoyvoda: self = .zhelyuVoyvoda
        case .zavet: self = .zavet
        case .zavoy: self = .zavoy
        case .zaharnaFabrika: self = .zaharnaFabrika
        case .zverino: self = .zverino
        case .zemen: self = .zemen
        case .zimnica: self = .zimnica
        case .zlatica: self = .zlatica
        case .zmeyovo: self = .zmeyovo
        case .ivanovo: self = .ivanovo
        case .iliyanci: self = .iliyanci
        case .iskar: self = .iskar
        case .iskarskoShose: self = .iskarskoShose
        case .isperih: self = .isperih
        case .ithiman: self = .ithiman
        case .kazanlak: self = .kazanlak
        case .kazichene: self = .kazichene
        case .kalitinovo: self = .kalitinovo
        case .kalotina: self = .kalotina
        case .kalotinaZapad: self = .kalotinaZapad
        case .kalofer: self = .kalofer
        case .kaloyanovec: self = .kaloyanovec
        case .kaloyanovo: self = .kaloyanovo
        case .kapiKule: self = .kapiKule
        case .karadzhalovo: self = .karadzhalovo
        case .kardam: self = .kardam
        case .karlovo: self = .karlovo
        case .karlukovo: self = .karlukovo
        case .karnobat: self = .karnobat
        case .kaspichan: self = .kaspichan
        case .katunica: self = .katunica
        case .kermen: self = .kermen
        case .klisura: self = .klisura
        case .kozarevec: self = .kozarevec
        case .komunari: self = .komunari
        case .horsovo: self = .horsovo
        case .koprivshtica: self = .koprivshtica
        case .kostandovo: self = .kostandovo
        case .kostenec: self = .kostenec
        case .kostinbrod: self = .kostinbrod
        case .kocherinovo: self = .kocherinovo
        case .krakra: self = .krakra
        case .kremikovci: self = .kremikovci
        case .kresna: self = .kresna
        case .krivodol: self = .krivodol
        case .krichim: self = .krichim
        case .krumovo: self = .krumovo
        case .krastec: self = .krastec
        case .kulata: self = .kulata
        case .kunino: self = .kunino
        case .kurilo: self = .kurilo
        case .kardzhali: self = .kardzhali
        case .kyustendil: self = .kyustendil
        case .lakatnik: self = .lakatnik
        case .levski: self = .levski
        case .lovech: self = .lovech
        case .lovechSeverRp: self = .lovechSeverRp
        case .lozarevo: self = .lozarevo
        case .lom: self = .lom
        case .lyubenovoPred: self = .lyubenovoPred
        case .lyubimec: self = .lyubimec
        case .lyulyakovoRp: self = .lyulyakovoRp
        case .makocevo: self = .makocevo
        case .manole: self = .manole
        case .medkovec: self = .medkovec
        case .mezdra: self = .mezdra
        case .mezdraYug: self = .mezdraYug
        case .mericleri: self = .mericleri
        case .metalStop: self = .metalStop
        case .mirkovo: self = .mirkovo
        case .mihaylovo: self = .mihaylovo
        case .mominProhod: self = .mominProhod
        case .momchilGrad: self = .momchilGrad
        case .montana: self = .montana
        case .morunica: self = .morunica
        case .most: self = .most
        case .musachevoRp: self = .musachevoRp
        case .murchevo: self = .murchevo
        case .mutnica: self = .mutnica
        case .novaZagora: self = .novaZagora
        case .novaNadezhda: self = .novaNadezhda
        case .obedinena: self = .obedinena
        case .obrazvocChiflik: self = .obrazvocChiflik
        case .ognyanovo: self = .ognyanovo
        case .oresh: self = .oresh
        case .oreshec: self = .oreshec
        case .orizovo: self = .orizovo
        case .pavelBanya: self = .pavelBanya
        case .pavlikeni: self = .pavlikeni
        case .pazardzhik: self = .pazardzhik
        case .panagyurishte: self = .panagyurishte
        case .peyoYavorov: self = .peyoYavorov
        case .pernik: self = .pernik
        case .pernikRazpred: self = .pernikRazpred
        case .petkoKaravelov: self = .petkoKaravelov
        case .petrich: self = .petrich
        case .peturch: self = .peturch
        case .peshtera: self = .peshtera
        case .pirdop: self = .pirdop
        case .plachkovci: self = .plachkovci
        case .pleven: self = .pleven
        case .plevenZapad: self = .plevenZapad
        case .pliska: self = .pliska
        case .plovdiv: self = .plovdiv
        case .plovdivRazpred: self = .plovdivRazpred
        case .pobitKamak: self = .pobitKamak
        case .povelyanovo: self = .povelyanovo
        case .podvis: self = .podvis
        case .podkova: self = .podkova
        case .poduyanePatn: self = .poduyanePatn
        case .polikraishte: self = .polikraishte
        case .polskiTrambesh: self = .polskiTrambesh
        case .popovica: self = .popovica
        case .popovo: self = .popovo
        case .pordim: self = .pordim
        case .prileprp: self = .prileprp
        case .provadiya: self = .provadiya
        case .prostorno: self = .prostorno
        case .parvomay: self = .parvomay
        case .radnevo: self = .radnevo
        case .radomir: self = .radomir
        case .radunci: self = .radunci
        case .razdhavica: self = .razdhavica
        case .razgrad: self = .razgrad
        case .razdelna: self = .razdelna
        case .razlog: self = .razlog
        case .razmenna: self = .razmenna
        case .rebrovo: self = .rebrovo
        case .resen: self = .resen
        case .roman: self = .roman
        case .ruse: self = .ruse
        case .ruseZapad: self = .ruseZapad
        case .ruseRazpred: self = .ruseRazpred
        case .ruseSever: self = .ruseSever
        case .ruskaByala: self = .ruskaByala
        case .sadovo: self = .sadovo
        case .samovodene: self = .samovodene
        case .samuil: self = .samuil
        case .sandanski: self = .sandanski
        case .saranci: self = .saranci
        case .sahrene: self = .sahrene
        case .svetovrachene: self = .svetovrachene
        case .svilengrad: self = .svilengrad
        case .svishtov: self = .svishtov
        case .svoboda: self = .svoboda
        case .svoge: self = .svoge
        case .senovo: self = .senovo
        case .septemvri: self = .septemvri
        case .silistra: self = .silistra
        case .simeonovgrad: self = .simeonovgrad
        case .simitli: self = .simitli
        case .sindel: self = .sindel
        case .skutare: self = .skutare
        case .slavyanovo: self = .slavyanovo
        case .sliven: self = .sliven
        case .slivnica: self = .slivnica
        case .smyadovo: self = .smyadovo
        case .somovit: self = .somovit
        case .sopot: self = .sopot
        case .sofia: self = .sofia
        case .sofiaSever: self = .sofiaSever
        case .sracimir: self = .sracimir
        case .stamboliyski: self = .stamboliyski
        case .stanyanci: self = .stanyanci
        case .staraZagora: self = .staraZagora
        case .stolnik: self = .stolnik
        case .strazhica: self = .strazhica
        case .straldzha: self = .straldzha
        case .strelcha: self = .strelcha
        case .strumyani: self = .strumyani
        case .stryama: self = .stryama
        case .suvorovo: self = .suvorovo
        case .saedinenie: self = .saedinenie
        case .tvardica: self = .tvardica
        case .telish: self = .telish
        case .todorKableshkov: self = .todorKableshkov
        case .topolite: self = .topolite
        case .trakia: self = .trakia
        case .troyan: self = .troyan
        case .trud: self = .trud
        case .tryavna: self = .tryavna
        case .tulovo: self = .tulovo
        case .tazha: self = .tazha
        case .targovishte: self = .targovishte
        case .tarnak: self = .tarnak
        case .filipovo: self = .filipovo
        case .hanAsparuh: self = .hanAsparuh
        case .hanKrum: self = .hanKrum
        case .harmanli: self = .harmanli
        case .haskovo: self = .haskovo
        case .hisar: self = .hisar
        case .hitrino: self = .hitrino
        case .hrabarsko: self = .hrabarsko
        case .hristoDanovo: self = .hristoDanovo
        case .carLivada: self = .carLivada
        case .cvetino: self = .cvetino
        case .cerkovski: self = .cerkovski
        case .chervenBryag: self = .chervenBryag
        case .cherganovo: self = .cherganovo
        case .cherkvica: self = .cherkvica
        case .chernaGora: self = .chernaGora
        case .cherniche: self = .cherniche
        case .chernograd: self = .chernograd
        case .chirpan: self = .chirpan
        case .chukurovo: self = .chukurovo
        case .shivachevo: self = .shivachevo
        case .shumen: self = .shumen
        case .yunak: self = .yunak
        case .yabalkovo: self = .yabalkovo
        case .yakoruda: self = .yakoruda
        case .yambol: self = .yambol
        case .yana: self = .yana
        case .yantra: self = .yantra
        case .yasen: self = .yasen
        }
    }
    
    var asDomainStation: BGStation {
        switch self {
        case .avramovo: return .avramovo
        case .aytos: return .aytos
        case .aldomirovci: return .aldomirovci
        case .alfatar: return .alfatar
        case .anton: return .anton
        case .asenovgrad: return .asenovgrad
        case .asparuhovo: return .asparuhovo
        case .bankya: return .bankya
        case .bansko: return .bansko
        case .banya: return .banya
        case .batanovci: return .batanovci
        case .bezmer: return .bezmer
        case .beliIzvor: return .beliIzvor
        case .belica: return .belica
        case .belovo: return .belovo
        case .belozem: return .belozem
        case .beloslav: return .beloslav
        case .berkovica: return .berkovica
        case .blagoevgrad: return .blagoevgrad
        case .boboshevo: return .boboshevo
        case .bov: return .bov
        case .boychinovci: return .boychinovci
        case .borovo: return .borovo
        case .botev: return .botev
        case .botunec: return .botunec
        case .bracigovo: return .bracigovo
        case .brigadir: return .brigadir
        case .brusarci: return .brusarci
        case .bunovo: return .bunovo
        case .burgas: return .burgas
        case .bulgarovo: return .bulgarovo
        case .byala: return .byala
        case .vakarel: return .vakarel
        case .varvara: return .varvara
        case .varna: return .varna
        case .varnaFerry: return .varnaFerry
        case .velikoTarnovo: return .velikoTarnovo
        case .velingrad: return .velingrad
        case .velichkovo: return .velichkovo
        case .verinsko: return .verinsko
        case .vetovo: return .vetovo
        case .vidinPassenger: return .vidinPassenger
        case .vidinCargo: return .vidinCargo
        case .visokaPolyana: return .visokaPolyana
        case .vlTrichkov: return .vlTrichkov
        case .vladaya: return .vladaya
        case .ВvladimirPavlov: return .ВvladimirPavlov
        case .voluyak: return .voluyak
        case .vraca: return .vraca
        case .valchiDol: return .valchiDol
        case .gabrovo: return .gabrovo
        case .gavrailovo: return .gavrailovo
        case .genTodorov: return .genTodorov
        case .genToshev: return .genToshev
        case .bigVillage: return .bigVillage
        case .gorPriemPark: return .gorPriemPark
        case .gornaBanya: return .gornaBanya
        case .gornaBanyaSp: return .gornaBanyaSp
        case .gornaOryahovitsa: return .gornaOryahovitsa
        case .gorniDabnik: return .gorniDabnik
        case .grafIgnatievo: return .grafIgnatievo
        case .gurkovo: return .gurkovo
        case .gyueshevo: return .gyueshevo
        case .damyanica: return .damyanica
        case .daskalovo: return .daskalovo
        case .dveMogili: return .dveMogili
        case .debelec: return .debelec
        case .devnya: return .devnya
        case .delyan: return .delyan
        case .dzhulyunica: return .dzhulyunica
        case .dimitrovgrad: return .dimitrovgrad
        case .dimitrovgradSv: return .dimitrovgradSv
        case .dimovo: return .dimovo
        case .dobrinishte: return .dobrinishte
        case .dobrich: return .dobrich
        case .doyranci: return .doyranci
        case .dolapite: return .dolapite
        case .dyulene: return .dyulene
        case .dolnaMahala: return .dolnaMahala
        case .dolnaMitropoliya: return .dolnaMitropoliya
        case .dolniDabnik: return .dolniDabnik
        case .dolniRakovec: return .dolniRakovec
        case .dolnoEzer: return .dolnoEzer
        case .dolnoKamarci: return .dolnoKamarci
        case .dragichevo: return .dragichevo
        case .dragoman: return .dragoman
        case .dralfa: return .dralfa
        case .drenovec: return .drenovec
        case .druzhba: return .druzhba
        case .dryanovo: return .dryanovo
        case .dulovo: return .dulovo
        case .dunavci: return .dunavci
        case .dupnica: return .dupnica
        case .dabovo: return .dabovo
        case .dalgopol: return .dalgopol
        case .daskotna: return .daskotna
        case .dyakovo: return .dyakovo
        case .ezerovo: return .ezerovo
        case .elinPelin: return .elinPelin
        case .eliseyna: return .eliseyna
        case .zhelyuVoyvoda: return .zhelyuVoyvoda
        case .zavet: return .zavet
        case .zavoy: return .zavoy
        case .zaharnaFabrika: return .zaharnaFabrika
        case .zverino: return .zverino
        case .zemen: return .zemen
        case .zimnica: return .zimnica
        case .zlatica: return .zlatica
        case .zmeyovo: return .zmeyovo
        case .ivanovo: return .ivanovo
        case .iliyanci: return .iliyanci
        case .iskar: return .iskar
        case .iskarskoShose: return .iskarskoShose
        case .isperih: return .isperih
        case .ithiman: return .ithiman
        case .kazanlak: return .kazanlak
        case .kazichene: return .kazichene
        case .kalitinovo: return .kalitinovo
        case .kalotina: return .kalotina
        case .kalotinaZapad: return .kalotinaZapad
        case .kalofer: return .kalofer
        case .kaloyanovec: return .kaloyanovec
        case .kaloyanovo: return .kaloyanovo
        case .kapiKule: return .kapiKule
        case .karadzhalovo: return .karadzhalovo
        case .kardam: return .kardam
        case .karlovo: return .karlovo
        case .karlukovo: return .karlukovo
        case .karnobat: return .karnobat
        case .kaspichan: return .kaspichan
        case .katunica: return .katunica
        case .kermen: return .kermen
        case .klisura: return .klisura
        case .kozarevec: return .kozarevec
        case .komunari: return .komunari
        case .horsovo: return .horsovo
        case .koprivshtica: return .koprivshtica
        case .kostandovo: return .kostandovo
        case .kostenec: return .kostenec
        case .kostinbrod: return .kostinbrod
        case .kocherinovo: return .kocherinovo
        case .krakra: return .krakra
        case .kremikovci: return .kremikovci
        case .kresna: return .kresna
        case .krivodol: return .krivodol
        case .krichim: return .krichim
        case .krumovo: return .krumovo
        case .krastec: return .krastec
        case .kulata: return .kulata
        case .kunino: return .kunino
        case .kurilo: return .kurilo
        case .kardzhali: return .kardzhali
        case .kyustendil: return .kyustendil
        case .lakatnik: return .lakatnik
        case .levski: return .levski
        case .lovech: return .lovech
        case .lovechSeverRp: return .lovechSeverRp
        case .lozarevo: return .lozarevo
        case .lom: return .lom
        case .lyubenovoPred: return .lyubenovoPred
        case .lyubimec: return .lyubimec
        case .lyulyakovoRp: return .lyulyakovoRp
        case .makocevo: return .makocevo
        case .manole: return .manole
        case .medkovec: return .medkovec
        case .mezdra: return .mezdra
        case .mezdraYug: return .mezdraYug
        case .mericleri: return .mericleri
        case .metalStop: return .metalStop
        case .mirkovo: return .mirkovo
        case .mihaylovo: return .mihaylovo
        case .mominProhod: return .mominProhod
        case .momchilGrad: return .momchilGrad
        case .montana: return .montana
        case .morunica: return .morunica
        case .most: return .most
        case .musachevoRp: return .musachevoRp
        case .murchevo: return .murchevo
        case .mutnica: return .mutnica
        case .novaZagora: return .novaZagora
        case .novaNadezhda: return .novaNadezhda
        case .obedinena: return .obedinena
        case .obrazvocChiflik: return .obrazvocChiflik
        case .ognyanovo: return .ognyanovo
        case .oresh: return .oresh
        case .oreshec: return .oreshec
        case .orizovo: return .orizovo
        case .pavelBanya: return .pavelBanya
        case .pavlikeni: return .pavlikeni
        case .pazardzhik: return .pazardzhik
        case .panagyurishte: return .panagyurishte
        case .peyoYavorov: return .peyoYavorov
        case .pernik: return .pernik
        case .pernikRazpred: return .pernikRazpred
        case .petkoKaravelov: return .petkoKaravelov
        case .petrich: return .petrich
        case .peturch: return .peturch
        case .peshtera: return .peshtera
        case .pirdop: return .pirdop
        case .plachkovci: return .plachkovci
        case .pleven: return .pleven
        case .plevenZapad: return .plevenZapad
        case .pliska: return .pliska
        case .plovdiv: return .plovdiv
        case .plovdivRazpred: return .plovdivRazpred
        case .pobitKamak: return .pobitKamak
        case .povelyanovo: return .povelyanovo
        case .podvis: return .podvis
        case .podkova: return .podkova
        case .poduyanePatn: return .poduyanePatn
        case .polikraishte: return .polikraishte
        case .polskiTrambesh: return .polskiTrambesh
        case .popovica: return .popovica
        case .popovo: return .popovo
        case .pordim: return .pordim
        case .prileprp: return .prileprp
        case .provadiya: return .provadiya
        case .prostorno: return .prostorno
        case .parvomay: return .parvomay
        case .radnevo: return .radnevo
        case .radomir: return .radomir
        case .radunci: return .radunci
        case .razdhavica: return .razdhavica
        case .razgrad: return .razgrad
        case .razdelna: return .razdelna
        case .razlog: return .razlog
        case .razmenna: return .razmenna
        case .rebrovo: return .rebrovo
        case .resen: return .resen
        case .roman: return .roman
        case .ruse: return .ruse
        case .ruseZapad: return .ruseZapad
        case .ruseRazpred: return .ruseRazpred
        case .ruseSever: return .ruseSever
        case .ruskaByala: return .ruskaByala
        case .sadovo: return .sadovo
        case .samovodene: return .samovodene
        case .samuil: return .samuil
        case .sandanski: return .sandanski
        case .saranci: return .saranci
        case .sahrene: return .sahrene
        case .svetovrachene: return .svetovrachene
        case .svilengrad: return .svilengrad
        case .svishtov: return .svishtov
        case .svoboda: return .svoboda
        case .svoge: return .svoge
        case .senovo: return .senovo
        case .septemvri: return .septemvri
        case .silistra: return .silistra
        case .simeonovgrad: return .simeonovgrad
        case .simitli: return .simitli
        case .sindel: return .sindel
        case .skutare: return .skutare
        case .slavyanovo: return .slavyanovo
        case .sliven: return .sliven
        case .slivnica: return .slivnica
        case .smyadovo: return .smyadovo
        case .somovit: return .somovit
        case .sopot: return .sopot
        case .sofia: return .sofia
        case .sofiaSever: return .sofiaSever
        case .sracimir: return .sracimir
        case .stamboliyski: return .stamboliyski
        case .stanyanci: return .stanyanci
        case .staraZagora: return .staraZagora
        case .stolnik: return .stolnik
        case .strazhica: return .strazhica
        case .straldzha: return .straldzha
        case .strelcha: return .strelcha
        case .strumyani: return .strumyani
        case .stryama: return .stryama
        case .suvorovo: return .suvorovo
        case .saedinenie: return .saedinenie
        case .tvardica: return .tvardica
        case .telish: return .telish
        case .todorKableshkov: return .todorKableshkov
        case .topolite: return .topolite
        case .trakia: return .trakia
        case .troyan: return .troyan
        case .trud: return .trud
        case .tryavna: return .tryavna
        case .tulovo: return .tulovo
        case .tazha: return .tazha
        case .targovishte: return .targovishte
        case .tarnak: return .tarnak
        case .filipovo: return .filipovo
        case .hanAsparuh: return .hanAsparuh
        case .hanKrum: return .hanKrum
        case .harmanli: return .harmanli
        case .haskovo: return .haskovo
        case .hisar: return .hisar
        case .hitrino: return .hitrino
        case .hrabarsko: return .hrabarsko
        case .hristoDanovo: return .hristoDanovo
        case .carLivada: return .carLivada
        case .cvetino: return .cvetino
        case .cerkovski: return .cerkovski
        case .chervenBryag: return .chervenBryag
        case .cherganovo: return .cherganovo
        case .cherkvica: return .cherkvica
        case .chernaGora: return .chernaGora
        case .cherniche: return .cherniche
        case .chernograd: return .chernograd
        case .chirpan: return .chirpan
        case .chukurovo: return .chukurovo
        case .shivachevo: return .shivachevo
        case .shumen: return .shumen
        case .yunak: return .yunak
        case .yabalkovo: return .yabalkovo
        case .yakoruda: return .yakoruda
        case .yambol: return .yambol
        case .yana: return .yana
        case .yantra: return .yantra
        case .yasen: return .yasen
        }
    }
}
