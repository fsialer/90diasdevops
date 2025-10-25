# Worker Service - Node.js application
FROM node:lts-alpine

WORKDIR /app

# Install system dependencies
RUN apk add --no-cache curl

# Copy package files
COPY package*.json ./

# Install dependencies
RUN npm install --only=production && npm cache clean --force

# Copy application code
COPY . .

# Create non-root user
RUN addgroup -g 1001 -S nodejs && \
    adduser -S worker -u 1001 -G nodejs

# Change ownership of the app directory
RUN chown -R worker:nodejs /app
USER worker

# Health check
HEALTHCHECK --interval=30s --timeout=10s --start-period=10s --retries=3 \
  CMD curl -f http://localhost:3000/healthz || exit 1

# Expose port
EXPOSE 3000

# Start the application
CMD ["node", "main.js"]