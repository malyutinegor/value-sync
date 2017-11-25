[VPortal, VSystem, VConfig, VGS] = do ->

	isNode = typeof process is 'object' and typeof process.versions is 'object' and typeof process.versions.node isnt 'undefined'

	# some aliases
	define = Object.defineProperty

	showCM = ->
		if VConfig.cm
			console.log new Error 'You should set "configurable" in "Object.defineProperty", or you can get bad results!'
		if isNode
			console.log 'You also can mute this message using "valueSync.config.cm = false"!'
		else
			console.log 'You also can mute this message using "VConfig.cm = false"!'

	iP = (portal, sf) ->
		portal[0][portal[1]] = undefined if portal[0][portal[1]] is undefined
		sf.value = portal[0][portal[1]] if portal[0][portal[1]] isnt undefined and sf? and not sf.value

	class VPortal
		constructor: ->
			if arguments.length == 2 # parse arguments
				@value   = arguments[0]
				@portals = arguments[1]
			else
				@portals = arguments[0]

			sf = @

			descriptor = {}
			for portal in @portals
				desc = Object.getOwnPropertyDescriptor(portal[0], portal[1])
				if desc
					descriptor.get = descriptor.get or desc.get
					descriptor.set = descriptor.set or desc.set

			if descriptor.get or descriptor.set
				vgsf.call @, descriptor, @portals	
			else
				changed = (portal) ->
					iP portal, sf
					try
						define portal[0], portal[1], # define getters
							get: ( ) -> sf.value
							set: (s) -> sf.value = s
							configurable: true
					catch
						showCM()

				for portal in @portals  # connect all portals
					changed portal

		desynchronize: ->
			@value = @_getter() if @_getter or @_setter
			for portal in @portals
				Object.defineProperty portal[0], portal[1],
					enumerable: true,
					writable: true,
					configurable: true,
					value: @value

		desync: ->
			@desynchronize.apply @, arguments

	vgsf = ->
		if arguments.length == 2 # parse arguments
			@_getter  = arguments[0].get or arguments[0].getter or ->
			@_setter  = arguments[0].set or arguments[0].setter or ->
			@portals  = arguments[1]
		else
			@portals = arguments[0]

		sf = @

		changed = (portal) ->
			iP portal
			try
				define portal[0], portal[1], # define getters
					get: ( ) -> sf._getter( )
					set: (s) -> sf._setter(s)
					configurable: true
			catch error
				showCM()


		for portal in @portals  # connect all portals
			changed portal

	class VGS
		constructor: ->
			vgsf.apply @, arguments

		desynchronize: ->
			result = @_getter() if @_getter or @_setter
			for portal in @portals
				Object.defineProperty portal[0], portal[1],
					enumerable: true,
					writable: true,
					configurable: true,
					value: result

		desync: ->
			@desynchronize.apply @, arguments

	VConfig =
		configurableMessage: true

	new VPortal [[VConfig, 'configurableMessage'], [VConfig, 'cm']]

	[VPortal, VSystem, VConfig, VGS]


if typeof process is 'object' and typeof process.versions is 'object' and typeof process.versions.node isnt 'undefined'
	module.exports = VPortal

	module.exports.VPortal = VPortal
	module.exports.VP      = VPortal

	module.exports.VGS           = VGS
	module.exports.VGetterSetter = VGS
	module.exports.VD            = VGS
	module.exports.VDescriptor   = VGS

	module.exports.config  = VConfig
