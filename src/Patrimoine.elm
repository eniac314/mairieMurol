module Patrimoine where

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

initialModel =
  { mainMenu    = mainMenu
  , mainContent = initialContent
  }

-- View
view address model =
  div [ id "container"]
      [ renderMainMenu ["Culture et loisirs","Patrimoine"]
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
      [ p [] [text "La commune de Murol possède un patrimoine naturel 
                   et culturel exceptionnel comme en témoigne le nombre 
                   de sites et monuments inscrits et classés auxquels 
                   se rajoutent les zones protégées: "]
      , ul []
           [ li [] [text "Château de Murol, classé monument historique depuis 1889 "]
           , li [] [text "Château de Murol et ses abords inscrits à 
                          l’inventaire des sites en 1944 "]
           , li [] [text "Table mégalithique, classée monument historique depuis 1948 "]
           , li [] [text "Mur avec panneau armorié de la maison de 
                         l’Abbé d’Estaing, inscrit aux monuments historiques en 1975"]
           , li [] [text "Eglise de Murol, inscrite en totalité en 2006 "]
           , li [] [text "Massif du Tartaret, inscrit à l’inventaire des sites 
                         en 1970 "]
           , li [] [text "Lac Chambon et ses rives, site inscrit en 
                          1939"]
           , li [] [text "Bois des Bouves, inscrit à l’inventaire des sites 
                          en 1941"]
           , li [] [text "Protection des bois et forêt : forêts sectionnales 
                          de Beaune-le-Froid, Murol, La Chassagne et les Ballats. "]
           ]
      , p  [] [text "Outre ces sites classés, la commune est riche 
                     d’édifices du petit patrimoine : lavoirs, moulins, fours 
                     à pain…"]

      , h4 [] [text "Château de Murol"]
      , p  [] [text "Le château de Murol est classé au monument historique depuis 1889."]
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
      , link "Site officiel" "http://www.chateaudemurol.fr"

      , h4 [] [text "Musée archéologique "]

      , p  [] [text "Situé dans le parc du Prélong, ce petit 
                     édifice est couvert d'un toit de chaume. Ses 
                     collections de poteries sigillées, pièces de monnaie, céramiques 
                     proviennent des fouilles de Jassat réalisées par l'abbé 
                     Boudal vers 1895 et de Rageat réalisées par 
                     Mr Verdier vers 1950. "]

      
     
      , h4 [] [text "La vieille tour"]

      , p [] [text "Cette maison, située rue de la vieille tour, 
                   date du XVème siècle et est l'édifice le 
                   plus ancien du village. Elle aurait été occupée 
                   par un officier de rang élevé de la 
                   seigneurie de Murol."]
      
      , h4 [] [text "Musée des Peintres de l´Ecole de Murol(s)"]
      , p  [] [text "Le musée des Peintres de l’Ecole de Murols 
                     est classé musée de France. Il recèle un 
                     patrimoine pictural original. Les tableaux ont été réalisés 
                     au début du XXe siècle par de nombreux 
                     peintres dont l´Abbé Boudal et des maîtres comme 
                     Victor Charreton et Wladimir de Terlikowski. Les paysages 
                     de neige ont été la source d’inspiration privilégiée 
                     de ces artistes. "]
      , p  [] [text "Après avoir visionné une vidéo de présentation retraçant 
                     l´histoire de l´Ecole de Murols, découvrez une collection 
                     de peintures exceptionnelle au fil des différentes salles. 
                     L’exposition temporaire 2016, visible du 1er au 31 
                     octobre, sera consacrée à Alfred Thésonnier. "]
      , p  [style [("font-style","oblique")]]
           [text "* Le nom de Murol se vit ajouter 
                 un « s » au XIXe siècle. "]
      , link "Site officiel" "http://www.musee-murol.fr/"


      , h4 [] [text "L'Eglise de Murol"]
      , p  [] [text "De style gothique, elle a été construite en 
                     1888, inscrite dans l’inventaire supplémentaire des monuments historiques 
                     en 2006 "]
      , p  [] [text "Le porche est surmonté d´une pierre sculptée représentant 
                     armes et devise des d´Estaing. L´intérieur de l´église 
                     a été peint par l´Abbé Boudal, curé de 
                     Murol, au cours du XIXe siècle. Il a 
                     réalisé des décors sous forme de motifs ornementaux, 
                     des représentations de saints et apôtres, et surtout 
                     neuf grandes compositions murales, de 12m² chacune, retraçant 
                     des épisodes du nouveau testament."]

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
                   l'âpreté de ses paysages et la luminosité de 
                   ses couleurs. Avec le peintre Léon Boudal, curé 
                   de Murol, il fonde l'École de Murol qui 
                   attire de nombreux artistes de tous horizons, séduits 
                   par ce néo-impressionnisme qui exprime si bien la 
                   simplicité crue et la lumière des paysages auvergnats. "] 
      , p [] [text "Le monument Charreton se trouve au bout de 
                   la rue du même nom au pied du 
                   Tartaret. Les œuvres des peintres de l’Ecole de 
                   Murols sont exposées au musée municipal. 
                    "]

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

      
      , h4 [] [text "Le volcan du Tartaret "]
      , p  [] [text "Le volcan du Tartaret est un petit volcan 
                     de 870 m d’altitude qui fait partie des 
                     plus récentes formations volcaniques d’Auvergne. Le massif du 
                     Tartaret a été inscrit à l’inventaire des sites 
                     en 1970. "]
      , p  [] [text "Le sommet du volcan offre une vue panoramique 
                     sur le Lac Chambon avec le Sancy en 
                     arrière-plan. Il permet de comprendre facilement l'histoire volcanique 
                     du site. Le lac de Chambon n’aurait sans 
                     doute jamais existé sans l’éruption tardive du Tartaret. 
                     Par un phénomène de barrage naturel, l’éruption du 
                     Tartaret coupa la route à la Couze de 
                     Chaudefour, ruisseau de montagne et permit ainsi la 
                     formation du lac de Chambon. Quelques millénaires plus 
                     tard, le lac est toujours là. "]
      , p  [] [text "Pendant une de ses périodes effusives, le Tartaret 
                     a produit une des plus longues coulées de 
                     lave du massif, qui s'est étirée jusqu'à une 
                     vingtaine de kilomètres de Murol. 
                     "]
      , p  [] [text "Les pentes du volcan sont habillées de hêtres 
                     et de pins. "]
      , p  [] [text "Un sentier de randonnée fait une boucle depuis 
                     Murol. Le sentier chemine quelques instants sur la 
                     crête, avant de descendre vers le cratère, il 
                     revient ensuite vers Murol dont les maisons sont 
                     taillés dans la « cheire » du volcan. "]
      , p  [] [text "Durant l’été 2012, de jeunes bénévoles de l’association 
                     des chantiers de jeunesse nous ont aidés à 
                     rénover le parcours sportif situé au sein du 
                     Tartaret, et à aménager le site du point 
                     de vue à son sommet. "]
      , p  [] [text "La cime du Tartaret a été choisie à 
                     plusieurs reprises pour installer des œuvres d’art contemporain 
                     dans le cadre de l’événement annuel « Horizons 
                     Art et Nature en Sancy ». "]
      

      

      , h4 [] [text "Le moulin à Beaune le froid "]

      , p [] [text "Découvrir le moulin à eau de Beaune, en 
                   compagnie de Michel Tardif, est un vrai plaisir. 
                   Il vous raconte tout à la fois l'histoire 
                   du village et du moulin. "] 
      , p [] [text "Le moulin de Beaune-le-Froid, vieux de 3 siècles, 
                   a été exploité jusqu'en 1949. Moulin banal, ce 
                   sont les villageois qui l'utilisaient pour produire leur 
                   farine. "]

      , p [] [text "Il a été restauré il y a quelques 
                    années. "]

      , h4 [] [text "Visite de ferme "]

      , p [] [text "Beaune le froid et Chautignat sont des villages 
                   fortement liés à la tradition agropastorale. Le Saint 
                   Nectaire, fromage d´Appellation d´Origine Protégée (AOP), est fabriqué 
                   au cœur du Sancy et jusque dans le 
                   Cantal. Il témoigne d’un savoir-faire ancestral. A Murol, 
                   le Saint Nectaire fermier est de fabrication artisanale, 
                   ce qui lui garantit une saveur exceptionnelle et 
                   changeante au gré des saisons. Les fermes vous 
                   ouvrent leurs portes pour assister à la fabrication 
                   de ce fabuleux fromage. "]

      , p [] [text "Beaune le froid est fortement lié à la 
                   tradition agropastorale. Ce n´est donc pas un hasard 
                   si nombre de fermes spécialisées dans la fabrication 
                   artisanale de ce fromage jalonnent le village. Partez 
                   à la découverte de ce fromage mais respectez 
                   les horaires indiqués. Avant, le lait ne sera 
                   pas trait et après, le fromage sera déjà 
                   fait."] 
      , h4 [] [text "Les Caves à Beaune-le-Froid"]
      , p [] [text "Ces grottes ont été aménagées dans la roche 
                   pour l´affinage du Saint-Nectaire. Vous pourrez les découvrir 
                   après la visite du moulin. "]

      , a [href "/PatrimoinePhoto.html"] [text "Lien photothèque"]
      ]