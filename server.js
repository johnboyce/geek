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
    
    const filePath = path.join(__dirname, 'docs', filename);
    const content = await fs.readFile(filePath, 'utf-8');
    const html = marked(content);
    
    res.json({
      filename,
      content,
      html
    });
  } catch (error) {
    console.error('Error reading documentation file:', error);
    res.status(404).json({ error: 'Documentation not found' });
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
