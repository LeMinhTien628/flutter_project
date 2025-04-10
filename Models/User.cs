using System.ComponentModel.DataAnnotations;

namespace api_app_pizza_flutter.Models
{
    public class User
    {
        public int UserId { get; set; }
        
        public required string UserName { get; set; }
        public  required string Email { get; set; }
        public required string Phone {  get; set; }
        public required string PasswordHash { get; set; }
        public  string? ProfilePicture { get; set; }
        public DateTime CreatedDate { get; set; }
    }
}
