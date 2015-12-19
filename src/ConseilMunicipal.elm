module ConseilMunicipal where

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
      [ renderMainMenu address (.mainMenu model)
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
  div [ class "subContainerData", id "conseilMunicipal"]
      [ h4 [] [text "Le Conseil Municipal"]
      , p  [] [text "Le conseil municipal règle par ses délibérations les 
                     affaires de la commune : vote du budget, 
                     gestion du domaine municipal… Le nombre d’adjoints est 
                     déterminé par le nombre d’habitants de la ville. 
                     Avec ses 500 habitants, Murol bénéficie de 4 
                     adjoints. Le conseil se réunit généralement une fois 
                     par mois, sauf en été. Les séances sont 
                     publiques."]
      , p  [] [text "Dans un souci de transparence et de participation 
                     des citoyens à la démocratie locale, les projets 
                     de délibération soumis au vote du Conseil Municipal 
                     sont diffusés avant chaque séance."]
      , p  [] [text "Les comptes-rendus des débats et les délibérations sont 
                     publiés à l’issue des séances sur la page 
                     compte rendu, vous les trouverez également sur les 
                     panneaux d'informations de la mairie. "]
      , h4 [] [text "Rôles et missions des élus"]
      , h5 [] [text "Le Maire"]
      , p  [] [text "Le Maire est le représentant de l’Etat dans la commune. "]
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
                                arrêtés pris par le Maire (stationnement, circulation …), 
                                la police nationale étant chargée du maintien de 
                                la sécurité publique"]]
           , li [] [p [] [text "enfin, il est responsable de la sécurité 
                                civile (centre de secours, sapeurs-pompiers)"]]
           ]
      , p  [] [text "Le Maire est aussi chef de l’administration communale"]
      , p  [] [text "Un peu comme un chef d’entreprise, il assume 
                     quotidiennement de nombreuses charges : faire exécuter les 
                     décisions du Conseil municipal ; préparer le budget 
                     et ordonnancer les dépenses ; signer les contrats 
                     ; diriger les travaux, etc."]
      , p  [] [text "Le Maire joue enfin le rôle d’ambassadeur de 
                     la commune auprès des pouvoirs publics et de 
                     tous les interlocuteurs (organismes publics, etc.) qui peuvent 
                     influer sur le sort de la commune. "]

      , h5 [] [text "Les adjoints"]
      , p  [] [text "Les Adjoints sont chargés d’assumer des fonctions que 
                     le Maire leur confie, et éventuellement de suppléer 
                     le Maire en cas d’empêchement (dans l’ordre de 
                     nomination). Ils exercent leurs responsabilités dans un domaine 
                     spécifique, en rapport avec leurs compétences et leurs 
                     motivations : finances, habitat, culture, environnement, etc. "]

      , h5 [] [text "Les conseillers municipaux"]
      , p  [] [text "Quant aux Conseillers municipaux , ils ont reçu 
                     une délégation pour exercer une mission précise auprès 
                     des adjoints ou du Maire."]
      
      , h4 [] [text "Vos élus"]
      , table [] 
              [ tr [] [ td [] [img [src "/images/elus/GOUTTEBEL.jpg"] []]
                      , td [] [text "Maire"]
                      , td [] [text "Sébastien GOUTTEBEL, 
                                     Président SIVOM de la Vallée Verte
                                     Président des Maires Ruraux du Puy-de-Dôme"]
                      ]
              , tr [] [ td [] [img [src "/images/elus/DUMONTEL.jpg"] []]
                      , td [] [text "1er adjoint"]
                      , td [] [text "Roger DUMONTEL
                                     Retraité Michelin"]
                      ]
              , tr [] [ td [] [img [src "/images/elus/AUBERTY.jpg"] []]
                      , td [] [text "2ème Adjoint"]
                      , td [] [text "François AUBERTY,
                                     Capitaine - Chef de compagnie
                                     des Sapeurs Pompiers"]
                      ]
              , tr [] [ td [] [img [src "/images/elus/BOUCHE.jpg"] []]
                      , td [] [text "3ème adjoint"]
                      , td [] [text "Estel BOUCHE, 
                                     Professeur d'anglais"]
                      ]
              , tr [] [ td [] [img [src "/images/elus/GILLARD.jpg"] []]
                      , td [] [text "4ème adjoint"]
                      , td [] [text "Sylvie GILLARD,
                                     Vice-Présidente du CCAS
                                     Professeur des Ecoles"]
                      ]
              , tr [] [ td [] [img [src "/images/elus/CATTARELLI.jpg"] []]
                      , td [] [text "Conseiller municipal"]
                      , td [] [text "Yvan CATTARELLI, 
                                     Commerçant retraité"]
                      ]
              , tr [] [ td [] [img [src "/images/elus/COMPAGNON.jpg"] []]
                      , td [] [text "Conseiller municipal"]
                      , td [] [text "Gilles COMPAGNON,
                                     Technicien informatique"]
                      ]
              , tr [] [ td [] [img [src "/images/elus/DEBOUT.jpg"] []]
                      , td [] [text "Conseiller municipal"]
                      , td [] [text "Véronique DEBOUT,  
                                     Webmaster du site \"murol.fr\"
                                     Bénévole associatif - Militaire à la retraite "]
                      ]
              , tr [] [ td [] [img [src "/images/elus/DOTTE.jpg"] []]
                      , td [] [text "Conseiller municipal"]
                      , td [] [text "Anne-Marie DOTTE,
                                     Retraitée du Tourisme
                                     Co-présidente du COSA"]
                      ]
              , tr [] [ td [] [img [src "/images/elus/LAIR.jpg"] []]
                      , td [] [text "Conseiller municipal"]
                      , td [] [text "Angélique LAIR, 
                                     Présidente du Syndicat agricole
                                     Exploitante agricole"]
                      ]
              , tr [] [ td [] [img [src "/images/elus/LANARO.jpg"] []]
                      , td [] [text "Conseiller municipal"]
                      , td [] [text "Joséphine LANARO, 
                                     Membre du CCAS
                                     responsable de la régie d’avance
                                     Educatrice
                                     spécialisée retraitée"]
                      ]
              , tr [] [ td [] [img [src "/images/elus/MAURY.jpg"] []]
                      , td [] [text "Conseiller municipal"]
                      , td [] [text "Cathy MAURY,  
                                     Responsable de Halte Garderie "]
                      ]
              , tr [] [ td [] [img [src "/images/elus/PEROL.jpg"] []]
                      , td [] [text "Conseiller municipal"]
                      , td [] [text "Séverine PEROL,  
                                    Exploitante agricole -
                                    Présidente de l’association pour l’expansion
                                    du St Nectaire"]
                      ]
              , tr [] [ td [] [img [src "/images/elus/ROUX.jpg"] []]
                      , td [] [text "Conseiller municipal"]
                      , td [] [text "Christelle ROUX
                                     Commerciale"]
                      ]
              ]


      ]

      

-- Data
