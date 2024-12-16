using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.IO;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Xml;

namespace popCrud
{
    public partial class About : Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                BindProductNames();
                BindPartData();
                btnsave.Text = "Save";
            }

            if (Session["Username"] == null)
            {

                Response.Redirect("Login.aspx");
            }

            lblmsg.Text = string.Empty;
        }

        private void BindProductNames()
        {
            string connectionstring = ConfigurationManager.ConnectionStrings["connection_"].ConnectionString;
            using (SqlConnection conn = new SqlConnection(connectionstring))
            {
                conn.Open();
                SqlCommand cmd = new SqlCommand("SELECT Product_ID, Product_Name FROM prod_updated", conn);
                SqlDataReader reader = cmd.ExecuteReader();

                ddlProductSearch.Items.Clear();
                ddlProductSearch.Items.Add(new ListItem("--Select Product--", ""));
                while (reader.Read())
                {
                    string productId = reader["Product_ID"].ToString();
                    string productName = reader["Product_Name"].ToString();
                    ddlProductSearch.Items.Add(new ListItem(productName, productId));
                }
                ddl.Items.Clear();
                ddl.Items.Add(new ListItem("--Select Product--", ""));
                reader.Close();
                reader = cmd.ExecuteReader();
                while (reader.Read())
                {
                    string productId = reader["Product_ID"].ToString();
                    string productName = reader["Product_Name"].ToString();
                    ddl.Items.Add(new ListItem(productName, productId));
                }
            }
        }

        private void BindPartData(string productId = "")
        {
            string connectionstring = ConfigurationManager.ConnectionStrings["connection_"].ConnectionString;
            using (SqlConnection conn = new SqlConnection(connectionstring))
            {
                string query = @"
            SELECT p.PartID, p.Part_name, p.Cost, p.Quantity, p.Product_ID, pr.Product_Name
            FROM part p
            INNER JOIN prod_updated pr ON p.Product_ID = pr.Product_ID";

                if (!string.IsNullOrEmpty(productId))
                {
                    query += " WHERE p.Product_ID = @Product_ID";
                }

                SqlDataAdapter da = new SqlDataAdapter(query, conn);
                if (!string.IsNullOrEmpty(productId))
                {
                    da.SelectCommand.Parameters.AddWithValue("@Product_ID", productId);
                }

                DataTable dt = new DataTable();
                da.Fill(dt);

                if (!dt.Columns.Contains("Cost"))
                {
                    lblmsg.Text = "The Cost column is missing from the data.";
                    return;
                }

                if (!dt.Columns.Contains("CostPerQuantity"))
                {
                    dt.Columns.Add("CostPerQuantity", typeof(double));
                }

                foreach (DataRow row in dt.Rows)
                {
                    double cost = row["Cost"] != DBNull.Value ? Convert.ToDouble(row["Cost"]) : 0;
                    double quantity = row["Quantity"] != DBNull.Value ? Convert.ToDouble(row["Quantity"]) : 0;
                    row["CostPerQuantity"] = cost * quantity;
                }

                rpt1.DataSource = dt;
                rpt1.DataBind();
            }
        }


        protected void ddlProductSearch_SelectedIndexChanged(object sender, EventArgs e)
        {
            string productId = ddlProductSearch.SelectedValue;
            if (!string.IsNullOrEmpty(productId))
            {
                BindPartData(productId);
            }
            else
            {
                BindPartData();
            }
        }

        private void ClearFormFields()
        {
            txtname.Text = "";
            txtprice.Text = "";
            txtquantity.Text = "";
            ddl.SelectedIndex = 0;
        }

        protected void modal_Click(object sender, EventArgs e)
        {
            ClearFormFields();
            hdid.Value = "";

            ddl.Enabled = true;

            ScriptManager.RegisterStartupScript(this, this.GetType(), "setModalTitle", "setModalTitle(false);", true);

            ScriptManager.RegisterStartupScript(this, this.GetType(), "ShowModal", "$('#mymodal').modal('show');", true);
        }


        protected void btnsave_Click(object sender, EventArgs e)
        {
            lblmsg.Text = string.Empty;

            if (string.IsNullOrEmpty(txtname.Text))
            {
                lblmsg.Text = "Part Name cannot be empty!";
                return;
            }

            string partName = txtname.Text;
            if (!System.Text.RegularExpressions.Regex.IsMatch(partName, @"^[a-zA-Z\s]+$"))
            {
                lblmsg.Text = "Part Name can only contain letters and spaces!";
                return;
            }

            if (string.IsNullOrEmpty(txtprice.Text) || string.IsNullOrEmpty(txtquantity.Text) || ddl.SelectedIndex == 0)
            {
                lblmsg.Text = "All fields must be filled out!";
                return;
            }

            string connectionstring = ConfigurationManager.ConnectionStrings["connection_"].ConnectionString;
            string insertedPartId = string.Empty;

            using (SqlConnection conn = new SqlConnection(connectionstring))
            {
                conn.Open();

                int productId = Convert.ToInt32(ddl.SelectedValue);
                double cost = double.Parse(txtprice.Text);
                double quantity = double.Parse(txtquantity.Text);
                double costPerQuantity = cost * quantity;

                SqlCommand cmd;

                if (!string.IsNullOrEmpty(hdid.Value))  // Update operation
                {
                    string PartID = hdid.Value;
                    cmd = new SqlCommand("UPDATE part SET Part_name = @Part_name, Cost = @Cost, Quantity = @Quantity, Product_ID = @Product_ID WHERE PartID = @PartID", conn);
                    cmd.Parameters.AddWithValue("@PartID", PartID);
                    cmd.Parameters.AddWithValue("@Part_name", partName);
                    cmd.Parameters.AddWithValue("@Cost", cost);
                    cmd.Parameters.AddWithValue("@Quantity", quantity);
                    cmd.Parameters.AddWithValue("@Product_ID", productId);
                    cmd.ExecuteNonQuery();
                    insertedPartId = PartID;

                    // Insert log for update
                    LogAction(conn, "Updated", insertedPartId, productId, partName, cost, quantity);
                }
                else  // Insert operation
                {
                    cmd = new SqlCommand("INSERT INTO part(Part_name, Cost, Quantity, Product_ID) OUTPUT INSERTED.PartID VALUES(@Part_name, @Cost, @Quantity, @Product_ID)", conn);
                    cmd.Parameters.AddWithValue("@Part_name", partName);
                    cmd.Parameters.AddWithValue("@Cost", cost);
                    cmd.Parameters.AddWithValue("@Quantity", quantity);
                    cmd.Parameters.AddWithValue("@Product_ID", productId);

                    insertedPartId = cmd.ExecuteScalar().ToString();

                    // Insert log for insert
                    LogAction(conn, "Inserted", insertedPartId, productId, partName, cost, quantity);
                }

                conn.Close();

                if (!string.IsNullOrEmpty(insertedPartId))
                {
                    string successMessage = $"Data saved successfully! Part ID: {insertedPartId}";
                    string script = $"alert('{successMessage}');";
                    ScriptManager.RegisterStartupScript(this, GetType(), "SuccessPopup", script, true);
                }
                else
                {
                    lblmsg.Text = "Error occurred!";
                }

                ClearFormFields();  // Clears form fields after saving

                string selectedProductId = ddlProductSearch.SelectedValue;
                if (!string.IsNullOrEmpty(selectedProductId))
                {
                    BindPartData(selectedProductId);  // Refresh part data for selected product
                }
                else
                {
                    BindPartData();  // Refresh all part data
                }
            }
        }

        // Log the action in the PartLogs table
        private void LogAction(SqlConnection conn, string actionType, string partId, int productId, string partName, double cost, double quantity)
        {
            // Use DECIMAL for cost and INT for quantity
            string logQuery = "INSERT INTO PartLogs (ActionType, PartID, ProductID, PartName, Cost, Quantity, Timestamp, UserName) " +
                              "VALUES (@ActionType, @PartID, @ProductID, @PartName, @Cost, @Quantity, @Timestamp, @UserName)";
            SqlCommand cmd = new SqlCommand(logQuery, conn);

            // Add parameters with the correct types
            cmd.Parameters.AddWithValue("@ActionType", actionType); // e.g., 'Insert', 'Update', 'Delete'
            cmd.Parameters.AddWithValue("@PartID", partId);         // Pass the partId as a string
            cmd.Parameters.AddWithValue("@ProductID", productId);   // Pass the productId as an int
            cmd.Parameters.AddWithValue("@PartName", partName);     // Pass the partName as a string
            cmd.Parameters.AddWithValue("@Cost", cost);             // Ensure cost is passed as a decimal (double)
            cmd.Parameters.AddWithValue("@Quantity", quantity);     // Ensure quantity is passed as an int
            cmd.Parameters.AddWithValue("@Timestamp", DateTime.Now); // Timestamp is the current time
            cmd.Parameters.AddWithValue("@UserName", Session["Username"].ToString()); // Assuming session contains the username

            // Execute the SQL query to log the action
            cmd.ExecuteNonQuery();
        }



        protected void dltbtn_Command(object sender, CommandEventArgs e)
        {
            string PartID = e.CommandArgument.ToString();
            string selectedProductId = ddlProductSearch.SelectedValue; // Get the currently selected product ID

            string connectionstring = ConfigurationManager.ConnectionStrings["connection_"].ConnectionString;

            using (SqlConnection conn = new SqlConnection(connectionstring))
            {
                conn.Open();

                // Log the deletion action before actually deleting the part
                // Retrieve the part details to log them
                SqlCommand getPartCmd = new SqlCommand("SELECT * FROM part WHERE PartID = @PartID", conn);
                getPartCmd.Parameters.AddWithValue("@PartID", PartID);
                SqlDataReader reader = getPartCmd.ExecuteReader();

                string partName = string.Empty;
                int productId = 0;
                double cost = 0;
                double quantity = 0;

                if (reader.Read())
                {
                    partName = reader["Part_name"].ToString();
                    productId = Convert.ToInt32(reader["Product_ID"]);
                    cost = Convert.ToDouble(reader["Cost"]);
                    quantity = Convert.ToDouble(reader["Quantity"]);
                }
                reader.Close();

                // Log the deletion action
                LogAction(conn, "Deleted", PartID, productId, partName, cost, quantity);

                // Proceed with deleting the part
                SqlCommand cmd = new SqlCommand("DELETE FROM part WHERE PartID = @PartID", conn);
                cmd.Parameters.AddWithValue("@PartID", PartID);
                cmd.ExecuteNonQuery();
            }

            // Rebind the part data after deletion
            if (!string.IsNullOrEmpty(selectedProductId))
            {
                BindPartData(selectedProductId);
            }
            else
            {
                BindPartData();
            }
        }


        protected void updbtn_Command(object sender, CommandEventArgs e)
        {
            if (e.CommandName == "Update")
            {
                int partID = Convert.ToInt32(e.CommandArgument);
                string connectionstring = ConfigurationManager.ConnectionStrings["connection_"].ConnectionString;

                using (SqlConnection conn = new SqlConnection(connectionstring))
                {
                    conn.Open();

                    SqlCommand cmd = new SqlCommand("SELECT * FROM part WHERE PartID = @PartID", conn);
                    cmd.Parameters.AddWithValue("@PartID", partID);
                    SqlDataReader reader = cmd.ExecuteReader();

                    if (reader.Read())
                    {
                        txtname.Text = reader["Part_name"].ToString();
                        txtprice.Text = reader["Cost"].ToString();
                        txtquantity.Text = reader["Quantity"].ToString();

                        string productId = reader["Product_ID"].ToString();
                        ddl.SelectedValue = productId;

                        ddl.Enabled = false;

                        hdid.Value = partID.ToString();

                        btnsave.Text = "Update";
                    }

                    reader.Close();
                }

                ScriptManager.RegisterStartupScript(this, this.GetType(), "setModalTitle", "setModalTitle(true);", true);

                ScriptManager.RegisterStartupScript(this, this.GetType(), "ShowModal", "$('#mymodal').modal('show');", true);
            }
        }

    }
}
