FNAME=cartoon-$( date +%F ).json
ENGLISH=$(  cat ${FNAME} | jq -r '.english'  )
RUSSIAN=$(  cat ${FNAME} | jq -r '.russian'  )
DAVE=$(     cat ${FNAME} | jq -r '.dave'     )
EMPLOYEE=$( cat ${FNAME} | jq -r '.employee' )

echo "The russian word of the day is \"${RUSSIAN}\"."
echo "It means \"${ENGLISH}\"."
SVGNAME=cartoon-$( date +%F ).svg
cp template.svg ${SVGNAME}
sed -i "s/Dave talking/${DAVE}/g" ${SVGNAME}
sed -i "s/Cool dude talking/${EMPLOYEE}/g" ${SVGNAME}
PNGNAME=cartoon-$( date +%F ).png
inkscape -z -b white -e ${PNGNAME} ${SVGNAME}
