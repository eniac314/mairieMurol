module AssociationsList where

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
                       prettyUrl,
                       capitalize,
                       renderListImg,
                       logos,
                       Action (..),
                       renderSubMenu,
                       mail,
                       site,
                       link,
                       split3')

-- Model
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
  , cat     : Category
  }

type Category = Culture | Sport | Pro

emptyAssoc = Assoc "" "" "" "" "" [] [] [] "" Culture

-- View


renderAssocs : List Assoc -> Html
renderAssocs assocs = 
  let assocs' = List.sortBy (.nom) assocs
      toDivs = List.map renderAssoc assocs'
      col ds = div [class "column", style [("max-width","30%")]] ds

  in div [] ((List.map col (split3' toDivs)) ++ [contact])

contact = 
   p []
     [ text "Liste non exhaustive, contactez "
     , a [href ("mailto:"++"contactsite.murol@orange.fr")]
         [text "le webmaster"]
     , text " pour toute erreur ou oubli!"
     ]

renderAssoc : Assoc -> Html
renderAssoc { nom, preci, domaine, siege, affil, resp, mails, sites, logo} = 
  let nom'  = maybeElem nom (\s -> h5 [] [anchor, text s])
      preci' = maybeElem preci (\s -> p [] [text s])
      dom'   = maybeElem 
                domaine 
                (\s -> div [class "domaine"]
                           [h6 [] [ text "Domaine de compétences: "]
                           , p [] [ text (capitalize s)]
                           ])
      siege' = maybeElem
                siege
                (\s -> div [class "siege"]
                           [h6 [] [ text "Siège social: "]
                           , p [] [ text s]
                           ])
      affil' = maybeElem
                affil
                (\s -> div [class "affil"]
                           [h6 [] [ text "Affiliation: "]
                           , p [] [ text s]
                           ])
      resp'  = if List.isEmpty resp
               then nullTag
               else div [class "resps"]
                           ([h6 [] [text "Responsable(s): "]]
                            ++ List.concat
                                (List.intersperse ([br [] []])
                                   (List.map renderResp resp)))
      mails' = mailsToHtml mails
      sites' = sitesToHtml sites

      anchor = a [name (String.concat (String.words nom))
                 --, style [("display","none")]
                 ] []    

  in div [class "assoc", style [("max-width","95%")]]
         ([nom',preci',dom', siege', affil', resp', mails',sites'])


renderResp : Responsable -> List Html
renderResp {poste,nom,tel} =
  let poste' = maybeElem poste (\s -> p [] [text (s ++ ": " ++ nom)])
      tel'   = maybeElem tel (\s -> p [] [text (" Tel: " ++ s)])
  in [poste',tel']

maybeElem : String -> ( String -> Html ) -> Html
maybeElem s f =
  if String.isEmpty s
  then nullTag
  else f s

nullTag = span [style [("display","none")]] []

mailsToHtml mails = 
  case mails of
   [] -> nullTag
   _  -> div [class "mailsAssoc"]
              ( [h6 [] [text "Email(s): "]]
                ++ (List.map  (\m -> a [href ("mailto:"++ m)] [text m]) mails))

sitesToHtml sites = 
  case sites of
   [] -> nullTag
   _  -> div [class "sitesAssoc"]
              ( [h6 [] [text "Site(s): "]]
                ++ (List.map  (\s-> a [href  s, target "_blank"] [text ( prettyUrl s)]) sites))
-- Data
associations = [("Culture, Evénementiel, Solidarité","/images/tiles/misc/ASSOC CULTURE.jpg",[culture])
               ,("Sport","/images/tiles/misc/ASSOC SPORT.jpg",[sport])
               ,("Professionnel","/images/tiles/misc/ASSOC PRO.jpg",[pro])
               ]

culture = renderAssocs (List.filter (\a -> a.cat == Culture) assocs)
sport   = renderAssocs (List.filter (\a -> a.cat == Sport)   assocs)
pro     = renderAssocs (List.filter (\a -> a.cat == Pro)     assocs) 

assocs = 
  [ { emptyAssoc |
      nom     = "Amicale des chasseurs murolais"
    , domaine = "société de chasse"
    , siege   = "mairie de Murol 63790 MUROL"
    , affil   = "Fédération départementale des chasseurs du Puy-de-Dôme"
    , resp = [{ poste = "Coprésident"
              , nom   = "Laurent GASCHON"
              , tel   = "06 45 28 96 84"
              }
              ,
              { poste = "Coprésident"
              , nom   = "Guy Roche"
              , tel   = "04 73 88 65 99"
              }
              ]
    --, mails    = ["laurent.gaschon@laposte.net"]
    , cat = Sport 
    }
  , { emptyAssoc |
      nom     = "Amicale des Sapeurs Pompiers"
    , domaine = "actions en faveur des sapeurs pompiers, organisation de festivités sur la commune"
    , siege   = "Mairie de Murol"
    , resp = [{ poste = "Président"
              , nom   = "Yannick COHERIER"
              , tel   = "04 73 88 64 38"
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
    , siege   = "« Les Aloès » Rue de Chabrol – 63790 Murol"
    , resp = [{ poste = "Présidente"
              , nom   = "Bénédicte Manfri"
              , tel   = "06 72 16 78 46"
              }]
    , mails    = ["associationbougnarts@orange.fr"] 
    }
  , { emptyAssoc |
      nom     = "Association Culture et Patrimoine de la Vallée Verte ACPVV"
    , domaine = "organisation de manifestations sur le massif du Sancy
                 (fêtes de villages, Sancy Deuch…)"
    , resp = [{ poste = "Président"
              , nom   = "Henri-Frédéric LEGRAND"
              , tel   = "06 08 68 65 45"
              }]
    , mails    = ["hfl63@orange.fr"]
    --, sites    = ["http://www.acme63.com"] 
    }
  , { emptyAssoc |
      nom     = "Association Couleurs et motifs"
    , domaine = "promouvoir, encourager, développer 
                 la pratique des arts, favoriser les talents
                  par tous les moyens existants. "
    , siege   = "Allée de la Plage 63790 Murol"
    , resp = [{ poste = "Présidente"
              , nom   = "Jacqueline GODARD"
              , tel   = ""
              }]
    , mails    = ["jacqueline.godard@free.fr"] 
    }
  , { emptyAssoc |
      nom     = "Association culturelle et sportive de Beaune-le-froid"
    , domaine = "activité ski de fond"
    , siege   = "Beaune-le-Froid 63790 MUROL"
    , resp = [{ poste = "Président"
              , nom   = "Yannick LATREILLE"
              , tel   = "04 73 88 81 18"
              }]
    , mails    = ["yannick-latreille@hotmail.fr"]
    --, cat = Sport 
    }
  , { emptyAssoc |
      nom     = "Association culturelle et sportive de Beaune-le-froid"
    , domaine = "activité ski de fond"
    , siege   = "Beaune-le-Froid 63790 MUROL"
    , resp = [{ poste = "Président"
              , nom   = "Yannick LATREILLE"
              , tel   = "04 73 88 81 18"
              }]
    , mails    = ["yannick-latreille@hotmail.fr"]
    , cat = Sport 
    }
  , { emptyAssoc |
      nom     = "Association de la Foire du Saint Nectaire de Beaune-le-Froid"
    , domaine = "organisation de manifestations agricoles, promotion du 
                 Saint Nectaire fermier et des produits régionaux, activités d’animation dans la commune"
    , siege   = "Mairie de Murol"
    , resp = [{ poste = "Présidente"
              , nom   = "Pierrette TOURREIX"
              , tel   = "04 73 35 97 71"
              }]
    , mails    = ["pierrette.tourreix@orange.fr"] 
    }
  , { emptyAssoc |
      nom     = "Association de parents d'élèves des écoles de Murol et de Chambon sur Lac"
    , domaine = "contribuer et favoriser les activités scolaires et extra- scolaires"
    , siege   = "Mairie de Murol"
    , resp = [{ poste = "Présidente"
              , nom   = "Dominique BIGAND"
              , tel   = "06 89 59 22 94"
              }]
    , mails    = ["ape.murolchambon@laposte.net"] 
    }
    , { emptyAssoc |
      nom     = "Association des Amis du Musée de Murol (AAMM)"
    , domaine = "soutenir, faire connaître et promouvoir le musée des peintres de l’Ecole de Murol"
    , siege   = "rue de Chabrol, 63790 MUROL"
    , resp = [{ poste = "Président"
              , nom   = "Dr Bernard LAPALUS"
              , tel   = "04 73 37 10 88"
              }]
    , mails    = [] 
    }
    , { emptyAssoc |
      nom     = "Association des jeunes de Murol"
    , siege   = "La chassagne Murol"
    , resp = [{ poste = "Président"
              , nom   = "Victor LAGEIX"
              , tel   = ""
              }
              ]
    , mails    = ["victor.lageix@laposte.net"] 
    }
    , { emptyAssoc |
      nom     = "Association Intercommunale des Anciens Combattants"
    , preci   = "Section de Chambon sur Lac, Murol, Saint Nectaire"
    , domaine = "transmettre le devoir de mémoire aux jeunes générations, assurer la solidarité"
    , siege   = "rue Charreton, 63790 MUROL"
    , resp = [{ poste = "Vice Président pour Murol"
              , nom   = "Georges GAUFFIER"
              , tel   = "04 73 83 62 02"
              }]
    }
    , { emptyAssoc |
      nom     = "Association Médiévale de Murol - Auvergne (AMMA)"
    , domaine = "promouvoir et sauvegarder le patrimoine médiéval de la commune de Murol"
    , siege   = "La rivière route de Saint-Nectaire 63790 Murol"
    , resp = [{ poste = "Président"
              , nom   = "Vincent Salesse"
              , tel   = "06 09 04 67 92"
              }
              ]
    , mails    = ["amma.murol@laposte.net"] 
    }
    , { emptyAssoc |
      nom     = "Association Sancy Celtique"
    , domaine = "organisation de festival"
    , siege   = "La rivière route de Saint-Nectaire 63790 Murol"
    , resp = [{ poste = "Président"
              , nom   = "Jérôme GODARD"
              , tel   = "04 73 26 02 00"
              }
             ]
    , mails    = ["amma.murol@laposte.net"] 
    }
    , { emptyAssoc |
      nom     = "Association Sportive des écoles de Murol et de Chambon sur Lac (A.S.E.M.C.)"
    , domaine = "contribuer à l’éducation des enfants par la pratique d’activités physiques et sportives"
    , siege   = "école primaire de Chambon sur Lac"
    , affil   = "USEP Sancy, les Hermines"
    , resp = [{ poste = "Président"
              , nom   = "Claude Bourret"
              , tel   = "04 73 88 68 16"
              }]
    , mails    = ["ecole.chambon-sur-lac.63@ac-clermont.fr"]
    , cat = Sport 
    }
    , { emptyAssoc |
      nom     = "Bureau Montagne Auvergne Sancy Volcans"
    , domaine = "activités sportives de pleine nature grand public"
    , siege   = "mairie de Murol Adresse : BP11 63790 MUROL"
    , resp = [{ poste = "Président"
              , nom   = "Alexandre PRUNYI"
              , tel   = ""
              }
             ]
    , mails    = ["bertrandgoimard@hotmail.com","contact@guides-asv.com"]
    , cat = Sport 
    }
    , { emptyAssoc |
      nom     = "Bureau Montagne Auvergne Sancy Volcans"
    , domaine = "activités sportives de pleine nature grand public"
    , siege   = "mairie de Murol Adresse : BP11 63790 MUROL"
    , resp = [{ poste = "Président"
              , nom   = "Alexandre PRUNYI"
              , tel   = ""
              }
             ]
    , mails    = ["bertrandgoimard@hotmail.com","contact@guides-asv.com"]
    , cat = Pro 
    }
    --, { emptyAssoc |
    --  nom     = "Chambre syndicale des commerçants des marchés du Puy de Dôme (CSCM du 63)"
    --, domaine = "organisation de la Foire du Terroir de Murol"
    --, siege   = "BP 30016 63401 CHAMALIERES"
    --, affil   = ""
    --, resp = [{ poste = "Vice-Président"
    --          , nom   = "Rémy VALLAT"
    --          , tel   = "04 7173 6263"
    --          }]
    --, mails    = ["remy.vallat@wanadoo.fr"] 
    --}
    , { emptyAssoc |
      nom     = "Collectif développement des commerçants Murolais 63"
    , domaine = "développement de l'activité commerciale"
    , siege   = "rue Georges Sand - 63790 MUROL"
    , resp = [{ poste = "Président"
              , nom   = "Jean-Jacques ROUCHVARGER"
              , tel   = "06 32 97 02 19"
              }]
    , mails    = ["njrorganisation@orange.fr"]
    , cat = Pro 
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
    , cat = Sport
    }
    , { emptyAssoc |
      nom     = "Don de Sang bénévole du Canton de Besse"
    , domaine = "organiser les collectes de sang sur le canton"
    , siege   = "3, cour des miracles 63610 BESSE"
    , resp = [{ poste = "Président"
              , nom   = "Pierre SOULIER "
              , tel   = "04 73 79 50 70"
              }]
    , cat = Pro
    }
    , { emptyAssoc |
      nom     = "L'Ensemble Instrumental de la Vallée Verte (EIVV)"
    , siege   = "Lac Chambon - 63790 Chambon sur lac"
    , domaine = "participer aux manifestations officielles, créer un tissu social 
                 entre les musiciens de la région du sancy 
                 et être fédérateur de toutes les personnes qui 
                 aiment la musique d’harmonie. "
    , resp = [{ poste = "Président"
              , nom   = "Jean-louis REBOUFFAT"
              , tel   = "04 73 88 63 08"
              }]
    , mails    = ["jeanlouis.rebouffat@sfr.fr"] 
    }
    ,
    { emptyAssoc |
      nom     = "Elément Terre"
    , domaine = "éducation à l’environnement des scolaires, organisation de classes de découvertes"
    , siege   = "Mairie de Murol BP 11- 63 790 MUROL "
    , resp = [{ poste = "Présidente"
              , nom   = "Claire FAYE"
              , tel   = ""
              }]
    , mails    = ["contact@element-terre.org"]
    , sites    = ["http://www.element-terre.org"]
    }
    ,
    { emptyAssoc |
      nom     = "Elément Terre"
    , domaine = "éducation à l’environnement des scolaires, organisation de classes de découvertes"
    , siege   = "Mairie de Murol BP 11- 63 790 MUROL "
    , resp = [{ poste = "Présidente"
              , nom   = "Claire FAYE"
              , tel   = ""
              }]
    , mails    = ["contact@element-terre.org"]
    , sites    = ["http://www.element-terre.org"]
    , cat = Pro
    }
    ,
    { emptyAssoc |
      nom     = "Groupement de défense contre les ennemis des cultures"
    , domaine = "lutte contre les nuisibles"  
    , siege   = "Chautignat - 63790 MUROL"
    , resp = [{ poste = "Président"
              , nom   = "Jean-Marie PEROL"
              , tel   = "04 73 88 68 90"
              }]
    , cat = Pro
    }
    ,
    { emptyAssoc |
      nom     = "Groupement pastorale de la Couialle"
    , siege   = "Mairie de Murol - 63 790 MUROL"
    , resp = [{ poste = "Président"
              , nom   = "Angélique Lair"
              , tel   = "04 73 88 81 10"
              }]
    , cat = Pro
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
    , mails    = ["jeepaoc@gmail.com, info@jeepaoc.com, jeepaoc.infoclub@orange.fr"]
    , sites    = ["http://www.jeepaoc.com"]
    }
    ,
    { emptyAssoc |
      nom     = "La Gaule Murolaise"
    , domaine = "société de Pêche"
    , siege   = "Les rives - lac Chambon 63790 Chambon sur lac"
    , affil   = "fédération de pêche du Puy de Dôme et du milieu aquatique (LEMPDES)"
    , resp = [{ poste = "Président"
              , nom   = "Emmanuel LABASSE"
              , tel   = "04 73 88 64 09"
              }]
    , cat = Sport
    }
    --,
    --{ emptyAssoc |
    --  nom     = "La Main Gauche"
    --, domaine = "club sportif de pétanque"
    --, siege   = "bar Intimyté, route de Besse, 63790 MUROL "
    --, resp = [{ poste = "Président"
    --          , nom   = "Christophe GUITTARD"
    --          , tel   = "06 2851 2802"
    --          }]
    --, cat = Sport
    --}
    ,
    { emptyAssoc |
      nom     = "Le XV de la Vallée Verte"
    , domaine = "rugby"
    , siege   = "Restaurant « Les Baladins », 63790 St Nectaire"
    , resp = [{ poste = "Président"
              , nom   = "Stéphane Crégut"
              , tel   = "06 12 56 30 47"
              }]
    , mails    = ["lexvdelavalleeverte@hotmail.fr","julien.boucheix@orange.fr","contact@stephane-cregut.fr"]
    , cat = Sport
    }
    ,
    { emptyAssoc |
      nom     = "Les Amis du Vieux Murol"
    , domaine = "association des personnes du troisième âge"
    , affil   = "fédération « les Aînés Ruraux » Clermont-Ferrand"
    , siege   = "mairie de Murol, 63790 MUROL"
    , resp = [{ poste = "Président"
              , nom   = "Pierrette TOURREIX"
              , tel   = "04 73 35 97 71"
              }]
    , mails    = ["pierrette.tourreix@orange.fr"]
    }
    ,
    --{ emptyAssoc |
    --  nom     = "Les Chevaucheurs"
    --, domaine = "organisation de manifestations culturelles (reconstitution historique, combats, spectacle équestre…)"
    --, siege   = "18 rue Guyot Dessaigne 63114 AUTHEZAT"
    --, resp = [{ poste = "Président"
    --          , nom   = "Pascal BONY"
    --          , tel   = "07 7792 1530"
    --          }]
    --, mails    = ["hagranyms@hotmail.fr"]
    --}
    --,
    { emptyAssoc |
      nom     = "Murol Remparts du Sancy"
    , domaine = "organisation de festivals et de manifestations culturelles (fête du 14 juillet)"
    , siege   = "mairie, 63790 MUROL"
    , resp = [{ poste = "Présidente"
              , nom   = "Bénédicte MANFRI "
              , tel   = "06 72 16 78 46"
              }
             ]
    , mails    = ["assmurolrempart@gmail.com"]
    }
    ,
    { emptyAssoc |
      nom     = "Natur’ Sancy"
    , domaine = "Activité de pleine nature, tout public
                 Protection du patrimoine naturel en milieu montagnard,
                 activités liées à la découverte du patrimoine."
    , siege   = "route de Besse, 63790 MUROL"
    , resp = [{ poste = "Présidente"
              , nom   = "Véronique DEBOUT"
              , tel   = "04 73 88 67 56"
              }]
    , mails    = ["natur.sancy@gmail.com"]
    , sites    = ["http://natursancy.blogspot.fr/"]
    }
    ,
    { emptyAssoc |
      nom     = "Rencontre et détente"
    , domaine = "activités gymniques"
    , siege   = "rue du Tartaret 63790 MUROL"
    , resp = [{ poste = "Présidente"
              , nom   = "Sylvie Legoueix"
              , tel   = "04 73 88 66 21"
              }]
    , cat = Sport
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
    , cat = Sport
    }
    ,
    { emptyAssoc |
      nom     = "Syndicat agricole"
    , domaine = "syndicat professionnel"
    , siege   = "mairie de Murol 63790 MUROL"
    , resp = [{ poste = "Présidente"
              , nom   = "Angélique LAIR"
              , tel   = "04 73 88 81 10"
              }]
    , mails = ["angelique.lair84@orange.fr"]
    , cat = Pro
    }
    ,
    { emptyAssoc |
      nom     = "Syndicat hôtelier"
    , domaine = "syndicat professionnel"
    , siege   = "rue de la Vieille Tour 63790 MUROL"
    , resp = [{ poste = "Présidente"
              , nom   = "Amélie DABERT"
              , tel   = "04 73 88 61 06 "
              }]
    , mails = ["amelie.dabert@wanadoo.FR"]
    , cat = Pro
    }
    ,
    { emptyAssoc |
      nom     = "Système d'Echange Local \"S.SancyEL\""
    , domaine = "association à caractère social permettant à ses membres de procéder
                 à des échanges de biens, de services et de savoirs, sans avoir recours à la monnaie. "
    , siege   = "3 impasse de la Vernoze - Champeix"
    , resp = [{ poste = "Coprésidente"
              , nom   = "Annie JONCOUX"
              , tel   = "04 43 12 61 98 ou 06 9850 4297"
              }
              ,
              { poste = "Coprésidente"
              , nom   = "Livia VAN EIJLE"
              , tel   = "04 7388 6489"
              }]
    , mails    = ["annie.joncoux@sfr.fr"
                 ," Livia.vaneijle@wanadoo.fr"
                 ,"j-p.lanaro@orange.fr"]
    }
    --,
    --{ emptyAssoc |
    --  nom     = "Les Scieurs d’Antan des Monts des Dômes"
    --, domaine = "organisation de manifestations culturelles,
    --             faire revivre les vieux métiers de la terre"
    --, siege   = "6, allée de Rivassol 63 830 NOHANENT"
    --, resp = [{ poste = "Président"
    --          , nom   = "Maurice BARD"
    --          , tel   = "04 7362 8487"
    --          }]
    --}
    --,
    --{ emptyAssoc |
    --  nom     = "Académie de la Gentiane"
    --, mails    = ["academiegentiane@orange.fr"]
    --}
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
    , cat = Pro
    }
    ,
    { emptyAssoc |
      nom     = "Auvergne Escapade"
    , domaine = "Accompagnateurs en montagne"
    , siege   = "Beaune-le-Froid 63790 Murol"
    , resp = [{ poste = "Président"
              , nom   = "Jean Luc Ranvier"
              , tel   = "04 73 88 85 78 - 06 86 89 34 87"
              }]
    , mails = ["info@auvergne-escapade.com"]
    , sites = ["http://www.auvergne-escapade.com"]
    , cat = Sport
    }
    ,
    { emptyAssoc |
      nom     = "Auvergne Escapade"
    , domaine = "Accompagnateurs en montagne"
    , siege   = "Beaune-le-Froid 63790 Murol"
    , resp = [{ poste = "Président"
              , nom   = "Jean Luc Ranvier"
              , tel   = "04 73 88 85 78 - 06 86 89 34 87"
              }]
    , mails = ["info@auvergne-escapade.com"]
    , sites = ["http://www.auvergne-escapade.com"]
    , cat = Pro
    }  
  ]