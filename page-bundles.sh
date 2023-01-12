for FILE in *.md
do
  # remove the last dot and subsequent chars to name the folder from the .md
  DIR="${FILE%.*}"
  mkdir -p "$DIR"
  mv "$FILE" "$DIR"
done
find ./ -iname '*.md' -execdir mv -i '{}' index.md \;
