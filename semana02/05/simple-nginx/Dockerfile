FROM nginx:alpine
LABEL maintainer="asialer05@hotmail.com"
COPY index.html /usr/share/nginx/html/index.html
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
HEALTHCHECK CMD ["curl", "--fail", "http://localhost"]