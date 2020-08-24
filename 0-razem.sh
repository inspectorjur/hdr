#! /bin/bash

#FILES=./*+1.jpg
#for f in $FILES
#do
#  echo "${f:2:17}+1.jpg"
#  echo "${f:2:17}+2.jpg"
#  echo "${f:2:17}+3.jpg"
#  mkdir "${f:2:17}"
#  mv ${f:2:17}*.jpg  ${f:2:17}
#  ./createHDR.sh ${f:2:17}
#  cd ${f:2:17} 
#  mogrify -flatten -format jpg *.xcf
#  rm HDR*.xcf
#  mv HDR*.jpg ../${f:2:17}HDR.jpg

#  cd ..
#done

FILES=./*+1.jpg

mkdir al

for f in $FILES
do

if [ ! -e "${f:2:17}+1.jpg" ]; then
	echo "${f:2:19}.jpg nie ma 1 - koniec parowania"


else
#	echo "${f:2:19}.jpg - jest 1"


	if [ ! -e "${f:2:17}+2.jpg" ]; then
    		echo "${f:2:19}.jpg nie ma 2"
else
		if [ ! -e "${f:2:17}+3.jpg" ]; then
			echo "${f:2:19}.jpg nie ma 3"
		else
echo "${f:2:19}.jpg - jest wszystko"

  mkdir "${f:2:17}"

  mv ${f:2:17}*.jpg  ${f:2:17}

#  ./createHDR.sh ${f:2:17}
  cp levelPics.pl ${f:2:17}/levelPics.pl
  cd ${f:2:17} 
  enfuse -o ${f:2:17}HDR.jpg  ${f:2:17}*.jpg 
  ./levelPics.pl -i "${f:2:17}HDR.jpg" -o "1"
  mv 1/${f:2:17}HDR.jpg ../al/${f:2:17}HDR_AL.jpg

#  mogrify -flatten -format jpg *.xcf
#  rm HDR*.xcf
#  mv HDR*.jpg ../${f:2:17}HDR.jpg
  cd ..

		fi


	fi

fi

done

cd al
n=0
for file in *.jpg; do
  printf -v new "%05d.jpg" "$((++n))"
  mv -v -- "$file" "$new"
done


ffmpeg -framerate 25 -i %05d.jpg -c:v libx264 -profile:v high  -pix_fmt yuv420p ${f:2:17}.mp4

mv ${f:2:17}.mp4 ../${f:2:17}.mp4
