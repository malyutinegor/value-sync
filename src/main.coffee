[VPortal, VSystem, VConfig] = do ->
	cf = true
	isNode = typeof process is 'object' and typeof process.versions is 'object' and typeof process.versions.node isnt 'undefined'
	# - pair(default_value /* (not necessarily) */, [[foo, 'a'], [bar, 'a']])
	class VPortal
		getter = undefined
		setter = undefined
		constructor: ->
			if arguments.length == 2 # parse arguments
				@value   = arguments[0]
				@portals = arguments[1]
			else
				@portals = arguments[0]
			sf = @

			for portal in @portals
				desc = Object.getOwnPropertyDescriptor(portal[0], portal[1])
				console.log desc.get.toString() if desc and (desc.get or desc.set)


			changed = (portal) ->
				portal[0][portal[1]] = undefined if portal[0][portal[1]] is undefined
				sf.value = portal[0][portal[1]] if portal[0][portal[1]] isnt undefined and not sf.value  # set default value
				try
					Object.defineProperty portal[0], portal[1], # define getters
						get: ()  -> sf.value
						set: (s) -> sf.value = s
						configurable: true

				catch error
					if cf
						console.log new Error 'You must set "configurable" in "Object.defineProperty", or you can get bad results!'
						if isNode
							console.log 'You also can disable this message using "valueSync.VConfig(\'no cf\')"'
						else
							console.log 'You also can disable this message using "VConfig(\'no cf\')"'


			for portal in @portals  # connect all portals
				changed portal

		desynchronize: ->
			for portal in @portals
				Object.defineProperty portal[0], portal[1],
					enumerable: true,
					writable: true,
					configurable: true,
					value: @value

		desync: ->
			@desynchronize.apply @, arguments

	class VSystem
		getPaths = do ->
			paths = []
			rn = (obj, path = {steps: []}) ->
				for prop of obj
					if typeof obj[prop] is 'number' or typeof obj[prop] is 'string'
						nw = {steps: path.steps.concat(), name: prop, value: obj[prop]}
						paths.push nw
					else if typeof obj[prop] is 'object'
						nw = {steps: path.steps.concat(prop)}
						rn obj[prop], nw
			f = (obj) ->
				rn obj
				paths
			f

		sortPaths = (paths) ->
			res = {}
			for path in paths
				res[path.value] = [] unless res[path.value]
				res[path.value].push {steps: path.steps, name: path.name}
			res


		pairPaths = (storages, defs, obj) ->
			portals = []
			for storageName, storage of storages
				args = []
				for pair in storage
					prop = obj[pair.steps[0]] if pair.steps[0]
					for num, step of pair.steps
						continue if num is 0
						prop = prop[step] if prop[step]
					args.push [prop, pair.name]

				if defs[storageName] isnt undefined
					portals.push new VPortal defs[storageName], args
				else if typeof defs isnt 'object'
					portals.push new VPortal defs, args
				else
					portals.push new VPortal args
			r = {
				desynchronize: ->
					for portal in portals
						portal.desync()
			}
			r.desync = r.desynchronize
			r

		init = undefined

		constructor: (@model = {}) ->
			@paths = sortPaths getPaths @model

		install: ->
			if arguments.length == 2 # parse arguments
				defs = arguments[0]
				obj  = arguments[1]
			else
				obj  = arguments[0]
				defs = {}
			return (pairPaths @paths, defs, obj).desync

	settings = {
		cf: {
			yes: -> cf = true
			no:  -> cf = false
		}
	}

	VConfig = (option) ->
		rs = if option.match(/^no/i) then 'no' else 'yes'
		if rs is 'no'
			op = option.match(/^no\s*([\w\d]+)\s*/i)[1]
		else
			op = option.match(/\s*([\w\d]+)\s*/i)[1]
		if settings[op]
			if settings[op][rs]
				settings[op][rs]()
			else
				if rs is 'yes'
					throw new Error 'Sorry, but you can\'t enable "' + op + '" setting!'
				else
					throw new Error 'Sorry, but you can\'t disable "' + op + '" setting!'
		else
			throw new Error 'Sorry, but there is no any "' + op + '" setting!'

	[VPortal, VSystem, VConfig]


if typeof process is 'object' and typeof process.versions is 'object' and typeof process.versions.node isnt 'undefined'
	module.exports.VPortal = VPortal
	module.exports.VSystem = VSystem
	module.exports.VConfig = VConfig
