# Stage 1: Build the app
FROM node:18-alpine as builder

# Add build-time environment variables
ARG VITE_API_URL
ENV VITE_API_URL=$VITE_API_URL

WORKDIR /app
COPY package*.json ./
RUN npm install
COPY . .
RUN npm run build # Outputs to '/app/dist'

# Stage 2: Serve with Nginx
FROM nginx:alpine
COPY --link --from=builder /app/dist /usr/share/nginx/html
COPY --link nginx.conf /etc/nginx/conf.d/default.conf
EXPOSE 8080
