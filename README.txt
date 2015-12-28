for sounds, look at the sounds branch:
https://github.com/HybridDog/MinetestAmbience/tree/sounds

to download them parallel, use this command:
$ for i in $(curl -s https://github.com/HybridDog/Ambience/tree/sounds/testsounds | ag /HybridDog/Ambience/blob/sounds/testsounds/ |  sed -e :a -e 's/<[^>]*>//g;/</N;//ba' | sed 's/^[ \t]*//' | sed 's/ /§/g'); do (ru=$(echo $i | sed 's/§/%20/g'); i=$(echo $i | sed 's/§/ /g'); if [ ! -e "$i" ]; then curl -s https://raw.githubusercontent.com/HybridDog/Ambience/sounds/testsounds/$ru > "$i"; echo $i loaded; fi) & done
you may need to use grep if you didn't install silversearcher ag
