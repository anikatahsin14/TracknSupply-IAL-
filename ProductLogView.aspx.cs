using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.IO;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace popCrud
{
    public partial class ProductLogView : Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                BindProductLogs();
            }
        }

        private void BindProductLogs()
        {
            string connectionString = ConfigurationManager.ConnectionStrings["connection_"].ConnectionString;

            using (SqlConnection conn = new SqlConnection(connectionString))
            {
                conn.Open();
                SqlCommand cmd = new SqlCommand("SELECT * FROM ProductLogs ORDER BY ActionTime DESC", conn);
                SqlDataAdapter da = new SqlDataAdapter(cmd);
                DataSet ds = new DataSet();
                da.Fill(ds);

                rptProductLogs.DataSource = ds;
                rptProductLogs.DataBind();
            }
        }

        protected void btnExportLogToExcel_Click(object sender, EventArgs e)
        {
            string connectionString = ConfigurationManager.ConnectionStrings["connection_"].ConnectionString;

            using (SqlConnection conn = new SqlConnection(connectionString))
            {
                conn.Open();
                SqlCommand cmd = new SqlCommand("SELECT * FROM ProductLogs ORDER BY ActionTime DESC", conn);
                SqlDataAdapter da = new SqlDataAdapter(cmd);
                DataSet ds = new DataSet();
                da.Fill(ds);

                Response.Clear();
                Response.ContentType = "application/vnd.ms-excel";
                Response.AddHeader("Content-Disposition", "attachment; filename=ProductLogs.xls");

                StringWriter sw = new StringWriter();
                HtmlTextWriter htw = new HtmlTextWriter(sw);

                Table table = new Table();
                TableRow headerRow = new TableRow();

                // Add headers to the Excel file
                headerRow.Cells.Add(new TableCell { Text = "Log ID" });
                headerRow.Cells.Add(new TableCell { Text = "Product ID" });
                headerRow.Cells.Add(new TableCell { Text = "Action Type" });
                headerRow.Cells.Add(new TableCell { Text = "Previous Data" });
                headerRow.Cells.Add(new TableCell { Text = "Updated Data" });
                headerRow.Cells.Add(new TableCell { Text = "Username" });
                headerRow.Cells.Add(new TableCell { Text = "Action Time" });
                table.Rows.Add(headerRow);

                // Add rows from the dataset
                foreach (DataRow row in ds.Tables[0].Rows)
                {
                    TableRow dataRow = new TableRow();
                    dataRow.Cells.Add(new TableCell { Text = row["Log_ID"].ToString() });
                    dataRow.Cells.Add(new TableCell { Text = row["Product_ID"].ToString() });
                    dataRow.Cells.Add(new TableCell { Text = row["ActionType"].ToString() });
                    dataRow.Cells.Add(new TableCell { Text = row["PreviousData"].ToString() });
                    dataRow.Cells.Add(new TableCell { Text = row["UpdatedData"].ToString() });
                    dataRow.Cells.Add(new TableCell { Text = row["Username"].ToString() });
                    dataRow.Cells.Add(new TableCell { Text = row["ActionTime"].ToString() });
                    table.Rows.Add(dataRow);
                }

                // Render the table
                table.RenderControl(htw);

                // Write the output to the response
                Response.Write(sw.ToString());
                Response.End();
            }
        }
    }
}
