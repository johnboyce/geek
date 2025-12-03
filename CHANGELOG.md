# Changelog

## [Unreleased] - 2025-12-03

### Added

#### Documentation Convergence
- **New `docs/09-peripheral-setup.md`**: Comprehensive peripheral setup guide consolidating all peripheral-related content
  - RedThunder K84 wireless keyboard and mouse setup
  - SSK 128GB USB-C flash drive configuration
  - Acer Nitro KG241Y gaming monitor setup
  - Performance benchmarking tools and commands
  - Troubleshooting guides for all peripherals

- **Enhanced `docs/02-linux-installation.md`**: Major improvements for MacBook M3 users
  - Quick Start section specifically for MacBook Pro M3 users
  - Four USB creation methods:
    1. Balena Etcher (recommended for M3)
    2. Rufus (Windows only)
    3. dd command (advanced macOS Terminal method with M3 optimizations)
    4. Ventoy (multi-ISO support)
  - M3-specific troubleshooting tips
  - Fast USB-C port performance notes for M3
  - Progress indicator options for Terminal users

#### Makefile for MacBook M3
- **New `Makefile`**: Complete build automation for local development
  - `make help` - Display all available commands with descriptions
  - `make install` - Install npm dependencies with checks
  - `make dev` - Start development server
  - `make start` - Start production server
  - `make clean` - Clean node_modules and temporary files
  - `make check-deps` - Verify Node.js and npm installation
  - `make info` - Show project and system information
  - `make status` - Check if server is running
  - `make validate-docs` - Validate documentation structure
  - `make macos-setup` - Automated macOS/M3 environment setup (with user confirmation)
  - `make watch` - Auto-reload server (requires nodemon)
  - `make lint` - Lint markdown files (requires markdownlint)
  - `make format` - Format code (requires prettier)
  - `make build` - Build and validate project
  - `make docker-build`, `make docker-run`, `make docker-stop` - Docker support
  - Color-coded terminal output for better UX
  - M3-optimized commands and workflows

#### Documentation
- **New `DEPRECATED.md`**: Clear documentation of deprecated root-level files
  - Explains migration from root-level guides to `docs/` directory
  - Provides mapping from old to new file locations
  - Instructions for using the new structure

- **Updated `README.md`**:
  - Added Makefile usage instructions
  - Added documentation migration notice
  - Removed references to root-level documentation files
  - Added reference to new peripheral setup guide
  - Enhanced installation instructions with Makefile options
  - Added M3-specific notes

- **Updated `CONTRIBUTING.md`**:
  - Added Makefile setup instructions
  - Provided both Makefile and npm workflow examples
  - M3-friendly development workflow

- **Updated `docs/README.md`**:
  - Added peripheral setup guide to documentation index
  - Updated navigation structure

### Changed

#### Documentation Structure
- Converged competing documentation into single source of truth in `docs/` directory
- Root-level `linux-installation-guide.md` content merged into `docs/02-linux-installation.md`
- Root-level `peripheral-setup.md` content moved to `docs/09-peripheral-setup.md`
- Maintained backward compatibility - old files still present but marked as deprecated

#### Improvements
- Enhanced USB creation instructions with MacBook M3 specific guidance
- Improved clarity on Balena Etcher ARM64 compatibility
- Added checksum verification reminder in quick start
- Better error handling in Makefile commands
- User confirmation added for Homebrew installation

### Fixed
- Corrected markdown link validation regex in Makefile
- Improved security for macOS setup command (added user confirmation)
- Clarified Balena Etcher version selection for M3 Macs

### Technical Details

#### Files Added
- `Makefile` - Build automation (6.4 KB)
- `docs/09-peripheral-setup.md` - Peripheral guide (8.8 KB)
- `DEPRECATED.md` - Deprecation notice (2.3 KB)
- `CHANGELOG.md` - This file

#### Files Modified
- `README.md` - Updated references and added Makefile usage
- `CONTRIBUTING.md` - Added Makefile workflow
- `docs/README.md` - Added peripheral setup guide
- `docs/02-linux-installation.md` - Enhanced with M3 instructions and USB guide

#### Files Deprecated (but retained)
- `linux-installation-guide.md` - Superseded by `docs/02-linux-installation.md`
- `peripheral-setup.md` - Superseded by `docs/09-peripheral-setup.md`

### Security
- No security vulnerabilities introduced
- Added user confirmation for Homebrew installation in Makefile
- ISO checksum verification reminder added to documentation

### Compatibility
- Fully backward compatible - old files retained
- Node.js 18+ recommended
- Optimized for macOS on Apple Silicon (M1/M2/M3)
- Cross-platform Makefile (macOS, Linux)
- All existing npm scripts continue to work

### Usage Examples

#### For MacBook M3 Users
```bash
# First time setup
git clone https://github.com/johnboyce/geek.git
cd geek
make install
make dev

# Creating bootable USB for Geekom AX8
# See docs/02-linux-installation.md Quick Start section
```

#### Using Makefile
```bash
make help           # See all commands
make install        # Install dependencies
make dev            # Start development server
make status         # Check server status
make info           # Show project info
make validate-docs  # Validate documentation
```

#### Using npm (traditional)
```bash
npm install
npm start
```

### Migration Guide

If you were using the old root-level documentation files:

1. **For Linux Installation**: Use `docs/02-linux-installation.md` instead of `linux-installation-guide.md`
   - Includes all original content plus M3-specific instructions
   - Enhanced USB creation guide

2. **For Peripheral Setup**: Use `docs/09-peripheral-setup.md` instead of `peripheral-setup.md`
   - All original content preserved
   - Better organized and formatted

3. **For Development**: Use `make dev` instead of `npm run dev` (optional)
   - More convenient on macOS/M3
   - Better error messages and validation

See `DEPRECATED.md` for complete migration details.

### Contributors
- Enhanced by GitHub Copilot
- Based on original work by @johnboyce

---

## Previous Versions

See git history for changes prior to this release.
