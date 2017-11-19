sync = require './src/main.js'

# Let's create our objects.
foo = {}
bar = {}
baz = {}

# And bind them together!
portal = new sync.VPortal ([
	[foo, 'ham']
	[bar, 'spam']
	[baz, 'eggs'] ])

foo.ham = 100

console.log "#{foo.ham}, #{bar.spam}, #{baz.eggs}" # will print "100, 100, 100".

# Now desynchronize them!
portal.desync()

foo.ham = 10
bar.spam = 'Do dolor esse tempor'
baz.eggs = { x: 50 }

console.log "#{foo.ham}, #{bar.spam}, #{baz.eggs}" # will print "10, Do dolor esse tempor., [object Object]".