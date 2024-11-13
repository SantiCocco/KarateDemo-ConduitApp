# Imagen base con Maven y JDK 11
FROM maven:3.6.3-jdk-11

# Directorio de trabajo
WORKDIR /usr/scr/app

# Copia el archivo pom.xml
COPY pom.xml /usr/scr/app

# Copia las pruebas de Java al contenedor
COPY ./src/test/java /usr/scr/app/test/java