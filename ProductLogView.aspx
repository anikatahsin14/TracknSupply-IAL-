<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="ProductLogView.aspx.cs" Inherits="popCrud.ProductLogView" %>

<!DOCTYPE html>
<html lang="en">
<head runat="server">
    <meta charset="utf-8" />
    <title>Product Action Logs</title>
    <link href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css" rel="stylesheet" />
</head>
<body>
    <form id="form1" runat="server">
        <div class="container">
            <h2>Product Action Logs</h2>
            <asp:Repeater ID="rptProductLogs" runat="server">
                <HeaderTemplate>
                    <table class="table table-bordered">
                        <thead>
                            <tr>
                                <th>Log ID</th>  <!-- Add Log_ID Column -->
                                <th>Product ID</th>
                                <th>Action Type</th>
                                <th>Previous Data</th>
                                <th>Updated Data</th>
                                <th>Username</th>
                                <th>Action Time</th>
                            </tr>
                        </thead>
                </HeaderTemplate>
                <ItemTemplate>
                    <tr>
                        <td><%# Eval("Log_ID") %></td> <!-- Bind Log_ID -->
                        <td><%# Eval("Product_ID") %></td>
                        <td><%# Eval("ActionType") %></td>
                        <td><%# Eval("PreviousData") %></td>
                        <td><%# Eval("UpdatedData") %></td>
                        <td><%# Eval("Username") %></td>
                        <td><%# Eval("ActionTime", "{0:yyyy-MM-dd HH:mm:ss}") %></td>
                    </tr>
                </ItemTemplate>
                <FooterTemplate>
                    </table>
                </FooterTemplate>
            </asp:Repeater>
        </div>
    </form>

</body>
</html>
