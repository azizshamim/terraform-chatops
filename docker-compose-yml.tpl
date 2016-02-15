mongo:
  image: mongo
  volumes:
    - ./data/runtime/db:/data/db
    - ./data/dump:/data/dump
  command: mongod --smallfiles --oplogSize 128

rocketchat:
  image: rocketchat/rocket.chat:latest
  volumes:
    - ./uploads:/app/uploads
  environment:
    - PORT=3000
    - ROOT_URL=${root_url}
    - MONGO_URL=mongodb://mongo:27017/rocketchat
  links:
    - mongo:mongo
  ports:
    - 3000:3000

# hubot, the popular chatbot (add the bot user first and change the password before starting this image)
hubot:
  image: rocketchat/hubot-rocketchat
  environment:
    - ROCKETCHAT_URL=rocketchat:3000
    - ROCKETCHAT_ROOM=GENERAL
    - ROCKETCHAT_USER=${rocketchat_user}
    - ROCKETCHAT_PASSWORD=${rocketchat_password}
# hubot-github-repo-event-notifier
    - HUBOT_GITHUB_EVENT_NOTIFIER_TYPES=issues,page_build,pull_request,push
    - BOT_NAME=hubot
    - HUBOT_LOG_LEVEL=debug
# you can add more scripts as you'd like here, they need to be installable by npm
    - EXTERNAL_SCRIPTS=hubot-help,hubot-seen,hubot-links,hubot-diagnostics,hubot-github-repo-event-notifier
  links:
    - rocketchat:rocketchat
# this is used to expose the hubot port for notifications on the host on port 3001, e.g. for hubot-jenkins-notifier
  ports:
    - 3001:8080