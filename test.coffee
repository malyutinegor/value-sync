sync       = require './src/main.js'
{ assert } = require 'chai'


describe 'value-sync', ->
	describe 'VSystem', ->
		it 'synchronizes value system with defaults', ->
			f = (x, y) ->
				foo = {}
				bar = {}
				baz = {}

				system = new sync.VSystem ([
					[x: 'x', y: 'y']
					[x: 'x', y: 'y']
					[x: 'x', y: 'y'] ])

				defaults = {x: x, y: y}
				returns  = {x: x, y: y}

				system.install defaults, [foo, bar, baz]

				assert.equal defaults.x, foo.x
				assert.equal defaults.y, foo.y

				assert.equal defaults.x, bar.x
				assert.equal defaults.y, bar.y

				assert.equal defaults.x, baz.x
				assert.equal defaults.y, baz.y

				baz.x = returns.x
				foo.y = returns.y

				assert.equal returns.x, foo.x
				assert.equal returns.y, foo.y

				assert.equal returns.x, bar.x
				assert.equal returns.y, bar.y

				assert.equal returns.x, baz.x
				assert.equal returns.y, baz.y

			for x in [0..5]
				for y in [0..5]
					f x, y

		it 'synchronizes value system without defaults', ->
			f = (x, y) ->
				foo = {y: y}
				bar = {}
				baz = {x: x}

				system = new sync.VSystem ([
					[x: 'x', y: 'y']
					[x: 'x', y: 'y']
					[x: 'x', y: 'y'] ])

				returns = {x: x, y: y}

				system.install [foo, bar, baz]

				assert.equal x, foo.x
				assert.equal y, foo.y

				assert.equal x, bar.x
				assert.equal y, bar.y

				assert.equal x, baz.x
				assert.equal y, baz.y

				baz.x = returns.x
				foo.y = returns.y

				assert.equal returns.x, foo.x
				assert.equal returns.y, foo.y

				assert.equal returns.x, bar.x
				assert.equal returns.y, bar.y

				assert.equal returns.x, baz.x
				assert.equal returns.y, baz.y

			for x in [0..5]
				for y in [0..5]
					f x, y

	describe 'VPortal', ->
		it 'synchronizes value without default value', ->
			f = (x) ->
				foo = {}
				bar = {}
				baz = {}

				desync = new sync.VPortal ([
					[foo, 'x']
					[bar, 'x']
					[baz, 'x'] ])

				defaults = {x: x}
				returns  = {x: x}

				foo.x = defaults.x

				assert.equal defaults.x, foo.x
				assert.equal defaults.x, bar.x
				assert.equal defaults.x, baz.x

				baz.x = returns.x

				assert.equal returns.x, foo.x
				assert.equal returns.x, bar.x
				assert.equal returns.x, baz.x

			for x in [0..5]
				for y in [0..5]
					f x, y
