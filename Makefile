watch:
	node_modules/stylus/bin/stylus --out lib/ --watch src/*.styl &
	node_modules/coffee-script/bin/coffee -o lib/ -cw src/*.coffee 
