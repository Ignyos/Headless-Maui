using Microsoft.JSInterop;
using Microsoft.Extensions.Logging;
using System.Text.Json;

namespace AppShell.Services;

/// <summary>
/// JSInterop bridge service that exposes C# backend functionality to JavaScript frontend.
/// This is the main bridge between the frontend and backend in the Blazor Hybrid architecture.
/// </summary>
public class JsBridgeService
{
    private readonly IAppService _appService;
    private readonly ILogger<JsBridgeService> _logger;

    public JsBridgeService(IAppService appService, ILogger<JsBridgeService> logger)
    {
        _appService = appService;
        _logger = logger;
    }

    /// <summary>
    /// Get application information for the frontend
    /// </summary>
    [JSInvokable]
    public async Task<string> GetAppInfoAsync()
    {
        try
        {
            _logger.LogInformation("Bridge: Getting app info");
            var appInfo = await _appService.GetAppInfoAsync();
            return JsonSerializer.Serialize(appInfo);
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, "Error getting app info");
            throw;
        }
    }

    /// <summary>
    /// Perform operations from the frontend
    /// </summary>
    [JSInvokable]
    public async Task<string> PerformOperationAsync(string operation, string? dataJson = null)
    {
        try
        {
            _logger.LogInformation("Bridge: Performing operation {Operation}", operation);
            
            object? data = null;
            if (!string.IsNullOrWhiteSpace(dataJson))
            {
                // Try to deserialize as different types based on operation
                data = operation switch
                {
                    "calculate" => JsonSerializer.Deserialize<int>(dataJson),
                    "validate" => JsonSerializer.Deserialize<string>(dataJson),
                    _ => JsonSerializer.Deserialize<object>(dataJson)
                };
            }

            var result = await _appService.PerformOperationAsync(operation, data);
            return JsonSerializer.Serialize(result);
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, "Error performing operation {Operation}", operation);
            var errorResult = new OperationResult(false, $"Error: {ex.Message}");
            return JsonSerializer.Serialize(errorResult);
        }
    }

    /// <summary>
    /// Get user preferences for the frontend
    /// </summary>
    [JSInvokable]
    public async Task<string> GetPreferencesAsync()
    {
        try
        {
            _logger.LogInformation("Bridge: Getting preferences");
            var preferences = await _appService.GetPreferencesAsync();
            return JsonSerializer.Serialize(preferences);
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, "Error getting preferences");
            throw;
        }
    }

    /// <summary>
    /// Update user preferences from the frontend
    /// </summary>
    [JSInvokable]
    public async Task<bool> UpdatePreferencesAsync(string preferencesJson)
    {
        try
        {
            _logger.LogInformation("Bridge: Updating preferences");
            var preferences = JsonSerializer.Deserialize<Dictionary<string, object>>(preferencesJson);
            return await _appService.UpdatePreferencesAsync(preferences ?? new Dictionary<string, object>());
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, "Error updating preferences");
            return false;
        }
    }

    /// <summary>
    /// Test the bridge connection from the frontend
    /// </summary>
    [JSInvokable]
    public async Task<string> TestConnectionAsync()
    {
        try
        {
            _logger.LogInformation("Bridge: Testing connection");
            await Task.Delay(10);
            
            var result = new
            {
                Success = true,
                Message = "Bridge connection successful!",
                Timestamp = DateTime.UtcNow,
                Platform = DeviceInfo.Platform.ToString()
            };
            
            return JsonSerializer.Serialize(result);
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, "Error testing connection");
            throw;
        }
    }
}
