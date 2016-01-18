module.exports = function(grunt) {

  grunt.initConfig({
    elm: {
      compile: {
        files: {
          "./js/murol.js": ["./src/Murol.elm"],
          "./js/tourisme.js": ["./src/Tourisme.elm"],
          "./js/vieScolaire.js": ["./src/VieScolaire.elm"],
          "./js/gestionDesDechets.js": ["./src/GestionDesDechets.elm"],
          "./js/numerosUrgences.js": ["./src/NumerosUrgences.elm"],
          "./js/agriculture.js": ["./src/Agriculture.elm"],
          "./js/artisanat.js": ["./src/Artisanat.elm"],
          "./js/commerces.js": ["./src/Commerces.elm"],
          "./js/entreprises.js": ["./src/Entreprises.elm"],
          "./js/lesSeniors.js": ["./src/LesSeniors.elm"],
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
          "./js/sportEtDetentes.js": ["./src/SportEtDetentes.elm"],
          "./js/decouvrirMurol.js": ["./src/DecouvrirMurol.elm"],
          "./js/officeTourisme.js": ["./src/OfficeTourisme.elm"],
          "./js/sante.js": ["./src/Sante.elm"],
          "./js/cartePlan.js": ["./src/CartePlan.elm"],
          "./js/hebergements.js": ["./src/Hebergements.elm"],
          "./js/transports.js": ["./src/Transports.elm"],
          "./js/animation.js": ["./src/Animation.elm"],
          "./js/documentation.js": ["./src/Documentation.elm"]


          
        }
      }
    },
    watch: {
      elm: {
        files: ["./src/Murol.elm"
                , "./src/Tourisme.elm"
                , "./src/VieScolaire.elm"
                , "./src/GestionDesDechets.elm"
                , "./src/NumerosUrgences.elm"
                , "./src/Agriculture.elm"
                , "./src/Artisanat.elm"
                , "./src/Commerces.elm"
                , "./src/Entreprises.elm"
                , "./src/LesSeniors.elm"
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
                , "./src/SportEtDetentes.elm"
                , "./src/DecouvrirMurol.elm"
                , "./src/OfficeTourisme.elm"
                , "./src/Sante.elm"
                , "./src/CartePlan.elm"
                , "./src/Hebergements.elm"
                , "./src/Animation.elm"
                , "./src/Transports.elm"
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
