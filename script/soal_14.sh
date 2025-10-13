#!/bin/bash

#Sirion

echo "🔄 Configuring Sirion to forward real IP headers..."

# Step 1: Install Nginx if not already installed
echo "🔄 Installing Nginx..."
apt-get update
apt-get install -y nginx
echo "✅ Nginx installed"

# Step 2: Configure Nginx as reverse proxy with IP forwarding
echo "🔄 Configuring reverse proxy..."

cat > /etc/nginx/sites-available/sirion << 'EOF'
server {
    listen 80;
    server_name sirion.k38.com www.k38.com;

    # Proxy for /app to Vingilot
    location /app {
        proxy_pass http://192.230.3.6/;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
    }

    # Proxy for root to Vingilot app
    location / {
        proxy_pass http://192.230.3.6/;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
    }

    # Logging
    access_log /var/log/nginx/sirion-access.log;
    error_log /var/log/nginx/sirion-error.log;
}
EOF
echo "✅ Reverse proxy configuration created"

# Step 3: Enable site
ln -sf /etc/nginx/sites-available/sirion /etc/nginx/sites-enabled/sirion
rm -f /etc/nginx/sites-enabled/default
echo "✅ Site enabled"

# Step 4: Test and restart Nginx
echo "🔄 Testing Nginx configuration..."
nginx -t

echo "🔄 Restarting Nginx..."
pkill nginx
nginx
echo "✅ Nginx restarted"

echo "🎉 Sirion reverse proxy configuration completed!"

#Verification

echo "🔍 Testing Real IP Logging..."

# Step 1: Test access through Sirion
echo "1. Testing access through Sirion reverse proxy..."
echo "Response from www.k38.com/app:"
curl -s http://www.k38.com/app/ | head -10

# Step 2: Check Vingilot logs for real IP
echo ""
echo "2. Checking Vingilot access logs..."
echo "Please run this command on VINGILOT to see the logs:"
echo "tail -f /var/log/nginx/access.log"
echo ""
echo "The log should show your REAL client IP, not Sirion's IP (192.230.3.2)"

# Step 3: Test direct access to Vingilot for comparison
echo ""
echo "3. Testing direct access to Vingilot (for comparison)..."
direct_response=$(curl -s http://192.230.3.6/ | head -5)
echo "Direct access response:"
echo "$direct_response"

# Step 4: Show expected log format
echo ""
echo "4. Expected log format in Vingilot:"
echo "   REAL_CLIENT_IP - - [timestamp] \"GET /app/ HTTP/1.1\" 200 ..."
echo ""
echo "❌ If you see 192.230.3.2 in logs → Real IP not working"
echo "✅ If you see your client IP (e.g., 192.230.2.x) → Real IP working"

echo ""
echo "🎉 Real IP logging test completed!"

#monitoring

echo "📊 Monitoring Real IP Logs on Vingilot..."

echo "Current access logs:"
echo "==================="
tail -10 /var/log/nginx/access.log

echo ""
echo "Live log monitoring (Ctrl+C to stop):"
echo "====================================="
tail -f /var/log/nginx/access.log
