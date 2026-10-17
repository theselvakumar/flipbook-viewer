# Flipbook Viewer

An ultra-lightweight, hardware-accelerated 3D animated flipbook viewer for PDFs and image collections using pure HTML5 Canvas.

![demo](./test/demo.gif)

---

## Highlights

- **Ultra-Lightweight**: Only **~18 KB** minified bundle size.
- **Pure Canvas Rendering**: Smooth 60 FPS page-turning physics and curl animations directly rendered onto a single `<canvas>`.
- **Universal Provider Model**: Supports any input source (PDFs via PDF.js, image arrays, canvases, or custom providers).
- **Interactive Controls**: Touch swipe, corner drag, mouse click, keyboard navigation, smooth zoom, and pan.
- **Analytics & Events**: Built-in event hooks (`seen`) to track page views in real time.
- **Zero Heavy Dependencies**: Self-contained runtime requiring no large CSS frameworks or bloat.

---

## Quick Start (Vanilla JavaScript)

Include the distribution scripts in your HTML:

```html
<!doctype html>
<html lang="en">
<head>
  <meta charset="utf-8">
  <title>Flipbook Viewer Demo</title>
  <style>
    body { font-family: sans-serif; display: flex; flex-direction: column; align-items: center; padding: 20px; background: #1e293b; color: #fff; }
    #app { width: 800px; height: 600px; margin-bottom: 12px; }
    .controls button { padding: 8px 16px; margin: 0 4px; cursor: pointer; }
  </style>
</head>
<body>
  <div id="app"></div>

  <div class="controls">
    <button id="prev">Previous</button>
    <button id="next">Next</button>
    <button id="zoom">Zoom</button>
  </div>

  <!-- Built Distribution Scripts -->
  <script src="dist/pdf.worker.js"></script>
  <script src="dist/flipbook-viewer.js"></script>
  <script src="dist/book.pdf.js"></script>

  <script>
    const opts = { width: 800, height: 600, backgroundColor: "#0f172a" };
    const app = document.getElementById('app');
    const prev = document.getElementById('prev');
    const next = document.getElementById('next');
    const zoom = document.getElementById('zoom');

    // Load PDF document using book provider
    book.init('sample-local-pdf.pdf', function(err, bookObj) {
      if (err) return console.error('Failed to load PDF:', err);

      flipbook.init(bookObj, app, opts, function(err, viewer) {
        if (err) return console.error('Viewer init error:', err);

        // Track page visits
        viewer.on('seen', pageNum => console.log('Current page:', pageNum));

        // Connect navigation buttons
        next.onclick = () => viewer.flip_forward();
        prev.onclick = () => viewer.flip_back();
        zoom.onclick = () => viewer.zoom();

        // Keyboard arrow navigation
        window.addEventListener('keydown', e => {
          if (e.key === 'ArrowRight') viewer.flip_forward();
          if (e.key === 'ArrowLeft') viewer.flip_back();
        });
      });
    });
  </script>
</body>
</html>
```

---

## Module Usage (ESM / npm)

Install and import the viewer into your modern bundler setup:

```javascript
import { init as flipbook } from 'flipbook-viewer';

flipbook(bookProvider, 'container-id', options, (err, viewer) => {
  if (err) return console.error(err);

  console.log('Total pages:', viewer.page_count);

  viewer.on('seen', (pageNumber) => {
    console.log('Viewed page:', pageNumber);
  });

  // Navigation API
  viewer.flip_forward();
  viewer.flip_back();
  viewer.zoom();
});
```

---

## The Book Provider Interface

The viewer can display pages from **any** arbitrary source. All you need to supply is an object implementing two simple methods:

```javascript
const myBookProvider = {
  // Returns total number of pages
  numPages: () => 10,

  // Retrieves a specific 1-indexed page
  getPage: (pageNumber, callback) => {
    /*
      callback signature: callback(error, pageData)
      pageData format:
      {
        img: HTMLImageElement | HTMLCanvasElement | ImageBitmap,
        num: pageNumber,
        width: number,
        height: number
      }
    */
    const img = new Image();
    img.onload = () => {
      callback(null, {
        img: img,
        num: pageNumber,
        width: img.width,
        height: img.height
      });
    };
    img.src = `pages/page_${pageNumber}.jpg`;
  }
};
```

---

## Configuration Options

Pass an optional configuration object to customize display dimensions and styling:

```javascript
const options = {
  width: 800,               // Stage canvas width in pixels
  height: 600,              // Stage canvas height in pixels
  backgroundColor: "#0f172a", // Background fill color
  boxColor: "#334155",      // Border container color
  boxBorder: 0,             // Border width in pixels
  margin: 1,                // Default page margin percentage
  singlepage: false         // Set true for experimental vertical scroll mode
};
```

---

## Programmatic API & Events

### Viewer Methods
| Method | Description |
| :--- | :--- |
| `viewer.flip_forward()` | Turn forward to the next page spread |
| `viewer.flip_back()` | Turn backward to the previous page spread |
| `viewer.zoom(level?)` | Toggle or set canvas magnification |

### Viewer Events
| Event | Callback Argument | Description |
| :--- | :--- | :--- |
| `'seen'` | `pageNumber: number` | Emitted when a page spread becomes visible |

---

## Development & Building

1. **Install dependencies:**
   ```bash
   npm install
   ```

2. **Build production bundles (`dist/`):**
   ```bash
   npm run start
   ```

3. **Run local development test server:**
   ```bash
   npm test
   ```

---

## License

MIT © Charles Lobo / Contributors
