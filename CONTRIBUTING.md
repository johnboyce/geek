# Contributing to Geekom AX8 Documentation

Thank you for considering contributing to this project! This guide will help you get started.

## How to Contribute

### Reporting Issues

Found a problem? Please open an issue with:
- Clear description of the problem
- Steps to reproduce (if applicable)
- Expected vs actual behavior
- System information (OS, hardware)

### Suggesting Improvements

Have an idea? Open an issue with:
- Clear description of the suggestion
- Use case and benefits
- Any relevant examples or references

### Contributing Documentation

Documentation improvements are always welcome!

1. **Fork the repository**
2. **Create a branch**: `git checkout -b improve-security-docs`
3. **Make your changes**
4. **Test your changes**: Ensure markdown renders correctly
5. **Commit**: `git commit -m "Improve security documentation"`
6. **Push**: `git push origin improve-security-docs`
7. **Open a Pull Request**

### Documentation Guidelines

When contributing documentation:

- **Be clear and concise**: Write for users of all skill levels
- **Use proper formatting**: Follow markdown best practices
- **Include examples**: Code examples help understanding
- **Test commands**: Verify all commands work as expected
- **Keep it updated**: Remove outdated information
- **Add context**: Explain why, not just how

### Code Style for Documentation

- Use fenced code blocks with language specifiers:
  ````markdown
  ```bash
  sudo apt update
  ```
  ````

- Use headings hierarchically (H1 for title, H2 for sections, etc.)
- Use bullet points for lists
- Use numbered lists for sequential steps
- Use **bold** for important terms
- Use `inline code` for commands and filenames

### Contributing Code

For the web application:

1. Follow JavaScript/Node.js best practices
2. Keep code simple and readable
3. Add comments for complex logic
4. Test your changes locally
5. Ensure no security vulnerabilities

### Pull Request Process

1. Update documentation if needed
2. Add description of changes
3. Reference any related issues
4. Wait for review
5. Address feedback if requested
6. Merge when approved

### Code of Conduct

- Be respectful and inclusive
- Welcome newcomers
- Give constructive feedback
- Focus on the issue, not the person

## Development Setup

### Using Makefile (Recommended for macOS/MacBook M3)

```bash
# Clone repository
git clone https://github.com/johnboyce/geek.git
cd geek

# Install dependencies
make install

# Run development server
make dev

# View all available commands
make help
```

### Using npm

```bash
# Clone repository
git clone https://github.com/johnboyce/geek.git
cd geek

# Install dependencies
npm install

# Run development server
npm run dev
```

## Project Structure

```
geek/
├── docs/           # Markdown documentation files
├── public/         # Frontend files (HTML, CSS, JS)
├── server.js       # Express server
└── package.json    # Project dependencies
```

## Testing Changes

Before submitting:

1. **Test locally**: Run the server and verify changes
2. **Check links**: Ensure all links work
3. **Validate markdown**: Use a markdown linter
4. **Test on mobile**: Ensure responsive design works
5. **Check accessibility**: Ensure content is accessible

## GitHub Pages Deployment

The documentation is automatically deployed to GitHub Pages when changes are merged to the `main` branch.

### How It Works

1. **Workflow Trigger**: The `.github/workflows/deploy-pages.yml` workflow runs on:
   - Push to `main` branch
   - Manual workflow dispatch

2. **Build Process**:
   - Checks out the repository
   - Installs Node.js dependencies
   - Uploads the `public/` directory as a GitHub Pages artifact
   - Deploys to GitHub Pages

3. **Access**: Once deployed, the documentation is available at:
   - https://johnboyce.github.io/geek/

### Enabling GitHub Pages (One-Time Setup)

If GitHub Pages returns a 404, ensure it's properly configured:

1. Go to repository **Settings** → **Pages**
2. Under **Source**, select:
   - **Deploy from a branch**: NOT this option
   - **GitHub Actions**: Select this option
3. Save the configuration
4. Trigger a deployment:
   - Merge a PR to `main`, or
   - Go to **Actions** → **Deploy to GitHub Pages** → **Run workflow**

### Testing Before Deployment

Always test locally before merging to `main`:

```bash
# Install dependencies
npm install

# Start local server
npm start

# Visit http://localhost:3000
```

### Troubleshooting GitHub Pages

**404 Error:**
- Verify GitHub Pages is enabled and set to "GitHub Actions"
- Check that the workflow ran successfully in the Actions tab
- Ensure the `public/` directory contains `index.html` and `.nojekyll`
- Wait 1-2 minutes after deployment for DNS propagation

**Workflow Fails:**
- Check the Actions tab for error messages
- Verify `package.json` dependencies are correct
- Ensure `npm ci` can install dependencies successfully

**Outdated Content:**
- Clear browser cache (Ctrl+F5 or Cmd+Shift+R)
- Check the deployment time in the Actions tab
- Verify the latest commit is deployed

## Questions?

Not sure about something? Feel free to:
- Open an issue for discussion
- Ask in the pull request
- Reach out to maintainers

## License

By contributing, you agree that your contributions will be licensed under the MIT License.

## Recognition

Contributors will be recognized in the project README and commit history.

Thank you for helping improve this documentation! 🎉
