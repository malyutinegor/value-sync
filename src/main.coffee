# REMOVE
_ = require './_.js'
# END

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

		changed = (portal) ->
			sf.value = portal[0][portal[1]] if portal[0][portal[1]] and not sf.value  # set default value
			portal[0][portal[1]] = undefined unless portal[0][portal[1]]

			desc = Object.getOwnPropertyDescriptor portal[0], portal[1]
			if desc
				if getter and (desc.get or desc.set)
					throw new Error 'You can use only 1 dominant property descriptor!'
				else
					getter = desc.get
					setter = desc.set
			try
				Object.defineProperty portal[0], portal[1],  # define getters
					get: ->
						return getter() if getter
						return sf.value
					set: (s) -> 
						return setter(s) if setter
						sf.value = s
			catch error
				console.log new Error 'You must set "configurable" in "Object.defineProperty", or you can get bad results!'

		@portals = watchArray @portals, (arg) -> 
			portal = arg
			return unless typeof portal == 'object' and portal[0] and portal[1]
			changed portal

		for portal in @portals  # connect all portals
			changed portal

	desynchronize: ->
		for portal in @portals
			Object.defineProperty portal[0], portal[1],
				enumerable: false,
				writable: false,
				configurable: false,
				value: @value

	desync: ->
		@desynchronize.apply @, arguments


watchArray = (object, callback) ->
	return new Proxy object,
		set: (target, property, value, receiver) ->
			target[property] = value
			callback(value)
			return true

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
			if defs[storageName]
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

if typeof process is 'object' and typeof process.versions is 'object' and typeof process.versions.node isnt 'undefined'
	module.exports.VPortal = VPortal
	module.exports.VSystem = VSystem
