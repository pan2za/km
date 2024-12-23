docker rm kykms

docker rmi kykms

./compile

#docker cp compiled-jar-container-id: target/jar.jar jee-system/target/jar

docker cp 1a50f4c4b61c:/km_community/jeecg-boot/jeecg-boot-module-system/target/jeecg-boot-module-system-2.4.5.jar jeecg-boot-module-system/target/

docker-compose up
