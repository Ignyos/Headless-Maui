# Pure JavaScript Frontend - MAUI Template

![Latest Release](https://img.shields.io/github/v/release/Ignyos/Headless-Maui-Frontend?label=latest)
![License](https://img.shields.io/badge/license-Apache--2.0-blue)
![Stars](https://img.shields.io/github/stars/Ignyos/Headless-Maui-Frontend?style=social)

A clean, professional .NET MAUI template with **pure JavaScript frontend** and C# backend services, connected via a minimal JSInterop bridge.

## 🤔 Why This Template?

### **The Problem**
Building cross-platform desktop apps often means choosing between:
- **Electron**: Great web tech support, but large bundle sizes and performance overhead
- **MAUI XAML**: Native performance, but limited to Microsoft's UI framework
- **Blazor Server**: Real-time updates, but requires server connection
- **Web APIs**: Flexible, but complex deployment and authentication

### **The Solution**
This template combines the best of both worlds:
- ✅ **Modern Web UI** - Use any JavaScript framework (React, Vue, Angular) or vanilla JS
- ✅ **Native Performance** - Direct access to platform APIs through .NET MAUI
- ✅ **Self-Contained** - No server required, works offline
- ✅ **Professional Deployment** - Create native installers for each platform
- ✅ **Clean Architecture** - Complete separation between frontend and backend

### **Comparison with Alternatives**

| Feature | This Template | Electron | MAUI XAML | Blazor Server |
|---------|---------------|----------|-----------|---------------|
| **Bundle Size** | Medium (~50MB) | Large (~150MB+) | Small (~20MB) | Small (~20MB) |
| **Performance** | Native | Good | Native | Network-dependent |
| **Offline Support** | ✅ Full | ✅ Full | ✅ Full | ❌ Requires server |
| **Web Tech Support** | ✅ Any framework | ✅ Any framework | ❌ XAML only | ⚠️ Blazor only |
| **Platform Integration** | ✅ Full .NET APIs | ⚠️ Limited | ✅ Full .NET APIs | ✅ Full .NET APIs |
| **Development Experience** | ✅ Hot reload | ✅ Hot reload | ✅ Hot reload | ✅ Hot reload |
| **Deployment** | Native installers | Native installers | Native installers | Web deployment |
| **Learning Curve** | Medium | Low | Medium-High | Medium |

### **When to Use This Template**
**✅ Perfect for:**
- Desktop-first applications with modern web UI
- Teams with strong JavaScript/CSS skills
- Apps requiring native platform integration
- Professional software distribution

**❌ Consider alternatives for:**
- Simple CRUD applications (Blazor Server might be easier)
- Web-only applications (use ASP.NET Core instead)
- Maximum performance apps (consider native XAML)

## 🚀 Getting Started

### Prerequisites
- [.NET 9.0 SDK](https://dotnet.microsoft.com/download) or later
- [Visual Studio 2022](https://visualstudio.microsoft.com/) or [Visual Studio Code](https://code.visualstudio.com/)
- For Windows publishing: [InnoSetup 6.0+](https://jrsoftware.org/isinfo.php)

### Quick Start
1. **Fork this repository** to your GitHub account
2. **Clone your fork** locally
3. **Customize the template** for your project:
   ```powershell
   .\setup.ps1
   ```

### One-Time Setup Script (setup.ps1)
The `setup.ps1` script MUST be executed **from the repository root** (same folder that contains `AppShell/` and this `README.md`).

It will:
- Prompt you for: Display Name, Application Identifier, Company Name, Package ID, Description
- Replace all `@@TOKEN@@` placeholders across the project
- Optionally remove the template marketing `docs/` folder (you decide during the run)
- Test a build
- Self-delete to prevent accidental re-use

Optional arguments:
```powershell
# Show help / usage
.\setup.ps1 -Help

# Preview changes (no file writes, no deletion, no build)
.\setup.ps1 -DryRun

# Combine (help text first, then exit)
.\setup.ps1 -Help -DryRun
```

Cross‑platform (PowerShell Core):
```bash
pwsh ./setup.ps1 -DryRun
```

Safety / notes:
- The script only runs correctly from the root because it uses relative paths like `AppShell\AppShell.csproj`.
- If you see "Project file not found" you are not in the root directory.
- After a successful non-dry run, `setup.ps1` deletes itself. Commit changes first if you want a history diff.
- To re-run after deletion, restore it from git history (`git checkout HEAD~1 -- setup.ps1`) or your fork (not usually needed).
- Use `-DryRun` in CI or to verify what will change before committing.

After running the setup (non-dry), continue with the build/run steps below.

## 📦 Releases

Full release history and detailed notes: https://github.com/Ignyos/Headless-Maui-Frontend/releases

Current latest version badge (above) updates automatically when a new GitHub Release is published. Each release includes:
- Summary of major changes
- Installation / publish notes if relevant
- Any migration tips (when necessary)

For versioning we follow simple semantic versioning (MAJOR.MINOR.PATCH) informed by real-world feedback rather than a rigid roadmap.
4. **Build and run** the application:
   ```powershell
   cd AppShell
   dotnet run
   ```
5. **Start developing** your frontend in `AppShell/wwwroot/`

### Your First Customization
After running setup, try modifying the frontend:

1. **Edit the UI** in `AppShell/wwwroot/index.html`
2. **Add functionality** in `AppShell/wwwroot/app.js`
3. **Style components** in `AppShell/wwwroot/styles.css`
4. **Add backend services** in `AppShell/Services/`

The app will hot-reload as you make changes!

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

### **Project Structure**
```
📁 AppShell/                    # Main MAUI project
├── 📁 Components/              # Blazor bridge components (minimal)
├── 📁 Platforms/               # Platform-specific configurations
│   ├── 📁 Windows/            # Windows-specific settings
│   ├── 📁 Android/            # Android manifests and resources
│   └── 📁 iOS/                # iOS Info.plist and settings
├── 📁 Properties/              # Launch settings
├── 📁 Publish/                 # Generated installers (ignored by Git)
├── 📁 Resources/               # App icons, fonts, images
├── 📁 Services/                # Backend business logic
│   ├── IAppService.cs         # Service contracts
│   ├── AppService.cs          # Service implementations
│   └── JsBridgeService.cs     # JSInterop bridge
├── 📁 wwwroot/                 # Frontend assets (your web app)
│   ├── index.html             # Main UI page
│   ├── app.js                 # JavaScript application
│   └── styles.css             # CSS styling
├── AppShell.csproj            # Project configuration
├── MainPage.xaml              # MAUI page hosting BlazorWebView
└── MauiProgram.cs             # App startup and service registration

📁 Scripts/                     # Development tools
└── version-manager.ps1         # Shared version utilities

📄 publish.ps1                  # Main publishing script
📄 setup.ps1                    # One-time template customization
```

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

## �️ Development Workflow

### Adding a New Backend Service
1. **Create service interface** in `Services/IMyService.cs`:
   ```csharp
   public interface IMyService 
   {
       Task<string> ProcessDataAsync(string input);
   }
   ```

2. **Implement the service** in `Services/MyService.cs`:
   ```csharp
   public class MyService : IMyService 
   {
       public async Task<string> ProcessDataAsync(string input) 
       {
           // Your business logic here
           return $"Processed: {input}";
       }
   }
   ```

3. **Register in MauiProgram.cs**:
   ```csharp
   builder.Services.AddScoped<IMyService, MyService>();
   ```

4. **Add JSInterop method** in `Services/JsBridgeService.cs`:
   ```csharp
   [JSInvokable]
   public async Task<string> ProcessData(string input)
   {
       var result = await _myService.ProcessDataAsync(input);
       return JsonSerializer.Serialize(new { success = true, data = result });
   }
   ```

5. **Call from JavaScript**:
   ```javascript
   const result = await window.bridgeService.processData('my data');
   console.log(JSON.parse(result));
   ```

### Adding a New UI Component
1. **Create HTML structure** in `wwwroot/index.html`
2. **Add interactivity** in `wwwroot/app.js`
3. **Style the component** in `wwwroot/styles.css`
4. **Connect to backend** via bridge service calls

### Error Handling Best Practices
- **Backend**: Always return JSON with `success` flag and `error` details
- **Frontend**: Use try-catch blocks and display user-friendly messages
- **Development**: Check browser console and Visual Studio output for debugging

## 🔧 Troubleshooting

### Common Build Issues

**Error: "Project file not found"**
```
Solution: Ensure you're running commands from the repository root directory
```

**Error: "JSInterop bridge not available"**
```
Solution: Check that Blazor services are registered in MauiProgram.cs
and that the bridge is properly initialized in App.razor
```

**Error: "InnoSetup not found during publishing"**
```
Solution: Install InnoSetup 6.0+ from https://jrsoftware.org/isinfo.php
and ensure it's in your PATH or default installation directory
```

### Runtime Issues

**JavaScript errors: "bridgeService is undefined"**
- Check browser console for bridge initialization errors
- Ensure `App.razor` is properly loading and initializing the bridge
- Verify that `Components/App.razor` is referenced in `MainPage.xaml`

**Backend service not found**
- Confirm service is registered in `MauiProgram.cs` dependency injection
- Check that JSInvokable methods match JavaScript calls exactly
- Verify service interfaces and implementations are correctly defined

**Publishing failures**
- Ensure .NET 9.0 SDK is installed and in PATH
- For Windows: Install InnoSetup and verify it's accessible
- Check that all tokens (@@DISPLAY_TITLE@@, etc.) have been replaced by setup.ps1

### Platform-Specific Issues

**Windows**
- Some antivirus software may block InnoSetup or the generated installer
- Windows Defender SmartScreen may warn about unsigned installers

**Development Environment**
- Hot reload requires Visual Studio 2022 17.8+ or VS Code with C# Dev Kit
- Some JavaScript debugging features require Edge WebView2 runtime

### Getting Help
1. **Check the Issues** section of this repository
2. **Review MAUI documentation** at [docs.microsoft.com/dotnet/maui](https://docs.microsoft.com/dotnet/maui)
3. **Join the community** at [MAUI GitHub Discussions](https://github.com/dotnet/maui/discussions)

## 🎨 What You Get Out-of-the-Box

### 🎯 **Ready-to-Use Foundation**
- Complete project structure with build configuration
- Professional UI with responsive design and modern styling
- Working examples of frontend-backend communication
- Automated setup and publishing scripts

### 🔧 **Development Tools**
- Hot reload for rapid development
- Debug support in Visual Studio and VS Code
- Comprehensive error handling and logging
- Input validation and user feedback systems

### 📦 **Production Ready**
- Professional installer creation for Windows
- Proper application metadata and branding
- Version management and update preparation
- Clean deployment with all dependencies included

### 🚀 **Extensible Architecture**
- Framework-agnostic frontend (easily swap in React/Vue/Angular)
- Clean service layer for business logic
- Minimal bridge pattern for easy maintenance
- Cross-platform foundation for mobile and desktop

## �📦 Publishing & Distribution

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
