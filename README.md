<p align="center">
	<a href="http://malyutinegor.github.io/value-sync/"> <img width="150" title="value-sync logo" src="http://malyutinegor.github.io/value-sync/only-icon.svg"> </a>
	<br>
	<br>
	<img width="320" title="value-sync" src="http://malyutinegor.github.io/value-sync/only-title.svg">
</p>

<a href="https://travis-ci.org/malyutinegor/value-sync"><img src="https://img.shields.io/travis/malyutinegor/value-sync.svg?style=flat-square"></a>

Better docs coming soon!

# Example?

CoffeeScript example:

```coffeescript
sync = require 'value-sync'

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
```
