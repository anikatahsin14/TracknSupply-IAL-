using System;
using System.Data.SqlClient; // For database operations
using System.Net;
using System.Net.Mail;
using System.Web.UI;

namespace popCrud
{
    public partial class ForgotPassword : Page
    {
        protected void btnSendResetLink_Click(object sender, EventArgs e)
        {
            string email = txtEmail.Text.Trim();

            // Check if the email exists in the database
            if (IsEmailRegistered(email))
            {
                string resetToken = GenerateResetToken(); // Generate a token for password reset
                string resetLink = "https://yourwebsite.com/ResetPassword.aspx?token=" + resetToken;

                // Save the token in the database
                if (SaveResetTokenToDb(email, resetToken))
                {
                    // Send the password reset email
                    if (SendPasswordResetEmail(email, resetLink))
                    {
                        lblMessage.ForeColor = System.Drawing.Color.Green;
                        lblMessage.Text = "Password reset link has been sent to your email.";
                    }
                    else
                    {
                        lblMessage.Text = "There was an error sending the reset email.";
                    }
                }
                else
                {
                    lblMessage.Text = "There was an error generating the reset link. Please try again later.";
                }
            }
            else
            {
                lblMessage.Text = "The email is not registered.";
            }
        }

        // Check if the email exists in the database
        private bool IsEmailRegistered(string email)
        {
            string connectionString = "Data Source=LAPTOP-7GH4FMI5;Initial Catalog=Practice;Persist Security Info=True;User ID=IAL;Password=anika;Encrypt=False"; // Replace with your database connection string

            using (SqlConnection conn = new SqlConnection(connectionString))
            {
                string query = "SELECT COUNT(*) FROM Users WHERE Email COLLATE SQL_Latin1_General_CP1_CI_AS = @Email"; // Case-insensitive query
                SqlCommand cmd = new SqlCommand(query, conn);
                cmd.Parameters.AddWithValue("@Email", email);

                conn.Open();
                int count = (int)cmd.ExecuteScalar();
                return count > 0; // Return true if the email exists
            }

        }



        // Generate a unique reset token
        private string GenerateResetToken()
        {
            return Guid.NewGuid().ToString(); // Use a GUID as the token
        }

        // Save the reset token to the database
        private bool SaveResetTokenToDb(string email, string resetToken)
        {
            string connectionString = "YourConnectionString"; // Update with your database connection string
            using (SqlConnection conn = new SqlConnection(connectionString))
            {
                string query = "UPDATE Users SET ResetToken = @ResetToken, TokenExpiry = @TokenExpiry WHERE Email = @Email";
                SqlCommand cmd = new SqlCommand(query, conn);
                cmd.Parameters.AddWithValue("@ResetToken", resetToken);
                cmd.Parameters.AddWithValue("@TokenExpiry", DateTime.Now.AddHours(1)); // Token valid for 1 hour
                cmd.Parameters.AddWithValue("@Email", email);

                conn.Open();
                int rowsAffected = cmd.ExecuteNonQuery();
                return rowsAffected > 0; // Return true if the token was saved successfully
            }
        }

        // Send password reset email
        private bool SendPasswordResetEmail(string email, string resetLink)
        {
            try
            {
                MailMessage mail = new MailMessage
                {
                    From = new MailAddress("youremail@gmail.com"), // Replace with your email
                    Subject = "Password Reset Request",
                    Body = $"<p>Click the link below to reset your password:</p><a href='{resetLink}'>Reset Password</a>",
                    IsBodyHtml = true
                };
                mail.To.Add(email);

                SmtpClient smtp = new SmtpClient("smtp.gmail.com", 587)
                {
                    Credentials = new NetworkCredential("youremail@gmail.com", "your-app-password"), // Replace with your email and App Password
                    EnableSsl = true
                };

                smtp.Send(mail);
                return true;
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine("Error: " + ex.Message);
                return false;
            }
        }
    }
}
