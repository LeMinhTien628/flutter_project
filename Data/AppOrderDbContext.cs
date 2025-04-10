using api_app_pizza_flutter.Models;
using Microsoft.EntityFrameworkCore;
using System.Collections.Generic;
using System.Data;
namespace api_app_pizza_flutter.Data
{
    public class AppOrderDbContext:DbContext
    {
        public AppOrderDbContext(DbContextOptions options) : base(options) { }
        public DbSet<User> Users { get; set; }
    }
}
