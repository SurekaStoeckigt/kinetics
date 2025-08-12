const express = require('express');
const path = require('path');
const fs = require('fs');
const app = express();
const PORT = process.env.PORT || 3000;
const siteDir = path.join(__dirname, 'site');
app.use(express.static(siteDir, { extensions: ['html'] }));
app.get('/', (req, res) => {
  const indexPath = path.join(siteDir, 'index.html');
  if (fs.existsSync(indexPath)) res.sendFile(indexPath);
  else res.status(503).send('Site is not built yet. Run `npm run build` or let CI build it.');
});
app.get('/healthz', (_req, res) => res.json({ ok: true }));
app.listen(PORT, () => console.log(`Server running on http://localhost:${PORT}`));
