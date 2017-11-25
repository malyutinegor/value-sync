gulp    = require 'gulp'
coffee  = require 'gulp-coffee'
uglify  = require 'gulp-uglify'
mocha   = require 'gulp-mocha'
rename  = require 'gulp-rename'

gulp.task 'tests', ->
	gulp.src 'test.js', read: false
		.pipe mocha()

gulp.task 'pack', ->
	gulp.src 'src/main.coffee'

		.pipe coffee bare: true

		.pipe rename 'build.js'
		.pipe gulp.dest 'build'

		.pipe rename 'build.min.js'
		.pipe uglify()
		.pipe gulp.dest 'build'

gulp.task 'build', ['tests', 'pack']
gulp.task 'default', ['build']