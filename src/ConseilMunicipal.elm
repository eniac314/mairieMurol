module ConseilMunicipal where

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import StartApp.Simple as StartApp
import List exposing (..)
import String exposing (words, join, cons, uncons)
import Char
import Dict exposing (..)
import Utils exposing (mainMenu,
                       renderMainMenu,
                       pageFooter,
                       
                       capitalize,
                       renderListImg,
                       logos,
                       Action (..),
                       renderSubMenu,
                       mail,
                       site,
                       link)

-- Model
subMenu = []

initialModel =
  { mainMenu    = mainMenu
  , subMenu     = subMenu
  , mainContent = initialContent
  }

type alias Category =
  { title   : String
  , entries : List Entry
  }

type alias Entry = (String,String)


-- View
view address model =
  div [ id "container"]
      [ renderMainMenu ["Mairie","Conseil municipal"]
                               (.mainMenu model)
      , div [ id "subContainer"]
            [ .mainContent model
            ]
      , pageFooter
      ]



contentMap =
 fromList []

update action model =
  case action of
    NoOp    -> model
    Entry s -> changeMain model s

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
  div [ class "subContainerData noSubmenu", id "conseilMunicipal"]
      [ h2 [] [text "Le Conseil Municipal"]
      , p  [] [text "Le conseil municipal règle par ses délibérations les 
                     affaires de la commune : vote du budget, 
                     gestion du domaine municipal… Le nombre d’adjoints est 
                     déterminé par le nombre d’habitants de la ville. 
                     Avec plus de 500 habitants, Murol bénéficie de 4 
                     adjoints. Le conseil se réunit généralement une fois 
                     par mois, sauf en été. Les séances sont 
                     publiques."]
      --, p  [] [text "Dans un souci de transparence et de participation 
      --               des citoyens à la démocratie locale, les projets 
      --               de délibération soumis au vote du Conseil Municipal 
      --               sont diffusés avant chaque séance."]
      --, p  [] [text "Les comptes-rendus des débats et les délibérations sont 
      --               publiés à l’issue des séances sur la page 
      --               compte rendu, vous les trouverez également sur les 
      --               panneaux d'informations de la mairie. "]
      , p []
          [ text "Dans un souci de transparence et de participation 
                 des citoyens à la démocratie locale l’ordre du 
                 jour des réunions du conseil municipal est affiché 
                 sur les panneaux d’informations de la mairie et 
                 les délibérations sont publiées à l’issue des séances 
                 sur la page «"
          , a [href "/Délibérations.html"]
              [text "délibérations"]
          , text "» du site."
          ]

      , h4 [] [text "Rôles et missions des élus"]
      , h5 [] [text "Le maire"]
      , p  [] [text "Le maire est le représentant de l’Etat dans la commune. "]
      , p  [] [text "A ce titre, il est officier d’état civil 
                     et officier de police judiciaire, chargé de missions 
                     déléguées par l’Etat : "]
      , ul []
           [ li [] [p [] [text "il gère certains services administratifs (état civil, 
                                listes électorales, listes de conscription …) "]]
           , li [] [p [] [text "il fait exécuter les lois, règlements et 
                                décisions transmis par le préfecture"]]
           , li [] [p [] [text "il veille, en accord avec le préfet, 
                                à la bonne marche de la police municipale 
                                qui a pour mission de faire respecter les 
                                arrêtés pris par le maire (stationnement, circulation …), 
                                la police nationale étant chargée du maintien de 
                                la sécurité publique"]]
           , li [] [p [] [text "enfin, il est responsable de la sécurité 
                                civile (centre de secours, sapeurs-pompiers)"]]
           ]
      , p  [] [text "Le maire est aussi chef de l’administration communale"]
      , p  [] [text "Un peu comme un chef d’entreprise, il assume 
                     quotidiennement de nombreuses charges : faire exécuter les 
                     décisions du Conseil municipal ; préparer le budget 
                     et ordonnancer les dépenses ; signer les contrats 
                     ; diriger les travaux, etc."]
      , p  [] [text "Le maire joue enfin le rôle d’ambassadeur de 
                     la commune auprès des pouvoirs publics et de 
                     tous les interlocuteurs (organismes publics, etc.) qui peuvent 
                     influer sur le sort de la commune. "]

      , h5 [] [text "Les adjoints"]
      , p  [] [text "Les adjoints sont chargés d’assumer des fonctions que 
                     le maire leur confie, et éventuellement de suppléer 
                     le maire en cas d’empêchement (dans l’ordre de 
                     nomination). Ils exercent leurs responsabilités dans un domaine 
                     spécifique, en rapport avec leurs compétences et leurs 
                     motivations : finances, habitat, culture, environnement, etc. "]

      , h5 [] [text "Les conseillers municipaux"]
      --, p  [] [text "Quant aux Conseillers municipaux , ils ont reçu 
      --               une délégation pour exercer une mission précise auprès 
      --               des adjoints ou du maire."]
      
      , p []
          [ text "Les conseillers municipaux participent et votent les délibérations 
                 lors des réunions du conseil municipal. De plus, 
                 ils travaillent dans le cadre des commissions communales 
                 et représentent la commune au sein des intercommunalités 
                 en tant que délégués. (cf document "
          , a [ href "/baseDocumentaire/conseilMunicipal/COMMISSIONS ET DELEGATIONS.pdf"
              , target "_blank"]
              [ text "commissions et 
                      délégations"]
          , text ")"
          ]
      , h4 [] [text "Les élus"]
      , table [] 
              [ tr [] [ td [] [img [src "/images/elus/GOUTTEBEL.jpg"] []]
                      , td [] [span [class "status"] [text "maire"]]
                      , td [] [ p [class "nom"] [text "Sébastien GOUTTEBEL"]
                              , p [class "job"]
                                  [text "Président SIVOM de la Vallée Verte"
                                  , br [] []
                                  , text "Président des maires Ruraux du Puy-de-Dôme"
                                  ]  
                              ]
                      ]
              , tr [] [ td [] [img [src "/images/elus/DUMONTEL.jpg"] []]
                      , td [] [span [class "status"] [text "1er adjoint"]]
                      , td [] [ p [class "nom"] [text "Roger DUMONTEL"]
                              , p [class "job"]
                                  [text "Retraité Michelin"]
                              ]
                      ]
              , tr [] [ td [] [img [src "/images/elus/AUBERTY.jpg"] []]
                      , td [] [span [class "status"] [text "2ème adjoint"]]
                      , td [] [ p [class "nom"] [text "François AUBERTY"]
                              , p [class "job"]
                                  [text "Commandant 
                                         des Sapeurs Pompiers retraité"]
                              ]
                      ]
              , tr [] [ td [] [img [src "/images/elus/BOUCHE.jpg"] []]
                      , td [] [span [class "status"] [text "3ème adjointe"]]
                      , td [] [ p [class "nom"] [text "Estel BOUCHE"]
                              , p [class "job"]
                                  [text "Professeur d'anglais"]
                              ]
                      ]
              , tr [] [ td [] [img [src "/images/elus/GILLARD.jpg"] []]
                      , td [] [span [class "status"] [text "4ème adjointe"]]
                      , td [] [ p [class "nom"] [text "Sylvie GILLARD"]
                              , p [class "job"]
                                  [text "Vice-Présidente du CCAS"
                                  , br [] []
                                  ,text "Professeur des Ecoles"]
                              ]
                      ]
              , tr [] [ td [] [img [src "/images/elus/CATTARELLI.jpg"] []]
                      , td [] [span [class "status"] [text "Conseiller municipal"]]
                      , td [] [ p [class "nom"] [text "Yvan CATTARELLI"]
                              , p [class "job"]
                                  [text "Commerçant retraité"]
                              ]
                      ]
              , tr [] [ td [] [img [src "/images/elus/COMPAGNON.jpg"] []]
                      , td [] [span [class "status"] [text "Conseiller municipal"]]
                      , td [] [ p [class "nom"] [text "Gilles COMPAGNON"]
                              , p [class "job"]
                                  [text "Technicien informatique"]
                              ]
                      ]
              , tr [] [ td [] [img [src "/images/elus/DEBOUT.jpg"] []]
                      , td [] [span [class "status"] [text "Conseillère municipale"]]
                      , td [] [ p [class "nom"] [text "Véronique DEBOUT"]
                              , p [class "job"]
                                  [text "Bénévole associatif - Militaire à la retraite"]
                              ]
                      ]
              , tr [] [ td [] [img [src "/images/elus/DOTTE.jpg"] []]
                      , td [] [span [class "status"] [text "Conseillère municipale"]]
                      , td [] [ p [class "nom"] [text "Anne-Marie DOTTE"]
                              , p [class "job"]
                                  [text "Retraitée du Tourisme"
                                  ]
                              ]
                      ]
              , tr [] [ td [] [img [src "/images/elus/LAIR.jpg"] []]
                      , td [] [span [class "status"] [text "Conseillère municipale"]]
                      , td [] [ p [class "nom"] [text "Angélique LAIR"]
                              , p [class "job"]
                                  [text "Présidente du Syndicat agricole"
                                  , br [] []
                                  ,text "Exploitante agricole"]
                              ]
                      ]
              , tr [] [ td [] [img [src "/images/elus/LANARO.jpg"] []]
                      , td [] [span [class "status"] [text "Conseillère municipale"]]
                      , td [] [ p [class "nom"] [text "Joséphine LANARO"]
                              , p [class "job"]
                                  [text "Membre du CCAS
                                        responsable de la régie d’avance"
                                  , br [] []
                                  ,text "Educatrice
                                        spécialisée retraitée"]
                              ]
                      ]
              , tr [] [ td [] [img [src "/images/elus/MAURY.jpg"] []]
                      , td [] [span [class "status"] [text "Conseillère municipale"]]
                      , td [] [ p [class "nom"] [text "Cathy MAURY"]
                              , p [class "job"]
                                  [text "Responsable de Halte Garderie"]
                              ]
                      ]
              , tr [] [ td [] [img [src "/images/elus/PEROL.jpg"] []]
                      , td [] [span [class "status"] [text "Conseillère municipale"]]
                      , td [] [ p [class "nom"] [text "Séverine PEROL"]
                              , p [class "job"] 
                                  [text "Exploitante agricole -
                                        Présidente de l’association pour l’expansion
                                        du St Nectaire"]
                              ]
                      ]
              , tr [] [ td [] [img [src "/images/elus/ROUX.jpg"] []]
                      , td [] [span [class "status"] [text "Conseillère municipale"]]
                      , td [] [ p [class "nom"] [text "Christelle ROUX"]
                              , p [class "job"] [text "Commerciale"]
                              ]
                      ]
              ]


      ]

      

-- Data
