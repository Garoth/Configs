for x in *; do inkscape -z --export-png=${x%.svg}.png --export-height=32 $x; done
