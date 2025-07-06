namespace AppShell.Services;

/// <summary>
/// Interface for application business logic services.
/// This defines the contract between the Blazor bridge and backend functionality.
/// </summary>
public interface IAppService
{
    /// <summary>
    /// Get application information
    /// </summary>
    Task<AppInfo> GetAppInfoAsync();
    
    /// <summary>
    /// Perform application operations
    /// </summary>
    Task<OperationResult> PerformOperationAsync(string operation, object? data = null);
    
    /// <summary>
    /// Get user preferences
    /// </summary>
    Task<Dictionary<string, object>> GetPreferencesAsync();
    
    /// <summary>
    /// Update user preferences
    /// </summary>
    Task<bool> UpdatePreferencesAsync(Dictionary<string, object> preferences);
}

/// <summary>
/// Application information data transfer object
/// </summary>
public record AppInfo(
    string Version,
    string Platform,
    DateTime StartTime,
    Dictionary<string, object> Properties
);

/// <summary>
/// Operation result data transfer object
/// </summary>
public record OperationResult(
    bool Success,
    string Message,
    object? Data = null
);
