if functions -q deactivate-lua
    deactivate-lua
end

function deactivate-lua
    if test -x '/home/travis/build/TeamUlysses/ulx4/env/bin/lua'
        eval ('/home/travis/build/TeamUlysses/ulx4/env/bin/lua' '/home/travis/build/TeamUlysses/ulx4/env/bin/get_deactivated_path.lua' --fish)
    end

    functions -e deactivate-lua
end

set -gx PATH '/home/travis/build/TeamUlysses/ulx4/env/bin' $PATH
