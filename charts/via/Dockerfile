# Multi-stage build for VIA keyboard configuration tool
FROM node:22 AS builder

# Set working directory
WORKDIR /app

# Install system dependencies and bun
RUN apt-get update && apt-get install -y jq xdg-utils git curl unzip && \
    curl -fsSL https://bun.sh/install | bash && \
    ln -s /root/.bun/bin/bun /usr/local/bin/bun && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

# Clone the VIA app repository
RUN git clone https://github.com/the-via/app.git .

# Install dependencies (including via-keyboards from GitHub)
RUN npm install

# Build with azure script which handles refresh-kbs and build properly
RUN npm run build:azure

# Production stage
FROM nginx:1.27.5-alpine

# Copy the built app from the builder stage
COPY --from=builder /app/dist /usr/share/nginx/html

# Copy custom nginx configuration
COPY nginx.conf /etc/nginx/nginx.conf

# Set proper permissions
RUN chown -R nginx:nginx /usr/share/nginx/html && \
    chown -R nginx:nginx /var/cache/nginx && \
    chown -R nginx:nginx /var/log/nginx && \
    chown -R nginx:nginx /etc/nginx/conf.d

# Create directories for nginx to write to
RUN mkdir -p /tmp/nginx && \
    chown -R nginx:nginx /tmp/nginx

# Switch to non-root user
USER nginx

# Expose port 8080 (non-privileged port)
EXPOSE 8080

# Health check
HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
    CMD wget --no-verbose --tries=1 --spider http://localhost:8080/ || exit 1

CMD ["nginx", "-g", "daemon off;"]
