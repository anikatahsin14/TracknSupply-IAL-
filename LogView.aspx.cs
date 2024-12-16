using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI;

namespace popCrud
{
    public partial class LogView : Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                string module = Request.QueryString["module"];
                if (module == "PartManagement")
                {
                    BindLogs(filterByModule: true);
                }
                else
                {
                    BindLogs();
                }
            }

            // Check if a new log has been added
            if (Session["NewLogAdded"] != null && (bool)Session["NewLogAdded"])
            {
                // Trigger the client-side effect (via JavaScript)
                ScriptManager.RegisterStartupScript(this, this.GetType(), "ShowNewLogEffect", "showNewLogEffect();", true);

                // Reset session flag
                Session["NewLogAdded"] = null;
            }
        }



        // This method will be called when a new log is added to the database
        // This method will be called when a new log is added to the database
        private void AddNewLog(string actionType, string partId, string partName, decimal cost, int quantity)
        {
            string connectionstring = ConfigurationManager.ConnectionStrings["connection_"].ConnectionString;

            using (SqlConnection conn = new SqlConnection(connectionstring))
            {
                string query = "INSERT INTO PartLogs (ActionType, PartID, PartName, Cost, Quantity, Timestamp, UserName) VALUES (@ActionType, @PartID, @PartName, @Cost, @Quantity, @Timestamp, @UserName)";

                using (SqlCommand cmd = new SqlCommand(query, conn))
                {
                    cmd.Parameters.AddWithValue("@ActionType", actionType);
                    cmd.Parameters.AddWithValue("@PartID", partId);
                    cmd.Parameters.AddWithValue("@PartName", partName);
                    cmd.Parameters.AddWithValue("@Cost", cost);
                    cmd.Parameters.AddWithValue("@Quantity", quantity);
                    cmd.Parameters.AddWithValue("@Timestamp", DateTime.Now);
                    cmd.Parameters.AddWithValue("@UserName", "Admin"); // Assuming an admin user for example

                    conn.Open();
                    cmd.ExecuteNonQuery();
                }
            }

            // After inserting the new log, set the session flag indicating a new log is added
            Session["NewLogAdded"] = true;
        }



        private void BindLogs(bool filterByModule = false)
        {
            string connectionstring = ConfigurationManager.ConnectionStrings["connection_"].ConnectionString;

            using (SqlConnection conn = new SqlConnection(connectionstring))
            {
                // Query to fetch logs
                string query = "SELECT LogID, ActionType, PartID, ProductID, PartName, Cost, Quantity, Timestamp, UserName FROM PartLogs";

                // Apply filter if required
                if (filterByModule)
                {
                    query += " WHERE ModuleName = @ModuleName";
                }

                query += " ORDER BY Timestamp DESC";

                using (SqlCommand cmd = new SqlCommand(query, conn))
                {
                    if (filterByModule)
                    {
                        cmd.Parameters.AddWithValue("@ModuleName", "PartManagement");
                    }

                    SqlDataAdapter da = new SqlDataAdapter(cmd);
                    DataTable dt = new DataTable();
                    da.Fill(dt);

                    gvLogs.DataSource = dt;
                    gvLogs.DataBind();
                }
            }
        }
    }
}
