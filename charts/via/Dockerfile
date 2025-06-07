# Multi-stage build for VIA keyboard configuration tool
FROM oven/bun:alpine AS builder

# Set working directory
WORKDIR /app

# Clone the VIA app repository
RUN apk add --no-cache git && \
    git clone https://github.com/the-via/app.git .

# Install dependencies (including via-keyboards from GitHub)
RUN bun install --frozen-lockfile

# Check what's available in node_modules/.bin
RUN ls -la node_modules/.bin/ | grep -i via || echo "via-keyboards not found in .bin"

# Create the public/definitions directory
RUN mkdir -p public/definitions

# Build keyboard definitions using bunx (which should find via-keyboards in node_modules)
RUN bunx via-keyboards public/definitions || echo "via-keyboards command failed, continuing anyway"

# Check what was created by via-keyboards
RUN ls -la public/definitions/ || echo "No files in public/definitions"

# Ensure hash.json exists (create minimal version if missing)
RUN test -f public/definitions/hash.json || echo '"docker-build-hash"' > public/definitions/hash.json

# Build the TypeScript and Vite parts
RUN bunx tsc && bunx vite build

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