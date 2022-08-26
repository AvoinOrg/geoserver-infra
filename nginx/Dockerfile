FROM nginx:1.23.1

COPY ./config/ /etc/nginx/

# Add env variables to conf files with the entrypoint
COPY docker-entrypoint.sh /

ENTRYPOINT ["/docker-entrypoint.sh"]

CMD ["nginx", "-g", "daemon off;"]

EXPOSE 80 443