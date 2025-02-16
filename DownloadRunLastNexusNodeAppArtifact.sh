#!bin/bash
file_name=node-app.tgz
folder_name=node-app

rm -rf package $folder_name

curl -u user:password -L -X GET "http://144.126.218.34:8081/service/rest/v1/search/assets/download?sort=version&repository=hosted-repositories-node-app" -H "accept: application/json" > $file_name
tar -xvzf $file_name

mkdir $folder_name
mv package/* $folder_name
cd $folder_name
npm install
npm run start &