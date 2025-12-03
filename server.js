const express = require('express');
const fs = require('fs').promises;
const path = require('path');
const { marked } = require('marked');

const app = express();
const PORT = process.env.PORT || 3000;

// Serve static files
app.use(express.static('public'));

// Get list of documentation files
app.get('/api/docs', async (req, res) => {
  try {
    const docsDir = path.join(__dirname, 'docs');
    const files = await fs.readdir(docsDir);
    const mdFiles = files
      .filter(file => file.endsWith('.md'))
      .sort()
      .map(file => ({
        id: file.replace('.md', ''),
        filename: file,
        title: file.replace('.md', '').replace(/^\d+-/, '').replace(/-/g, ' ')
      }));
    res.json(mdFiles);
  } catch (error) {
    console.error('Error reading docs directory:', error);
    res.status(500).json({ error: 'Failed to load documentation list' });
  }
});

// Get specific documentation file
app.get('/api/docs/:filename', async (req, res) => {
  try {
    const filename = req.params.filename.endsWith('.md') 
      ? req.params.filename 
      : `${req.params.filename}.md`;
    
    // Prevent path traversal attacks
    if (filename.includes('..') || filename.includes('/') || filename.includes('\\')) {
      return res.status(400).json({ error: 'Invalid filename' });
    }
    
    const docsDir = path.join(__dirname, 'docs');
    const filePath = path.normalize(path.join(docsDir, filename));
    
    // Ensure the resolved path is within docs directory
    if (!filePath.startsWith(docsDir)) {
      return res.status(403).json({ error: 'Access denied' });
    }
    
    const content = await fs.readFile(filePath, 'utf-8');
    const html = marked(content);
    
    res.json({
      filename,
      content,
      html
    });
  } catch (error) {
    // Don't expose internal error details
    if (error.code === 'ENOENT') {
      res.status(404).json({ error: 'Documentation not found' });
    } else {
      console.error('Error reading documentation file:', error.message);
      res.status(500).json({ error: 'Failed to load documentation' });
    }
  }
});

// Serve the main HTML page
app.get('/', (req, res) => {
  res.sendFile(path.join(__dirname, 'public', 'index.html'));
});

app.listen(PORT, () => {
  console.log(`Geekom AX8 Documentation Server running at http://localhost:${PORT}`);
  console.log(`Press Ctrl+C to stop the server`);
});
