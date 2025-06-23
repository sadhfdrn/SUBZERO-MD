FROM node:20-bullseye

# Switch to root user for system operations
USER root

# Update package lists and install FFmpeg, webp, git and other dependencies
RUN apt-get update && \
    apt-get install -y ffmpeg webp git && \
    apt-get upgrade -y && \
    rm -rf /var/lib/apt/lists/*

# Set environment variables for FFmpeg (optional but recommended)
ENV FFMPEG_PATH=/usr/bin/ffmpeg
ENV FFPROBE_PATH=/usr/bin/ffprobe

# Switch back to node user for security
USER node

# Clone the SUBZERO-MD repository
RUN git clone https://github.com/mrfrankofcc/SUBZERO-MD.git /home/node/SUBZERO-MD

# Set working directory
WORKDIR /home/node/SUBZERO-MD

# Set permissions
RUN chmod -R 777 /home/node/SUBZERO-MD/

# Install dependencies using yarn
RUN yarn install --network-concurrency 1 --ignore-engines

# Add the TikTok API dependency (only if not already in package.json)
RUN yarn add "@tobyg74/tiktok-api-dl@^1.3.2"

# Expose port
EXPOSE 7860

# Set environment
ENV NODE_ENV=production

# Start the application
CMD ["npm", "start"]
