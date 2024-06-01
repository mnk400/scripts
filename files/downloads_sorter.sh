#!/bin/bash

# Required parameters:
# @raycast.schemaVersion 1
# @raycast.title Downloads Sorter
# @raycast.mode silent

# Optional parameters:
# @raycast.icon ../icons/down.png


# Documentation:
# @raycast.description Sorts the files in the downloads directory into sub-directories
# @raycast.author Manik

cd "/Users/manik/Downloads"

mv *.jpg *.png *.jpeg *.gif *.webp "/Users/manik/Downloads/Downloaded Photos"
mv *.pdf *.txt *.wordx "/Users/manik/Downloads/Downloaded Documents"
mv *.app *.dmg *.pkg "/Users/manik/Downloads/Downloaded Applications"
mv *.* "/Users/manik/Downloads/Other Downloads"

echo "Downloads folder organized"