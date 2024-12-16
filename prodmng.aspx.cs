using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.IO;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace popCrud
{
    public partial class Part : Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                BindProductList();
                btnSaveProduct.Text = "Save";
            }

            if (Session["Username"] == null)
            {
                Response.Redirect("Login.aspx");
            }

            lblProductMessage.Text = string.Empty;
        }

        private void BindProductList()
        {
            string connectionString = ConfigurationManager.ConnectionStrings["connection_"].ConnectionString;
            using (SqlConnection conn = new SqlConnection(connectionString))
            {
                conn.Open();
                SqlCommand cmd = new SqlCommand("SELECT * FROM prod_updated", conn);
                SqlDataReader reader = cmd.ExecuteReader();

                rptProductList.DataSource = reader;
                rptProductList.DataBind();
            }
        }

        protected void btnAddNewProduct_Click(object sender, EventArgs e)
        {
            ClearFormFields();
            hdProductIdentifier.Value = "";
            txtProductNameInput.Enabled = true;
            btnSaveProduct.Text = "Save";
            ScriptManager.RegisterStartupScript(this, this.GetType(), "setModalTitle", "setModalTitle(false);", true);
            ScriptManager.RegisterStartupScript(this, this.GetType(), "ShowModal", "$('#productModal').modal('show');", true);
        }

        private void ClearFormFields()
        {
            txtProductNameInput.Text = "";
            txtPriceInput.Text = "";
        }

        protected void btnSaveProduct_Click(object sender, EventArgs e)
        {
            lblProductMessage.Text = string.Empty;

            if (string.IsNullOrEmpty(txtProductNameInput.Text) || string.IsNullOrEmpty(txtPriceInput.Text))
            {
                lblProductMessage.Text = "All fields are required!";
                return;
            }

            string productName = txtProductNameInput.Text.Trim();
            if (!decimal.TryParse(txtPriceInput.Text, out decimal price))
            {
                lblProductMessage.Text = "Invalid price format!";
                return;
            }

            string connectionString = ConfigurationManager.ConnectionStrings["connection_"].ConnectionString;
            using (SqlConnection conn = new SqlConnection(connectionString))
            {
                conn.Open();
                SqlCommand cmd;
                string previousData = "Null";
                string updatedData = $"Product Name: {productName}, Price: {price}";

                int productId = 0;

                if (!string.IsNullOrEmpty(hdProductIdentifier.Value))
                {
                    productId = int.Parse(hdProductIdentifier.Value);
                    previousData = GetProductData(productId, conn);

                    cmd = new SqlCommand("UPDATE prod_updated SET Product_Name = @ProductName, Price = @Price WHERE Product_ID = @ProductID", conn);
                    cmd.Parameters.AddWithValue("@ProductID", productId);
                }
                else
                {
                    cmd = new SqlCommand("INSERT INTO prod_updated (Product_Name, Price) OUTPUT INSERTED.Product_ID VALUES (@ProductName, @Price)", conn);
                }

                cmd.Parameters.AddWithValue("@ProductName", productName);
                cmd.Parameters.AddWithValue("@Price", price);

                if (string.IsNullOrEmpty(hdProductIdentifier.Value))
                {
                    productId = (int)cmd.ExecuteScalar();
                }
                else
                {
                    cmd.ExecuteNonQuery();
                }

                LogProductAction(conn, productId, string.IsNullOrEmpty(hdProductIdentifier.Value) ? "Insert" : "Update", previousData, updatedData);
            }

            BindProductList();
            ClearFormFields();
            ScriptManager.RegisterStartupScript(this, this.GetType(), "HideModal", "$('#productModal').modal('hide');", true);
        }

        private string GetProductData(int productId, SqlConnection conn)
        {
            SqlCommand cmd = new SqlCommand("SELECT Product_Name, Price FROM prod_updated WHERE Product_ID = @ProductID", conn);
            cmd.Parameters.AddWithValue("@ProductID", productId);
            SqlDataReader reader = cmd.ExecuteReader();

            string previousData = string.Empty;
            if (reader.Read())
            {
                previousData = $"Product Name: {reader["Product_Name"]}, Price: {reader["Price"]}";
            }

            reader.Close();
            return previousData;
        }

        private void LogProductAction(SqlConnection conn, int productId, string actionType, string previousData, string updatedData)
        {
            try
            {
                string username = Session["Username"]?.ToString();
                if (string.IsNullOrEmpty(username))
                {
                    throw new Exception("Username is not available in session.");
                }

                string actionTime = DateTime.Now.ToString("yyyy-MM-dd HH:mm:ss");

                SqlCommand cmd = new SqlCommand(
                    "INSERT INTO ProductLogs (Product_ID, ActionType, PreviousData, UpdatedData, Username, ActionTime) " +
                    "VALUES (@ProductID, @ActionType, @PreviousData, @UpdatedData, @Username, @ActionTime)", conn);

                cmd.Parameters.AddWithValue("@ProductID", productId);
                cmd.Parameters.AddWithValue("@ActionType", actionType);
                cmd.Parameters.AddWithValue("@PreviousData", previousData ?? "Null");
                cmd.Parameters.AddWithValue("@UpdatedData", updatedData ?? "Null");
                cmd.Parameters.AddWithValue("@Username", username);
                cmd.Parameters.AddWithValue("@ActionTime", actionTime);

                cmd.ExecuteNonQuery();
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine("LogProductAction Error: " + ex.Message);
            }
        }

        protected void btnEditProduct_Command(object sender, CommandEventArgs e)
        {
            int productId = Convert.ToInt32(e.CommandArgument);

            string connectionString = ConfigurationManager.ConnectionStrings["connection_"].ConnectionString;
            using (SqlConnection conn = new SqlConnection(connectionString))
            {
                conn.Open();
                SqlCommand cmd = new SqlCommand("SELECT * FROM prod_updated WHERE Product_ID = @ProductID", conn);
                cmd.Parameters.AddWithValue("@ProductID", productId);
                SqlDataReader reader = cmd.ExecuteReader();

                if (reader.Read())
                {
                    txtProductNameInput.Text = reader["Product_Name"].ToString();
                    txtPriceInput.Text = reader["Price"].ToString();
                    hdProductIdentifier.Value = productId.ToString();
                }

                reader.Close();
            }

            ScriptManager.RegisterStartupScript(this, this.GetType(), "setModalTitle", "setModalTitle(true);", true);
            txtProductNameInput.Enabled = false;
            btnSaveProduct.Text = "Update";
            ScriptManager.RegisterStartupScript(this, this.GetType(), "ShowModal", "$('#productModal').modal('show');", true);
        }

        protected void btnDeleteProduct_Command(object sender, CommandEventArgs e)
        {
            int productId = Convert.ToInt32(e.CommandArgument);
            string connectionString = ConfigurationManager.ConnectionStrings["connection_"].ConnectionString;

            using (SqlConnection conn = new SqlConnection(connectionString))
            {
                conn.Open();

                string previousData = GetProductData(productId, conn);

                SqlCommand cmd = new SqlCommand("DELETE FROM prod_updated WHERE Product_ID = @ProductID", conn);
                cmd.Parameters.AddWithValue("@ProductID", productId);
                cmd.ExecuteNonQuery();

                LogProductAction(conn, productId, "Delete", previousData, "Null");
            }

            BindProductList();
        }

        protected void btnExportExcel_Click(object sender, EventArgs e)
        {
            string connectionString = ConfigurationManager.ConnectionStrings["connection_"].ConnectionString;

            using (SqlConnection conn = new SqlConnection(connectionString))
            {
                conn.Open();
                SqlCommand cmd = new SqlCommand("SELECT * from prod_updated", conn);
                SqlDataAdapter da = new SqlDataAdapter(cmd);
                DataSet ds = new DataSet();
                da.Fill(ds);

                Response.Clear();
                Response.ContentType = "application/vnd.ms-excel";
                Response.AddHeader("Content-Disposition", "attachment; filename=ProductData.xls");

                StringWriter sw = new StringWriter();
                HtmlTextWriter htw = new HtmlTextWriter(sw);

                Table table = new Table();
                TableRow headerRow = new TableRow();

                headerRow.Cells.Add(new TableCell { Text = "Product_ID" });
                headerRow.Cells.Add(new TableCell { Text = "Product_Name" });
                headerRow.Cells.Add(new TableCell { Text = "Price" });
                table.Rows.Add(headerRow);

                foreach (DataRow row in ds.Tables[0].Rows)
                {
                    TableRow dataRow = new TableRow();
                    dataRow.Cells.Add(new TableCell { Text = row["Product_ID"].ToString() });
                    dataRow.Cells.Add(new TableCell { Text = row["Product_Name"].ToString() });
                    dataRow.Cells.Add(new TableCell { Text = row["Price"].ToString() });
                    table.Rows.Add(dataRow);
                }

                table.RenderControl(htw);

                Response.Write(sw.ToString());
                Response.End();
            }
        }
    }
}
