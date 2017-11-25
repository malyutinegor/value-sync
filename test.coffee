sync       = require './src/main.js'
{ assert } = require 'chai'


describe 'value-sync', ->
	describe 'VPortal', ->
		it 'synchronizes properties without default value', ->
			f = (x, y) ->
				defaults = {x: x, y: y}
				returns  = {x: x + 5, y: y + 5}

				foo = {}
				bar = {}
				baz = {}


				portal = new sync.VPortal ([
					[foo, 'x']
					[bar, 'x']
					[baz, 'x'] ])

				portal2 = new sync.VPortal ([
					[foo, 'y']
					[bar, 'y']
					[baz, 'y'] ])


				foo.x = defaults.x
				bar.y = defaults.y

				assert.equal defaults.x, foo.x
				assert.equal defaults.x, bar.x
				assert.equal defaults.x, baz.x
				assert.equal defaults.y, foo.y
				assert.equal defaults.y, bar.y
				assert.equal defaults.y, baz.y

				baz.x = returns.x
				foo.y = returns.y

				assert.equal returns.x, foo.x
				assert.equal returns.x, bar.x
				assert.equal returns.x, baz.x
				assert.equal returns.y, foo.y
				assert.equal returns.y, bar.y
				assert.equal returns.y, baz.y

			for x in [0..5]
				for y in [0..5]
					f x, y

		it 'synchronizes properties with default value', ->
			f = (x, y) ->
				defaults = {x: x, y: y}
				returns  = {x: x + 5, y: y + 5}				

				foo = {}
				bar = {}
				baz = {}

				portal  = new sync.VPortal defaults.x, ([
					[foo, 'x']
					[bar, 'x']
					[baz, 'x'] ])

				portal2 = new sync.VPortal defaults.y, ([
					[foo, 'y']
					[bar, 'y']
					[baz, 'y'] ])


				assert.equal defaults.x, foo.x
				assert.equal defaults.x, bar.x
				assert.equal defaults.x, baz.x
				assert.equal defaults.y, foo.y
				assert.equal defaults.y, bar.y
				assert.equal defaults.y, baz.y

				baz.x = returns.x
				foo.y = returns.y

				assert.equal returns.x, foo.x
				assert.equal returns.x, bar.x
				assert.equal returns.x, baz.x
				assert.equal returns.y, foo.y
				assert.equal returns.y, bar.y
				assert.equal returns.y, baz.y

			for x in [0..5]
				for y in [0..5]
					f x, y

		it 'synchronizes properties with descriptor', ->
			f = (x, y) ->
				defaults = {x, y}
				returns  = {x, y}				

				foo = {}
				bar = {}
				baz = {}

				rx = defaults.x
				ry = defaults.y
				Object.defineProperty foo, 'x',
					get: ( ) -> rx - 5
					set: (s) -> rx = s
					configurable: true
				Object.defineProperty foo, 'y',
					get: ( ) -> ry + 5
					set: (s) -> ry = s
					configurable: true

				portal  = new sync.VPortal ([
					[foo, 'x']
					[bar, 'x']
					[baz, 'x'] ])
				portal2 = new sync.VPortal ([
					[foo, 'y']
					[bar, 'y']
					[baz, 'y'] ])


				assert.equal defaults.x, foo.x + 5
				assert.equal defaults.x, bar.x + 5
				assert.equal defaults.x, baz.x + 5
				assert.equal defaults.y, foo.y - 5
				assert.equal defaults.y, bar.y - 5
				assert.equal defaults.y, baz.y - 5

				bar.x = returns.x
				baz.y = returns.y

				assert.equal returns.x, foo.x + 5
				assert.equal returns.x, bar.x + 5
				assert.equal returns.x, baz.x + 5
				assert.equal returns.y, foo.y - 5
				assert.equal returns.y, bar.y - 5
				assert.equal returns.y, baz.y - 5

			for x in [0..5]
				for y in [0..5]
					f x, y

		describe 'desynchronize', ->
			it 'desynchronizes portal', ->
				f = (x, y) ->
					defaults = {x: x, y: y}
					returns  = {x: (Math.random() * 100), y: (Math.random() * 100)}

					foo = {}
					bar = {}
					baz = {}


					portal = new sync.VPortal ([
						[foo, 'x']
						[bar, 'x']
						[baz, 'x'] ])
					portal2 = new sync.VPortal ([
						[foo, 'y']
						[bar, 'y']
						[baz, 'y'] ])


					foo.x = defaults.x
					bar.y = defaults.y

					assert.equal defaults.x, foo.x
					assert.equal defaults.x, bar.x
					assert.equal defaults.x, baz.x
					assert.equal defaults.y, foo.y
					assert.equal defaults.y, bar.y
					assert.equal defaults.y, baz.y

					portal.desync()
					portal2.desync()

					foo.x = returns.x
					foo.y = returns.y

					assert.equal returns.x, foo.x
					assert.equal returns.y, foo.y

					assert.equal defaults.x, bar.x
					assert.equal defaults.x, baz.x
					assert.equal defaults.y, bar.y
					assert.equal defaults.y, baz.y

				for x in [0..5]
					for y in [0..5]
						f x, y



	describe 'VDescriptor', ->
		it 'synchronizes properties with default descriptor', ->
			f = (x, y) ->
				defaults = {x, y}
				returns  = {x, y}				

				foo = {}
				bar = {}
				baz = {}

				rx = defaults.x
				ry = defaults.y
				desc =
					get: ( ) -> rx - 5
					set: (s) -> rx = s
					configurable: true
				desc2 =
					get: ( ) -> ry + 5
					set: (s) -> ry = s
					configurable: true

				portal  = new sync.VD desc,  ([
					[foo, 'x']
					[bar, 'x']
					[baz, 'x'] ])

				portal2 = new sync.VD desc2, ([
					[foo, 'y']
					[bar, 'y']
					[baz, 'y'] ])


				assert.equal defaults.x, foo.x + 5
				assert.equal defaults.x, bar.x + 5
				assert.equal defaults.x, baz.x + 5
				assert.equal defaults.y, foo.y - 5
				assert.equal defaults.y, bar.y - 5
				assert.equal defaults.y, baz.y - 5

				baz.x = returns.x
				foo.y = returns.y

				assert.equal returns.x, foo.x + 5
				assert.equal returns.x, bar.x + 5
				assert.equal returns.x, baz.x + 5
				assert.equal returns.y, foo.y - 5
				assert.equal returns.y, bar.y - 5
				assert.equal returns.y, baz.y - 5

			for x in [0..5]
				for y in [0..5]
					f x, y
				describe 'desynchronize', ->

		describe 'desynchronize', ->
			it 'desynchronizes portal', ->
				f = (x, y) ->
					defaults = {x: x, y: y}
					returns  = {x: (Math.random() * 100), y: (Math.random() * 100)}

					foo = {}
					bar = {}
					baz = {}

					rx = defaults.x
					ry = defaults.y
					desc =
						get: ( ) -> rx - 5
						set: (s) -> rx = s
						configurable: true
					desc2 =
						get: ( ) -> ry + 5
						set: (s) -> ry = s
						configurable: true


					portal = new sync.VD desc, ([
						[foo, 'x']
						[bar, 'x']
						[baz, 'x'] ])
					portal2 = new sync.VD desc2, ([
						[foo, 'y']
						[bar, 'y']
						[baz, 'y'] ])


					foo.x = defaults.x
					bar.y = defaults.y

					# assert.equal defaults.x, foo.x
					# assert.equal defaults.x, bar.x
					# assert.equal defaults.x, baz.x
					# assert.equal defaults.y, foo.y
					# assert.equal defaults.y, bar.y
					# assert.equal defaults.y, baz.y

					portal.desync()
					portal2.desync()

					foo.x = returns.x
					foo.y = returns.y

					assert.equal returns.x, foo.x
					assert.equal returns.y, foo.y

					assert.equal defaults.x, bar.x + 5
					assert.equal defaults.x, baz.x + 5
					assert.equal defaults.y, bar.y - 5
					assert.equal defaults.y, baz.y - 5

				for x in [0..5]
					for y in [0..5]
						f x, y