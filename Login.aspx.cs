using System;
using System.Data.SqlClient;
using System.Security.Cryptography;
using System.Text;

namespace popCrud
{
    public partial class Login : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            // If the user is already logged in, redirect to the Home page
            if (Session["Username"] != null)
            {
                Response.Redirect("Home.aspx");
            }
        }

        protected void btnLogin_Click(object sender, EventArgs e)
        {
            string username = txtUsername.Text.Trim();
            string password = txtPassword.Text.Trim();

            if (IsValidUser(username, password))
            {
                // Store the logged-in user's username in session
                Session["Username"] = username;

                // Redirect to the Home page after successful login
                Response.Redirect("Home.aspx");
            }
            else
            {
                lblLoginMessage.Text = "Invalid username or password! Please try again.";
            }
        }

        private bool IsValidUser(string username, string password)
        {
            string storedPasswordHash = GetStoredPasswordHash(username);

            if (storedPasswordHash == null)
            {
                return false; // User not found
            }

            string enteredPasswordHash = HashPassword(password);  // Hash the entered password

            return storedPasswordHash == enteredPasswordHash;  // Compare hashed values
        }

        private string GetStoredPasswordHash(string username)
        {
            string connectionString = "Data Source=LAPTOP-7GH4FMI5;Initial Catalog=Practice;Persist Security Info=True;User ID=IAL;Password=anika;Encrypt=False";
            string storedPasswordHash = null;

            using (SqlConnection connection = new SqlConnection(connectionString))
            {
                string query = "SELECT PasswordHash FROM Users WHERE Username = @Username";
                using (SqlCommand command = new SqlCommand(query, connection))
                {
                    command.Parameters.AddWithValue("@Username", username);
                    connection.Open();
                    storedPasswordHash = (string)command.ExecuteScalar();
                }
            }

            return storedPasswordHash;
        }

        protected void btnRegisterRedirect_Click(object sender, EventArgs e)
        {
            // Debugging: Print a message to the browser output
            Response.Write("<script>alert('Button clicked');</script>");

            // Redirect to the Register page
            Response.Redirect("Register.aspx");
        }


        // This method hashes the password using SHA256
        private string HashPassword(string password)
        {
            using (SHA256 sha256 = SHA256.Create())
            {
                byte[] passwordBytes = Encoding.UTF8.GetBytes(password);
                byte[] hashedBytes = sha256.ComputeHash(passwordBytes);

                StringBuilder hashedPassword = new StringBuilder();
                foreach (byte b in hashedBytes)
                {
                    hashedPassword.Append(b.ToString("x2")); // Hex format
                }

                return hashedPassword.ToString();
            }
        }
    }
}
