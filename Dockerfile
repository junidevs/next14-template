FROM node:20-alpine

USER root

ARG NEXT_PUBLIC_DEPLOY_TARGET
ENV NEXT_PUBLIC_DEPLOY_TARGET=${NEXT_PUBLIC_DEPLOY_TARGET}

#RUN apk add --no-cache bash

RUN addgroup -S docker
RUN adduser \
       -S \
       -s /bin/sh \
       -G docker \
       -D \
        docker

COPY   . /app
RUN chown docker:docker -R /app \
    && mkdir -p  /app/node_modules/.cache \
    && chmod 777 -R /app
USER docker
ENV PATH /app/node_modules/.bin:$PATH
EXPOSE 3000
WORKDIR /app
ENV NODE_OPTIONS --max_old_space_size=3072
RUN npm install && npm run build:prod

CMD ["npm" , "run", "start:prod"]
