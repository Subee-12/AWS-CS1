#!/bin/bash
yum update -y
yum install -y nginx
systemctl enable nginx
systemctl start nginx

TOKEN=$(curl -s -X PUT "http://169.254.169.254/latest/api/token" -H "X-aws-ec2-metadata-token-ttl-seconds: 21600")
INSTANCE_ID=$(curl -s -H "X-aws-ec2-metadata-token: $TOKEN" http://169.254.169.254/latest/meta-data/instance-id)
AZ=$(curl -s -H "X-aws-ec2-metadata-token: $TOKEN" http://169.254.169.254/latest/meta-data/placement/availability-zone)

if [[ "$AZ" == *"a" ]]; then
  SERVER_LABEL="Webserver 1"
else
  SERVER_LABEL="Webserver 2"
fi

cat > /usr/share/nginx/html/index.html << HTML
<!DOCTYPE html>
<html lang="nl">
<head>
<meta charset="UTF-8">
<title>Innovatech Solutions</title>
<style>
  body {
    margin: 0;
    font-family: 'Segoe UI', Arial, sans-serif;
    background: #0f172a;
    color: #f1f5f9;
    display: flex;
    align-items: center;
    justify-content: center;
    height: 100vh;
  }
  .card {
    background: #1e293b;
    padding: 48px 56px;
    border-radius: 12px;
    box-shadow: 0 10px 30px rgba(0,0,0,0.4);
    text-align: center;
    border: 1px solid #334155;
  }
  h1 {
    margin: 0 0 8px;
    font-size: 28px;
    color: #38bdf8;
  }
  p.tagline {
    margin: 0 0 32px;
    color: #94a3b8;
    font-size: 14px;
  }
  .badge {
    display: inline-block;
    background: #0ea5e9;
    color: #0f172a;
    font-weight: 600;
    padding: 10px 24px;
    border-radius: 999px;
    font-size: 18px;
    margin-bottom: 16px;
  }
  .meta {
    font-size: 13px;
    color: #64748b;
    font-family: monospace;
  }
</style>
</head>
<body>
  <div class="card">
    <h1>Innovatech Solutions CI/CD test</h1>
    <p class="tagline">Cloud &amp; Network Automation Platform</p>
    <div class="badge">$SERVER_LABEL</div>
    <div class="meta">Instance ID: $INSTANCE_ID<br>Availability Zone: $AZ</div>
  </div>
</body>
</html>
HTML
