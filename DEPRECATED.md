# Deprecated Files

The following files in the root directory have been **deprecated** and consolidated into the `docs/` directory:

## Deprecated Documentation Files

### ❌ linux-installation-guide.md (Root Level)
**Status**: Deprecated  
**Replaced by**: [docs/02-linux-installation.md](docs/02-linux-installation.md)  
**Reason**: Content has been merged and enhanced with MacBook M3 specific instructions

The updated guide includes:
- Quick start guide for MacBook Pro M3 users
- Detailed USB creation methods optimized for macOS
- All original content plus improvements

### ❌ peripheral-setup.md (Root Level)
**Status**: Deprecated  
**Replaced by**: [docs/09-peripheral-setup.md](docs/09-peripheral-setup.md)  
**Reason**: Content has been moved to maintain a single source of truth

The updated guide includes:
- All original peripheral setup instructions
- Enhanced troubleshooting sections
- Consistent formatting with other documentation

## Migration Complete

All documentation has been converged into the `docs/` directory to:
- Eliminate duplicate content
- Provide a single source of truth
- Improve maintainability
- Better organization and navigation

## What to Use Instead

Please refer to the comprehensive documentation in the `docs/` directory:

1. [Hardware Specifications](docs/01-hardware-specs.md)
2. [Linux Installation](docs/02-linux-installation.md) - **Includes USB creation for MacBook M3**
3. [Development Setup](docs/03-development-setup.md)
4. [Security Configuration](docs/04-security-configuration.md)
5. [Remote Access](docs/05-remote-access.md)
6. [Gaming Setup](docs/06-gaming-setup.md)
7. [Video Streaming](docs/07-video-streaming.md)
8. [Troubleshooting](docs/08-troubleshooting.md)
9. [Peripheral Setup](docs/09-peripheral-setup.md) - **Moved from root level**

## Using the Documentation

### Via Web Interface
```bash
# Using Makefile (recommended for MacBook M3)
make dev

# Or using npm
npm start
```

Then open http://localhost:3000

### Via Makefile Commands

The new Makefile provides convenient commands:
```bash
make help        # Show all available commands
make install     # Install dependencies
make dev         # Start development server
make status      # Check if server is running
make info        # Show project information
```

See [README.md](README.md) for complete documentation.
