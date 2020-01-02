#!/bin/bash

### inspired from dumpdecrypted-tui
### and iAdam1n/App-Headers repo

FILEPATH="/var/mobile/Containers/Bundle/Application"
APPS=$FILEPATH/*/*.app
DUMPER="classdump-dyld"

APPSNAME=""
for FILE in $APPS
do
	APPSNAME=$APPSNAME`basename "$FILE"`$'\n' 
done

OIFS="$IFS"
IFS=$'\n'
echo "classdump-apps script inpsired from Henkru's dumpdecrypted-tui"
echo "https://github.com/Henkru/dumpdecrypted-tui"
echo "idea come after seeing iAdam1n's App Headers repo"
echo "@iMokhles"
echo ""
echo ""
echo "Select App to dump"
select FILE in $APPSNAME;
do
     APPNAME="${FILE%.*}"
     $DUMPER $FILEPATH/*/$FILE/$APPNAME -o /var/root/$APPNAME-Headers

     break
done
IFS="$OIFS"