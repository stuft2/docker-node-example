FROM node:20-slim as base

# Pass in the port (--build-arg="PORT=XXXX") or it defaults to 8080.
ARG PORT=8080

# The folder in the container where everything will be installed
WORKDIR /opt/app

# Build and run in production mode
ENV NODE_ENV="production"

# Copy over package.json (and package-lock.json) first and do an npm install
# It allows us to use Docker image caching on subsequent builds (unless we update package.json)
COPY package*.json ./
RUN npm ci

# Copy over source files
COPY routes/ routes/
COPY plugins/ plugins/
COPY app.js/ ./

# Set Environment Variables
ENV PORT=$PORT

# Export the port on the container
EXPOSE $PORT

# Limit this container's permissions on the file system to only run node
USER node

# Specify the command to start the application
CMD ["npm", "start"]
