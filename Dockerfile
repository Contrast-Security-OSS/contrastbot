FROM node:alpine

# Environment variables
ENV HUBOT_NAME=ContrastHubot
ENV HUBOT_OWNER=none
ENV HUBOT_DESCRIPTION=Hubot

RUN apk add --no-cache bash python py-pip jq && \
	pip install awscli

RUN adduser -D -u 1010 hubot

RUN npm install -g hubot coffeescript yo generator-hubot

USER hubot

WORKDIR /home/hubot

COPY --chown=hubot init.sh .

RUN yo hubot --owner="${HUBOT_OWNER}" --name="${HUBOT_NAME}" --description="${HUBOT_DESCRIPTION}" --defaults

COPY --chown=hubot external-scripts.json .

RUN	npm install --save \
		hubot-slack \
		hubot-scripts && \
	sed -i '/npm install/d' bin/hubot && \
	npm install --save $(jq -c -r '.[]' external-scripts.json | tr '\n' ' ') && \
	chmod +x init.sh

CMD ["/home/hubot/init.sh"]