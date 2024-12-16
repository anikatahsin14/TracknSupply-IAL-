using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace popCrud
{
    public partial class Supplier : Page
    {
        private string connectionString = System.Configuration.ConfigurationManager.ConnectionStrings["connection_"].ConnectionString;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                BindSuppliers();
                BindAddressDropDown();
                BindPartsCheckBoxList();

                // Check if the modal was open and re-populate form data from session
                if (Session["ModalState"] != null && Session["ModalState"].ToString() == "open")
                {
                    string supplierName = Session["SupplierName"]?.ToString();
                    string address = Session["Address"]?.ToString();
                    string partIDs = Session["PartIDs"]?.ToString();

                    // Set the form data if session values exist
                    if (supplierName != null)
                    {
                        txtName.Text = supplierName;
                    }

                    if (address != null)
                    {
                        ddlAddress.SelectedValue = address;
                    }

                    if (partIDs != null)
                    {
                        foreach (ListItem item in chkParts.Items)
                        {
                            item.Selected = partIDs.Contains(item.Value);
                        }
                    }

                    ScriptManager.RegisterStartupScript(this, GetType(), "showModal", "$('#supplierModal').modal('show');", true);
                }
            }

            if (Session["Username"] == null)
            {
                Response.Redirect("Login.aspx");
            }

            lblmsg.Text = string.Empty;
        }

        // Bind Suppliers to Repeater
        private void BindSuppliers()
        {
            string query = "SELECT SupplierID, Name, Address, PartID FROM Suppliertbl"; 
            using (SqlConnection conn = new SqlConnection(connectionString))
            {
                SqlDataAdapter adapter = new SqlDataAdapter(query, conn);
                DataTable dt = new DataTable();
                adapter.Fill(dt);
                rptSuppliers.DataSource = dt;
                rptSuppliers.DataBind();
            }
        }

        private void BindAddressDropDown()
        {
            string query = "SELECT DISTINCT Address FROM Suppliertbl";
            using (SqlConnection conn = new SqlConnection(connectionString))
            {
                SqlDataAdapter adapter = new SqlDataAdapter(query, conn);
                DataTable dt = new DataTable();
                adapter.Fill(dt);
                ddlAddress.DataSource = dt;
                ddlAddress.DataTextField = "Address";
                ddlAddress.DataValueField = "Address";
                ddlAddress.DataBind();
                ddlAddress.Items.Insert(0, new ListItem("--Select Address--", ""));
            }
        }

        private void BindPartsCheckBoxList()
        {
            string query = "SELECT PartID, Part_name FROM part";
            using (SqlConnection conn = new SqlConnection(connectionString))
            {
                SqlDataAdapter adapter = new SqlDataAdapter(query, conn);
                DataTable dt = new DataTable();
                adapter.Fill(dt);
                chkParts.DataSource = dt;
                chkParts.DataTextField = "Part_name";
                chkParts.DataValueField = "PartID";
                chkParts.DataBind();
            }
        }

        protected void modal_Click(object sender, EventArgs e)
        {
            hdSupplierID.Value = "";
            txtName.Text = "";
            ddlAddress.SelectedIndex = 0;
            chkParts.ClearSelection();

            Session["ModalState"] = "open";  // Ensure the modal is open
            Session["SupplierName"] = "";    // Clear previous name
            Session["Address"] = "";         // Clear previous address
            Session["PartIDs"] = "";         // Clear previous part selection

            // Set modal title
            setModalTitle(false);

            ScriptManager.RegisterStartupScript(this, GetType(), "showModal", "$('#supplierModal').modal('show');", true);
        }


        protected void btnSaveSupplier_Click(object sender, EventArgs e)
        {
            string supplierName = txtName.Text.Trim();
            string address = ddlAddress.SelectedValue;
            string partIDs = GetSelectedParts();

            if (string.IsNullOrEmpty(supplierName) || string.IsNullOrEmpty(address) || string.IsNullOrEmpty(partIDs))
            {
                Label1.Text = "Please fill all the fields.";
                return;
            }

            // Store data in session before saving
            Session["SupplierName"] = supplierName;
            Session["Address"] = address;
            Session["PartIDs"] = partIDs;

            if (string.IsNullOrEmpty(hdSupplierID.Value))
            {
                string query = "INSERT INTO Suppliertbl (Name, Address, PartID) VALUES (@Name, @Address, @PartID)";
                using (SqlConnection conn = new SqlConnection(connectionString))
                {
                    SqlCommand cmd = new SqlCommand(query, conn);
                    cmd.Parameters.AddWithValue("@Name", supplierName);
                    cmd.Parameters.AddWithValue("@Address", address);
                    cmd.Parameters.AddWithValue("@PartID", partIDs);

                    conn.Open();
                    cmd.ExecuteNonQuery();
                    Label1.Text = "Supplier added successfully!";

                    // Clear session after successful save (optional)
                    Session["SupplierName"] = null;
                    Session["Address"] = null;
                    Session["PartIDs"] = null;

                    BindSuppliers();
                }
            }
            else
            {
                string query = "UPDATE Suppliertbl SET Name = @Name, Address = @Address, PartID = @PartIDs WHERE SupplierID = @SupplierID";
                using (SqlConnection conn = new SqlConnection(connectionString))
                {
                    SqlCommand cmd = new SqlCommand(query, conn);
                    cmd.Parameters.AddWithValue("@Name", supplierName);
                    cmd.Parameters.AddWithValue("@Address", address);
                    cmd.Parameters.AddWithValue("@PartIDs", partIDs);
                    cmd.Parameters.AddWithValue("@SupplierID", hdSupplierID.Value);

                    conn.Open();
                    cmd.ExecuteNonQuery();
                    Label1.Text = "Supplier updated successfully!";

                    BindSuppliers();
                }
            }

            // Close the modal after save/update
            ScriptManager.RegisterStartupScript(this, GetType(), "closeModal", "$('#supplierModal').modal('hide');", true);
        }


        private string GetSelectedParts()
        {
            List<string> selectedParts = new List<string>();
            foreach (ListItem item in chkParts.Items)
            {
                if (item.Selected)
                {
                    selectedParts.Add(item.Value);
                }
            }
            return string.Join(",", selectedParts);
        }

        protected void updbtn_Command(object sender, CommandEventArgs e)
        {
            string supplierID = e.CommandArgument.ToString();
            string query = "SELECT SupplierID, Name, Address, PartID FROM Suppliertbl WHERE SupplierID = @SupplierID";
            using (SqlConnection conn = new SqlConnection(connectionString))
            {
                SqlCommand cmd = new SqlCommand(query, conn);
                cmd.Parameters.AddWithValue("@SupplierID", supplierID);

                conn.Open();
                SqlDataReader reader = cmd.ExecuteReader();
                if (reader.Read())
                {
                    hdSupplierID.Value = reader["SupplierID"].ToString();
                    txtName.Text = reader["Name"].ToString();
                    ddlAddress.SelectedValue = reader["Address"].ToString();
                    string partIDs = reader["PartID"].ToString();
                    txtName.Enabled = false;

                    // Store the values in ViewState
                    ViewState["SupplierName"] = reader["Name"].ToString();
                    ViewState["Address"] = reader["Address"].ToString();
                    ViewState["PartIDs"] = partIDs;

                    foreach (ListItem item in chkParts.Items)
                    {
                        item.Selected = partIDs.Contains(item.Value);
                        if (item.Selected)
                        {
                            item.Attributes.CssStyle.Add("color", "gray");
                        }
                    }

                    setModalTitle(true);
                    ScriptManager.RegisterStartupScript(this, GetType(), "showModal", "$('#supplierModal').modal('show');", true);
                }
            }
        }


        protected void dltbtn_Command(object sender, CommandEventArgs e)
        {
            string supplierID = e.CommandArgument.ToString();

            // First delete the related records in SupplierParts table
            string deleteSupplierPartsQuery = "DELETE FROM SupplierParts WHERE SupplierID = @SupplierID";
            using (SqlConnection conn = new SqlConnection(connectionString))
            {
                SqlCommand cmd = new SqlCommand(deleteSupplierPartsQuery, conn);
                cmd.Parameters.AddWithValue("@SupplierID", supplierID);

                conn.Open();
                cmd.ExecuteNonQuery();
            }

            // Then delete the supplier from Suppliertbl table
            string deleteSupplierQuery = "DELETE FROM Suppliertbl WHERE SupplierID = @SupplierID";
            using (SqlConnection conn = new SqlConnection(connectionString))
            {
                SqlCommand cmd = new SqlCommand(deleteSupplierQuery, conn);
                cmd.Parameters.AddWithValue("@SupplierID", supplierID);

                conn.Open();
                cmd.ExecuteNonQuery();
            }

            // Rebind suppliers list after deletion
            BindSuppliers();
        }


        protected void btnExportExcel_Click(object sender, EventArgs e)
        {

        }

        protected void btnCancel_Click(object sender, EventArgs e)
        {
            // Clear session data on modal cancel
            Session["ModalState"] = null;
            Session["SupplierName"] = null;
            Session["Address"] = null;
            Session["PartIDs"] = null;

            ScriptManager.RegisterStartupScript(this, GetType(), "closeModal", "$('#supplierModal').modal('hide');", true);
        }

        private void setModalTitle(bool isEditMode)
        {
            string script = isEditMode
                ? "document.getElementById('modalTitle').textContent = 'Update Supplier';"
                : "document.getElementById('modalTitle').textContent = 'Add New Supplier';";

            ScriptManager.RegisterStartupScript(this, GetType(), "setModalTitle", script, true);
        }

    }
}
