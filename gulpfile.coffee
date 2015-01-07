gulp   = require 'gulp'
jade   = require 'gulp-jade'
coffee = require 'gulp-coffee'
uglify = require 'gulp-uglify'
stylus  = require 'gulp-stylus'
minify = require 'gulp-minify-css'
concat = require 'gulp-concat'
watch  = require 'gulp-watch'
#server = require 'gulp-webserver'
#livereload = require 'gulp-livereload'
plumber = require 'gulp-plumber'
notify  = require 'gulp-notify'
imagemin= require 'gulp-imagemin'
rename  = require 'gulp-rename'

browserify = require 'browserify'
coffeeify  = require 'coffeeify'
source     = require 'vinyl-source-stream'
streamify  = require 'gulp-streamify'

pub_dir = 'app/public'
view_dir = 'app/views'

srcdata = {
  'coffee': 'source/coffee/**/*.coffee'
  'stylus': 'source/stylus/**/*.stylus'
  'jade'  : 'source/jade/**/*.jade'
  'image' : 'source/resources/**/*'
  'pjs'   : 'source/pjs/**/*'
  'bower' : ['dev/vendors/**/*','bower_components/**/*']
}

gulp.task 'compile-js', () ->
  compileFileName = 'application.min.js'
  browserify(
    entries: ['./source/coffee/main.coffee']
    extensions: ['.coffee']
    )
    .transform 'coffeeify'
    .bundle()
    .pipe plumber(errorHandler: notify.onError '<%= error.message %>')
    .pipe source 'application.min.js'
    .pipe streamify uglify({mangle: false})
    .pipe gulp.dest pub_dir+'/scripts'


gulp.task 'compile-css', () ->
  compileFileName = 'application.min.css'
  gulp.src srcdata.stylus
    .pipe plumber(errorHandler: notify.onError '<%= error.message %>')
    .pipe stylus()
    .pipe gulp.dest('source/.tmp/')
    .pipe concat(compileFileName)
    .pipe minify()
    .pipe gulp.dest(pub_dir+'/styles')

gulp.task 'compile-html', () ->
  compileFileName = 'index.erb'
  gulp.src srcdata.jade
    .pipe plumber(errorHandler: notify.onError '<%= error.message %>')
    .pipe jade()
    .pipe rename extname: '.erb'
    .pipe gulp.dest(view_dir)

gulp.task 'compile-image', () ->
  gulp.src srcdata.image
    .pipe imagemin()
    .pipe gulp.dest(pub_dir+'/resources')

gulp.task 'move-vendors', () ->
  gulp.src srcdata.bower
    .pipe gulp.dest(pub_dir+'/vendors')

gulp.task 'webserver', () ->
  gulp.src pub_dir
    .pipe server(livereload:true)

gulp.task 'compile', [
  'compile-js'
  'compile-css'
  'compile-html'
  'move-vendors'
  'compile-image'
]
gulp.task 'watch', () ->
  gulp.watch srcdata.stylus, ['compile-css']
  gulp.watch srcdata.coffee, ['compile-js']
  gulp.watch srcdata.jade, ['compile-html']
  gulp.watch srcdata.image, ['compile-image']
  gulp.watch srcdata.bower, ['move-vendors']

gulp.task 'default', [
  'compile'
  'watch'
  #'webserver'
]
