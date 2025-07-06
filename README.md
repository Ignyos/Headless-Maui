# Pure JavaScript Frontend - MAUI Template

A clean, professional .NET MAUI template with **pure JavaScript frontend** and C# backend services, connected via a minimal JSInterop bridge.

## 🏗️ Architecture

### **Pure Frontend** (`wwwroot/`)
- `index.html` - Complete HTML UI with interactive components
- `app.js` - Pure JavaScript application with backend bridge
- `styles.css` - Modern responsive CSS styling
- **Framework-agnostic design** - Ready for React/Vue/Angular

### **C# Backend** (`Services/`)
- `IAppService.cs` - Clean service contracts
- `AppService.cs` - Business logic implementation  
- `JsBridgeService.cs` - JSInterop bridge with `[JSInvokable]` methods

### **Minimal Bridge** (`Components/`)
- `App.razor` - 8-line bridge initializer (no UI logic)
- Only provides JSInterop connection to frontend

## 🚀 Features

✅ **Complete separation** - Frontend is 100% JavaScript  
✅ **Framework-agnostic** - Easy to replace with any JS framework  
✅ **Clean communication** - No HTTP polling or iframe hacks  
✅ **Professional structure** - Ready for production development  
✅ **Cross-platform** - Windows, Android, iOS, macOS support

## 🔗 Frontend-Backend Communication

### JavaScript to C# Backend
```javascript
// Test bridge connection
const result = await window.bridgeService.testConnection();

// Get application information
const appInfo = await window.bridgeService.getAppInfo();

// Perform operations with data
const opResult = await window.bridgeService.performOperation('calculate', 42);

// User preferences management
const prefs = await window.bridgeService.getPreferences();
await window.bridgeService.updatePreferences({ theme: 'dark' });
```

### Real-time UI Updates
- Button loading states during operations
- JSON result display with formatting
- Automatic error handling and user feedback
- Responsive design with modern CSS

## 🎯 Usage

### Run the Application
```bash
dotnet run --framework net9.0-windows10.0.19041.0
```

### Build for All Platforms
```bash
dotnet build
```

### Replace Frontend Framework
1. Replace `wwwroot/` contents with your framework (React/Vue/Angular)
2. Implement the same bridge interface in your framework
3. Keep the same C# backend services
4. Bridge methods remain identical

### Switch to Web API
1. Update `app.js` bridge implementation to use HTTP calls
2. Create Web API controllers using the same `IAppService` interface
3. Frontend JavaScript interface remains identical
4. Deploy as web application

## 📁 Project Structure

```
AppShell/
├── Components/
│   └── App.razor              # Minimal bridge host (8 lines)
├── Services/
│   ├── IAppService.cs         # Service contracts
│   ├── AppService.cs          # Business logic
│   └── JsBridgeService.cs     # JSInterop bridge
├── wwwroot/
│   ├── index.html             # Pure HTML UI
│   ├── app.js                 # Pure JavaScript app
│   └── styles.css             # Modern CSS styling
├── MainPage.xaml              # BlazorWebView host
└── MauiProgram.cs             # DI container setup
```

## 🛠️ Development

### Add New Backend Services
1. Create service interface in `Services/`
2. Implement business logic
3. Register in `MauiProgram.cs`
4. Add JSInterop methods to `JsBridgeService.cs`
5. Call from JavaScript frontend

### Customize Frontend
- Edit `wwwroot/index.html` for UI structure
- Modify `wwwroot/app.js` for functionality
- Update `wwwroot/styles.css` for styling
- Add new JavaScript libraries as needed

### Error Handling
- Backend errors are automatically caught and returned as JSON
- Frontend displays errors in the result area
- Console logging for development debugging
- Graceful fallbacks for bridge connection issues

## 🎨 UI Features

- **Modern Design**: Gradient backgrounds, card layouts, hover effects
- **Responsive**: Mobile-first design with CSS Grid/Flexbox
- **Interactive**: Real-time button states and result displays
- **Professional**: Clean typography and consistent spacing
- **Accessible**: Semantic HTML and proper contrast ratios

## 📦 Publishing & Distribution

### Create Installers
The template includes automated publishing scripts for creating platform-specific installers:

```powershell
# Interactive publishing (recommended)
.\publish.ps1

# Direct Windows publishing
.\publish.ps1 -Platform Windows -Version 1.0.0

# List all published versions
.\publish.ps1 -ListVersions
```

### Publishing Process
1. **Version Management**: Auto-detects latest version and suggests next increment
2. **Build**: Compiles optimized release build with all dependencies
3. **Package**: Creates platform-specific installer with proper metadata
4. **Organize**: Outputs to `AppShell/Publish/{Platform}/` with consistent naming

### Supported Platforms
- **Windows**: InnoSetup installer (`.exe`) - Professional, digitally signable
- **macOS**: Coming soon (`.pkg`)
- **Android**: Coming soon (`.apk`) 
- **iOS**: Coming soon (App Store)

### Requirements
- **Windows**: InnoSetup 6.0+ (free from [jrsoftware.org](https://jrsoftware.org/isinfo.php))
- **.NET**: 9.0 SDK or later

### Version Strategy
- **Unified versioning** across all platforms
- **Smart detection** of existing versions
- **Overwrite protection** with user confirmation
- **Automatic manifest updates** across all platform files

## 🎨 Ready for Production

This template provides a solid foundation for:
- Desktop applications with modern web UI
- Cross-platform mobile apps
- Web applications (with Web API backend)
- Hybrid solutions with framework-specific frontends

The architecture ensures clean separation of concerns, making it easy to scale and maintain professional applications.
