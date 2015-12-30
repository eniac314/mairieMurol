module VosDemarches where

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
subMenu = 
  { current = "Carte d'identité"
  , entries =
      [ "Carte d'identité"
      , "Passeport"
      , "Permis de conduire"
      , "Véhicules"
      , "Etat civil"
      , "Liste électorale"
      , "Service civique" 
      ]
  } 

initialModel =
  { mainMenu    = mainMenu
  , subMenu     = subMenu
  , mainContent = initialContent
  }


-- View
view address model =
  div [ id "container"]
      [ renderMainMenu address ["Mairie", "Vos démarches"] (.mainMenu model)
      , div [ id "subContainer"]
            [ renderSubMenu address "Vos démarches:" (.subMenu model)
            , .mainContent model
            ]
      , pageFooter
      ]



contentMap =
 fromList [("Carte d'identité",carteId)
          ,("Passeport",passport)
          ,("Permis de conduire",permis)
          ,("Véhicules",vehic)
          ,("Etat civil",etatCiv)
          ,("Liste électorale",listElec)
          ,("Service civique",servCiv)
          ]

update action model =
  case action of
    NoOp    -> model
    Entry s -> changeMain model s
    _       -> model

changeMain model s =
    let newContent = get s contentMap
        sb = .subMenu model
    in case newContent of
        Nothing -> model
        Just c  -> { model |
                     mainContent = c
                   , subMenu = { sb | current = s }
                   }

--Main

main =
  StartApp.start
    { model  = initialModel
    , view   = view
    , update = update
    }

initialContent =
  carteId
      

-- Data
carteId = 
  div [ class "subContainerData", id "idDemarches"]
      [ h2 [] [text "Carte d'identité"]
      , h4 [] [text "Bénéficiaire"]
      , p  [] [text "Le demandeur doit être de nationalité française."]
      , h4 [] [text "Durée de validité"]
      , p  [class "important"]
           [ text "À compter du 1er janvier 2014, la durée de validité 
                   des cartes nationales d'identité délivrées aux personnes majeures 
                   passera de 10 à 15 ans."]
      , h4 [] [text "Coût"]
      , p  [] [text "Gratuit en cas de première demande ou renouvellement
                     avec présentation de l'ancienne CNI, 25€ (timbres fiscaux) en
                     cas de perte ou de vol."]
      , h4 [] [text "Dépôt de la demande"]
      , p  [] [text "La demande est rédigée sur un formulaire à demander en mairie. "]
      , p  [] [text "Le formulaire renseigné doit être déposée à de la mairie du lieu de domicile. "]
      , p  [] [text "Votre présence est exigée lors du dépôt de la demande."]
      , h4 [] [text "Pièces justificatives à fournir"]
      , h5 [] [text "Dans tous les cas:"]
      , ul []
           [ li [] [p [] [text "deux photographies d'identité identiques, récentes et parfaitement ressemblantes, 
                                de face, tête nue (format 35mm x 45 mm)"]] 
           , li [] [p [] [text "un justificatif d'état civil (extrait d'acte de naissance 
                                comportant l'indication de la filiation du demandeur),en cas 
                                de première demande."]] 
           , li [] [p [] [text "Si l'acte de naissance ne permet pas de 
                               prouver la nationalité : un justificatif de nationalité 
                               française : original + photocopie (voir ci dessous)"]
                   
                   ] 
           , li [] [p [] [text "un justificatif de domicile ou de résidence (voir ci dessous)"]

                   ] 
           , li [] [p [] [text "l'ancienne CNI en cas de renouvellement"]]
           , li [] [p [] [text "un autre document officiel avec photographie (passeport, permis 
                               de conduire...) si possible en cas de première 
                               demande."]]
           ]
      , h5 [] [text "En cas de perte ou de vol de CNI:"]
      , p  [] [text "Si le demandeur a perdu ou s'est fait voler sa CNI il doit, en plus des pièces à fournir pour toute demande de CNI:"]
      , ul []
           [ li []
                [ p [] [text "En cas de perte"]
                , ul []
                     [ li [] [ p [] [text "déclarer la perte en renseignant le formulaire de 
                                           déclaration de perte de CNI (au lieu de 
                                           dépôt du dossier de demande de CNI)"]] 
                     , li [] [ p [] [text "ou, s'il a déjà effectué cette déclaration auprès 
                                           des services de police nationale ou de gendarmerie, 
                                           d'un consulat de France à l'étranger ou des 
                                           services de police étrangers, il doit présenter le 
                                           récépissé de la déclaration,"]]
                     , li [] [ p [] [text "et fournir également si possible un document officiel 
                                           avec photographie (passeport, permis de conduire, carte permis 
                                           de chasser...)"]]
                                                           ]
                ]
           , li []
                [ p [] [text "En cas de vol"]
                , ul []
                     [ li [] [ p [] [text "fournir la déclaration de vol enregistrée auprès des 
                                           services de la police nationale ou de la 
                                           gendarmerie d'un consulat de France à l'étranger ou 
                                           des services de police étrangers, "]]
                     , li [] [ p [] [text "fournir également si possible un document officiel avec 
                                           photographie."]]
                     ]
                ]
           ]
      , div [class "justifFrame"]
           [ justifNat
           , justifDom 
           ]
      ]
justifNat = 
  div [class "justif"]
      [ h6 [] [text "Justificatif de la nationalité française"]
      , ul []
           [ li [] [ p [] [ text "si le demandeur est né en France et 
                                  l'un au moins de ses parents est né 
                                  en France, un extrait de son acte de 
                                  naissance qui comporte les dates et lieux de 
                                  naissance de son (ses) parent(s) peut suffire"]
                   ]
           , li [] [ p [] [ text "en cas contraire, le demandeur doit produire un 
                                  document attestant qu'il possède bien la nationalité française. 
                                  Par exemple:"]
                   , ul []
                        [li [] [ p [] [ text "la déclaration d'acquisition de la nationalité française"]]
                        ,li [] [ p [] [ text "le décret de naturalisation"]]
                        ,li [] [ p [] [ text "le décret de réintégration dans la nationalité française"]]
                        ,li [] [ p [] [ text "le certificat de nationalité"]]
                        ]                        
                    ]
           ]
      ]

justifDom =
  div [class "justif"]
      [ h6 [] [text "Justificatif de domicile ou de résidence"]  
      , ul []
           [ li [] [p [] [text "un justificatif de domicile à son nom:"]
                   , ul []
                        [li [] [p [] [text "avis d'imposition ou de non imposition"]]
                        ,li [] [p [] [text "quittance de loyer"]]
                        ,li [] [p [] [text "facture d'électricité ou de gaz"]]
                        ,li [] [p [] [text "facture de téléphone fixe ou portable"]]
                        ,li [] [p [] [text "titre de propriété"]]
                        ,li [] [p [] [text "attestation d'assurance du logement"]]
                        ]
                   ]
           , li [] [p [] [text "s'il est hébergé, un justificatif d'identité de l'hébergeant 
                               ainsi qu'une lettre de celui-ci certifiant que le 
                               demandeur habite chez lui depuis plus de trois 
                               mois, et un justificatif de domicile de l'hébergeant 
                               (voir liste ci dessus)"]]
           , li [] [p [] [text "dans les autres cas s'adresser à la mairie du domicile"]]
           ]
      ]

passport = 
  div [ class "subContainerData", id "passDemarches"]
      [ h2 [] [text "passeport"]
      , h4 [] [text "Bénéficiaire"]
      , p  [] [text "Le demandeur doit être de nationalité française."]
      , p  [] [text "A noter : Il n'est plus possible d'inscrire un enfant mineur sur le passeport de l'un de ses parents."]
      , h4 [] [text "Durée de validité"]
      , p  [] [text "10 ans"]
      , h4 [] [text "Coût"]
      , p  [] [text "88€ (timbre fiscal à acheter dans un bureau de tabac ou au centre des impôts)."]
      , h4 [] [text "Dépôt de la demande"]
      , p  [] [text "La demande est rédigée sur un formulaire à demander en mairie. "]
      , p  [] [text "Le formulaire renseigné doit être déposée à de la mairie du lieu de domicile. "]
      , p  [] [text "Votre présence est exigée lors du dépôt de la demande."]
      , h4 [] [text "Pièces justificatives à fournir"]
      , h5 [] [text "Dans tous les cas:"]
      , ul []
           [ li [] [p [] [text "deux photographies d'identité identiques, récentes et parfaitement ressemblantes, 
                                de face, tête nue (format 35mm x 45 mm)"]] 
           , li [] [p [] [text "l'ancien passeport en cas de renouvellement"]]
           , li [] [p [] [text "un justificatif d'état civil:"]
                   , ul []
                        [ li [] [p [] [text "une copie intégrale d'acte de naissance"]]
                        , li [] [p [] [text "ou, à défaut la copie intégrale de l'acte
                                             de mariage, sous réserve de la preuve de
                                             l'impossibilité de produire l'acte de naissance précité"]]
                        ]
                   ] 
           , li [] [p [] [text "un justificatif de nationalité 
                               française : original + photocopie (voir ci dessous)"]
                   
                   ] 
           , li [] [p [] [text "un justificatif de domicile ou de résidence (voir ci dessous)"]                   ] 
           , li [] [p [] [text "un autre document officiel avec photographie (passeport, permis 
                               de conduire...) si possible en cas de première 
                               demande."]]
           ]
      , h5 [] [text "En cas de perte ou de vol de passeport:"]
      , p  [] [text "Si le demandeur a perdu ou s'est fait voler son passeport, il doit, outre les pièces à fournir pour toute demande de passeport :"]
      , ul []
           [ li []
                [ p [] [text "En cas de perte"]
                , ul []
                     [ li [] [ p [] [text "la déclarer en renseignant le formulaire de déclaration 
                                           de perte de passeport (au lieu de dépôt 
                                           du dossier)"]] 
                     , li [] [ p [] [text "ou, s'il a déjà effectué cette déclaration auprès 
                                           des services de police nationale ou de gendarmerie, 
                                           d'un consulat de France à l'étranger ou des 
                                           services de police étrangers, il doit présenter le 
                                           récépissé de la déclaration,"]]
                     , li [] [ p [] [text "et fournir également si possible un document officiel 
                                           avec photographie (CNI, permis de conduire, carte permis 
                                           de chasser...)"]]
                     ]
                ]
           , li []
                [ p [] [text "En cas de vol"]
                , ul []
                     [ li [] [ p [] [text "fournir la déclaration de vol enregistrée auprès des 
                                           services de la police nationale ou de la 
                                           gendarmerie d'un consulat de France à l'étranger ou 
                                           des services de police étrangers, "]]
                     , li [] [ p [] [text "fournir également si possible un document officiel avec 
                                           photographie."]]
                     ]
                ]
           ]
      , div [class "justifFrame"]
           [ justifNat
           , justifDom 
           ]
      ]

permis = 
  div [ class "subContainerData", id "permisDemarches"]
      [ h2 [] [text "Délivrance du permis"]
      , p  [] [text "Il peut être demandé que le permis soit 
                     délivré dans n'importe quelle sous-préfecture du département dont 
                     dépend le domicile du candidat reçu (par exemple 
                     celle du lieu où il travaille)."]
      , p  [] [text "Dans tous les cas, la demande peut être 
                     faite sur place ou par correspondance."]
      , h5 [] [text "Formalités sur place:"]
      , p  [] [text "Il convient, en principe, de présenter : "]
      , ul []
           [ li [] [p  [] [text "une pièce prouvant son identité (carte nationale d'identité, 
                                 passeport...). "]]
           , li [] [p  [] [text "le certificat d'examen du permis de conduire (attestation 
                                 provisoire ou \"feuille jaune\"), délivré par l'inspecteur"]]
           , li [] [p  [] [text "le montant de la taxe régionale ((non demandée 
                                 dans certaines régions)."]]
           ]
      , p  [] [text "Attention : aucun texte réglementaire ne précise le 
                     nombre et le type de pièces à fournir 
                     pour la délivrance du permis définitif. Se renseigner 
                     au préalable."]
      , h5 [] [text "Demande par correspondance:"]
      , p  [] [text "Pour une demande par correspondance doit être joint, 
                     en principe :"]
      , ul []
           [ li [] [p  [] [text "le certificat d'examen du permis de conduire (attestation 
                                 provisoire ou \"feuille jaune\"), délivré par l'inspecteur"]]
           , li [] [p  [] [text "une enveloppe libellée aux noms et adresses du 
                                 demandeur, timbrée au tarif \"lettre recommandée\""]]
           , li [] [p  [] [text "un chèque ou mandat-lettre à l'ordre de Monsieur 
                                 le régisseur des recettes de la préfecture, au 
                                 montant de la taxe régionale (si elle est 
                                 demandée)"]]
           , li [] [link "Demande de délivrance" "http://www.murol.fr/Base_documentaire/imprime_demande_permis_conduire.pdf"
                   ,span  [] [text " du permis de conduire"]]
           , li [] [link "Demande de permis international" "http://www.murol.fr/Base_documentaire/imprime_demande_permis_international.pdf"]
           ]
      ]

vehic = 
  div [ class "subContainerData", id "vehicDemarches"]
      [ h2 [] [text "Véhicules"]
      , ul []
           [ li [] [ span [] [text "Certificat "]
                   , link "d'immatriculation" "http://www.murol.fr/Base_documentaire/ddeimatcerfa10672.pdf"
                   , span [] [text " + "]
                   , link "notice explicative" "http://www.murol.fr/Base_documentaire/notexpcg50322C.pdf"
                   ]
           , li [] [link "Certificat de cession de véhicule" "http://www.murol.fr/Base_documentaire/cessionvehic.pdf"]
           , li [] [link "Certificat de non gage" "http://www.interieur.gouv.fr/A-votre-service/Mes-demarches/Mes-teleservices"]
           ]
      ]

etatCiv = 
  div [ class "subContainerData", id "etatCivDemarches"]
      [ h2 [] [text "Etat-Civil"]
      , h4 [] [text "Demande d'acte de naissance"]
      , p  [] [text "Les actes d'état civil ne peuvent être délivrés 
                     que pour les personnes nées à Murol."]
      , p  [] [text "Pour adresser votre demande par courrier postal, imprimez 
                     la demande en "
              ,link "cliquant ici" "http://www.murol.fr/Base_documentaire/demande%20acte%20de%20naissance.pdf"
              ,text ", remplissez-la et envoyez à la mairie"]
      , p  [class "important"] [text "Le délai d'obtention d'une demande d'acte de 
                                      naissance est de 8 jours (courrier transmis par voie postale)"]
      , p  [class "important"] [text "Nous vous remercions de votre compréhension"]
      , h4 [] [text "Déclaration de naissance"]
      , p  [] [text "La déclaration de naissance doit être effectuée à 
                    la Mairie du lieu de naissance (service Etat-Civil). "]
      , h5 [] [text "Enfants légitimes (dont les parents sont mariés):"]
      , p  [] [text "les parents doivent se présenter à la 
                     clinique où a lieu l'accouchement avec le livret 
                     de famille, la clinique se chargeant des formalités 
                     administratives pour la déclaration."]
      , h5 [] [text "Enfants naturels (dont les parents ne sont 
                     pas mariés):"]
      , ul []
           [li [] [p [] [text "Si les parents ont reconnu l'enfant avant 
                               la naissance à la Mairie du lieu de 
                               naissance, il suffit de donner le papier ainsi 
                               que la carte d'identité des parents à la 
                               clinique, qui se chargera de l'envoi des formalités 
                               administratives"]]
           ,li [] [p [] [text "S'il n'y a pas eu de reconnaissance 
                               anticipée de l'enfant, le père doit se présenter 
                               à la Mairie dans les 3 jours suivant 
                               la naissance (jour de celui-ci exclu), muni des 
                               pièces d'identité des 2 parents "]]
           ]
      
      , h4 [] [text "Demande de célébration de mariage"]
      , p  [] [text "La demande de célébration de mariage doit se 
                     faire à la mairie du lieu de mariage 
                     (service Etat-Civil). "]
      , h5 [] [text "Pièces à fournir:"]
      , p  [] [text "Un recueil fournissant tous les renseignements sur 
                     les formalités à accomplir est à votre disposition 
                     au bureau de l'Etat-Civil de la Mairie. "]
      , p  [] [text "Note : le mariage doit être célébré à 
                     la Mairie du domicile de l'un des futurs 
                     époux ou de leur résidence établie par un 
                     mois d'habitation continue."]

      , h4 [] [text "Déclaration de décès"]
      , p  [] [text "C'est la mairie du lieu de décès qui 
                     dresse l'acte de décès (service Etat-Civil)."]
      , h5 [] [text "Pièces à fournir:"]
      , ul []
           [li [] [p [] [text "le livret de famille, l'extrait d'acte de 
                               naissance, ou la carte d'identité du défunt"]]
           ,li [] [p [] [text "le certificat médical constatant le décès"]] 
           ]
      , p  [] [text "Note : la déclaration doit être faite par 
                     un parent ou une personne susceptible de donner 
                     des renseignements complets sur l'Etat-Civil du défunt"]
      ]

listElec = 
  div [ class "subContainerData", id "listElecDemarches"]
      [ h2 [] [text "inscription listes électorales"]
      , p [] [text "Vous devez vous rendre à la mairie munis:"]
      , ul []
           [ li [] [p [] [text "d'une pièce d'identité (carte nationale d'identité, passeport)"]]
           , li [] [p [] [text "et d'un justificatif d'adresse (facture de téléphone, 
                                quittance de loyer, EDF...)."]]
           , li [] [p [] [link "du formulaire qui vous concerne" "http://www.murol.fr/Base_documentaire/electionsinscriptionf.pdf"]]
           ]
      , h4 [] [text "Recommandations générales"]
      , p  [] [text "Pour que votre inscription sur les 
                     listes électorales soit effective au 1er mars de 
                     l’année prochaine, votre formulaire de demande d’inscription et 
                     les pièces justificatives (voir la rubrique « documents 
                     à fournir » ci-dessous) doivent impérativement être parvenus 
                     en mairie avant le 31 décembre de cette 
                     année. Il est donc fortement conseillé d’envoyer votre 
                     demande à votre mairie avant le 15 décembre."]
      , p  [] [text "Veillez à remplir le formulaire en 
                     lettres majuscules de façon lisible"]
      , p  [] [text "Notez impérativement vos coordonnées à la 
                     fin du formulaire afin que la mairie puisse 
                     vous contacter au cas où votre demande serait 
                     incomplète. La communication d’une adresse de courrier électronique 
                     est fortement recommandée afin qu’un accusé de réception 
                     sous format informatique puisse vous être adressé. "]
      , p  [] [text "En l’absence d’accusé de réception de 
                     la part de votre mairie, par courrier ou 
                     par courriel, assurez-vous avant la fin de l’année 
                     en cours que votre demande a bien été 
                     reçue par les services compétents. "]

      , h4 [] [text "Documents à fournir"]
      , p  [] [text "Afin que votre inscription soit prise en compte, 
                     vous devez impérativement faire parvenir au service des 
                     élections de votre mairie les trois types de 
                     documents suivants : "]
      , ol []
           [ li [] [h5 [] [text "Le formulaire d’inscription dûment renseigné"]
                   ,p  [] [text "Veuillez à être le plus clair et lisible 
                                 possible, et à bien remplir toutes les rubriques 
                                 du formulaire qui vous concernent."]
                   ]
           , li [] [h5 [] [text "Une photocopie d’un titre d’identité et 
                                 de nationalité en cours de validité "]
                   ,p  [] [text "Vous adresserez à votre commune une photocopie lisible 
                                 de votre pièce d’identité en cours de validité:"]
                   ,ul []
                       [ li [] [p [] [text "carte nationale d’identité (photocopie recto verso) "]]
                       , li [] [p [] [text "ou passeport (photocopie de la double page 
                                            où figure votre photo)"]]
                       , li [] [p [] [text "ou permis de conduire (valable uniquement s’il 
                                            est accompagné d’un justificatif de nationalité)"]]
                       ]
                   ]
           , li [] [h5 [] [text "Un justificatif de domicile"]
                   ,p  [] [text "Seront acceptées:"]
                   ,ul []
                       [ li [] [p [] [text "les pièces prouvant que vous êtes domicilié 
                                           dans la commune où vous souhaitez être inscrit(e) 
                                           (facture d’électricité, de gaz ou de téléphone fixe). 
                                           Veillez à ce que les factures soient établies 
                                           à votre nom et prénom et qu’elles ne datent pas de plus 
                                           de 3 mois"]]
                       , li [] [p [] [text "ou les pièces permettant de prouver que 
                                           vous êtes inscrit(e), pour la cinquième fois et 
                                           sans interruption, au rôle d’une des contributions directes 
                                           communales ou que votre conjoint répond à ces 
                                           conditions. "]]
                       ]
                   ]
           ]
      , h4 [] [text "Cas particuliers"]
      , ul []
           [ li [] [p [] [text "Les personnes domiciliées chez un parent ou 
                               un tiers sont invitées à prendre contact avec 
                               leur mairie pour connaître les justificatifs à fournir."]]
           , li [] [p [] [text "Pour les personnes résidant à l’étranger, seront 
                                acceptées : "]
                   ,ul []
                       [ li [] [p [] [text "les pièces prouvant que vous êtes inscrit(e) 
                                           au rôle des contributions directes de la commune 
                                           sur la liste électorale de laquelle vous souhaitez 
                                           être inscrit(e)"]]
                       , li [] [p [] [text "un certificat d’inscription au registre des Français 
                                           établis hors de France et les pièces prouvant 
                                           que la commune sur la liste de laquelle 
                                           vous souhaitez être inscrit(e) est soit : votre 
                                           commune de naissance ; la commune de votre 
                                           dernier domicile en France ; la commune de votre dernière résidence en France, 
                                           à condition que cette résidence ait été de 
                                           six mois au moins ; la commune sur 
                                           la liste électorale de laquelle est né, est 
                                           inscrit ou a été inscrit un de vos 
                                           ascendants ; la commune sur la liste électorale 
                                           de laquelle est inscrit un de vos parents 
                                           au quatrième degré. "]
                               , p [] [text "NB : la mention « inscrit(e) au registre 
                                             des Français établis hors de France » suivie 
                                             du cachet de l’ambassade ou du poste consulaire 
                                             compétent et de la date apposée à la 
                                             ligne du « cachet de la mairie » 
                                             vaut certificat d’inscription "]
                               ]
                       ]
                   ]
           ]
      ]

servCiv = 
  div [ class "subContainerData", id "servCivDemarches"]
      [ h2 [] [text "Service civique"]
      , h4 [] [text "Comment m'engager?"]
      , h5 [] [text "Quelles sont les conditions pour pouvoir m’engager en 
                     Service Civique ? "]
      , p  [] [text "Pour être volontaire, il faut avoir entre 16 
                     et 25 ans et posséder la nationalité française, 
                     celle d’un état membre de l’Union européenne ou 
                     de l’espace économique européen, ou justifier d’un séjour 
                     régulier en France depuis plus d’un an. "]
      , p  [] [text "Aucune autre condition n’est requise ; en particulier, 
                     il n’y a pas de condition en termes 
                     de diplôme ou d’expérience professionnelle préalable. Ce sont 
                     les savoirs-être et la motivation qui comptent avant 
                     tout."]
      , p  [] [text "Les conditions d’engagement des jeunes entre 16 et 
                     18 ans sont aménagées. Les missions doivent être 
                     adaptées à leur âge et une autorisation parentale 
                     est nécessaire."]
      , p  [] [text "Les jeunes en situation de handicap peuvent faire 
                     un Service Civique. L’indemnité de Service Civique est 
                     entièrement cumulable avec l’Allocation aux Adultes Handicapés (AAH)."]
      , h5 [] [text "Quelles sont les modalités de l’engagement de Service 
                     Civique ?"]
      , p  [] [text "Le Service Civique est un engagement volontaire de 
                     6 à 12 mois pour l’accomplissement d’une mission 
                     d’intérêt général dans un des neuf domaines d’interventions 
                     reconnus prioritaires pour la Nation : culture et 
                     loisirs, développement international et action humanitaire, éducation pour 
                     tous, environnement, intervention d'urgence en cas de crise, 
                     mémoire et citoyenneté, santé, solidarité, sport. "]
      , p  [] [text "Une indemnité de 446,65 euros nets par mois 
                     est directement versée au volontaire par l'Etat, quelle 
                     que soit la durée hebdomadaire de la mission. "]
      , p  [] [text "L'organisme d’accueil verse aussi au volontaire une prestation 
                     en nature ou en espèce d’un montant de 
                     101,49 euros, correspondant à la prise en charge 
                     des frais d’alimentation (fourniture de repas) ou de 
                     transports. Cette prestation peut être versée de différentes 
                     façons (titre repas, accès à la cantine, remboursements 
                     de frais, etc.) "]
      , p  [] [text "Les jeunes, bénéficiaires ou appartenant à un foyer 
                     bénéficiaire du RSA, ou titulaire d'une bourse de 
                     l'enseignement supérieur au titre du 5e échelon ou 
                     au delà bénéficient d’une majoration d'indemnité de 101,68 
                     euros par mois. "]
      , p  [] [text "Les volontaires en Service Civique bénéficient d'une protection 
                    sociale intégrale."]
      , p  [] [text "Au total, selon les situations, les volontaires en 
                     Service Civique perçoivent entre 548,14 euros et 649,82 
                     euros par mois. "]
      , p  [] [text "Le bénéfice de l’aide au logement est conservé 
                     pendant le Service Civique."]
      , p  [] [text "Un accompagnement pour faciliter le déroulement de la 
                     mission est proposé. Il s'agit d'une phase de 
                     préparation et d'accompagnement dans la réalisation de la 
                     mission, d'une formation civique et citoyenne et d'un 
                     appui à la réflexion sur le projet d’avenir. "]
      , h5 [] [text "Comment postuler à une mission de Service Civique? "]
      , p  [] [text "Postulez auprès des organismes proposant des missions de 
                     Service Civique directement à partir du site:"]
      , link "http://www.service-civique.gouv.fr" "http://www.service-civique.gouv.fr"
      , p  [] [text "Mission dans le puy de dôme:"]
      , link "service civique puy de dôme" "http://www.service-civique.gouv.fr/les_missions?tid=All&tid_1=16&tid_2=All&dept=Puy-de-Dôme "
      ]