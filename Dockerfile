# Create image based on the Skaffolder Node ES6 image
FROM node:14.11.0-alpine as build-step

# Copy source files
WORKDIR /app
COPY package.json ./

# Install dependencies
RUN npm install

COPY . .
# Build prod
RUN npm run build


# ----------------------------------
# Prepare production environment
FROM nginx:1.16.0-alpine as prod-stage
# ----------------------------------


# Copy dist
COPY --from=build-step /app/dist/angular-docker-kubernetes /usr/share/nginx/html
#COPY nginx.conf /etc/nginx/nginx.conf

#WORKDIR /usr/share/nginx/html

# Permission
RUN chown root /usr/share/nginx/html/*
RUN chmod 755 /usr/share/nginx/html/*

# Expose port
EXPOSE 2000

# Start
CMD ["nginx", "-g", "daemon off;"]

