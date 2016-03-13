module CMJ where

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
      [ renderMainMenu address ["Mairie","CMJ"] (.mainMenu model)
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
  div [ class "subContainerData noSubmenu", id "cmj"]
      [ h2 [] [text "Conseil municipal des jeunes (CMJ)"]
      , p  [] [text "Le CMJ est élu pour un mandat de 
                     2 ans."]
      , p  [] [text "Rôles et objectifs du conseil municipal des jeunes 
                     Le conseil municipal des jeunes a pour mission 
                     d'initier les jeunes à la vie politique réelle 
                     et de collecter les idées et initiatives pour 
                     améliorer la vie dans le cadre de la 
                     municipalité. Ils débattent dans tous les domaines, (embellissement, 
                     animation, tourisme, associations, jeunesse et sport, agriculture, environnement, 
                     forêt, musée, culture, patrimoine, social, etc…) "]
      , h4 [] [text "Election du CMJ"]
      , p  [] [text "Tous les jeunes de 9 ans et jusqu'à 
                     20 ans votent pour élire les jeunes conseillers. 
                     Pour que toutes les classes d'âge soient représentées 
                     le conseil est subdivisé en 2 collèges électoraux. 
                     Les jeunes sont élus pour deux ans et 
                     siègent sous la présidence du Maire. "]
      , table []
              [tr [] [th [] [text "Pour être ELECTEUR"], th [] [text "Pour être CANDIDAT"]]
              ,tr [] [td [] [text "habiter la commune de Murol"], td [] [text "habiter la commune de Murol"]]
              ,tr [] [td [] [text "avoir entre 9 et 20 ans au moment de l'élection"], td [] [text "avoir entre 9 et 20 ans au moment de l'élection"]]
              ,tr [] [td [] [text ""], td [] [text "faire acte de candidature"]]
              ,tr [] [td [] [text ""], td [] [text "avoir l'autorisation parentale (pour les mineurs) "]]
              ,tr [] [td [] [text ""], td [] [text "avoir envie de s'investir dans la vie de la commune"]]
              ]
      , p  [] [text "Les jeunes feront acte de candidatures à la 
                     mairie, munis de la déclaration de candidature, de 
                     l'autorisation parentale, pour les mineurs) et de la 
                     charte du candidat (documents téléchargeable sur la page 
                     documents) "]
      , h4 [] [text "Collège électoral et sièges à pourvoir"]
      , p  [] [text "Les électeurs seront répartis en 2 collèges électoraux 
                     comportant chacun 7 sièges : - 1er collège, 
                     pour les jeunes de 9 à 12 ans 
                     inclus. - 2ème collège, pour les jeunes de 
                     13 à 20 ans. Le CMJ se composera 
                     du maire et des 14 jeunes élus. "]
      , h5 [] [text "Vote sur la liste et le décompte des voix"]
      , p  [] [text "Il s'agit d'un mode de scrutin à un 
                     seul tour. Chaque électeur vote en utilisant la 
                     liste de son collège électoral et se voit 
                     reconnaître la possibilité d'y barrer un ou plusieurs 
                     noms de candidats. Sur une liste comportant des 
                     modifications, seuls les 7 premiers noms seront comptabilisés. 
                     Les bulletins blancs sont autorisés. Ils seront comptabilisés 
                     comme des suffrages exprimés. Les bulletins nuls ne 
                     seront pas comptés comme suffrages exprimés."]
      , p  [] [text "Tous les jeunes murolais, de 9 à 20 
                     ans, peuvent se présenter. Les candidats pourront, s'ils 
                     le souhaitent, faire leur campagne électorale en faisant 
                     des affiches ou des tracts pour présenter leurs 
                     propositions. Les services municipaux prépareront tout le matériel 
                     nécessaire pour le vote : o les bulletins 
                     de vote : sur chaque bulletin seront inscrits 
                     les noms des candidats par collèges. o Les 
                     enveloppes : pour y glisser le bulletin o 
                     Les urnes : où chacun déposera son enveloppe 
                     o Les isoloirs : ce sont des petites 
                     cabines où les votants devront s'isoler pour choisir 
                     tranquillement le candidat pour qui ils voteront. "]

      , h4 [] [text "Comment Voter?"]
      , p  [] [text "Le vote se déroule à bulletin secret (sous 
                     enveloppe) selon les conditions générales des votes en 
                     France. Il faut exprimer son choix en déposant 
                     le bulletin des candidats que vous aurez choisi 
                     dans une enveloppe."]
      , p  [] [text "Vote (comptabilisé):"]
      , ul []
           [li [] [p [] [text "Vous placez un bulletin de vote dans l'enveloppe, sans rature."]]
           ,li [] [p [] [text "Vous placez un bulletin modifié dans l'enveloppe seuls les 7 premiers noms sont comptés."]]
           ,li [] [p [] [text "Si vous mettez un bulletin blanc, votre vote sera comptabilisé comme un suffrage exprimé. "]]
           ,li [] [p [] [text "Si vous mettez plusieurs bulletins identiques, un seul comptera. Dans tous les cas vous aurez voté et donc marqué votre intérêt à la vie publique."]]
           ]
      , p  [] [text "En cas d'absence vous pourrez voter par procuration."]

      , h4 [] [text "Après le vote"]
      , p  [] [text "Le scrutin est déclaré clos à l'issue de 
                     la journée d'élection, dont la date est fixée 
                     le 11 octobre 2014. Le dépouillement des enveloppes 
                     se déroule dès la clôture du scrutin. Celui 
                     ou celle qui a obtenu le plus de 
                     voix dans son collège électoral est élu, conseillé 
                     municipal des jeunes de la commune. S'il y 
                     a égalité de voix, c'est le ou la 
                     plus âgé(e) qui l'emporte. "]

      , h4 [] [text "Le travail des conseillers"]
      , p  [] [text "Les nouveaux élus commencent par découvrir les services 
                     municipaux. Ils apprennent leurs fonctionnements et les diverses 
                     possibilités d'intervention. Les conseillers se réunissent plusieurs fois 
                     par an en conseil municipal avec le maire. 
                     Ils organisent également des réunions de travail pour 
                     élaborer leurs projets. "]
      , p  [] [text "Deux réunions d'informations seront organisées par la commission 
                     \"Jeunesse & sport\" pour présenter à 
                     l'ensemble des jeunes de la commune le CMJ. "]

      , h4 [] [text "Calendrier"]
      , p  [] [text "Première réunion, fixée au 2 juillet 2014 à 
                     18h00 à la salle des fêtes. "]
      , p  [] [text "Du 13 au 19 septembre 2014, dépôts de 
                     candidatures au CMJ "]
      , p  [] [text "Du 1 au 10 octobre, campagne des candidats "]
      , p  [] [text "Samedi 11 octobre 2014 de 10h à 12h00 
                    : élections du CMJ"]
      , p  [] [text "Renseignements sur murol.fr/mairie/CMJ ou à la mairie."]
      
      , h4 [] [text "Documents"]
      , link "Demande de subvention" "/baseDocumentaire/Associations/Demande%20de%20subvention.pdf"
      , br [] []
      , link "Fiche SACEM" "/baseDocumentaire/Associations/fiche%20SACEM%20-%20mairie.pdf"
      , br [] []
      , link "SACEM" "/baseDocumentaire/Associations/SACEM.pdf"
      , br [] []
      ]
 
