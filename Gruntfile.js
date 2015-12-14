module.exports = function(grunt) {

  grunt.initConfig({
    elm: {
      compile: {
        files: {
          "./js/murol.js": ["Murol.elm"],
          "./js/tourisme.js": ["Tourisme.elm"],
          "./js/vieScolaire.js": ["VieScolaire.elm"]
        }
      }
    },
    watch: {
      elm: {
        files: ["Murol.elm", "Tourisme.elm", "VieScolaire.elm"],
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
