module.exports = function(grunt) {

  grunt.initConfig({
    elm: {
      compile: {
        files: {
          "./js/murol.js": ["./src/Murol.elm"],
          // "./js/tourisme.js": ["./src/Tourisme.elm"],
          // "./js/vieScolaire.js": ["./src/VieScolaire.elm"],
          // "./js/covoiturage.js": ["./src/Covoiturage.elm"],
          // "./js/gestionDesDechets.js": ["./src/GestionDesDechets.elm"],
          // "./js/numerosUrgences.js": ["./src/NumerosUrgences.elm"],
          // "./js/agriculture.js": ["./src/Agriculture.elm"],
          // "./js/artisanat.js": ["./src/Artisanat.elm"],
          // "./js/commerces.js": ["./src/Commerces.elm"],
          // "./js/entreprises.js": ["./src/Entreprises.elm"],
          // "./js/lesSeniors.js": ["./src/LesSeniors.elm"],
          // "./js/offresEmploi.js": ["./src/OffresEmploi.elm"],
          // "./js/quinzaineCom.js": ["./src/QuinzaineCom.elm"],
          // "./js/laCommune.js": ["./src/LaCommune.elm"],
          // "./js/vosDemarches.js": ["./src/VosDemarches.elm"],
          // "./js/conseilMunicipal.js": ["./src/ConseilMunicipal.elm"],
          // "./js/cmj.js": ["./src/CMJ.elm"],
          // "./js/ccas.js": ["./src/CCAS.elm"],
          // "./js/commissions.js": ["./src/Commissions.elm"],
          // "./js/gestionDesRisques.js": ["./src/GestionDesRisques.elm"],
          // "./js/horairesContact.js": ["./src/HorairesContact.elm"],
          //"./js/publications.js": ["./src/Publications.elm"],
          //"./js/artEtMusique.js": ["./src/ArtEtMusique.elm"],
          "./js/associations.js": ["./src/Associations.elm"],
          "./js/artisanatArt.js": ["./src/ArtisanatArt.elm"]


        }
      }
    },
    watch: {
      elm: {
        files: ["./src/Murol.elm"
                // , "./src/Tourisme.elm"
                // , "./src/VieScolaire.elm"
                // , "./src/Covoiturage.elm"
                // , "./src/GestionDesDechets.elm"
                // , "./src/NumerosUrgences.elm"
                // , "./src/Agriculture.elm"
                // , "./src/Artisanat.elm"
                // , "./src/Commerces.elm"
                // , "./src/Entreprises.elm"
                // , "./src/LesSeniors.elm"
                // , "./src/OffresEmploi.elm"
                // , "./src/QuinzaineCom.elm"
                // , "./src/LaCommune.elm"
                // , "./src/VosDemarches.elm"
                // , "./src/ConseilMunicipal.elm"
                // , "./src/CMJ.elm"
                // , "./src/CCAS.elm"
                // , "./src/Commissions.elm"
                // , "./src/GestionDesRisques.elm"
                // , "./src/HorairesContact.elm"
                //, "./src/Publications.elm"
                //, "./src/ArtEtMusique.elm"
                , "./src/Associations.elm"
                , "./src/ArtisanatArt.elm"],
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
