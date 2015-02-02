gulp   = require 'gulp'
jade   = require 'gulp-jade'
coffee = require 'gulp-coffee'
coffeelint = require 'gulp-coffeelint'
uglify = require 'gulp-uglify'
stylus  = require 'gulp-stylus'
minify = require 'gulp-minify-css'
concat = require 'gulp-concat'

# watcher
watch  = require 'gulp-watch'
server = require 'gulp-webserver'
livereload = require 'gulp-livereload'

#util
plumber = require 'gulp-plumber'
notify  = require 'gulp-notify'
imagemin= require 'gulp-imagemin'
rename  = require 'gulp-rename'

#browserify
browserify = require 'browserify'
coffeeify  = require 'coffeeify'
source     = require 'vinyl-source-stream'
streamify  = require 'gulp-streamify'

# dir settings
pub_dir  = 'app/public'
view_dir = 'app/views'

srcdata = {
  'coffee'   : 'source/coffee/**/*.coffee'
  'stylus'   : 'source/stylus/**/*.stylus'
  'jade'     : 'source/jade/**/*.jade'
  'image'    : 'source/resources/**/*'
  'bower'    : ['dev/vendors/**/*','bower_components/**/*']
  'vendorjs' : 'source/javascript/**/*'
}

gulp.task 'lint-coffee', () ->
  gulp.src [srcdata.coffee]
    .pipe coffeelint()
    .pipe coffeelint.reporter()

gulp.task 'compile-js', () ->
  compileFileName = 'application.min.js'
  browserify(
    entries: ['./source/coffee/main.coffee']
    extensions: ['.coffee']
    )
    .transform 'coffeeify'
    .bundle()
    .pipe plumber(errorHandler: notify.onError '<%= error.message %>')
    .pipe source compileFileName
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

gulp.task 'move-vendorjs', () ->
  gulp.src srcdata.vendorjs
    .pipe gulp.dest(pub_dir+'/scripts/vendors')

gulp.task 'webserver', () ->
  gulp.src pub_dir
    .pipe server(livereload:true)

gulp.task 'compile', [
  'lint-coffee'
  'compile-js'
  'compile-css'
  'compile-html'
  'move-vendors'
  'move-vendorjs'
  'compile-image'
]
gulp.task 'watch', () ->
  gulp.watch srcdata.coffee, ['clint-coffee']
  gulp.watch srcdata.coffee, ['compile-js']
  gulp.watch srcdata.jade, ['compile-html']
  gulp.watch srcdata.stylus, ['compile-css']
  gulp.watch srcdata.image, ['compile-image']
  gulp.watch srcdata.bower, ['move-vendors']
  gulp.watch srcdata.vendorjs, ['move-vendorjs']

gulp.task 'default', [
  'compile'
  'watch'
  #'webserver'
]
