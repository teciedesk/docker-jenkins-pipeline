# Use an official Nginx image
FROM nginx:latest

# Copy static files or configuration (adjust as needed)
COPY index.html /usr/share/nginx/html/index.html

# Expose port 80
EXPOSE 80

# Start Nginx
CMD ["nginx", "-g", "daemon off;"]
