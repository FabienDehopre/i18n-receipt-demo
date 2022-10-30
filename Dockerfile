### STAGE 1:BUILD ###
# Defining a node image to be used as giving it an alias of "build"
# Which version of Node image to use depends on project dependencies
# This is needed to build and compile our code
# while generating the docker image
FROM node:18-alpine AS build
# Create a Virtual directory inside the docker image
WORKDIR /dist/src/app
# Copy files to virtual directory
# COPY package.json package-lock.json ./
# Run command in Virtual directory
RUN npm cache clean --force
# Copy files from local machine to virtual directory in docker image
COPY . .
RUN npm install
RUN npm run build


### STAGE 2:RUN ###
# Defining nginx image to be used
FROM nginx:alpine AS ngi
# Copying compiled code and nginx config to different folder
# NOTE: This path may change according to your project's output folder
COPY --from=build /dist/src/app/dist/i18n-receipt-demo /usr/share/nginx/html
COPY /nginx.conf  /etc/nginx/conf.d/default.conf
RUN curl https://ssl-config.mozilla.org/ffdhe4096.txt > /etc/ssl/ffdhe4096.pem

VOLUME /etc/ssl/dehopre.dev
# Exposing a port, here it means that inside the container
# the app will be using Port 80 and 443 while running
EXPOSE 80
EXPOSE 443
HEALTHCHECK --interval=5m --timeout=3s CMD curl -f http://localhost/ || exit 1
