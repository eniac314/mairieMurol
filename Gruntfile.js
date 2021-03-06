module.exports = function(grunt) {

  grunt.initConfig({
    elm: {
      compile: {
        files: {
          "./js/murol.js": ["./src/Murol.elm"],
          "./js/utils.js": ["./src/Utils.elm"],
          "./js/periscolaire.js": ["./src/Periscolaire.elm"],
          "./js/decouvrirMurol.js": ["./src/DecouvrirMurol.elm"],
          "./js/Juillet14.js": ["./src/Juillet14.elm"],
          "./js/medievales.js": ["./src/Medievales.elm"],
          "./js/patrimoinePhoto.js": ["./src/PatrimoinePhoto.elm"],
          "./js/annee2016.js": ["./src/Annee2016.elm"],
          "./js/annee2017.js": ["./src/Annee2017.elm"],
          "./js/annee2018.js": ["./src/Annee2018.elm"],
          "./js/journeeMurolais.js": ["./src/JourneeMurolais.elm"],
          "./js/printempsEte.js": ["./src/PrintempsEte.elm"],
          "./js/automneHiver.js": ["./src/AutomneHiver.elm"],
          "./js/festivalArt.js": ["./src/FestivalArt.elm"],
          "./js/animaux.js": ["./src/Animaux.elm"],
          "./js/vieScolaire.js": ["./src/VieScolaire.elm"],
          "./js/gestionDesDechets.js": ["./src/GestionDesDechets.elm"],
          "./js/numerosUrgences.js": ["./src/NumerosUrgences.elm"],
          "./js/agriculture.js": ["./src/Agriculture.elm"],
          "./js/artisanat.js": ["./src/Artisanat.elm"],
          "./js/commerces.js": ["./src/Commerces.elm"],
          "./js/entreprises.js": ["./src/Entreprises.elm"],
          "./js/lesSeniors.js": ["./src/LesSeniors.elm"],
          "./js/lesAdos.js": ["./src/LesAdos.elm"],
          "./js/offresEmploi.js": ["./src/OffresEmploi.elm"],
          "./js/quinzaineCom.js": ["./src/QuinzaineCom.elm"],
          "./js/laCommune.js": ["./src/LaCommune.elm"],
          "./js/vosDemarches.js": ["./src/VosDemarches.elm"],
          "./js/conseilMunicipal.js": ["./src/ConseilMunicipal.elm"],
          "./js/cmj.js": ["./src/CMJ.elm"],
          "./js/ccas.js": ["./src/CCAS.elm"],
          "./js/commissions.js": ["./src/Commissions.elm"],
          "./js/gestionDesRisques.js": ["./src/GestionDesRisques.elm"],
          "./js/horairesContact.js": ["./src/HorairesContact.elm"],
          "./js/publications.js": ["./src/Publications.elm"],
          "./js/artistes.js": ["./src/Artistes.elm"],
          "./js/associations.js": ["./src/Associations.elm"],
          "./js/cinema.js": ["./src/Cinema.elm"],
          "./js/sportsDetente.js": ["./src/SportsDetente.elm"],        
          "./js/officeTourisme.js": ["./src/OfficeTourisme.elm"],
          "./js/sante.js": ["./src/Sante.elm"],
          "./js/cartePlan.js": ["./src/CartePlan.elm"],
          "./js/restaurants.js": ["./src/Restaurants.elm"],
          "./js/hebergements.js": ["./src/Hebergements.elm"],
          "./js/transports.js": ["./src/Transports.elm"],
          "./js/animation.js": ["./src/Animation.elm"],
          "./js/murolInfos.js": ["./src/MurolInfos.elm"],
          "./js/deliberations.js": ["./src/Deliberations.elm"],
          "./js/bulletinsMunicipaux.js": ["./src/BulletinsMunicipaux.elm"],
          "./js/elections.js": ["./src/Elections.elm"],
          "./js/autresPublications.js": ["./src/AutresPublications.elm"],
          "./js/villageFleuri.js": ["./src/VillageFleuri.elm"],
          "./js/sortir.js": ["./src/Sortir.elm"],
          "./js/patrimoine.js": ["./src/Patrimoine.elm"],
          "./js/phototheque.js": ["./src/Phototheque.elm"],
          "./js/petitesAnnonces.js": ["./src/PetitesAnnonces.elm"],
          "./js/animationEstivale.js": ["./src/AnimationEstivale.elm"],
          "./js/sallesFetes.js": ["./src/SallesFetes.elm"],
          "./js/mentions.js": ["./src/Mentions.elm"],
          "./js/environnement.js": ["./src/Environnement.elm"],
          "./js/contactMairie.js": ["./src/ContactMairie.elm"],
          "./js/documentation.js": ["./src/Documentation.elm"]
          
        }
      }
    },
    watch: {
      elm: {
        files: ["./src/Murol.elm"
                , "./src/Utils.elm"
                , "./src/Medievales.elm"
                , "./src/Juillet14.elm"
                , "./src/Annee2016.elm"
                , "./src/Annee2017.elm"
                , "./src/Annee2018.elm"
                , "./src/PatrimoinePhoto.elm"
                , "./src/Periscolaire.elm"
                , "./src/DecouvrirMurol.elm"
                , "./src/PrintempsEte.elm"
                , "./src/JourneeMurolais.elm"
                , "./src/AutomneHiver.elm"
                , "./src/FestivalArt.elm"
                , "./src/Animaux.elm"
                , "./src/VieScolaire.elm"
                , "./src/GestionDesDechets.elm"
                , "./src/NumerosUrgences.elm"
                , "./src/Agriculture.elm"
                , "./src/Artisanat.elm"
                , "./src/Commerces.elm"
                , "./src/Entreprises.elm"
                , "./src/LesSeniors.elm"
                , "./src/LesAdos.elm"
                , "./src/OffresEmploi.elm"
                , "./src/QuinzaineCom.elm"
                , "./src/LaCommune.elm"
                , "./src/VosDemarches.elm"
                , "./src/ConseilMunicipal.elm"
                , "./src/CMJ.elm"
                , "./src/CCAS.elm"
                , "./src/Commissions.elm"
                , "./src/GestionDesRisques.elm"
                , "./src/HorairesContact.elm"
                , "./src/Publications.elm"
                , "./src/Artistes.elm"
                , "./src/Associations.elm"
                , "./src/Cinema.elm"
                , "./src/SportsDetente.elm"                
                , "./src/OfficeTourisme.elm"
                , "./src/Sante.elm"
                , "./src/CartePlan.elm"
                , "./src/Hebergements.elm"
                , "./src/Restaurants.elm"
                , "./src/Animation.elm"
                , "./src/Transports.elm"
                , "./src/MurolInfos.elm"
                , "./src/Deliberations.elm"
                , "./src/BulletinsMunicipaux.elm"
                , "./src/Elections.elm"
                , "./src/AutresPublications.elm"
                , "./src/VillageFleuri.elm"
                , "./src/Sortir.elm"
                , "./src/Patrimoine.elm"
                , "./src/Phototheque.elm"
                , "./src/PetitesAnnonces.elm"
                , "./src/AnimationEstivale.elm"
                , "./src/SallesFetes.elm"
                , "./src/Mentions.elm"
                , "./src/Environnement.elm"
                , "./src/ContactMairie.elm"
                , "./src/Documentation.elm"],
        tasks: ["elm"]
      }
    },
    clean: ["elm-stuff/build-artifacts"]
  });

  grunt.loadNpmTasks('grunt-contrib-watch');
  grunt.loadNpmTasks('grunt-contrib-clean');
  grunt.loadNpmTasks('grunt-elm');

  grunt.registerTask('default', ['elm']);

};
