module Publications where

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import StartApp.Simple as StartApp
import List exposing (..)
import String exposing (words, join, cons, uncons)
import Char
import Dict exposing (..)
import Murol exposing (mainMenu,
                       renderMainMenu,
                       pageFooter,
                       renderMisc,
                       capitalize,
                       renderListImg,
                       logos,
                       Action (..),
                       renderSubMenu,
                       mail,
                       site,
                       link)

-- Model
subMenu = [ "Délibération conseil municipal"
          , "Murol info"
          , "Bulletin municipal"
          , "Reportages à Murol"
          , "Elections"
          , "Résultats élections municipales"
          , "Divers"
          ]

type alias Bulletin = 
  { cover : String
  , date  : String
  , index : List String
  }

initialModel =
  { mainMenu    = mainMenu
  , subMenu     = subMenu
  , mainContent = initialContent
  }

-- View
view address model =
  div [ id "container"]
      [ renderMainMenu address (.mainMenu model)
      , div [ id "subContainer"]
            [ renderSubMenu address "Publications:" (.subMenu model)
            , .mainContent model
            ]
      , pageFooter
      ]

renderBulletin 
  {cover, date, index} = 
    div [class "bulletin"]
        [ figure [ class "cover"]
                 [ figcaption [] [text date] 
                 , img [src ("/images/bulletin/" ++ cover)] []
                 ]
        , ul []
             ((h6 [] [text "Dans ce numéro:"]
               :: List.map (\e -> li [] [text e]) index)
              ++ [link "Téléchargez ici" ""])
        ]

-- Update

contentMap =
 fromList [("Délibération conseil municipal",delib)
          ,("Murol info",murolInf)
          ,("Bulletin municipal",bulletin)
          ,("Reportages à Murol",reportages)
          ,("Elections",elections)
          ,("Résultats élections municipales", resElec)
          ,("Divers",divers)
          ]

update action model =
  case action of
    NoOp    -> model
    Entry s -> changeMain model s
    _       -> model

changeMain model s =
    let newContent = get s contentMap
    in case newContent of
        Nothing -> model
        Just c  -> { model | mainContent = c }

--Main

main =
  StartApp.start
    { model  = initialModel
    , view   = view
    , update = update
    }

initialContent =
  div [ class "subContainerData", id "publications"]
      [delib]

      

-- Data
delib = 
  div [class "subContainerData", id "delibPubli"]
      [ h5 [] [text "2014"]
      , ul []
           [ li [] [link "19 mars" "http://www.murol.fr/Deliberations_conseil/2014/19032014.pdf"]
           , li [] [link "4 avril" "http://www.murol.fr/Deliberations_conseil/2014/04042014.pdf"]
           , li [] [link "10 avril" "http://www.murol.fr/Deliberations_conseil/2014/10042014.pdf"]
           , li [] [link "16 juillet" "http://www.murol.fr/Deliberations_conseil/2014/16072014.pdf"]
           , li [] [link "28 oct" "http://www.murol.fr/Deliberations_conseil/2014/28102014.pdf"]
           , li [] [link "22 dec" "http://www.murol.fr/Deliberations_conseil/2014/22122014.pdf"]
           ]
      , h5 [] [text "2015"]
      , ul []
           [ li [] [link "12 février" "http://www.murol.fr/Deliberations_conseil/2015/CM12022015.pdf"]
           , li [] [link "19 mars" "http://www.murol.fr/Deliberations_conseil/2015/CM19032015.pdf"]
           , li [] [link "15 avril" "http://www.murol.fr/Deliberations_conseil/2015/CM15042015.pdf"]
           , li [] [link "2 juin" "http://www.murol.fr/Deliberations_conseil/2015/CM24092015.pdf"]
           , li [] [link "4 novembre" "http://www.murol.fr/Deliberations_conseil/2015/CM04112015.pdf"]
           ]
      ]

murolInf =
  div [class "subContainerData", id "murolInfPubli"]
      [ h5 [] [text "2008"]
      , ul []
           [ li [] [link "Numero 01 - Avril" "http://www.murol.fr/Murol_info/01.pdf"]
           , li [] [link "Numero 02 - Mai" "http://www.murol.fr/Murol_info/02.pdf"]
           , li [] [link "Numero 03 - Juin" "http://www.murol.fr/Murol_info/03.pdf"]
           , li [] [link "Numero 04 - Septembre" "http://www.murol.fr/Murol_info/04.pdf"]
           , li [] [link "Numero 05 - Décembre" "http://www.murol.fr/Murol_info/05.pdf"]
           ]
      , h5 [] [text "2009"]
      , ul []
           [ li [] [link "Numero 05 - Février" "http://www.murol.fr/Murol_info/06.pdf"]
           , li [] [link "Numero 07 - Mai" "http://www.murol.fr/Murol_info/07.pdf"]
           , li [] [link "Numero 08 - Septembre" "http://www.murol.fr/Murol_info/08.pdf"]
           , li [] [link "Numero 09 - Décembre" "http://www.murol.fr/Murol_info/09.pdf"]
           ]     
      , h5 [] [text "2010"]
      , ul []
           [ li [] [link "Numero 10 - Août" "http://www.murol.fr/Murol_info/10.pdf"]
           , li [] [link "Numero 11 - Octobre" "http://www.murol.fr/Murol_info/11.pdf"]
           , li [] [link "Numero 12 - Décembre" "http://www.murol.fr/Murol_info/12.pdf"]
           ]
      , h5 [] [text "2011"]
      , ul []
           [ li [] [link "Numero 13 - Avril" "http://www.murol.fr/Murol_info/13.pdf"]
           , li [] [link "Numero 14 - Mai" "http://www.murol.fr/Murol_info/14.pdf"]
           , li [] [link "Numero 15 - Août" "http://www.murol.fr/Murol_info/15.pdf"]
           , li [] [link "Numero 16 - Octobre" "http://www.murol.fr/Murol_info/16.pdf"]
           ]
      , h5 [] [text "2013"]
      , ul []
           [ li [] [link "Numero 17 - Juin" "http://www.murol.fr/Murol_info/17.pdf"]
           , li [] [link "Numero 18 - Novembre" "http://www.murol.fr/Murol_info/18.pdf"]
           ]
      , h5 [] [text "2014"]
      , ul []
           [ li [] [link "Numero 19 - Avril" "http://www.murol.fr/Murol_info/19.pdf"]
           , li [] [link "Numero 20 - Mai" "http://www.murol.fr/Murol_info/20.pdf"]
           , li [] [link "Numero 21 - Juin" "http://www.murol.fr/Murol_info/21.pdf"]
           , li [] [link "Numero 22 - Octobre" "http://www.murol.fr/Murol_info/22.pdf"]
           , li [] [link "Numero 23 - Décembre" "http://www.murol.fr/Murol_info/23.pdf"]
           ]
      , h5 [] [text "2015"]     
      , ul []
           [ li [] [link "Numero 24 - Mai" "http://www.murol.fr/Murol_info/24.pdf"]
           , li [] [link "Numero 25 - Juin" "http://www.murol.fr/Murol_info/25.pdf"]
           , li [] [link "Numero 26 - Septembre" "http://www.murol.fr/Murol_info/26.pdf"]
           , li [] [link "Numero 27 - Novembre" "http://www.murol.fr/Murol_info/27.pdf"]
           ]
      ]

bulls = List.reverse
 [ Bulletin "cover0.png" "Janvier 2009"
            [ "La maison médicale"
            , "La sécurité : Pompiers et Maîtres Nageurs Sauveteurs"
            , "Murol en chiffres: Les employés communaux"
            , "Le château : travail des archéologues"
            , "Les écoles maternelles et élémentaires"
            , "Murol en images"
            , "Le tri des déchets"
            , "L’animation estivale"
            , "L’embellissement"
            , "Les commissions"
            , "Les opérations 2008"
            , "L’intercommunalité"
            , "L’état civil"
            , "Le site internet"
            ]
 , Bulletin "cover1.png" "Janvier 2011"
            [ "Etat civil 2010"
            , "Horaires des services"
            , "Recensement 2011"
            , "Travaux en cours"
            , "Urbanisme"
            , "Budget et fiscalité"
            , "Archéologie"
            , "Ecoles"
            , "SIVOM de la Vallée Verte"
            , "Animation estivale"
            , "Musée"
            , "Ski de fond"
            , "Embellissement"
            , "Lac Chambon"
            , "Création du SIVU"
            , "Employés communaux"
            , "Propreté"
            , "SIVOM de Besse"
            , "Sécurité: pompiers MNS, gendarmerie"
            , "CCAS services sociaux"
            , "Relais bibliothèque"
            , "TNT"
            , "Murol en images"
            , "Associations"
            , "Calendrier des diverses
               manifestations du
               1er semestre 2011"
            ]
 , Bulletin "cover2.png" "Février 2012"
            [ "Etat civil 2011"
            , "Horaires des services"
            , "Urbanisme"
            , "SIVU assainissement"
            , "Travaux et investissements"
            , "Chantier de jeunesse"
            , "Archéologie"
            , "Musée des peintres"
            , "Ecoles"
            , "Sivom de la Vallée Verte"
            , "Maison médicale"
            , "Communauté de Communes du Massif du Sancy"
            , "Animation estivale"
            , "Sécurité : pompiers, gendarmerie et MNS"
            , "CCAS et services sociaux"
            , "SIVOM de Besse"
            , "Exposition: « la mairie de Murol a 100 ans »"
            , "Elections 2012"
            , "Murol en images"
            , "Associations"
            , "Calendrier des
               manifestations du
               1er semestre 2012"
            ]
 , Bulletin "cover3.png" "Mars 2013"
            [ "Etat civil"
            , "Urbanisme"
            , "Transports"
            , "Services"
            , "Recyclage"
            , "Sports"
            , "Parcours sportif"
            , "Activités jeunesse"
            , "Eléments budgétaires"
            , "Travaux"
            , "Projets en cours"
            , "SIVU"
            , "Personnel"
            , "Embellissement"
            , "Archéologie"
            , "Musée"
            , "Pompiers"
            , "Plage"
            , "DICRIM cahier détachable"
            , "Murol en images"
            , "Station de tourisme"
            , "ONF"
            , "Animation"
            , "Ecoles"
            , "CCAS"
            , "SIVOM de Besse"
            , "Services sociaux"
            , "Associations"
            , "Calendrier"
            ]
  , Bulletin "cover4.png" "Janvier 2014"
             [ "Etat civil"
             , "Elections"
             , "Services"
             , "Chiens et chats"
             , "Personnel"
             , "Eléments budgétaires"
             , "Rue George Sand"
             , "Circulation bourg"
             , "Travaux"
             , "Maison médicale"
             , "Sécurité / Pompiers"
             , "Urbanisme"
             , "Agriculture - Forêts"
             , "Embellissement"
             , "Musée des peintres"
             , "Tourisme"
             , "Murol en images" 
             , "Station de tourisme"
             , "Archéologie"
             , "Ecoles"
             , "Réforme des rythmes scolaires"
             , "Jeunesse et sports"
             , "Lac Chambon"
             , "CCAS Social"
             , "Atelier couture"
             , "Balades du journal"
             , "Informatique et sites"
             , "Associations"
             , "Calendrier"
             ]
 , Bulletin "cover5.png" "Mars 2015"
            [ "Equipe municipale"
            , "Intercommunalité"
            , "Réforme territoriale"
            , "Elections régionales"
            , "Etat civil"
            , "Conseil des jeunes"
            , "Services"
            , "Ordures ménagères"
            , "ADIL (énergie, habitat)"
            , "Personnel"
            , "Chantier de jeunesse"
            , "Travaux 2014"
            , "Maison de santé"
            , "Pompiers"
            , "Eclairage public"
            , "Tourisme"
            , "Festival d'art"
            , "Embellissement"
            , "Archéologie"
            , "Mutuelle"
            , "CCAS"
            , "Ecoles"
            , "SIVOM de la Vallée Verte"
            , "Activités jeunesse"
            , "Eléments budgétaires"
            , "Accessibilité"
            , "Abords du chateau"
            , "Musée des peintres"
            , "Lac Chambon"
            , "Autres projets en cours"
            , "Murol en images"
            , "Associations"
            , "Calendrier"
            ]
 ]

bulletin =
  div [class "subContainerData", id "bullPubli"]
      (List.map renderBulletin bulls)

reportages = 
  div [class "subContainerData", id "repoPubli"]
      [h4 [] [text "Reportages à Murol"]
      , link "JT du 19 septembre :" ""
      , text "Travail de l'équipe archéologique sur le château \"juillet-août 2008\""
      , br [] []
      , link "JT du 4 mai :" ""
      , text "Reportage sur les médiévales"
      , br [] []
      ]

elections = 
  div [class "subContainerData", id "elecPubli"]
      [ h4 [] [text "Les élections municipales"]
      , p  [] [text "Les élections municipales ont lieu, en principe, tous 
                     les 6 ans, au suffrage universel direct. La 
                     circonscription électorale est la commune, sauf à Paris, 
                     Lyon et Marseille : l’élection a lieu dans 
                     le cadre de l’arrondissement pour Paris et Lyon, 
                     et par secteurs regroupant deux arrondissements pour Marseille 
                     (art. 261 du code électoral). "]
      , p  [] [text "Le nombre de conseillers municipaux varie selon la 
                     taille de la commune : de 7 conseillers 
                     pour les communes de moins de 100 habitants 
                     (avant la loi du 17 mai 2013, ce 
                     nombre était de 9), à 69 pour les 
                     communes de 300 000 habitants ou plus (art. 
                     L2121-2 du code général des collectivités territoriales - 
                     CGCT)."]
      , p  [] [text "Le mode de scrutin municipal étant globalement un 
                     scrutin majoritaire de liste, il convient de l’adapter 
                     à la situation des communes les plus petites 
                     où il serait difficile de constituer des listes 
                     complètes, ainsi qu’à la situation des communes les 
                     plus peuplées pour lesquelles il est important de 
                     dégager une majorité municipale. "]
      , p  [] [text "Le mode de scrutin varie selon le nombre 
                     d’habitants de la commune. Cherchant à concilier ces 
                     impératifs avec ceux de la parité et de 
                     l’élection d’une majorité municipale porteuse d’un projet, la 
                     loi du 17 mai 2013 a abaissé de 
                     3 500 à 1 000 habitants le seuil 
                     pour l’application du scrutin à la proportionnelle. "]
      , p  [] [text "Les conseillers municipaux sont élus pour six ans, 
                     et sont renouvelés intégralement au mois de mars 
                     de l’année électorale concernée (art. L227 du code 
                     électoral)."]
      , p  [] [text "Le maire est élu par et au sein 
                     du conseil municipal, au scrutin secret et à 
                     la majorité absolue pour les deux premiers tours 
                     de scrutin, et à la majorité relative si 
                     un troisième tour est nécessaire (art. L2122-1 et 
                     L2122-4 CGCT)."]
      , p  [] [text "Le nombre d’adjoints est fixé par le conseil 
                     municipal mais ne peut cependant excéder 30% de 
                     l’effectif légal du conseil municipal (art. L2122-2 CGCT). 
                     La loi du 27 février 2002 relative à 
                     la démocratie de proximité autorise toutefois à dépasser 
                     cette limite dans les communes de 80 000 
                     habitants par la création de postes d’adjoints chargés 
                     de quartiers, dans une limite de 10% de 
                     l’effectif du conseil municipal (art. L2122-2-1 CGCT). L’article 
                     L2122-10 lie la durée des fonctions des adjoints 
                     à celle des fonctions du maire."]
      , p  [] [text "Enfin, la loi du 31 janvier 2007 tendant 
                     à promouvoir l’égal accès des femmes et des 
                     hommes aux mandats électoraux et fonctions électives avait 
                     instauré l’obligation de parité pour les exécutifs des 
                     communes de 3 500 habitants et plus, cette 
                     obligation concernant les adjoints au maire. Depuis la 
                     loi du 17 mai 2013, c’est dans toutes 
                     les communes de plus de 1 000 habitants 
                     que doit être respecté le principe de la 
                     parité."]
      , p  [] [text "Les lois du 16 décembre 2010 de réforme 
                     territoriale et la loi électorale du 17 mai 
                     2013 posent le principe de l’élection au suffrage 
                     universel des assemblées des établissements publics de coopération 
                     intercommunale à fiscalité propre (cf. Chapitre 5). Cette 
                     innovation a entraîné des modifications sur les modes 
                     de scrutin applicables aux élections municipales "]

      , h4 [] [text "Les modes de scrutins"]
      , p  [] [text "Les conseillers municipaux seront élus les 23 et 
                     30 mars 2014. Les élections municipales ont lieu, 
                     en principe, tous les six ans. Le mode 
                     de scrutin varie selon le nombre d’habitants de 
                     la commune. Au plus tôt le vendredi et 
                     au plus tard le dimanche suivant le scrutin, 
                     le conseil municipal nouvellement élu se réunit pour 
                     procéder à l’élection du maire et de ses 
                     adjoints."]
      
      , h5 [] [text "Deux grandes innovations en 2014"]
      , p  [] [text "Les élections municipales des 23 et 30 mars 
                     2014 seront marquées par deux grandes innovations :"]
      , p  [] [text "Les électeurs de toutes les communes de plus 
                     de 1000 habitants éliront leurs conseillers municipaux selon 
                     le même mode scrutin. Ce mode de scrutin, 
                     qui impose le respect du principe de parité 
                     aux listes de candidats, était jusqu’alors réservé aux 
                     seules communes de plus de 3500 habitants. Cette 
                     modification, introduite par les lois organique et ordinaire 
                     du 17 mai 2013, concerne 6 550 communes. 
                     Elle devrait entraîner, selon les estimations du gouvernement, 
                     l’élection dans les conseils municipaux de près de 
                     16 000 conseillères supplémentaires (les conseils municipaux devraient 
                     à terme compter environ 87 000 élues). "]
      , p  [] [text "Les électeurs désigneront, à l’aide d’un seul bulletin 
                     de vote, leurs conseillers municipaux et les conseillers 
                     communautaires. Les conseillers communautaires sont les représentants de 
                     la commune au sein de la structure intercommunale 
                     dont elle est membre. Prévue par la loi 
                     du 16 décembre 2010, cette réforme est destinée 
                     à conférer une véritable légitimité démocratique aux établissements 
                     publics de coopération intercommunale (EPCI) à fiscalité propre 
                     (communautés de communes, communautés d’agglomération, communautés urbaines, métropoles). 
                     Jusqu’alors, les représentants des communes au sein de 
                     ces EPCI étaient élus par les membres du 
                     conseil municipal. Les lois organique et ordinaire du 
                     17 mai 2013 ont déterminé deux modes de 
                     scrutin, selon que la commune compte moins de 
                     1 000 habitants, ou 1 000 habitants et 
                     plus. "]

      , h4 [] [text "Les communes de moins de 1 000 habitants "]
      , p  [] [text "Dans les communes de moins de 1 000 
                     habitants, les conseillers municipaux sont élus au scrutin 
                     majoritaire, plurinominal, à deux tours. "]
      , p  [] [text "Le nombre de conseillers municipaux à élire varie 
                     selon la taille de la commune (article L. 
                     2121-2 du Code général des collectivités territoriales). En 
                     2014, le nombre de conseillers municipaux des communes 
                     de moins de 100 habitants est modifié, il 
                     passe de 9 à 7."]
      , p  [] [text "Le dépôt d’une déclaration de candidature est désormais 
                     obligatoire, quelle que soit la taille de la 
                     commune. L’obligation de la parité femmes hommes n’est 
                     pas requise pour les communes de moins de 
                     1 000 habitants. Les candidats se présentent sur 
                     une liste, mais les bulletins de vote peuvent 
                     être modifiés par les électeurs (panachage). En 2014, 
                     les modalités de panachage sont toutefois différentes de 
                     celles appliquées lors des précédents scrutins, il n’est 
                     plus possible d’élire une personne qui ne s’est 
                     pas déclarée candidate."]
      , p  [] [text "Les suffrages sont décomptés individuellement par candidat et 
                     non par liste. Pour obtenir un siège au 
                     conseil municipal dès le premier tour, le candidat 
                     doit avoir obtenu la majorité absolue des suffrages 
                     exprimés et recueilli au moins un quart des 
                     suffrages des électeurs inscrits."]
      , p  [] [text "Un second tour est organisé pour les sièges 
                     restant à pourvoir : l’élection a lieu à 
                     la majorité relative et, en cas d’égalité du 
                     nombre des suffrages entre plusieurs candidats, l’élection est 
                     acquise pour le plus âgé. "]
      , p [] [text "Pour la première fois en 2014, les conseillers 
                    communautaires représentant les communes de moins de 1 
                    000 habitants au sein des organes délibérants des 
                    EPCI sont les membres du conseil municipal désignés 
                    dans l’ordre du tableau, c’est-à-dire le maire puis 
                    les adjoints puis les conseillers municipaux ayant obtenu 
                    le plus de voix lors des élections municipales"]
      ]

resElec = 
  div [ class "subContainerData", id "resElecPubli"]
      [ h4 [] [text "Résultats 1er tour des élections municipales"]
      , p  [] [text "Bureau de vote de Murol : votants 354, exprimés 338"]
      , p  [] [text "Bureau de vote de Beaune : votants 84, exprimés 81"] 
      , p  [] [text "Bureau de vote de Beaune : votants 84, exprimés 81"]
      , p  [] [text "Suffrages total exprimés : 419"]
      , p  [] [text "Pour être élu au 1er tour les candidats doivent avoir recueillis 210 voix."]
      , p  [] [text "14 candidats sont élus au 1er tour"]
      , table []
              [tr []
                  [ th [] [text "Candidats par liste"]
                  , th [] [text "Voix"]
                  , th [] [text "Candidats par liste"]
                  , th [] [text "Voix"]
                  ]
              ,tr []
                  [ td [class "win"] [text "Sébastien GOUTTEBEL"]
                  , td [class "win"] [text "238"]
                  , td [class "win"] [text "Colette ARVEUF"]
                  , td [class "win"] [text "213"]
                  ] 
              ,tr []
                  [ td [class "win"] [text "Francois AUBERTY"]
                  , td [class "win"] [text "222"]
                  , td [] [text "Philippe AUSERVE"]
                  , td [] [text "193"]
                  ]
              ,tr []
                  [ td [class "win"] [text "Etel BOUCHE"]
                  , td [class "win"] [text "251"]
                  , td [] [text "Brigitte BERTAUD"]
                  , td [] [text "178"]
                  ]
              ,tr []
                  [ td [class "win"] [text "Yvan CATTARELLI"]
                  , td [class "win"] [text "236"]
                  , td [] [text "Michelle PLANEIX"]
                  , td [] [text "200"]
                  ]
              ,tr []
                  [ td [class "win"] [text "Gilles COMPAGNON"]
                  , td [class "win"] [text "219"]
                  , td [] [text "Isabelle ANGIBAUD"]
                  , td [] [text "183"]
                  ]
              ,tr []
                  [ td [class "win"] [text "Véronique DEBOUT"]
                  , td [class "win"] [text "212"]
                  , td [] [text "Catherine JUSSAUME"]
                  , td [] [text "163"]
                  ]
              ,tr []
                  [ td [] [text "Olivier DHAINAUT"]
                  , td [] [text "204"]
                  , td [] [text "Benédicte MEYER"]
                  , td [] [text "158"]
                  ]
              ,tr []
                  [ td [class "win"] [text "Anne-Marie DOTTE"]
                  , td [class "win"] [text "210"]
                  , td [] [text "Henri LEGRAND"]
                  , td [] [text "178"]
                  ]
              ,tr []
                  [ td [class "win"] [text "Roger DUMONTEL"]
                  , td [class "win"] [text "239"]
                  , td [] [text "Aline REVELLAT"]
                  , td [] [text "188"]
                  ]
              ,tr []
                  [ td [class "win"] [text "Sylvie GILLARD"]
                  , td [class "win"] [text "230"]
                  , td [] [text "Michel MONTAL"]
                  , td [] [text "197"]
                  ]
              ,tr []
                  [ td [class "win"] [text "Angélique LAIR"]
                  , td [class "win"] [text "224"]
                  , td [] [text "Michel TARDIF"]
                  , td [] [text "197"]
                  ]
              ,tr []
                  [ td [] [text "Joséphine LANARO"]
                  , td [] [text "205"]
                  , td [] [text "Marie ABDESSELAM"]
                  , td [] [text "167"]
                  ]
              ,tr []
                  [ td [class "win"] [text "Catherine MAURY"]
                  , td [class "win"] [text "226"]
                  , td [] [text "Patrice DABERT"]
                  , td [] [text "202"]
                  ]
              ,tr []
                  [ td [class "win"] [text "Cristelle ROUX"]
                  , td [class "win"] [text "222"]
                  , td [] [text "Etienne SALA"]
                  , td [] [text "197"]
                  ]
              ,tr []
                  [ td [class "win"] [text "Séverine PEROL"]
                  , td [class "win"] [text "226"]
                  , td [] [text "Hervé de Puytorac"]
                  , td [] [text "184"]
                  ]
              ]
      , h4 [] [text "Résultats 2ème tour des élections municipales"]
      , p  [] [text "Votants 265, exprimés 213"]
      , p  [] [text "Joséphine LANARO est élue"]
      
      , table []
              [tr []
                  [ th [] [text "Candidats par liste"]
                  , th [] [text "Voix"]
                  , th [] [text "Candidats par liste"]
                  , th [] [text "Voix"]
                  ]
              ,tr []
                  [ td [class "win"] [text "Sébastien GOUTTEBEL"]
                  , td [class "win"] [text ""]
                  , td [class "win"] [text "Colette ARVEUF"]
                  , td [class "win"] [text ""]
                  ] 
              ,tr []
                  [ td [class "win"] [text "Francois AUBERTY"]
                  , td [class "win"] [text ""]
                  , td [] [text "Philippe AUSERVE"]
                  , td [] [text ""]
                  ]
              ,tr []
                  [ td [class "win"] [text "Etel BOUCHE"]
                  , td [class "win"] [text ""]
                  , td [] [text "Brigitte BERTAUD"]
                  , td [] [text "1"]
                  ]
              ,tr []
                  [ td [class "win"] [text "Yvan CATTARELLI"]
                  , td [class "win"] [text ""]
                  , td [] [text "Michelle PLANEIX"]
                  , td [] [text ""]
                  ]
              ,tr []
                  [ td [class "win"] [text "Gilles COMPAGNON"]
                  , td [class "win"] [text ""]
                  , td [] [text "Isabelle ANGIBAUD"]
                  , td [] [text ""]
                  ]
              ,tr []
                  [ td [class "win"] [text "Véronique DEBOUT"]
                  , td [class "win"] [text ""]
                  , td [] [text "Catherine JUSSAUME"]
                  , td [] [text ""]
                  ]
              ,tr []
                  [ td [] [text "Olivier DHAINAUT"]
                  , td [] [text "2"]
                  , td [] [text "Benédicte MEYER"]
                  , td [] [text ""]
                  ]
              ,tr []
                  [ td [class "win"] [text "Anne-Marie DOTTE"]
                  , td [class "win"] [text ""]
                  , td [] [text "Henri LEGRAND"]
                  , td [] [text ""]
                  ]
              ,tr []
                  [ td [class "win"] [text "Roger DUMONTEL"]
                  , td [class "win"] [text ""]
                  , td [] [text "Aline REVELLAT"]
                  , td [] [text ""]
                  ]
              ,tr []
                  [ td [class "win"] [text "Sylvie GILLARD"]
                  , td [class "win"] [text ""]
                  , td [] [text "Michel MONTAL"]
                  , td [] [text ""]
                  ]
              ,tr []
                  [ td [class "win"] [text "Angélique LAIR"]
                  , td [class "win"] [text ""]
                  , td [] [text "Michel TARDIF"]
                  , td [] [text ""]
                  ]
              ,tr []
                  [ td [] [text "Joséphine LANARO"]
                  , td [] [text "204"]
                  , td [] [text "Marie ABDESSELAM"]
                  , td [] [text ""]
                  ]
              ,tr []
                  [ td [class "win"] [text "Catherine MAURY"]
                  , td [class "win"] [text ""]
                  , td [] [text "Patrice DABERT"]
                  , td [] [text "4"]
                  ]
              ,tr []
                  [ td [class "win"] [text "Cristelle ROUX"]
                  , td [class "win"] [text ""]
                  , td [] [text "Etienne SALA"]
                  , td [] [text "2"]
                  ]
              ,tr []
                  [ td [class "win"] [text "Séverine PEROL"]
                  , td [class "win"] [text ""]
                  , td [] [text "Hervé de Puytorac"]
                  , td [] [text ""]
                  ]
              ]

      ]
divers = 
  div [class "subContainerData", id "diversPubli"]
      [link " Note de synthèse 2012 station classée de tourisme" ""]
