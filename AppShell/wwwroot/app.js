// Pure JavaScript Frontend - MAUI Template with C# Backend Bridge

console.log('Pure JavaScript Frontend - Loading...');

/**
 * Frontend Bridge Interface - Clean abstraction for backend communication
 * This interface can be easily swapped for different backends (Web API, SignalR, etc.)
 */
class AppBridge {
    constructor() {
        this.bridgeService = null;
        this.isInitialized = false;
        console.log('Bridge interface initialized');
    }

    /**
     * Initialize the bridge with the C# JSInterop service
     * @param {object} dotNetBridgeService - .NET object reference for JSInterop
     */
    initialize(dotNetBridgeService) {
        this.bridgeService = dotNetBridgeService;
        this.isInitialized = true;
        console.log('Bridge connected to .NET backend');
        
        // Update UI to show bridge is ready
        this.updateConnectionStatus(true);
    }

    /**
     * Update connection status in the UI
     * @param {boolean} connected - Whether bridge is connected
     */
    updateConnectionStatus(connected) {
        // This could update a status indicator in the UI
        console.log(`Bridge status: ${connected ? 'Connected' : 'Disconnected'}`);
    }

    /**
     * Test the bridge connection
     * @returns {Promise<object>} Connection test result
     */
    async testConnection() {
        if (!this.isInitialized) {
            throw new Error('Bridge not initialized');
        }
        
        try {
            const result = await this.bridgeService.invokeMethodAsync('TestConnectionAsync');
            return JSON.parse(result);
        } catch (error) {
            console.error('Bridge test connection failed:', error);
            throw error;
        }
    }

    /**
     * Get application information
     * @returns {Promise<object>} App info object
     */
    async getAppInfo() {
        if (!this.isInitialized) {
            throw new Error('Bridge not initialized');
        }
        
        try {
            const result = await this.bridgeService.invokeMethodAsync('GetAppInfoAsync');
            return JSON.parse(result);
        } catch (error) {
            console.error('Get app info failed:', error);
            throw error;
        }
    }

    /**
     * Perform backend operations
     * @param {string} operation - Operation name
     * @param {any} data - Operation data
     * @returns {Promise<object>} Operation result
     */
    async performOperation(operation, data = null) {
        if (!this.isInitialized) {
            throw new Error('Bridge not initialized');
        }
        
        try {
            const dataJson = data ? JSON.stringify(data) : null;
            const result = await this.bridgeService.invokeMethodAsync('PerformOperationAsync', operation, dataJson);
            return JSON.parse(result);
        } catch (error) {
            console.error('Perform operation failed:', error);
            throw error;
        }
    }

    /**
     * Get user preferences
     * @returns {Promise<object>} Preferences object
     */
    async getPreferences() {
        if (!this.isInitialized) {
            throw new Error('Bridge not initialized');
        }
        
        try {
            const result = await this.bridgeService.invokeMethodAsync('GetPreferencesAsync');
            return JSON.parse(result);
        } catch (error) {
            console.error('Get preferences failed:', error);
            throw error;
        }
    }

    /**
     * Update user preferences
     * @param {object} preferences - Preferences to update
     * @returns {Promise<boolean>} Update success
     */
    async updatePreferences(preferences) {
        if (!this.isInitialized) {
            throw new Error('Bridge not initialized');
        }
        
        try {
            const preferencesJson = JSON.stringify(preferences);
            return await this.bridgeService.invokeMethodAsync('UpdatePreferencesAsync', preferencesJson);
        } catch (error) {
            console.error('Update preferences failed:', error);
            throw error;
        }
    }
}

// Global bridge instance
window.appBridge = new AppBridge();

/**
 * Initialize the bridge (called from Blazor)
 * @param {object} dotNetBridgeService - .NET object reference
 */
window.initializeBridge = function(dotNetBridgeService) {
    console.log('Bridge initialization called from .NET');
    
    // Ensure DOM is ready before initializing bridge
    if (document.readyState === 'loading') {
        document.addEventListener('DOMContentLoaded', () => {
            window.appBridge.initialize(dotNetBridgeService);
            exposeBridgeMethods();
        });
    } else {
        window.appBridge.initialize(dotNetBridgeService);
        exposeBridgeMethods();
    }
};

function exposeBridgeMethods() {
    // Expose bridge methods globally for easy access
    window.bridgeService = {
        testConnection: () => window.appBridge.testConnection(),
        getAppInfo: () => window.appBridge.getAppInfo(),
        performOperation: (operation, data) => window.appBridge.performOperation(operation, data),
        getPreferences: () => window.appBridge.getPreferences(),
        updatePreferences: (preferences) => window.appBridge.updatePreferences(preferences)
    };
    
    console.log('Global bridge methods exposed');
    
    // Auto-demo the bridge functionality after a short delay
    setTimeout(() => demonstrateBridge(), 1500);
}

/**
 * UI Helper Functions
 */
function showLoading() {
    const loading = document.getElementById('loading');
    const resultDisplay = document.getElementById('result-display');
    if (loading) loading.classList.remove('hidden');
    if (resultDisplay) resultDisplay.classList.add('hidden');
    
    // Disable all buttons
    const buttons = document.querySelectorAll('.bridge-demo button');
    buttons.forEach(btn => btn.disabled = true);
}

function hideLoading() {
    const loading = document.getElementById('loading');
    if (loading) loading.classList.add('hidden');
    
    // Re-enable all buttons
    const buttons = document.querySelectorAll('.bridge-demo button');
    buttons.forEach(btn => btn.disabled = false);
}

function showResult(data) {
    const resultDisplay = document.getElementById('result-display');
    const resultContent = document.getElementById('result-content');
    
    if (resultDisplay && resultContent) {
        resultContent.textContent = JSON.stringify(data, null, 2);
        resultDisplay.classList.remove('hidden');
    }
}

/**
 * Frontend UI Event Handlers
 */
async function testBridgeConnection() {
    showLoading();
    
    try {
        const result = await window.bridgeService.testConnection();
        showResult(result);
        console.log('Bridge test successful:', result);
    } catch (error) {
        showResult({ error: error.message });
        console.error('Bridge test failed:', error);
    } finally {
        hideLoading();
    }
}

async function getApplicationInfo() {
    showLoading();
    
    try {
        const result = await window.bridgeService.getAppInfo();
        showResult(result);
        console.log('App info retrieved:', result);
    } catch (error) {
        showResult({ error: error.message });
        console.error('Get app info failed:', error);
    } finally {
        hideLoading();
    }
}

async function performOperation() {
    showLoading();
    
    try {
        const result = await window.bridgeService.performOperation('ping');
        showResult(result);
        console.log('Operation performed:', result);
    } catch (error) {
        showResult({ error: error.message });
        console.error('Operation failed:', error);
    } finally {
        hideLoading();
    }
}

async function getUserPreferences() {
    showLoading();
    
    try {
        const result = await window.bridgeService.getPreferences();
        showResult(result);
        console.log('Preferences retrieved:', result);
    } catch (error) {
        showResult({ error: error.message });
        console.error('Get preferences failed:', error);
    } finally {
        hideLoading();
    }
}

/**
 * Demonstrate bridge functionality for development/testing
 */
async function demonstrateBridge() {
    if (!window.bridgeService) {
        console.log('Bridge not ready yet, skipping demo');
        return;
    }
    
    try {
        console.log('--- Auto Bridge Demo ---');
        
        // Test connection
        const connectionTest = await window.bridgeService.testConnection();
        console.log('✅ Connection Test:', connectionTest);
        
        // Show initial result
        showResult({
            message: "Bridge initialized successfully!",
            timestamp: new Date().toISOString(),
            status: "ready"
        });
        
    } catch (error) {
        console.error('Auto bridge demo failed:', error);
        showResult({ error: "Bridge initialization failed: " + error.message });
    }
}

/**
 * Initialize the pure JavaScript UI
 */
function initializeUI() {
    const appDiv = document.getElementById('app');
    if (!appDiv) {
        console.error('App container not found!');
        return;
    }

    // Create the complete UI structure
    appDiv.innerHTML = `
        <h1>@@DISPLAY_TITLE@@</h1>
        <p>🚀 @@APP_DESCRIPTION@@</p>
        
        <div class="status">
            <h3>Application Status</h3>
            <ul>
                <li>✅ Pure HTML/CSS/JS frontend</li>
                <li>✅ C# backend services</li>
                <li>✅ JSInterop bridge active</li>
                <li>✅ Framework-agnostic architecture</li>
                <li>✅ Ready for React/Vue/Angular</li>
                <li>✅ Standard Windows title bar</li>
            </ul>
        </div>

        <div class="demo-section">
            <h3>Backend Communication Demo</h3>
            
            <div class="bridge-demo">
                <button id="testBridge" onclick="testBridgeConnection()">
                    Test Bridge Connection
                </button>
                
                <button id="getAppInfo" onclick="getApplicationInfo()">
                    Get App Info
                </button>
                
                <button id="performOp" onclick="performOperation()">
                    Perform Operation
                </button>
                
                <button id="getPrefs" onclick="getUserPreferences()">
                    Get Preferences
                </button>
            </div>

            <div id="result-display" class="result-display hidden">
                <h4>Result:</h4>
                <pre id="result-content"></pre>
            </div>
            
            <div id="loading" class="loading hidden">
                <p>⏳ Processing...</p>
            </div>
        </div>

        <div class="frontend-integration">
            <h3>Frontend Architecture</h3>
            <p>This pure JavaScript frontend communicates with C# backend through:</p>
            <ul>
                <li><code>window.bridgeService.testConnection()</code></li>
                <li><code>window.bridgeService.getAppInfo()</code></li>
                <li><code>window.bridgeService.performOperation(operation, data)</code></li>
                <li><code>window.bridgeService.getPreferences()</code></li>
                <li><code>window.bridgeService.updatePreferences(preferences)</code></li>
            </ul>
            
            <div class="note">
                <strong>Ready for frameworks:</strong> This frontend can be easily replaced with React, Vue, Angular, 
                or any other JavaScript framework while keeping the same backend bridge.
            </div>
        </div>

        <div class="tech-stack">
            <h3>Technology Stack</h3>
            <div class="stack-grid">
                <div class="stack-item">
                    <h4>Frontend</h4>
                    <ul>
                        <li>Pure HTML/CSS/JavaScript</li>
                        <li>Framework-agnostic design</li>
                        <li>Modern ES6+ features</li>
                        <li>Responsive design</li>
                    </ul>
                </div>
                <div class="stack-item">
                    <h4>Backend</h4>
                    <ul>
                        <li>.NET MAUI (C#)</li>
                        <li>Dependency injection</li>
                        <li>Service interfaces</li>
                        <li>Structured logging</li>
                    </ul>
                </div>
                <div class="stack-item">
                    <h4>Bridge</h4>
                    <ul>
                        <li>JSInterop (Blazor)</li>
                        <li>Async/await patterns</li>
                        <li>JSON serialization</li>
                        <li>Error handling</li>
                    </ul>
                </div>
            </div>
        </div>
    `;
    
    console.log('Pure JavaScript UI initialized');
}

// App initialization
document.addEventListener('DOMContentLoaded', () => {
    console.log('DOM ready - Pure JavaScript frontend starting');
    
    // Initialize the UI first
    initializeUI();
    
    console.log('Waiting for .NET bridge initialization...');
    console.log('Frontend ready - awaiting bridge connection');
});