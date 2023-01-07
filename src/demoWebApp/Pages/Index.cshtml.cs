using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.RazorPages;

namespace demoWebApp.Pages;

public class IndexModel : PageModel
{
  public string? MyDbConnectionString { get; set; }
  private readonly ILogger<IndexModel> _logger;
  private readonly IConfiguration _configuration;

  public IndexModel(ILogger<IndexModel> logger, IConfiguration configuration)
  {
    _logger = logger;
    _configuration = configuration;
  }

  public void OnGet()
  {
    MyDbConnectionString = _configuration.GetConnectionString("MyDbConnection");
  }
}
