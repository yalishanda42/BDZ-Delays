//
//  Stations.swift
//  BDZDelays
//
//  Created by Alexander Ignatov on 22.04.23.
//

import Foundation

public enum Station: Equatable {
    case bulgarian(BGStation)
    case other(String)
}

public enum BGStation: Equatable, CaseIterable {
    case avramovo
    case aytos
    case aldomirovci
    case alfatar
    case anton
    case asenovgrad
    case asparuhovo
    case bankya
    case bansko
    case banya
    case batanovci
    case bezmer
    case beliIzvor
    case belica
    case belovo
    case belozem
    case beloslav
    case berkovica
    case blagoevgrad
    case boboshevo
    case bov
    case boychinovci
    case borovo
    case botev
    case botunec
    case bracigovo
    case brigadir
    case brusarci
    case bunovo
    case burgas
    case bulgarovo
    case byala
    case vakarel
    case varvara
    case varna
    case varnaFerry
    case velikoTarnovo
    case velingrad
    case velichkovo
    case verinsko
    case vetovo
    case vidinPassenger
    case vidinCargo
    case visokaPolyana
    case vlTrichkov
    case vladaya
    case ВvladimirPavlov
    case voluyak
    case vraca
    case valchiDol
    case gabrovo
    case gavrailovo
    case genTodorov
    case genToshev
    case bigVillage
    case gorPriemPark
    case gornaBanya
    case gornaBanyaSp
    case gornaOryahovitsa
    case gorniDabnik
    case grafIgnatievo
    case gurkovo
    case gyueshevo
    case damyanica
    case daskalovo
    case dveMogili
    case debelec
    case devnya
    case delyan
    case dzhulyunica
    case dimitrovgrad
    case dimitrovgradSv
    case dimovo
    case dobrinishte
    case dobrich
    case doyranci
    case dolapite
    case dyulene
    case dolnaMahala
    case dolnaMitropoliya
    case dolniDabnik
    case dolniRakovec
    case dolnoEzer
    case dolnoKamarci
    case dragichevo
    case dragoman
    case dralfa
    case drenovec
    case druzhba
    case dryanovo
    case dulovo
    case dunavci
    case dupnica
    case dabovo
    case dalgopol
    case daskotna
    case dyakovo
    case ezerovo
    case elinPelin
    case eliseyna
    case zhelyuVoyvoda
    case zavet
    case zavoy
    case zaharnaFabrika
    case zverino
    case zemen
    case zimnica
    case zlatica
    case zmeyovo
    case ivanovo
    case iliyanci
    case iskar
    case iskarskoShose
    case isperih
    case ithiman
    case kazanlak
    case kazichene
    case kalitinovo
    case kalotina
    case kalotinaZapad
    case kalofer
    case kaloyanovec
    case kaloyanovo
    case kapiKule
    case karadzhalovo
    case kardam
    case karlovo
    case karlukovo
    case karnobat
    case kaspichan
    case katunica
    case kermen
    case klisura
    case kozarevec
    case komunari
    case horsovo
    case koprivshtica
    case kostandovo
    case kostenec
    case kostinbrod
    case kocherinovo
    case krakra
    case kremikovci
    case kresna
    case krivodol
    case krichim
    case krumovo
    case krastec
    case kulata
    case kunino
    case kurilo
    case kardzhali
    case kyustendil
    case lakatnik
    case levski
    case lovech
    case lovechSeverRp
    case lozarevo
    case lom
    case lyubenovoPred
    case lyubimec
    case lyulyakovoRp
    case makocevo
    case manole
    case medkovec
    case mezdra
    case mezdraYug
    case mericleri
    case metalStop
    case mirkovo
    case mihaylovo
    case mominProhod
    case momchilGrad
    case montana
    case morunica
    case most
    case musachevoRp
    case murchevo
    case mutnica
    case novaZagora
    case novaNadezhda
    case obedinena
    case obrazvocChiflik
    case ognyanovo
    case oresh
    case oreshec
    case orizovo
    case pavelBanya
    case pavlikeni
    case pazardzhik
    case panagyurishte
    case peyoYavorov
    case pernik
    case pernikRazpred
    case petkoKaravelov
    case petrich
    case peturch
    case peshtera
    case pirdop
    case plachkovci
    case pleven
    case plevenZapad
    case pliska
    case plovdiv
    case plovdivRazpred
    case pobitKamak
    case povelyanovo
    case podvis
    case podkova
    case poduyanePatn
    case polikraishte
    case polskiTrambesh
    case popovica
    case popovo
    case pordim
    case prileprp
    case provadiya
    case prostorno
    case parvomay
    case radnevo
    case radomir
    case radunci
    case razdhavica
    case razgrad
    case razdelna
    case razlog
    case razmenna
    case rebrovo
    case resen
    case roman
    case ruse
    case ruseZapad
    case ruseRazpred
    case ruseSever
    case ruskaByala
    case sadovo
    case samovodene
    case samuil
    case sandanski
    case saranci
    case sahrene
    case svetovrachene
    case svilengrad
    case svishtov
    case svoboda
    case svoge
    case senovo
    case septemvri
    case silistra
    case simeonovgrad
    case simitli
    case sindel
    case skutare
    case slavyanovo
    case sliven
    case slivnica
    case smyadovo
    case somovit
    case sopot
    case sofia
    case sofiaSever
    case sracimir
    case stamboliyski
    case stanyanci
    case staraZagora
    case stolnik
    case strazhica
    case straldzha
    case strelcha
    case strumyani
    case stryama
    case suvorovo
    case saedinenie
    case tvardica
    case telish
    case todorKableshkov
    case topolite
    case trakia
    case troyan
    case trud
    case tryavna
    case tulovo
    case tazha
    case targovishte
    case tarnak
    case filipovo
    case hanAsparuh
    case hanKrum
    case harmanli
    case haskovo
    case hisar
    case hitrino
    case hrabarsko
    case hristoDanovo
    case carLivada
    case cvetino
    case cerkovski
    case chervenBryag
    case cherganovo
    case cherkvica
    case chernaGora
    case cherniche
    case chernograd
    case chirpan
    case chukurovo
    case shivachevo
    case shumen
    case yunak
    case yabalkovo
    case yakoruda
    case yambol
    case yana
    case yantra
    case yasen
}
