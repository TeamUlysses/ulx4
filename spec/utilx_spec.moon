moonscript = require "moonscript"
moonscript.dofile "moon/utilx.moon"

describe "Test Utilities", ->
	it "checks Round() compliance", ->
		assert.equal( UtilX.Round( 41.41 ), 41 )
		assert.equal( UtilX.Round( 41.50, 0 ), 42 )
		assert.equal( UtilX.Round( 41.499999999999, 0 ), 41 )
		assert.equal( UtilX.Round( 414, -1 ), 410 )
		assert.equal( UtilX.Round( 41.4099, 2 ), 41.41 )
		return
