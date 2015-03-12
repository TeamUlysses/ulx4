.PHONY: lua watch lint map test diagram doc

clean:
	find lua/* | grep -v "lua/lib" | xargs rm -r ; \
	rm -rf map

lua:
	cd moon && moonc -t ../lua *

watch: lua
	cd moon && moonc -w -t ../lua *

lint:
	moonc -l moon

map:
	cd moon && find . -name "*.moon" -exec sh -c 'mkdir -p ../maps/$${1%/*} && moonc -X "$$1" > "../maps/$$1.map"' -- {} \;

test:
	busted

diagram:
	plantuml -tsvg -o ../diagrams -nbthread auto doc/uml/*.iuml

doc: diagram
	naturaldocs -r -i . -o HTML doc -p doc/ndinfo