FNAME=cartoon-$( date +%F ).json
PNGNAME=cartoon-$( date +%F ).png

SIZE=$( stat --printf="%s" ${PNGNAME} )

echo "The file size is ${SIZE}"

echo "initing..."
twurl -H upload.twitter.com "/1.1/media/upload.json" -d "command=INIT&media_type=image/png&total_bytes=${SIZE}" | tee /tmp/twurl
echo

MEDIA_ID=$( cat /tmp/twurl | jq '.media_id_string' -r )

echo "Received media id: ${MEDIA_ID}"

echo "appending..."
twurl -H upload.twitter.com "/1.1/media/upload.json" -d "command=APPEND&media_id=${MEDIA_ID}&segment_index=0" -f ./${PNGNAME} -F media
echo

echo "finalizing..."
twurl -H upload.twitter.com "/1.1/media/upload.json" -d "command=FINALIZE&media_id=${MEDIA_ID}" | tee /tmp/twurl
echo

ENGLISH=$(  cat ${FNAME} | jq -r '.english'  )
RUSSIAN=$(  cat ${FNAME} | jq -r '.russian'  )

TWEETBODY=`cat <<EOF
The russian word of the day is "${RUSSIAN}".
It means "${ENGLISH}".
EOF
`

echo "tweeting..."
twurl -d "media_ids=${MEDIA_ID}&status=${TWEETBODY}" /1.1/statuses/update.json
