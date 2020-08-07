FROM node:lts-alpine as build-deps

WORKDIR /usr/src/app

RUN npm i gitfolio -g --silent
RUN gitfolio build gregoire78 --sort updated --order desc --theme light --background https://wallpaper-house.com/data/out/6/wallpaper2you_89162.jpg

EXPOSE 3000

FROM nginx:alpine

LABEL maintainer="gregoire@joncour.tech"
LABEL author="Grégoire Joncour"
LABEL website="https://gregoirejoncour.xyz"
LABEL description="personal website and blog"

COPY --from=build-deps /usr/src/app/dist /usr/share/nginx/html
RUN echo 'server_tokens off;' > /etc/nginx/conf.d/server_tokens.conf
RUN echo $'server {\n\
    listen 80;\n\
    location / { \n\
    root /usr/share/nginx/html;\n\
    index index.html index.htm;\n\
    try_files $uri $uri/ /index.html; \n\
    }\n\
    }'\
    > /etc/nginx/conf.d/default.conf
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]