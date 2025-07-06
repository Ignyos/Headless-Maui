using Microsoft.Extensions.Logging;

namespace AppShell.Services;

/// <summary>
/// Default implementation of application business logic services.
/// This provides the backend functionality exposed through the JSInterop bridge.
/// </summary>
public class AppService : IAppService
{
    private readonly ILogger<AppService> _logger;
    private readonly DateTime _startTime;
    private readonly Dictionary<string, object> _preferences;

    public AppService(ILogger<AppService> logger)
    {
        _logger = logger;
        _startTime = DateTime.UtcNow;
        _preferences = new Dictionary<string, object>
        {
            { "theme", "light" },
            { "language", "en" },
            { "autoSave", true }
        };
    }

    public async Task<AppInfo> GetAppInfoAsync()
    {
        _logger.LogInformation("Getting app info");
        
        await Task.Delay(10); // Simulate async operation
        
        var properties = new Dictionary<string, object>
        {
            { "environment", "development" },
            { "framework", ".NET MAUI Blazor Hybrid" },
            { "architecture", "clean" }
        };

        return new AppInfo(
            Version: "1.0.0",
            Platform: DeviceInfo.Platform.ToString(),
            StartTime: _startTime,
            Properties: properties
        );
    }

    public async Task<OperationResult> PerformOperationAsync(string operation, object? data = null)
    {
        _logger.LogInformation("Performing operation: {Operation}", operation);
        
        await Task.Delay(50); // Simulate async operation
        
        return operation switch
        {
            "ping" => new OperationResult(true, "Pong!", DateTime.UtcNow),
            "calculate" when data is int number => new OperationResult(true, "Calculated", number * 2),
            "validate" when data is string text => new OperationResult(
                !string.IsNullOrWhiteSpace(text), 
                string.IsNullOrWhiteSpace(text) ? "Invalid input" : "Valid input", 
                text?.Length
            ),
            _ => new OperationResult(false, $"Unknown operation: {operation}")
        };
    }

    public async Task<Dictionary<string, object>> GetPreferencesAsync()
    {
        _logger.LogInformation("Getting user preferences");
        
        await Task.Delay(10); // Simulate async operation
        
        return new Dictionary<string, object>(_preferences);
    }

    public async Task<bool> UpdatePreferencesAsync(Dictionary<string, object> preferences)
    {
        _logger.LogInformation("Updating user preferences");
        
        await Task.Delay(20); // Simulate async operation
        
        foreach (var kvp in preferences)
        {
            _preferences[kvp.Key] = kvp.Value;
        }
        
        return true;
    }
}
