which deactivate-lua >&/dev/null && deactivate-lua

alias deactivate-lua 'if ( -x '\''/home/travis/build/TeamUlysses/ulx4/env/bin/lua'\'' ) then; setenv PATH `'\''/home/travis/build/TeamUlysses/ulx4/env/bin/lua'\'' '\''/home/travis/build/TeamUlysses/ulx4/env/bin/get_deactivated_path.lua'\''`; rehash; endif; unalias deactivate-lua'

setenv PATH '/home/travis/build/TeamUlysses/ulx4/env/bin':"$PATH"
rehash
