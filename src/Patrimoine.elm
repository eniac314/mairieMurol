module Patrimoine where

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

initialModel =
  { mainMenu    = mainMenu
  , mainContent = initialContent
  }

-- View
view address model =
  div [ id "container"]
      [ renderMainMenu address ["Culture et loisirs","Patrimoine"]
                               (.mainMenu model)
      , div [ id "subContainer"]
            [ .mainContent model
            ]
      , pageFooter
      ]

-- Update

contentMap =
 fromList []

update action model =
  case action of
    NoOp    -> model
    _       -> model



--Main

main =
  StartApp.start
    { model  = initialModel
    , view   = view
    , update = update
    }

initialContent =
  div [ class "subContainerData noSubmenu", id "patrimoine"]
      [ h4 [] [text "Château de Murol"]
      , p  [] [text "Edifié à l'emplacement probable d'un ancien camp romain, 
                     sa construction s'étale du XIIème au XVIIIe siècle. 
                     Le Château de Murol appartint successivement aux seigneurs 
                     d´Apchon, aux comtes de Murol et enfin aux 
                     d´Estaing. Ces derniers feront de nombreux travaux pour 
                     moderniser les conditions de vie et adapter le 
                     système de défense aux exigences de l´artillerie. Grâce 
                     à la ferveur dont jouissaient les d´Estaing à 
                     la Cour, la forteresse fut épargnée par Richelieu. 
                     Elle le fut aussi à la Révolution. Mais 
                     ensuite abandonnée par son propriétaire, elle servit de 
                     carrière de pierres. Son classement comme Monument Historique 
                     mit un terme aux déprédations. Il est aujourd´hui 
                     propriété de la commune. Son architecture médiévale reste 
                     en partie conservée. C'est le château le plus 
                     visité de notre région et donne à Murol 
                     une notoriété dépassant largement les limites de l'Auvergne. "]
      , p [] [text "Des animations en costumes du Moyen-Âge sont proposées 
                   par les \"Paladins du Sancy\" de l'agence Organicom. 
                   Aux travers d´histoires et de démonstrations (combat à 
                   l'épée), des paysans, hommes d´armes, gentes dames et 
                   chevaliers font découvrir la vie d´une châtellenie au 
                   XIIIe siècle. "]
      , link "Site officiel" "www.chateaudemurol.fr"

      , h4 [] [text "Musée des Peintres de l´Ecole de Murol(s)"]

      , p  [] [text "Présentation d´une vidéo retraçant l´histoire de l´école et 
                    visite des collections de peintures. "]
      , p  [] [text "Tableaux réalisés durant les deux premiers tiers du 
                     XXe siècle autour de l´Abbé Boudal et des 
                     maîtres Victor Charreton et Wladimir de Terlikowski."]
      , link "Site officiel" "http://www.musee-murol.fr/"

      , h4 [] [text "Musée archéologique "]

      , p  [] [text "Situé dans le parc du Prélong, ce petit 
                     édifice est couvert d'un toit de chaume. Ses 
                     collections de poteries sigillées, pièces de monnaie, céramiques 
                     proviennent des fouilles de Jassat réalisées par l'abbé 
                     Boudal vers 1895 et de Rageat réalisées par 
                     Mr Verdier vers 1950. "]
      
      , h4 [] [text "L'Eglise "]
      , p  [] [text "De style gothique, construite en 1888. Le porche 
                     est surmonté d´une pierre sculptée représentant armes et 
                     devise des d´Estaing. L´intérieur de l´église a été 
                     peint par l´Abbé Boudal, curé de Murol, au 
                     cours du XIXe siècle. Ces décors se présentent 
                     sous forme de motifs ornementaux, représentations de Saints 
                     et apôtres, et surtout neuf grandes compositions murales, 
                     de 12m² chacune, retraçant des épisodes du nouveau 
                     testament. "]

      , h4 [] [text "Le Parc du Prélong "]
      , p  [] [text "Cette ancienne propriété familiale d´Achille Boyer, notable et 
                     maire de Murol, fut remodelée en parc d´agrément 
                     vers 1860. Un jardin à la française vient 
                     contraster avec l´apparente liberté du parc à l´anglaise. 
                     Il comporte des arbustes ornementaux (magnolias, rhododendrons, kalmias, 
                     azalées…) et deux types d´arbres : les essences 
                     locales et les essences encore nouvelles au milieu 
                     du XIXe siècle (séquoias, douglas, chênes rouges d´Amérique, 
                     cyprès de Lawson…). D'une grande richesse botanique, il 
                     abrite 714 arbres recensés dont 34% de feuillus 
                     pour 26 espèces et 66% de résineux pour 
                     31 espèces. A noter quelques essences rares telles 
                     sciadopidis verticalis et stewartia cimensis, ainsi qu'une allée 
                     de charmes, rares à cette altitude, où il 
                     fait bon flâner. Le plus gros arbre est 
                     un séquoia de 7,85m. de circonférence. "]
      , p [] [text "Cueillette interdite, accès libre et gratuit. "]

      , h4 [] [text "Monument Charreton "]
      , p  [] [text "Victor Charreton fait partie de cette génération d'artistes 
                     de l'école française qui s’est consacrée totalement au 
                     paysage après les impressionnistes. Il peint sur le 
                     motif retenant les lieux qui lui parlent en 
                     fonction des saisons, de la lumière et des 
                     couleurs. L'Auvergne, la Bretagne et la Provence lui 
                     sont ainsi tout particulièrement chères sans oublier le 
                     sud de l'Europe et le Maghreb où il 
                     eut l'occasion de séjourner. Il manifeste une véritable 
                     prédilection pour les paysages d'hiver auvergnats. Ses paysages 
                     printaniers et automnaux explosent quant à eux de 
                     couleurs. L'Église de Murol et le givre, De 
                     la terrasse de Saint-Amand-Tallende en automne, Les champs 
                     vus du jardin d'Eugénie, Neige sur le bassin, 
                     sont quelques titres de ses toiles significatifs de 
                     sa recherche picturale. "]

      , p [] [text "Victor Charreton a conseillé et influencé de nombreux 
                   peintres dont René Monteix. L'Auvergne le séduit par 
                   l'apreté de ses paysages et la luminosité de 
                   ses couleurs. Avec le peintre Léon Boudal, curé 
                   de Murol, il fonde l'École de Murol qui 
                   attire de nombreux artistes de tous horizons, séduits 
                   par ce néo-impressionnisme qui exprime si bien la 
                   simplicité crue et la lumière des paysages auvergnats. "] 
      , p [] [text "Rendez-vous au Musée de l’Ecole des peintres que 
                    vous pouvez visiter, il se trouve à côté 
                    du Parc municipal du Prélong à Murol ! 
                    "]

      , h4 [] [text "La vieille tour"]

      , p [] [text "Cette maison, située rue de la vieille tour, 
                   date du XVème siècle et est l'édifice le 
                   plus ancien du village. Elle aurait été occupée 
                   par un officier de rang élevé de la 
                   seigneurie de Murol."]

      , h4 [] [text "Le moulin à Beaune le froid "]

      , p [] [text "Découvrir le moulin à eau de beaune en 
                   compagnie de Michel Tardif est un vrai plaisir. 
                   Vous racontant tout à la fois l'histoire du 
                   village et du moulin. "] 
      , p [] [text "Le moulin de beaune a entre 2 et 
                   3 siècles et a été exploité jusqu'en 1949. 
                   La restauration a débuté il y a 5 
                   ans. "]

      , p [] [text "Moulin banal, ce sont les villageois qui l'exploitaient 
                    pour produire leur farine."]

      , h4 [] [text "Visite de ferme "]

      , p [] [text "Issus d´un terroir très riche, nos produits ont 
                   su garder le goût du passé. Le Saint 
                   Nectaire, fromage d´Appelation d´Origine Contrôlée (AOC), fabriqué au 
                   coeur du Sancy et jusque dans le Cantal 
                   n´échappe pas à la règle. Ainsi le saint 
                   nectaire fermier, dont la fabrication encore artisanale dans 
                   de nombreuses fermes garantit une saveur exceptionnelle et 
                   changeante au gré des saisons. Il témoigne du 
                   savoir-faire de chacun, transmis à travers les âges. "]

      , p [] [text "Beaune le froid est fortement lié à la 
                   tradition agropastorale. Ce n´est donc pas un hasard 
                   si nombre de fermes spécialisées dans la fabrication 
                   artisanale de ce fromage jalonnent le village. Partez 
                   à la découverte de ce fromage mais respectez 
                   les horaires indiqués. Avant, le lait ne sera 
                   pas trait et après, le fromage sera déjà 
                   fait."] 
      , h4 [] [text "Les Caves à Beaune-le-Froid"]
      , p [] [text "Grottes naturelles aménagées pour 
                   l´affinage du saint-nectaire. Vous pourrez les découvrir après 
                   la visite du moulin."]

      ]