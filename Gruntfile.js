module.exports = function(grunt) {

  grunt.initConfig({
    elm: {
      compile: {
        files: {
          "./js/murol.js": ["./src/Murol.elm"],
          "./js/tourisme.js": ["./src/Tourisme.elm"],
          "./js/vieScolaire.js": ["./src/VieScolaire.elm"],
          "./js/covoiturage.js": ["./src/Covoiturage.elm"],
          "./js/gestionDesDechets.js": ["./src/GestionDesDechets.elm"],
          "./js/numerosUrgences.js": ["./src/NumerosUrgences.elm"],
          "./js/agriculture.js": ["./src/Agriculture.elm"],
          "./js/artisanat.js": ["./src/Artisanat.elm"],
          "./js/commerces.js": ["./src/Commerces.elm"],
          "./js/entreprises.js": ["./src/Entreprises.elm"]
        }
      }
    },
    watch: {
      elm: {
        files: ["./src/Murol.elm"
                , "./src/Tourisme.elm"
                , "./src/VieScolaire.elm"
                , "./src/Covoiturage.elm"
                , "./src/GestionDesDechets.elm"
                , "./src/NumerosUrgences.elm"
                , "./src/Agriculture.elm"
                , "./src/Artisanat.elm"
                , "./src/Commerces.elm"
                , "./src/Entreprises.elm"],
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
