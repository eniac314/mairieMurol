module Associations where

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


type alias Responsable =
  { poste : String
  , nom   : String
  , tel   : String
  }

type alias Assoc = 
  { nom     : String
  , preci   : String
  , domaine : String
  , siege   : String
  , affil   : String
  , resp    : List Responsable
  , mails   : List String
  , sites   : List String
  , logo    : String
  }


emptyAssoc = Assoc "" "" "" "" "" [] [] [] ""

-- View
view address model =
  div [ id "container"]
      [ renderMainMenu address (.mainMenu model)
      , div [ id "subContainer"]
            [ .mainContent model
            ]
      , pageFooter
      ]

renderAssocs : Html
renderAssocs =
  let assocs' = List.sortBy (.nom) assocs
  in div [class "assocs"]
         (List.map renderAssoc assocs')

renderAssoc : Assoc -> Html
renderAssoc { nom, preci, domaine, siege, affil, resp, mails, sites, logo} = 
  let nom'  = maybeElem nom (\s -> h6 [] [text s])
      preci' = maybeElem preci (\s -> p [] [text s])
      dom'   = maybeElem 
                domaine 
                (\s -> p [] [text ("Domaine de compétences: " ++ s)])
      siege' = maybeElem
                siege
                (\s -> p [] [text ("Siège social: " ++ s)])
      affil' = maybeElem
                affil
                (\s -> p [] [text ("Affiliation: " ++ s)])
      resp'  = List.map renderResp resp
      mails' = List.map mail mails
      sites' = List.map (\s -> link s s) sites   

  in div [class "assoc"]
         ([nom',preci',dom', siege', affil'] ++ resp'++ mails'++sites')


renderResp : Responsable -> Html
renderResp {poste,nom,tel} =
  let poste' = maybeElem poste (\s -> span [] [text (s ++ ": ")])
      nom'   = maybeElem nom (\s -> span [] [text s])
      tel'   = maybeElem tel (\s -> span [] [text (" - Tel. " ++ s)])
  in div [class "responsable"]
         [poste',nom',tel']

maybeElem : String -> ( String -> Html ) -> Html
maybeElem s f =
  if String.isEmpty s
  then nullTag
  else f s

nullTag = span [style [("display","none")]] []

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
  div [ class "subContainerData", id "associations"]
      [renderAssocs]
 

-- Data
assocs = 
  [ { emptyAssoc |
      nom     = "Amicale des chasseurs murolais"
    , domaine = "société de chasse"
    , siege   = "mairie de Murol 63790 MUROL"
    , affil   = "Fédération départementale des chasseurs du Puy-de-Dôme"
    , resp = [{ poste = "Président"
              , nom   = "Laurent GASCHON"
              , tel   = "06 8667 1322"
              }]
    , mails    = ["laurent.gaschon@laposte.net"] 
    }
  , { emptyAssoc |
      nom     = "Amicale des Sapeurs Pompiers"
    , domaine = "actions en faveur des sapeurs pompiers, organisation de festivités sur la commune"
    , siege   = "rue Guy de Maupassant 63790 MUROL"
    , resp = [{ poste = "Président"
              , nom   = "Yannick COHERIER"
              , tel   = "04 4330 6596"
              }]
    , mails    = ["yannick632009@live.fr"]
    , sites    = ["http://pompiersdemurol.wifeo.com"] 
    }
  , { emptyAssoc |
      nom     = "Association Bougn’Arts"
    , domaine = "organiser des festivals et des manifestations culturelles
                - créer, organiser et promouvoir des animations et spectacles
                de rues ainsi que des animations pédagogiques
                - rassembler des artisans et des artistes à l’occasion de fêtes,
                foires, marchés artisanaux et marchés à thèmes."
    , siege   = "« Les Aloès » Rue chabrol – 63790 Murol"
    , resp = [{ poste = "Présidente"
              , nom   = "Bénédicte Manfri-Humbert"
              , tel   = "06 7216 7846"
              }]
    , mails    = ["associationbougnarts@orange.fr"] 
    }
  , { emptyAssoc |
      nom     = "Association Chambon Murol Evénements (ACME)"
    , domaine = "organisation de manifestations sur le massif du Sancy
                 (fêtes de villages, Sancy Deuch…)"
    , resp = [{ poste = "Président"
              , nom   = "Henri-Frédéric LEGRAND"
              , tel   = "06 0868 6545"
              }]
    , mails    = ["hfl63@orange.fr"]
    , sites    = ["http://www.acme63.com"] 
    }
  , { emptyAssoc |
      nom     = "Association Couleurs et motifs"
    , siege   = "rue du lac - 63790 CHAMBON SUR LAC"
    , resp = [{ poste = "Présidente"
              , nom   = "Jacqueline GODARD"
              , tel   = ""
              }]
    , mails    = ["jacqueline.godard@free.fr"] 
    }
  , { emptyAssoc |
      nom     = "Association culturelle et sportive de Beaune_le froid"
    , domaine = "activité ski de fond"
    , siege   = "Beaune-le-Froid 63790 MUROL"
    , resp = [{ poste = "Président"
              , nom   = "Yannick LATREILLE"
              , tel   = "04 7388 8118"
              }]
    , mails    = ["yannick-latreille@hotmail.fr"] 
    }
  , { emptyAssoc |
      nom     = "Association de la Foire du Saint Nectaire de Beaune le Froid"
    , domaine = "organisation de manifestations agricoles, promotion du 
                 Saint Nectaire fermier et des produits régionaux, activités d’animation dans la commune"
    , siege   = "mairie de Murol, 63790 MUROL"
    , resp = [{ poste = "Présidente"
              , nom   = "Pierrette TOURREIX"
              , tel   = "04 7335 9771"
              }]
    , mails    = ["pierrette.tourreix@orange.fr"] 
    }
  , { emptyAssoc |
      nom     = "Association de parents d’élèves des écoles Murol-Chambon"
    , domaine = "contribuer et favoriser les activités scolaires et extra- scolaires"
    , siege   = "Mairie de Murol - 63790 Murol"
    , resp = [{ poste = "Présidente"
              , nom   = "Dominique BIGAND"
              , tel   = "04 7388 6846 - Portable : 06 3213 0725"
              }]
    , mails    = ["ape.murolchambon@laposte.net"] 
    }
    , { emptyAssoc |
      nom     = "Association des Amis du Musée de Murol (AAMM)"
    , domaine = "soutenir, faire connaître et promouvoir le musée des peintres de l’Ecole de Murol"
    , siege   = "rue de Chabrol, 63790 MUROL"
    , resp = [{ poste = "Président"
              , nom   = "Dr Bernard LAPALUS"
              , tel   = "04 7337 1088"
              }]
    , mails    = [] 
    }
    , { emptyAssoc |
      nom     = "Association des jeunes de Murol"
    , siege   = "Chautignat 63790 MUROL"
    , resp = [{ poste = "Présidente"
              , nom   = "Manon PEROL"
              , tel   = ""
              }
              ,
              { poste = "Contact"
              , nom   = "Victor LAGEIX"
              , tel   = "06 8159 3353"
              }
              ]
    , mails    = ["victor.lageix@laposte.net"] 
    }
    , { emptyAssoc |
      nom     = "Association Intercommunale des Anciens Combattants"
    , preci   = "Section de Chambon sur Lac, Murol, Saint Nectaire"
    , domaine = "transmettre le devoir de mémoire aux jeunes générations, assurer la solidarité"
    , siege   = "rue Chareton, 63790 MUROL"
    , resp = [{ poste = "Vice Président pour Murol"
              , nom   = "Georges GAUFFIER"
              , tel   = "04 7383 6202"
              }]
    }
    , { emptyAssoc |
      nom     = "Association Médiévale de Murol - Auvergne (AMMA)"
    , domaine = "promouvoir et sauvegarder le patrimoine médiéval de la commune de Murol"
    , siege   = "63790 Murol"
    , resp = [{ poste = "Présidente"
              , nom   = "Jacqueline COUDERT"
              , tel   = ""
              }
              ,
              { poste = "Contact"
              , nom   = "Vincent Salesse"
              , tel   = "04 7326 0200"
              }
              ]
    , mails    = ["amma.murol@laposte.net"] 
    }
    , { emptyAssoc |
      nom     = "Association Sancy Celtique"
    , domaine = "organisation de festival"
    , siege   = "Maison du Prélong - 63790 Murol"
    , resp = [{ poste = "Président"
              , nom   = "Gérôme GODARD"
              , tel   = ""
              }
              ,
              { poste = "Contact"
              , nom   = "Vincent Salesse"
              , tel   = "04 73 26 02 00"
              }]
    , mails    = ["amma.murol@laposte.net"] 
    }
    , { emptyAssoc |
      nom     = "Association Sportive des écoles de Murol et de Chambon sur Lac (A.S.E.M.C.)"
    , domaine = "contribuer à l’éducation des enfants par la pratique d’activités physiques et sportives"
    , siege   = "école primaire de Chambon sur Lac"
    , affil   = "USEP Sancy, les Hermines"
    , resp = [{ poste = "Présidente"
              , nom   = "Carine BABUT"
              , tel   = "04 7388 6816"
              }]
    , mails    = ["ecole.chambon-sur-lac.63@ac-clermont.fr"] 
    }
    , { emptyAssoc |
      nom     = "Bureau Montagne Auvergne Sancy Volcans"
    , domaine = "activités sportives de pleine nature grand public"
    , siege   = "mairie de Murol Adresse : BP11 63790 MUROL"
    , resp = [{ poste = "Présidente"
              , nom   = "Arlette GOIMARD"
              , tel   = "06 2275 4237"
              }
              ,
              { poste = "Coordinateur activités hiver printemps"
              , nom   = "Romain Mezonnet"
              , tel   = "06 7524 1504"
              }
              ,
              { poste = "Coordinateur activités estivales"
              , nom   = "Ernesto RUIZ"
              , tel   = "06 8423 8728"
              }]
    , mails    = ["bertrandgoimard@hotmail.com","contact@guides-asv.com"] 
    }
    , { emptyAssoc |
      nom     = "Chambre syndicale des commerçants des marchés du Puy de Dôme (CSCM du 63)"
    , domaine = "organisation de la Foire du Terroir de Murol"
    , siege   = "BP 30016 63401 CHAMALIERES"
    , affil   = ""
    , resp = [{ poste = "Vice-Président"
              , nom   = "Rémy VALLAT"
              , tel   = "04 7173 6263"
              }]
    , mails    = ["remy.vallat@wanadoo.fr"] 
    }
    , { emptyAssoc |
      nom     = "Collectif développement des commerçants Murolais 63"
    , domaine = "développement de l'activité commerciale"
    , siege   = "rue Georges Sand - 63790 MUROL"
    , resp = [{ poste = "Président"
              , nom   = "jean-Jacques ROUCHVARGER"
              , tel   = "06 3297 0219"
              }]
    , mails    = ["njrorganisation@orange.fr"] 
    }
    , { emptyAssoc |
      nom     = "COSA63"
    , domaine = "organisation de forums associatifs"
    , resp = [{ poste = "Contact"
              , nom   = "Anne-marie DOTTE"
              , tel   = "06 81 00 20 32"
              }
              ,
              { poste = "Contact"
              , nom   = "Elisabeth CROZET"
              , tel   = "06 30 03 80 69"
              }]
    , mails    = ["lecosa63@gmail.com"] 
    }
    , { emptyAssoc |
      nom     = "Don de Sang bénévole du Canton de Besse"
    , domaine = "organiser les collectes de sang sur le canton"
    , siege   = "3, cour des miracles 63610 BESSE"
    , resp = [{ poste = "Président"
              , nom   = "Pierre SOULIER "
              , tel   = "04 7379 5070"
              }]
    }
    , { emptyAssoc |
      nom     = "EIVV"
    , siege   = "Lac Chambon - 63790 Chambon sur lac"
    , resp = [{ poste = "Président"
              , nom   = "Jean-louis REBOUFFAT"
              , tel   = "04 7388 6308"
              }]
    , mails    = ["jeanlouis.rebouffat@sfr.fr"] 
    }
    ,
    { emptyAssoc |
      nom     = "Elément Terre"
    , domaine = "éducation à l’environnement des scolaires, organisation de classes de découvertes"
    , siege   = "mairie de Murol BP 11- 63 790 MUROL "
    , resp = [{ poste = "Président"
              , nom   = "Bernard BOURGEOIS"
              , tel   = "04 7379 3523"
              }]
    , mails    = ["element.terre@laposte.net"]
    , sites    = ["www.element-terre.org"]
    }
    ,
    { emptyAssoc |
      nom     = "Groupement de défense contre les ennemis des cultures"
    , domaine = "lutte contre les nuisibles"  
    , siege   = "Chautignat - 63790 MUROL"
    , resp = [{ poste = "Président"
              , nom   = "Jean-Marie PEROL"
              , tel   = "04 7388 6890"
              }]
    }
    ,
    { emptyAssoc |
      nom     = "Groupement pastorale de la Couialle"
    , siege   = "mairie de Murol - 63 790 MUROL"
    , resp = [{ poste = "Président"
              , nom   = "Laurent PLANEIX"
              , tel   = ""
              }]
    }
    ,
    { emptyAssoc |
      nom     = "JEEP Appellation Origine Contrôlée (JEEP AOC)"
    , domaine = "rassembler les amateurs de Jeep et véhicules assimilés"
    , siege   = "Groire - 63790 MUROL"
    , resp = [{ poste = "Président"
              , nom   = "Bruno CATTARELLI "
              , tel   = "06 70 02 06 28"
              }]
    , mails    = ["jeepaoc@gmail.com"]
    , sites    = ["www.jeepaoc.com","http://jeepaoc.over-blog.com"]
    }
    ,
    { emptyAssoc |
      nom     = "La Gaule Murolaise"
    , domaine = "société de Pêche"
    , siege   = "Les rives - lac Chambon 63790 Chambon sur lac"
    , affil   = "fédération de pêche du Puy de Dôme et du milieu aquatique (LEMPDES)"
    , resp = [{ poste = "Président"
              , nom   = "Bernard LABASSE"
              , tel   = "04 7388 6409 / 09 6147 6717"
              }]
    }
    ,
    { emptyAssoc |
      nom     = "La Main Gauche"
    , domaine = "club sportif de pétanque"
    , siege   = "bar Intimyté, route de Besse, 63790 MUROL "
    , resp = [{ poste = "Président"
              , nom   = "Christophe GUITTARD"
              , tel   = "06 2851 2802"
              }]
    }
    ,
    { emptyAssoc |
      nom     = "Le XV de la Vallée Verte"
    , domaine = "rugby"
    , siege   = "bar « Les Baladins », 63790 St Nectaire"
    , resp = [{ poste = "Président"
              , nom   = "Bruno SERRE"
              , tel   = "04 7388 5135"
              }]
    , mails    = ["lexvdelavalleeverte@hotmail.fr","julien.boucheix@orange.fr","contact@stephane-cregut.fr"]
    }
    ,
    { emptyAssoc |
      nom     = "Les Amis du Vieux Murol"
    , domaine = "association des personnes du troisième âge"
    , affil   = "fédération « les Aînés Ruraux » Clermont-Ferrand"
    , siege   = "mairie de Murol, 63790 MUROL"
    , resp = [{ poste = "Président"
              , nom   = "Pierrette TOURREIX"
              , tel   = "04 7335 9771"
              }]
    , mails    = ["pierrette.tourreix@orange.fr"]
    }
    ,
    { emptyAssoc |
      nom     = "Les Chevaucheurs"
    , domaine = "organisation de manifestations culturelles (reconstitution historique, combats, spectacle équestre…)"
    , siege   = "18 rue Guyot Dessaigne 63114 AUTHEZAT"
    , resp = [{ poste = "Président"
              , nom   = "Pascal BONY"
              , tel   = "07 7792 1530"
              }]
    , mails    = ["hagranyms@hotmail.fr"]
    }
    ,
    { emptyAssoc |
      nom     = "Murol Remparts du Sancy"
    , domaine = "organisation de festivals et de manifestations culturelles (fête du 14 juillet)"
    , siege   = "mairie, 63790 MUROL"
    , resp = [{ poste = "Présidente"
              , nom   = "Bénédicte MANFRI "
              , tel   = "06 72 16 78 46"
              }
              ,
              { poste = "Secrétaire-Trésorière"
              , nom   = "Joëlle LIOUX"
              , tel   = "06 52 43 52 52"
              }]
    , mails    = ["assmurolrempart@gmail.com"]
    }
    ,
    { emptyAssoc |
      nom     = "Natur ’ Sancy"
    , domaine = "Activité de pleine nature, tout public
                 Protection du patrimoine naturel en milieu montagnard,
                 activités lié à la découverte du patrimoine."
    , siege   = "route de Besse, 63790 MUROL"
    , resp = [{ poste = "Présidente"
              , nom   = "Véronique DEBOUT"
              , tel   = "04 7388 6756 ou – Tél : 06 2806 8177"
              }]
    , mails    = ["natur.sancy@gmail.com","http://natursancy.blogspot.fr/"]
    }
    ,
    { emptyAssoc |
      nom     = "Rencontre et détente"
    , domaine = "activités gymniques"
    , siege   = "rue du Tartaret 63790 MUROL"
    , resp = [{ poste = "Présidente"
              , nom   = "Sylvie BEAL"
              , tel   = "04 73 88 66 21"
              }]
    }
    ,
    { emptyAssoc |
      nom     = "Société de Chasse"
    , domaine = "société de chasse"
    , siege   = "Beaune le Froid 63790 MUROL"
    , affil   = "Fédération départementale des chasseurs du Puy-de-Dôme"
    , resp = [{ poste = "Président"
              , nom   = "Laurent PLANEIX"
              , tel   = "04 73 88 60 74"
              }]
    }
    ,
    { emptyAssoc |
      nom     = "Syndicat agricole"
    , domaine = "syndicat professionnel"
    , siege   = "mairie de Murol 63790 MUROL"
    , resp = [{ poste = "Présidente"
              , nom   = "Angélique LAIR"
              , tel   = "04 7388 8110"
              }]
    }
    ,
    { emptyAssoc |
      nom     = "Syndicat hôtelier"
    , domaine = "syndicat professionnel"
    , siege   = "rue de la Vieille Tour 63790 MUROL"
    , resp = [{ poste = "Présidente"
              , nom   = "Amélie DABERT"
              , tel   = "04 7388 6106 "
              }]
    }
    ,
    { emptyAssoc |
      nom     = "Système d'Echange Local \"S.SancyEL\""
    , domaine = "association à caractère social permettant à leur membres de procéder
                 à des échanges de biens, de services et de savoirs, sans avoir recours à la monnaie. "
    , siege   = "3 impasse de la Vernoze - Champeix"
    , resp = [{ poste = "Contact"
              , nom   = "Annie JONCOUX"
              , tel   = "04 4312 6198 ou 06 9850 4297"
              }
              ,
              { poste = "Contact"
              , nom   = "Livia VAN EIJLE"
              , tel   = "04 7388 6489"
              }]
    , mails    = ["annie.joncoux@sfr.fr"," Livia.vaneijle@wanadoo.fr"]
    }
    ,
    { emptyAssoc |
      nom     = "Les Scieurs d’Antan des Monts des Dômes"
    , domaine = "organisation de manifestations culturelles,
                 faire revivre les vieux métiers de la terre"
    , siege   = "6, allée de Rivassol 63 830 NOHANENT"
    , resp = [{ poste = "Président"
              , nom   = "Maurice BARD"
              , tel   = "04 7362 8487"
              }]
    }
    ,
    { emptyAssoc |
      nom     = "Académie de la Gentiane"
    , mails    = ["academiegentiane@orange.fr"]
    }
    ,
    { emptyAssoc |
      nom     = "Camping qualité Auvergne"
    , domaine = "charte professionnelle de qualité"
    , affil   = "Camping Qualité national"
    , siege   = "Jassat 63790 MUROL"
    , resp = [{ poste = "Présidente"
              , nom   = "Sylvie JORY"
              , tel   = ""
              }]
    }  
  ]