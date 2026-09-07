using Microsoft.EntityFrameworkCore;
using ProductApi.Data;
using Azure.Identity;
using Azure.Extensions.AspNetCore.Configuration.Secrets;

var builder = WebApplication.CreateBuilder(args);

// ✅ Read port from environment (Azure sets PORT or use ASPNETCORE_URLS)
// Do NOT hardcode — let the env var set via Terraform drive this
builder.WebHost.ConfigureKestrel(options =>
{
    var port = Environment.GetEnvironmentVariable("WEBSITES_PORT") ?? "8080";
    options.ListenAnyIP(int.Parse(port));
});

// ✅ Key Vault integration (only runs if URI is set — safe for local dev)
//var keyVaultUri = builder.Configuration["KeyVaultUri"];
//if (!string.IsNullOrEmpty(keyVaultUri))
//{
//    builder.Configuration.AddAzureKeyVault(
//        new Uri(keyVaultUri),
//        new DefaultAzureCredential()
//    );
//}

builder.Services.AddControllers();
builder.Services.AddEndpointsApiExplorer();
builder.Services.AddSwaggerGen();

// ✅ Add DB context — wrapped so startup doesn't fail if connection is bad
builder.Services.AddDbContext<AppDbContext>(options =>
    options.UseSqlServer(
        builder.Configuration.GetConnectionString("DefaultConnection"),
        sql => sql.EnableRetryOnFailure(3)  // handles transient Azure SQL issues
    )
);

var app = builder.Build();

// ✅ Health/liveness endpoint — Azure uses this to confirm startup
app.MapGet("/health", () => Results.Ok(new { status = "healthy", timestamp = DateTime.UtcNow }));
app.MapGet("/", () => Results.Ok("API is running"));

// ✅ Only run migrations in non-production or via a separate job
// NEVER run migrations at startup in production — it causes startup timeouts
if (app.Environment.IsDevelopment())
{
    using var scope = app.Services.CreateScope();
    var db = scope.ServiceProvider.GetRequiredService<AppDbContext>();
    db.Database.Migrate();
}

app.UseSwagger();
app.UseSwaggerUI();
app.UseAuthorization();
app.MapControllers();

app.Run();