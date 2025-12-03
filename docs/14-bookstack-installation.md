# BookStack Installation and Setup

## Overview

BookStack is a free, open-source wiki and documentation platform that's perfect for organizing and sharing knowledge. This guide covers installing BookStack on your Geekom AX8, including setup, configuration, and migrating content from this repository.

## What is BookStack?

**BookStack** is a simple, self-hosted platform for organizing and storing information. Think of it as your own personal Wikipedia or documentation system.

**Key Features:**
- Clean, intuitive interface
- Hierarchical organization (Books → Chapters → Pages)
- Full-text search
- WYSIWYG editor with Markdown support
- User permissions and roles
- Multi-language support
- Export to PDF/HTML/Markdown
- Image management
- API for automation
- Lightweight and fast

**Why Use BookStack?**
- Organize personal or team documentation
- Create knowledge bases
- Document projects and processes
- Store and share technical documentation
- Build internal wikis
- Centralize information

**System Requirements:**
- PHP 8.1+
- MySQL 5.7+ or MariaDB 10.2+
- Web server (Apache/Nginx)
- 512MB RAM minimum (2GB+ recommended)
- The Geekom AX8 easily exceeds these requirements

## Installation Methods

### Method 1: Using Docker (Recommended - Easiest)

Docker installation is the simplest and most reliable method.

#### Prerequisites
```bash
# Install Docker if not already installed
curl -fsSL https://get.docker.com | sudo bash

# Add user to docker group
sudo usermod -aG docker $USER
newgrp docker

# Install Docker Compose
sudo apt install -y docker-compose
```

#### Install BookStack with Docker Compose

1. **Create directory structure:**
```bash
mkdir -p ~/bookstack
cd ~/bookstack
```

2. **Create docker-compose.yml:**
```bash
cat > docker-compose.yml << 'EOF'
version: '3'

services:
  bookstack:
    image: lscr.io/linuxserver/bookstack:latest
    container_name: bookstack
    environment:
      - PUID=1000
      - PGID=1000
      - APP_URL=http://your-ax8-ip:6875  # Change this!
      - DB_HOST=bookstack_db
      - DB_PORT=3306
      - DB_USER=bookstack
      - DB_PASS=bookstack_secret_password  # Change this!
      - DB_DATABASE=bookstackapp
    volumes:
      - ./bookstack_app_data:/config
    ports:
      - 6875:80
    restart: unless-stopped
    depends_on:
      - bookstack_db

  bookstack_db:
    image: lscr.io/linuxserver/mariadb:latest
    container_name: bookstack_db
    environment:
      - PUID=1000
      - PGID=1000
      - MYSQL_ROOT_PASSWORD=root_secret_password  # Change this!
      - TZ=America/New_York  # Change to your timezone
      - MYSQL_DATABASE=bookstackapp
      - MYSQL_USER=bookstack
      - MYSQL_PASSWORD=bookstack_secret_password  # Match above!
    volumes:
      - ./bookstack_db_data:/config
    restart: unless-stopped
EOF
```

3. **Important: Edit the configuration:**
```bash
# Edit docker-compose.yml with your settings
nano docker-compose.yml

# Change:
# - APP_URL to your AX8's IP or domain
# - DB_PASS to a strong password
# - MYSQL_ROOT_PASSWORD to a strong password
# - TZ to your timezone
```

4. **Start BookStack:**
```bash
# Start containers
docker-compose up -d

# Check status
docker-compose ps

# View logs if needed
docker-compose logs -f bookstack
```

5. **Access BookStack:**
- Open browser to: `http://your-ax8-ip:6875`
- Default credentials:
  - Email: `admin@admin.com`
  - Password: `password`
- **IMPORTANT:** Change these immediately!

#### Docker Management Commands

```bash
# Stop BookStack
docker-compose down

# Start BookStack
docker-compose up -d

# Restart BookStack
docker-compose restart

# Update BookStack
docker-compose pull
docker-compose up -d

# View logs
docker-compose logs -f

# Backup (stop first)
docker-compose down
tar -czf bookstack-backup-$(date +%Y%m%d).tar.gz bookstack_app_data bookstack_db_data
docker-compose up -d
```

---

### Method 2: Native Installation (Ubuntu/Debian)

For users preferring traditional installation without Docker.

#### 1. Install Prerequisites

```bash
# Update system
sudo apt update && sudo apt upgrade -y

# Install required packages
sudo apt install -y apache2 mariadb-server php8.1 php8.1-cli php8.1-common \
  php8.1-mysql php8.1-xml php8.1-mbstring php8.1-gd php8.1-curl \
  php8.1-zip git curl wget unzip

# Enable Apache modules
sudo a2enmod rewrite
sudo systemctl restart apache2
```

#### 2. Configure Database

```bash
# Secure MariaDB installation
sudo mysql_secure_installation

# Create BookStack database
sudo mysql -u root -p << 'EOF'
CREATE DATABASE bookstack;
CREATE USER 'bookstack'@'localhost' IDENTIFIED BY 'your_secure_password';
GRANT ALL PRIVILEGES ON bookstack.* TO 'bookstack'@'localhost';
FLUSH PRIVILEGES;
EXIT;
EOF
```

#### 3. Install Composer

```bash
# Install Composer (PHP package manager)
php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"
php composer-setup.php
sudo mv composer.phar /usr/local/bin/composer
php -r "unlink('composer-setup.php');"
```

#### 4. Download and Install BookStack

```bash
# Create directory and set permissions
sudo mkdir -p /var/www/bookstack
sudo chown -R www-data:www-data /var/www/bookstack

# Clone BookStack
cd /var/www
sudo -u www-data git clone https://github.com/BookStackApp/BookStack.git --branch release --single-branch bookstack
cd bookstack

# Install PHP dependencies
sudo -u www-data composer install --no-dev

# Copy and configure environment file
sudo -u www-data cp .env.example .env
```

#### 5. Configure BookStack

```bash
# Edit .env file
sudo nano .env
```

Key settings to change:
```bash
APP_URL=http://your-ax8-ip
DB_HOST=localhost
DB_DATABASE=bookstack
DB_USERNAME=bookstack
DB_PASSWORD=your_secure_password

# Change to true for production
APP_DEBUG=false

# Generate application key (run after saving .env)
sudo -u www-data php artisan key:generate --force
```

#### 6. Run Database Migrations

```bash
# Run migrations to set up database tables
sudo -u www-data php artisan migrate --force

# Create storage symlink
sudo -u www-data php artisan storage:link
```

#### 7. Configure Apache

```bash
# Create Apache virtual host
sudo nano /etc/apache2/sites-available/bookstack.conf
```

Add configuration:
```apache
<VirtualHost *:80>
    ServerName your-ax8-ip
    ServerAdmin webmaster@localhost
    DocumentRoot /var/www/bookstack/public/

    <Directory /var/www/bookstack/public/>
        Options -Indexes +FollowSymLinks
        AllowOverride All
        Require all granted
    </Directory>

    ErrorLog ${APACHE_LOG_DIR}/bookstack-error.log
    CustomLog ${APACHE_LOG_DIR}/bookstack-access.log combined
</VirtualHost>
```

Enable site and restart:
```bash
# Enable site
sudo a2ensite bookstack.conf
sudo a2dissite 000-default.conf

# Test configuration
sudo apache2ctl configtest

# Restart Apache
sudo systemctl restart apache2
```

#### 8. Set Permissions

```bash
# Set correct permissions
cd /var/www/bookstack
sudo chown -R www-data:www-data .
sudo chmod -R 755 .
sudo chmod -R 775 storage bootstrap/cache public/uploads
```

#### 9. Access BookStack

- Open browser to: `http://your-ax8-ip`
- Default credentials:
  - Email: `admin@admin.com`
  - Password: `password`
- **Change these immediately!**

---

### Method 3: Using CasaOS App Store

If you have CasaOS installed (see [Home Server OS Guide](13-home-server-os.md)):

1. Open CasaOS dashboard
2. Go to App Store
3. Search for "BookStack"
4. Click Install
5. Configure settings in the installation wizard
6. Access via CasaOS dashboard

---

## Initial Configuration

### 1. Change Default Credentials

```
1. Login with admin@admin.com / password
2. Click profile icon (top right)
3. Select "Edit Profile"
4. Change email and name
5. Go to "Settings" → "Change Password"
6. Set a strong password
```

### 2. Basic Settings

Navigate to Settings (gear icon):

**General Settings:**
- **App Name**: Give your wiki a name (e.g., "AX8 Documentation")
- **App Logo**: Upload a custom logo
- **Default Language**: Choose your language
- **Allow Public Viewing**: Disable for private wiki

**Registration Settings:**
- **Allow Registration**: Disable (invite users manually)
- **Default Role**: Set to "Viewer" if enabled

**Authentication:**
- Consider setting up LDAP or SAML for team use
- Enable two-factor authentication for admins

### 3. Create Your First Book

```
1. Click "Books" in navigation
2. Click "Create New Book"
3. Enter name: "Geekom AX8 Documentation"
4. Add description
5. Set cover image (optional)
6. Click "Save Book"
```

---

## Migrating Content from This Repository

Now let's migrate the documentation from this repository into your BookStack instance.

### Strategy

We'll create a hierarchical structure in BookStack:
- **Book**: "Geekom AX8 Documentation"
- **Chapters**: Each major topic (Hardware, Installation, Setup, etc.)
- **Pages**: Individual documentation files

### Method 1: Manual Migration (Best Quality)

This gives you the most control and best formatting:

1. **Create Book Structure:**
```
Book: "Geekom AX8 Documentation"
  Chapter: "Hardware and Setup"
    - Page: "Hardware Specifications"
    - Page: "BIOS Configuration"
    - Page: "Linux Installation"
    - Page: "Peripheral Setup"
  
  Chapter: "Development and Security"
    - Page: "Development Setup"
    - Page: "AI & Machine Learning Setup"
    - Page: "Security Configuration"
  
  Chapter: "Access and Management"
    - Page: "Remote Access"
    - Page: "Cool Tools"
  
  Chapter: "Entertainment and Media"
    - Page: "Gaming Setup"
    - Page: "Video Streaming"
  
  Chapter: "Server and Self-Hosting"
    - Page: "Home Server Operating Systems"
    - Page: "BookStack Installation"
  
  Chapter: "Troubleshooting"
    - Page: "Troubleshooting Guide"
```

2. **Copy Content:**
   - Open a markdown file from the repository
   - Copy the content
   - Create new page in BookStack
   - Paste content (BookStack supports Markdown)
   - Use the Markdown editor (toggle in editor toolbar)
   - Adjust formatting as needed

3. **Handle Images:**
   - Download images from the repository
   - Upload to BookStack via the image manager
   - Update image references in content

### Method 2: Automated Import Script

Create a script to automate the import process:

```bash
#!/bin/bash
# bookstack-import.sh

# Configuration
BOOKSTACK_URL="http://your-ax8-ip:6875"
TOKEN_ID="your_token_id"
TOKEN_SECRET="your_token_secret"
DOCS_DIR="/home/runner/work/geek/geek/docs"

# Create API token first in BookStack:
# Settings → API Tokens → Create Token

# Function to create page
create_page() {
    local title="$1"
    local file="$2"
    local chapter_id="$3"
    
    # Read markdown content
    content=$(cat "$file")
    
    # Create page via API
    curl -X POST "${BOOKSTACK_URL}/api/pages" \
        -H "Authorization: Token ${TOKEN_ID}:${TOKEN_SECRET}" \
        -H "Content-Type: application/json" \
        -d "{
            \"book_id\": 1,
            \"chapter_id\": ${chapter_id},
            \"name\": \"${title}\",
            \"markdown\": $(echo "$content" | jq -Rs .)
        }"
}

# Example: Import hardware specs
create_page "Hardware Specifications" \
    "${DOCS_DIR}/01-hardware-specs.md" \
    1

# Add more calls for other files...
```

To use this script:

1. **Create API Token in BookStack:**
   - Go to Settings → API Tokens
   - Create new token
   - Copy Token ID and Token Secret

2. **Run the script:**
```bash
chmod +x bookstack-import.sh
./bookstack-import.sh
```

### Method 3: Using BookStack's API with Python

More robust solution with better error handling:

```python
#!/usr/bin/env python3
# bookstack_import.py

import os
import requests
import json
from pathlib import Path

# Configuration
BOOKSTACK_URL = "http://your-ax8-ip:6875"
TOKEN_ID = "your_token_id"
TOKEN_SECRET = "your_token_secret"
DOCS_DIR = "/home/runner/work/geek/geek/docs"

# API headers
headers = {
    "Authorization": f"Token {TOKEN_ID}:{TOKEN_SECRET}",
    "Content-Type": "application/json"
}

def create_book(name, description=""):
    """Create a new book"""
    data = {
        "name": name,
        "description": description
    }
    response = requests.post(
        f"{BOOKSTACK_URL}/api/books",
        headers=headers,
        json=data
    )
    return response.json()

def create_chapter(book_id, name, description=""):
    """Create a new chapter"""
    data = {
        "book_id": book_id,
        "name": name,
        "description": description
    }
    response = requests.post(
        f"{BOOKSTACK_URL}/api/chapters",
        headers=headers,
        json=data
    )
    return response.json()

def create_page(book_id, chapter_id, name, markdown_content):
    """Create a new page"""
    data = {
        "book_id": book_id,
        "chapter_id": chapter_id,
        "name": name,
        "markdown": markdown_content
    }
    response = requests.post(
        f"{BOOKSTACK_URL}/api/pages",
        headers=headers,
        json=data
    )
    return response.json()

def import_docs():
    """Main import function"""
    # Create main book
    book = create_book(
        "Geekom AX8 Documentation",
        "Complete guide for setting up and using the Geekom AX8"
    )
    book_id = book["id"]
    
    # Create chapters and import pages
    docs = [
        {
            "chapter": "Hardware and Setup",
            "pages": [
                ("Hardware Specifications", "01-hardware-specs.md"),
                ("BIOS Configuration", "02-bios-configuration.md"),
                ("Linux Installation", "03-linux-installation.md"),
                ("Peripheral Setup", "04-peripheral-setup.md"),
            ]
        },
        {
            "chapter": "Development and Security",
            "pages": [
                ("Development Setup", "05-development-setup.md"),
                ("AI & ML Setup", "06-ai-ml-setup.md"),
                ("Security Configuration", "07-security-configuration.md"),
            ]
        },
        {
            "chapter": "Access and Management",
            "pages": [
                ("Remote Access", "08-remote-access.md"),
                ("Cool Tools", "11-cool-tools.md"),
            ]
        },
        {
            "chapter": "Entertainment and Media",
            "pages": [
                ("Gaming Setup", "09-gaming-setup.md"),
                ("Video Streaming", "10-video-streaming.md"),
            ]
        },
        {
            "chapter": "Server and Self-Hosting",
            "pages": [
                ("Home Server OS", "13-home-server-os.md"),
                ("BookStack Installation", "14-bookstack-installation.md"),
            ]
        },
        {
            "chapter": "Troubleshooting",
            "pages": [
                ("Troubleshooting Guide", "12-troubleshooting.md"),
            ]
        }
    ]
    
    for doc_section in docs:
        # Create chapter
        chapter = create_chapter(book_id, doc_section["chapter"])
        chapter_id = chapter["id"]
        
        # Create pages in chapter
        for page_title, page_file in doc_section["pages"]:
            file_path = Path(DOCS_DIR) / page_file
            if file_path.exists():
                with open(file_path, 'r') as f:
                    content = f.read()
                create_page(book_id, chapter_id, page_title, content)
                print(f"✓ Imported: {page_title}")
            else:
                print(f"✗ File not found: {page_file}")

if __name__ == "__main__":
    import_docs()
    print("\n✓ Import complete!")
```

To use the Python script:

```bash
# Install dependencies
pip3 install requests

# Edit configuration in script
nano bookstack_import.py

# Run import
python3 bookstack_import.py
```

### Post-Migration Tasks

After importing content:

1. **Review and Format:**
   - Check all pages for correct formatting
   - Adjust any broken links
   - Update image paths if needed

2. **Add Table of Contents:**
   - Create a home page with links to all books/chapters
   - Use BookStack's "Books" page as main navigation

3. **Set Permissions:**
   - Configure who can view/edit content
   - Create user roles as needed

4. **Add Search Tags:**
   - Tag pages with relevant keywords
   - Makes content easier to find

---

## Maintenance and Backup

### Regular Backups

#### Docker Method:
```bash
# Automated backup script
cat > ~/backup-bookstack.sh << 'EOF'
#!/bin/bash
BACKUP_DIR=~/bookstack-backups
DATE=$(date +%Y%m%d_%H%M%S)

mkdir -p $BACKUP_DIR
cd ~/bookstack

# Stop containers
docker-compose down

# Backup data
tar -czf $BACKUP_DIR/bookstack-backup-$DATE.tar.gz \
    bookstack_app_data bookstack_db_data

# Start containers
docker-compose up -d

# Keep only last 7 backups
cd $BACKUP_DIR
ls -t | tail -n +8 | xargs -r rm

echo "Backup completed: bookstack-backup-$DATE.tar.gz"
EOF

chmod +x ~/backup-bookstack.sh

# Add to crontab for daily backups
(crontab -l 2>/dev/null; echo "0 2 * * * ~/backup-bookstack.sh") | crontab -
```

#### Native Installation:
```bash
# Backup script
cat > ~/backup-bookstack-native.sh << 'EOF'
#!/bin/bash
BACKUP_DIR=~/bookstack-backups
DATE=$(date +%Y%m%d_%H%M%S)

mkdir -p $BACKUP_DIR

# Backup files
tar -czf $BACKUP_DIR/bookstack-files-$DATE.tar.gz /var/www/bookstack

# Backup database
mysqldump -u bookstack -p bookstack > $BACKUP_DIR/bookstack-db-$DATE.sql

# Compress database backup
gzip $BACKUP_DIR/bookstack-db-$DATE.sql

echo "Backup completed!"
EOF

chmod +x ~/backup-bookstack-native.sh
```

### Updates

#### Docker Method:
```bash
cd ~/bookstack
docker-compose pull
docker-compose up -d
```

#### Native Installation:
```bash
cd /var/www/bookstack
sudo -u www-data git pull origin release
sudo -u www-data composer install --no-dev
sudo -u www-data php artisan migrate --force
sudo -u www-data php artisan cache:clear
sudo -u www-data php artisan view:clear
```

---

## Advanced Configuration

### Enable HTTPS with Let's Encrypt

```bash
# Install certbot
sudo apt install -y certbot python3-certbot-apache

# Get certificate (requires domain name)
sudo certbot --apache -d your-domain.com

# Auto-renewal is configured automatically
```

### Performance Optimization

```bash
# Enable PHP OPcache
sudo nano /etc/php/8.1/apache2/php.ini

# Add/modify:
opcache.enable=1
opcache.memory_consumption=128
opcache.max_accelerated_files=10000

# Restart Apache
sudo systemctl restart apache2
```

### Email Configuration

Edit `.env` file:
```bash
MAIL_DRIVER=smtp
MAIL_HOST=smtp.gmail.com
MAIL_PORT=587
MAIL_FROM=your-email@gmail.com
MAIL_FROM_NAME=BookStack
MAIL_ENCRYPTION=tls
MAIL_USERNAME=your-email@gmail.com
MAIL_PASSWORD=your-app-password
```

---

## Troubleshooting

### Can't Access Web Interface

```bash
# Check if service is running (Docker)
docker-compose ps

# Check logs
docker-compose logs -f bookstack

# Check firewall
sudo ufw status
sudo ufw allow 6875/tcp
```

### Database Connection Error

```bash
# Verify database credentials in .env or docker-compose.yml
# Check database is running
docker-compose ps bookstack_db

# Restart database
docker-compose restart bookstack_db
```

### Permission Errors

```bash
# Fix permissions (native installation)
cd /var/www/bookstack
sudo chown -R www-data:www-data .
sudo chmod -R 775 storage bootstrap/cache public/uploads
```

### Import Script Fails

```bash
# Check API token is valid
# Verify BookStack URL is correct
# Ensure API is enabled in Settings
# Check file paths in script
```

---

## Additional Resources

- **BookStack Official Documentation**: https://www.bookstackapp.com/docs/
- **BookStack GitHub**: https://github.com/BookStackApp/BookStack
- **BookStack Discord**: https://discord.gg/ztkBqR2
- **API Documentation**: https://demo.bookstackapp.com/api/docs
- **Docker Image**: https://hub.docker.com/r/linuxserver/bookstack

---

## Conclusion

BookStack provides an excellent platform for organizing your Geekom AX8 documentation. Whether you choose Docker for simplicity or native installation for control, the AX8 has plenty of power to run BookStack smoothly.

After migrating content from this repository, you'll have:
- Searchable documentation
- Easy content editing
- Organized knowledge base
- Export capabilities
- Multi-user support

The Docker method is recommended for most users as it's easier to maintain and update. You can have BookStack running in less than 10 minutes!
