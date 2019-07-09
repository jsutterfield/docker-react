# For the first phase, build the application in a container
# and give that container the name "builder". We'll later extract
# only the built files we need from that container and put them in
# our nginx image
FROM node:alpine as builder
WORKDIR '/app'
COPY package.json .
RUN npm install
COPY . .
RUN npm run build

# Create a new image based on nginx. Anything before this
# FROM can be reference, but won't be included in the final
# image unless expclicitly added. Here we'll copy over the
# the built production files (leaving behind all the node_modules
# we used to build those files) into the nginx directory used to
# serve content.
FROM nginx
COPY --from=builder /app/build /usr/share/nginx/html
