using System;

namespace popCrud
{
    public partial class Home : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            // Check if the session for the username is null (user not logged in or session expired)
            if (Session["Username"] == null)
            {
                // If session expired or user is not logged in, redirect to login page
                Response.Redirect("Login.aspx");
            }
            else
            {
                // Session is valid, we will handle expiration via JavaScript in the client
                Session["SessionExpired"] = false;
            }
        }

        protected void btnLogout_Click(object sender, EventArgs e)
        {
            // Clear the session
            Session.Clear();

            // Optionally abandon the session to remove all data
            Session.Abandon();

            // Redirect the user to the login page (or any other page)
            Response.Redirect("Login.aspx");
        }

    }
}
