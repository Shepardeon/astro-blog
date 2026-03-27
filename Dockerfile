# Stage 1 - Install deps

FROM node:lts-alpine as deps
WORKDIR /app

COPY package*.json ./

RUN npm ci

# Stage 2 - Build static site

FROM node:lts-alpine as builder
WORKDIR /app

COPY --from=deps /app/node_modules ./node_modules
COPY . .

RUN npm run build

# Stage 3 - Serve with Nginx

FROM nginx:alpine as runner

COPY ci/nginx.conf /etc/nginx/conf.d/default.conf
COPY --from=builder /app/dist /usr/share/nginx/html

EXPOSE 80