module Elections where

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import StartApp.Simple as StartApp
import List exposing (..)
import String exposing (words, join, cons, uncons)
import Char
import Dict exposing (..)
import TiledMenu exposing (initWithLink,view,update,Action)
import StarTable exposing (makeTable, emptyTe, Label(..))
import Murol exposing (mainMenu,
                       renderMainMenu',
                       pageFooter,
                       renderMisc,
                       capitalize,
                       renderListImg,
                       logos,
                       renderSubMenu,
                       mail,
                       site,
                       link)


-- Model
subMenu : Murol.Submenu
subMenu = { current = "", entries = []}

type alias MainContent = 
  { wrapper : (Html -> Html)
  , tiledMenu :  TiledMenu.Model
  } 

type alias Model = 
  { mainMenu    : Murol.Menu
  , subMenu     : Murol.Submenu
  , mainContent : MainContent
  }  

initialModel =
  { mainMenu    = mainMenu
  , subMenu     = subMenu
  , mainContent = initialContent
  }



-- View
view : Signal.Address Action -> Model -> Html
view address model =
  div [ id "container"]
      [ renderMainMenu' ["Documentation", "Elections"]
                        (.mainMenu model)
      , div [ id "subContainer"]
            [ (.wrapper (.mainContent model))
               (TiledMenu.view (Signal.forwardTo address TiledMenuAction) (.tiledMenu (.mainContent model)))
            ]
      , pageFooter
      ]



-- Update

type Action =
    NoOp
  | TiledMenuAction (TiledMenu.Action)

update : Action -> Model -> Model
update action model =
  case action of
    NoOp    -> model
    TiledMenuAction act ->
      let mc = (.mainContent model)
          tm = (.tiledMenu (.mainContent model))
      in
          { model | 
            mainContent = 
             { mc | tiledMenu = TiledMenu.update act tm }
          }

--Main

main =
  StartApp.start
    { model  = initialModel
    , view   = view
    , update = update
    }


initialContent =
  { wrapper = 
    (\content ->
       div [ class "subContainerData noSubmenu", id "Elections"]
           [ h2 [] [text "Elections"]
           , content])
  , tiledMenu =
      initWithLink
            [("Les élections municipales"
            ,"/images/tiles/elections/01.jpg"
            ,[ elections
             ]
            ,""
             )
            ,
            ("Résultats des élections"
            ,"/images/tiles/elections/02.jpg"
            ,[ resElec
             ]
            ,""
             )
            ,
            ("Autres élections"
            ,"/images/tiles/elections/03.jpg"
            ,[
             ]
            ,"http://www.interieur.gouv.fr/Elections"
             )
            ]
  }

-- Data

elections = 
  div [id "elecPubli"]
      [ p  [] [text "Les élections municipales ont lieu, en principe, tous 
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
      , p  [] [text "Le mode de scrutin varie selon le nombre d’habitants
                     de la commune."]
      
      , h5 [] [text "Les communes de plus de 1 000 habitants "]
      , p  [] [text "Les élections municipales des 23 et 30 mars 
                     2014 ont été marquées par deux grandes innovations :"]
      , p  [] [text "Les électeurs de toutes les communes de plus 
                     de 1000 habitants ont élu leurs conseillers municipaux selon 
                     le même mode scrutin
                     qui impose le respect du principe de parité 
                     aux listes de candidats."]
      , p  [] [text "Les électeurs ont désigné, à l’aide d’un seul bulletin 
                     de vote, leurs conseillers municipaux et les conseillers 
                     communautaires. Les conseillers communautaires sont les représentants de 
                     la commune au sein de la structure intercommunale 
                     dont elle est membre."]

      , h5 [] [text "Les communes de moins de 1 000 habitants "]
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
  div [ id "resElecPubli"]
      [ h5 [] [text "Résultats 1er tour"]
      , p  [] [text "Bureau de vote de Murol : votants 354, exprimés 338"]
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
      , h5 [] [text "Résultats du 2ème tour"]
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