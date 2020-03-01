#! /bin/bash

function vow() 
{
		s=aeoiu
		p=$(( $RANDOM % 5))
		echo -n ${s:$p:1}
}

function cons() 
{
		s=zxcvbnmsdfghjklpytrwq
		p=$(( $RANDOM % 21))
		echo -n ${s:$p:1}
}

function clip()
{
	echo "$1" | tr -d '\n' | xclip -sel clip
}

function beep()
{
	play -q -n synth 0.1 sin 880
}

function upload_file
{
	url="https://ftp.nerdkiller.com"
	word=`cons; vow; cons; vow; cons; vow`
	date=$(date +%s)
	ext=""
	ext="${fname##*.}"
	if [[ $1 == *.* ]]; then
		fname=$(basename -- "$1")
		ext=".${fname##*.}"
	fi
	id="$word-$date$ext"
	url="$url/$id"
	scp -i ~/.ssh/id_rsa_nk "$1" nk@nerdkiller.com:/var/www/nkftp/"$id"
	clip "$url"
	beep
}

function upload_text
{
	dtime=`date '+%Y-%m-%d-%H:%M:%S'`

	id=$(curl https://paste.merkoba.com/save.php \
	--data-urlencode "content=${1}" \
	--data-urlencode "comment=${dtime}" \
	--data-urlencode "mode_name=Rust" | jq -r '.url')

	url="https://paste.merkoba.com/${id}"
	clip "$url"
	beep
}

if [[ $# -gt 0 ]]; then
	for file in "$@"
	do
		upload_file "$1"
	done

else
	content=$(xclip -se c -o)
	if [[ $content == "x-special"* ]]; then
		content=$(echo "$content" | sed '/^x\-special/d')
		content=$(echo "$content" | sed '/^copy$/d')
	fi

	if [[ $content == "file://"* ]]; then
		IFS=$'\n'; files=($content); unset IFS

		for (( i=0; i<${#files[@]}; i++ ))
		do
			file=$(echo "${files[$i]#file://}")
			upload_file "$file"
		done
	
	else
		upload_text "$content"
	fi
fi
