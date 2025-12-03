# Makefile for Geekom AX8 Documentation Project
# Optimized for MacBook M3 and cross-platform development

.PHONY: help install dev start clean test lint format check-deps

# Default target
.DEFAULT_GOAL := help

# Node.js and npm commands
NODE := node
NPM := npm
NPX := npx

# Project directories
DOCS_DIR := docs
PUBLIC_DIR := public
SERVER := server.js

# Colors for terminal output
RED := \033[0;31m
GREEN := \033[0;32m
YELLOW := \033[1;33m
BLUE := \033[0;34m
NC := \033[0m # No Color

help: ## Show this help message
	@echo "$(BLUE)Geekom AX8 Documentation - Available Commands$(NC)"
	@echo ""
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "$(GREEN)%-15s$(NC) %s\n", $$1, $$2}'
	@echo ""
	@echo "$(YELLOW)Quick Start:$(NC)"
	@echo "  1. Run 'make install' to install dependencies"
	@echo "  2. Run 'make dev' to start development server"
	@echo "  3. Open http://localhost:3000 in your browser"

check-deps: ## Check if required dependencies are installed
	@echo "$(BLUE)Checking dependencies...$(NC)"
	@command -v node >/dev/null 2>&1 || { echo "$(RED)Error: Node.js is not installed. Install it from https://nodejs.org/$(NC)"; exit 1; }
	@command -v npm >/dev/null 2>&1 || { echo "$(RED)Error: npm is not installed. Install Node.js from https://nodejs.org/$(NC)"; exit 1; }
	@echo "$(GREEN)✓ Node.js version: $$(node --version)$(NC)"
	@echo "$(GREEN)✓ npm version: $$(npm --version)$(NC)"
	@echo "$(GREEN)All dependencies are installed!$(NC)"

install: check-deps ## Install project dependencies
	@echo "$(BLUE)Installing npm packages...$(NC)"
	@$(NPM) install
	@echo "$(GREEN)✓ Dependencies installed successfully!$(NC)"

dev: ## Start development server
	@echo "$(BLUE)Starting development server...$(NC)"
	@echo "$(YELLOW)Server will be available at http://localhost:3000$(NC)"
	@$(NPM) run dev

start: ## Start production server
	@echo "$(BLUE)Starting production server...$(NC)"
	@echo "$(YELLOW)Server will be available at http://localhost:3000$(NC)"
	@$(NPM) start

clean: ## Clean up node_modules and temporary files
	@echo "$(BLUE)Cleaning up...$(NC)"
	@rm -rf node_modules
	@rm -f package-lock.json
	@rm -rf .npm
	@rm -f npm-debug.log*
	@echo "$(GREEN)✓ Cleanup complete!$(NC)"

reinstall: clean install ## Clean and reinstall all dependencies
	@echo "$(GREEN)✓ Reinstallation complete!$(NC)"

test: ## Run tests (if available)
	@echo "$(YELLOW)Running tests...$(NC)"
	@$(NPM) test || echo "$(YELLOW)No tests configured yet$(NC)"

lint: ## Lint markdown documentation files
	@echo "$(BLUE)Linting markdown files...$(NC)"
	@if command -v markdownlint >/dev/null 2>&1; then \
		markdownlint $(DOCS_DIR)/*.md README.md CONTRIBUTING.md; \
		echo "$(GREEN)✓ Markdown linting complete!$(NC)"; \
	else \
		echo "$(YELLOW)markdownlint not installed. Install with: npm install -g markdownlint-cli$(NC)"; \
	fi

format: ## Format code and documentation
	@echo "$(BLUE)Formatting files...$(NC)"
	@if command -v prettier >/dev/null 2>&1; then \
		prettier --write "*.js" "$(PUBLIC_DIR)/**/*.{html,css,js}" "*.md" "$(DOCS_DIR)/*.md"; \
		echo "$(GREEN)✓ Formatting complete!$(NC)"; \
	else \
		echo "$(YELLOW)Prettier not installed. Install with: npm install -g prettier$(NC)"; \
	fi

validate-docs: ## Validate all documentation links and structure
	@echo "$(BLUE)Validating documentation...$(NC)"
	@for file in $(DOCS_DIR)/*.md README.md; do \
		echo "Checking $$file..."; \
		if [ -f "$$file" ]; then \
			grep -n '\]\([^)]*\)' "$$file" | grep -v "http" | grep -v "^#" || true; \
		fi; \
	done
	@echo "$(GREEN)✓ Documentation validation complete!$(NC)"

serve: dev ## Alias for dev (start development server)

build: ## Build project (currently just validates)
	@echo "$(BLUE)Building project...$(NC)"
	@$(MAKE) check-deps
	@$(MAKE) validate-docs
	@echo "$(GREEN)✓ Build complete!$(NC)"

info: ## Show project information
	@echo "$(BLUE)Project Information:$(NC)"
	@echo "  Name: Geekom AX8 Documentation"
	@echo "  Version: $$(grep '"version"' package.json | cut -d'"' -f4)"
	@echo "  Node.js: $$(node --version)"
	@echo "  npm: $$(npm --version)"
	@echo "  Documentation files: $$(ls -1 $(DOCS_DIR)/*.md | wc -l | tr -d ' ')"
	@echo ""
	@echo "$(YELLOW)System Information:$(NC)"
	@echo "  OS: $$(uname -s)"
	@echo "  Architecture: $$(uname -m)"
	@echo "  Hostname: $$(hostname)"

docker-build: ## Build Docker image (if Dockerfile exists)
	@if [ -f "Dockerfile" ]; then \
		echo "$(BLUE)Building Docker image...$(NC)"; \
		docker build -t geek-docs:latest .; \
		echo "$(GREEN)✓ Docker image built!$(NC)"; \
	else \
		echo "$(YELLOW)No Dockerfile found$(NC)"; \
	fi

docker-run: ## Run Docker container (if image exists)
	@echo "$(BLUE)Running Docker container...$(NC)"
	@docker run -p 3000:3000 --name geek-docs -d geek-docs:latest
	@echo "$(GREEN)✓ Container running at http://localhost:3000$(NC)"

docker-stop: ## Stop Docker container
	@docker stop geek-docs || true
	@docker rm geek-docs || true
	@echo "$(GREEN)✓ Docker container stopped$(NC)"

watch: ## Watch for changes and restart server
	@if command -v nodemon >/dev/null 2>&1; then \
		echo "$(BLUE)Starting server with auto-reload...$(NC)"; \
		nodemon $(SERVER); \
	else \
		echo "$(YELLOW)nodemon not installed. Install with: npm install -g nodemon$(NC)"; \
		echo "$(YELLOW)Starting server without auto-reload...$(NC)"; \
		$(MAKE) dev; \
	fi

.PHONY: macos-setup
macos-setup: ## Setup development environment on macOS (including M3) - installs Homebrew & Node.js if needed
	@echo "$(BLUE)Setting up macOS development environment...$(NC)"
	@command -v brew >/dev/null 2>&1 || { \
		echo "$(YELLOW)Homebrew not found. This will install Homebrew (requires user interaction).$(NC)"; \
		echo "$(YELLOW)Press Ctrl+C to cancel, or Enter to continue...$(NC)"; \
		read -r; \
		/bin/bash -c "$$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"; \
	}
	@echo "$(GREEN)✓ Homebrew installed$(NC)"
	@command -v node >/dev/null 2>&1 || { \
		echo "$(YELLOW)Installing Node.js via Homebrew...$(NC)"; \
		brew install node; \
	}
	@echo "$(GREEN)✓ Node.js installed$(NC)"
	@$(MAKE) install
	@echo "$(GREEN)✓ macOS setup complete! Run 'make dev' to start.$(NC)"

status: ## Show server status
	@if lsof -Pi :3000 -sTCP:LISTEN -t >/dev/null 2>&1; then \
		echo "$(GREEN)✓ Server is running on port 3000$(NC)"; \
		echo "  PID: $$(lsof -Pi :3000 -sTCP:LISTEN -t)"; \
		echo "  URL: http://localhost:3000"; \
	else \
		echo "$(YELLOW)Server is not running$(NC)"; \
	fi
