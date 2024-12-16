using System;
using System.Data.SqlClient;
using System.Security.Cryptography;
using System.Text;
using System.Configuration;

namespace popCrud
{
    public partial class Register : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            // Optional: Any initialization logic on page load
        }

        protected void btnRegister_Click(object sender, EventArgs e)
        {
            string username = txtUsername.Text.Trim();
            string password = txtPassword.Text.Trim();
            string confirmPassword = txtConfirmPassword.Text.Trim();

            // Check if passwords match
            if (password != confirmPassword)
            {
                lblRegisterMessage.Text = "Passwords do not match!";
                return;
            }

            // Check if the username already exists
            if (UserExists(username))
            {
                lblRegisterMessage.Text = "Username already exists!";
                return;
            }

            // Proceed with registration if the username is available
            SaveUserToDatabase(username, HashPassword(password));
            lblRegisterMessage.Text = "Registration successful! Redirecting to Login...";
            Response.Redirect("Login.aspx");
        }

        protected void btnLoginRedirect_Click(object sender, EventArgs e)
        {
            // Test if the method is being called
            Response.Write("Redirecting to Login page...");

            // Redirect to Login page
            Response.Redirect("Login.aspx");
        }


        private bool UserExists(string username)
        {
            // Example of checking the database for an existing user
            string connectionString = "Data Source=LAPTOP-7GH4FMI5;Initial Catalog=Practice;Persist Security Info=True;User ID=IAL;Password=anika;Encrypt=False";
            using (SqlConnection connection = new SqlConnection(connectionString))
            {
                string query = "SELECT COUNT(*) FROM Users WHERE Username = @Username";
                using (SqlCommand command = new SqlCommand(query, connection))
                {
                    command.Parameters.AddWithValue("@Username", username);
                    connection.Open();

                    int userCount = (int)command.ExecuteScalar();

                    // Return true if the user exists, false otherwise
                    return userCount > 0;
                }
            }
        }


        private void SaveUserToDatabase(string username, string hashedPassword)
        {
            string connectionString = "Data Source=LAPTOP-7GH4FMI5;Initial Catalog=Practice;Persist Security Info=True;User ID=IAL;Password=anika;Encrypt=False";

            using (SqlConnection connection = new SqlConnection(connectionString))
            {
                string query = "INSERT INTO Users (Username, PasswordHash) VALUES (@Username, @PasswordHash)";
                using (SqlCommand command = new SqlCommand(query, connection))
                {
                    command.Parameters.AddWithValue("@Username", username);
                    command.Parameters.AddWithValue("@PasswordHash", hashedPassword);

                    connection.Open();
                    command.ExecuteNonQuery();
                }
            }
        }

        private string HashPassword(string password)
        {
            using (SHA256 sha256 = SHA256.Create())
            {
                byte[] bytes = sha256.ComputeHash(Encoding.UTF8.GetBytes(password));
                return BitConverter.ToString(bytes).Replace("-", "").ToLower();
            }
        }
    }
}
