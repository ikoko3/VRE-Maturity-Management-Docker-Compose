# images/keycloak/Dockerfile
FROM quay.io/keycloak/keycloak:latest
COPY import/ /opt/keycloak/data/import/
# (Optional) build for faster startup:
# RUN /opt/keycloak/bin/kc.sh build
