using System;
using System.Web.UI;

namespace popCrud
{
    public partial class ResetPassword : Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            // Retrieve the reset token from the query string
            string token = Request.QueryString["token"];

            if (string.IsNullOrEmpty(token))
            {
                lblMessage.Text = "Invalid or expired token.";
            }
            else
            {
                // Validate the token (check against your database)
                if (!IsTokenValid(token))
                {
                    lblMessage.Text = "Invalid or expired token.";
                }
            }
        }

        protected void btnResetPassword_Click(object sender, EventArgs e)
        {
            string newPassword = txtNewPassword.Text.Trim();
            string confirmPassword = txtConfirmPassword.Text.Trim();

            if (newPassword != confirmPassword)
            {
                lblMessage.Text = "Passwords do not match.";
                return;
            }

            // Reset the password (update the database with the new password)
            string token = Request.QueryString["token"];
            if (ResetPasswordInDb(token, newPassword))
            {
                lblMessage.ForeColor = System.Drawing.Color.Green;
                lblMessage.Text = "Your password has been reset successfully!";
            }
            else
            {
                lblMessage.Text = "There was an error resetting your password.";
            }
        }

        // Check if the token is valid (you'll need to implement this logic)
        private bool IsTokenValid(string token)
        {
            // Check against your database if the token exists and is not expired
            return true; // Placeholder for token validation logic
        }

        // Update the password in the database
        private bool ResetPasswordInDb(string token, string newPassword)
        {
            // Implement your logic to reset the password in your database
            return true; // Placeholder for DB update
        }
    }
}
