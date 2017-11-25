sync = require './src/main.js'
sync.config.cf = false

# Let's create our objects.
foo = {}
bar = {}
baz = {}

Object.defineProperty foo, 'ham', 
	get: -> 58
	configurable: true

# # And bind them together!
# portal = new sync.VPortal 100, ([
# 	[foo, 'ham']
# 	[bar, 'spam']
# 	[baz, 'eggs'] ])

Object.defineProperty foo, 'spam', 
	get: -> 23
	configurable: true

portal2 = new sync.VPortal ([
	[foo, 'spam']
	[bar, 'ham']
	[baz, 'lorem'] ])

sys = new sync.VSystem [{'ham': 1}, {'spam': 1}, {'eggs': 1}]
sys.install [foo, bar, baz]

# foo.ham = 100

console.log "#{foo.ham}, #{bar.spam}, #{baz.eggs}"  # will print "100, 100, 100".
console.log "#{foo.spam}, #{bar.ham}, #{baz.lorem}" # will print "100, 100, 100".
console.log "#{foo.ham}, #{bar.spam}, #{baz.eggs}"  # will print "100, 100, 100".

# Now desynchronize them!
# portal.desync()

# foo.ham = 10
# bar.spam = 'Do dolor esse tempor'
# baz.eggs = { x: 50 }

# console.log "#{foo.ham}, #{bar.spam}, #{baz.eggs}" # will print "10, Do dolor esse tempor., [object Object]".