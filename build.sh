# create and empty build folder
rm -rf ./build/*
mkdir -p ./build/de.wargamer.anime.teamspeak

# collect files
cp $(ls styles/**/*.{gif,png,css}) build/de.wargamer.anime.teamspeak/

# merge json files
jq -s '.' $(find ./styles/**/* | grep json) > build/themes.json
jq -s '.[0] + (.content.themes = .[1])' styles/package.json build/themes.json > build/de.wargamer.anime.teamspeak/package.json
jq -c --slurpfile themes build/themes.json '.content.themes |= $themes[0]' styles/package.json > build/de.wargamer.anime.teamspeak/package.json

# zip files
cd build
zip -r9 AnimeSpeak.zip de.wargamer.anime.teamspeak