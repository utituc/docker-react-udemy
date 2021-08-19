# setup for a multi-base-image process:

FROM node:alpine as builder

USER node
 
RUN mkdir -p /home/node/app
WORKDIR /home/node/app
 
COPY --chown=node:node ./package.json ./
RUN npm install
COPY --chown=node:node ./ ./
RUN npm run build

# .../app/build is the target directory for all build steps

# next bsae image -> automatically "ends" the block before ("builder")

FROM nginx

COPY --from=builder /home/node/app/build /usr/share/nginx/html
# --from=builder references the phase before
# the target path /usr/share... can be found in the nginx-docs
# https://hub.docker.com/_/nginx
