// State
let allDocs = [];
let currentDoc = null;

// Initialize app
document.addEventListener('DOMContentLoaded', () => {
    loadDocumentList();
    setupSearch();
});

// Load list of documentation files
async function loadDocumentList() {
    try {
        const response = await fetch('/api/docs');
        allDocs = await response.json();
        renderDocList(allDocs);
    } catch (error) {
        console.error('Error loading documentation list:', error);
        document.getElementById('docList').innerHTML = 
            '<div class="loading">Error loading documentation</div>';
    }
}

// Render documentation list
function renderDocList(docs) {
    const docList = document.getElementById('docList');
    
    if (docs.length === 0) {
        docList.innerHTML = '<div class="loading">No documentation found</div>';
        return;
    }
    
    docList.innerHTML = docs.map(doc => `
        <div class="doc-item" data-filename="${doc.filename}" onclick="loadDocument('${doc.filename}')">
            <div class="doc-item-title">${doc.title}</div>
        </div>
    `).join('');
}

// Load and display a documentation file
async function loadDocument(filename) {
    try {
        const response = await fetch(`/api/docs/${filename}`);
        const data = await response.json();
        
        currentDoc = filename;
        
        // Update UI
        document.getElementById('welcomeScreen').style.display = 'none';
        document.getElementById('docContent').style.display = 'block';
        document.getElementById('docHtml').innerHTML = data.html;
        
        // Update active state in sidebar
        document.querySelectorAll('.doc-item').forEach(item => {
            item.classList.remove('active');
        });
        document.querySelector(`[data-filename="${filename}"]`)?.classList.add('active');
        
        // Scroll to top
        document.querySelector('.content').scrollTop = 0;
        
        // Add copy buttons to code blocks
        addCopyButtons();
    } catch (error) {
        console.error('Error loading document:', error);
        document.getElementById('docHtml').innerHTML = 
            '<p style="color: red;">Error loading documentation. Please try again.</p>';
    }
}

// Setup search functionality
function setupSearch() {
    const searchInput = document.getElementById('searchInput');
    
    searchInput.addEventListener('input', (e) => {
        const query = e.target.value.toLowerCase();
        
        if (query === '') {
            renderDocList(allDocs);
            return;
        }
        
        const filtered = allDocs.filter(doc => 
            doc.title.toLowerCase().includes(query) ||
            doc.filename.toLowerCase().includes(query)
        );
        
        renderDocList(filtered);
    });
}

// Add copy buttons to code blocks
function addCopyButtons() {
    document.querySelectorAll('pre code').forEach((block) => {
        const pre = block.parentElement;
        
        // Skip if button already exists
        if (pre.querySelector('.copy-button')) return;
        
        const button = document.createElement('button');
        button.className = 'copy-button';
        button.textContent = 'Copy';
        button.style.cssText = `
            position: absolute;
            top: 8px;
            right: 8px;
            padding: 4px 8px;
            background: #0066cc;
            color: white;
            border: none;
            border-radius: 3px;
            cursor: pointer;
            font-size: 12px;
            opacity: 0.8;
        `;
        
        button.addEventListener('mouseover', () => {
            button.style.opacity = '1';
        });
        
        button.addEventListener('mouseout', () => {
            button.style.opacity = '0.8';
        });
        
        button.addEventListener('click', () => {
            const code = block.textContent;
            navigator.clipboard.writeText(code).then(() => {
                button.textContent = 'Copied!';
                setTimeout(() => {
                    button.textContent = 'Copy';
                }, 2000);
            }).catch(err => {
                console.error('Failed to copy:', err);
            });
        });
        
        pre.style.position = 'relative';
        pre.appendChild(button);
    });
}

// Handle keyboard shortcuts
document.addEventListener('keydown', (e) => {
    // Ctrl/Cmd + K to focus search
    if ((e.ctrlKey || e.metaKey) && e.key === 'k') {
        e.preventDefault();
        document.getElementById('searchInput').focus();
    }
    
    // Escape to clear search
    if (e.key === 'Escape') {
        document.getElementById('searchInput').value = '';
        renderDocList(allDocs);
    }
});
