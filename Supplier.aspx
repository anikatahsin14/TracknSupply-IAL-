<%@ Page Title="About" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" EnableViewState="true" ViewStateMode="Enabled" CodeBehind="Supplier.aspx.cs" Inherits="popCrud.Supplier" %>

<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">

    <style>
        body {
            background-image: url('<%= ResolveUrl("~/Images/bg.png") %>');
            background-size: cover;
            background-position: center center;
            background-repeat: no-repeat;
            margin: 0;
            height: 100vh;
        }

        table {
            border-collapse: collapse;
            width: 100%;
        }

        th, td {
            text-align: left;
            padding: 8px;
        }

        th {
            background-color: darkcyan;
            color: white;
        }

        tr:nth-child(even) {
            background-color: #f2f2f2;
        }

        tr.separator {
            border-top: 1px solid #ddd;
            border-bottom: 1px solid #ddd;
            border-color: darkgreen;
        }

        .btn-green {
            background-color: limegreen;
            color: white;
            border: solid;
            padding: 10px 20px;
            font-size: 14px;
            cursor: pointer;
        }

        .btn-red {
            background-color: orangered;
            color: white;
            border: solid;
            padding: 10px 20px;
            font-size: 14px;
            cursor: pointer;
        }

        .btn-green:hover {
            background-color: forestgreen;
        }

        .btn-red:hover {
            background-color: red;
        }

        .scrollable-checkboxlist-container {
            width: 100%; /* Ensure the box takes full width of the parent container */
            height: 150px; /* Set a fixed height */
            overflow-y: scroll; /* Enable vertical scrolling */
            border: 1px solid #ddd; /* Border around the container */
            padding: 10px; /* Padding inside the box */
            box-sizing: border-box; /* Ensure padding is inside the box's width */
        }

        .scrollable-checkboxlist {
            width: 100%; /* Ensure the CheckBoxList takes up the full width of the container */
        }

        .checkbox-item {
            display: block; /* Display each checkbox on a new line */
            margin-bottom: 5px; /* Add some space between the items */
        }

        .modal-title {
            text-align: center; /* Center the title */
            width: 100%;
        }
    </style>

    <link href="https://stackpath.bootstrapcdn.com/bootstrap/4.3.1/css/bootstrap.min.css" rel="stylesheet" />
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css" />

    <div class="container">
        <div class="modal fade" id="supplierModal" data-backdrop="false" role="dialog">
            <div class="modal-dialog modal-dialog-centered">
                <div class="modal-content">
                    <div class="modal-header">
                        <h4 id="modalTitle" class="modal-title">Add New Supplier</h4>
                        <!-- Modal title -->
                        <asp:Label ID="lblmsg" Text="" runat="server" EnableViewState="true"/>
                        <button type="button" class="close" data-dismiss="modal">&times;</button>
                    </div>

                    <div class="modal-body">
                        <div class="form-group">
                            <label for="<%= txtName.ClientID %>">Supplier Name</label>
                            <asp:TextBox ID="txtName" CssClass="form-control" runat="server" EnableViewState="true"></asp:TextBox>
                        </div>
                        <div class="form-group">
                            <label for="<%= ddlAddress.ClientID %>">Supplier Address</label>
                            <asp:DropDownList ID="ddlAddress" CssClass="form-control" runat="server" EnableViewState="true">
                                <asp:ListItem Value="">--Select Address--</asp:ListItem>
                            </asp:DropDownList>
                        </div>



                        <asp:HiddenField ID="hdSupplierID" runat="server" />

                        <div class="form-group">
                            <label for="chkParts">Select Parts:</label>
                            <div class="scrollable-checkboxlist-container">
                                <asp:CheckBoxList ID="chkParts" runat="server" CssClass="scrollable-checkboxlist" EnableViewState="true">
                                </asp:CheckBoxList>
                            </div>
                        </div>

                    </div>

                    <div class="modal-footer">
                        <asp:Button ID="btnSaveSupplier" runat="server" Text="Save" OnClick="btnSaveSupplier_Click" OnClientClick="return validateForm();" CssClass="btn-green" />
                        <asp:Label ID="Label1" runat="server" Text="" ForeColor="Red"></asp:Label>
                        <button type="button" class="btn btn-danger" data-dismiss="modal">Close</button>
                    </div>

                </div>
            </div>
        </div>

    </div>

    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <script src="https://stackpath.bootstrapcdn.com/bootstrap/4.3.1/js/bootstrap.min.js"></script>


    <section id="section">
        <div class="row match-height">
            <div class="col-12">
                <div class="card">
                    <div class="card-header d-flex justify-content-between align-items-center">
                        <h3 class="m-0 text-center w-100">Supplier Management</h3>
                        <asp:Button Text="Add New Supplier" ID="modal" CssClass="btn btn-primary" OnClick="modal_Click" runat="server" UseSubmitBehavior="false" />
                    </div>

                    <div class="card-content">
                        <div class="card-body">
                            <div class="row">
                                <div class="col-md-12 col-12">
                                    <table>
                                        <asp:Repeater ID="rptSuppliers" runat="server">
                                            <HeaderTemplate>
                                                <tr>
                                                    <th>Supplier ID</th>
                                                    <th>Supplier Name</th>
                                                    <th>Supplier Address</th>
                                                    <th>Part ID</th>
                                                    <th>Action</th>
                                                </tr>
                                            </HeaderTemplate>
                                            <ItemTemplate>
                                                <tr class="separator">
                                                    <td><%# Eval("SupplierID") %></td>
                                                    <td><%# Eval("Name") %></td>
                                                    <td><%# Eval("Address") %></td>
                                                    <td><%# Eval("PartID") %></td>
                                                    <td>
                                                        <asp:LinkButton ID="updbtn" CommandName="Update" OnCommand="updbtn_Command" CommandArgument='<%# Eval("SupplierID") %>' CssClass="btn btn-sm btn-green" runat="server"><i class="fas fa-pencil-alt"></i></asp:LinkButton>
                                                        <asp:LinkButton CommandName="Delete" ID="btndlt" CommandArgument='<%# Eval("SupplierID") %>' OnClientClick="return confirm('Are you sure you want to delete?');" OnCommand="dltbtn_Command" CssClass="btn btn-sm btn-danger" runat="server"><i class="fas fa-trash-alt"></i></asp:LinkButton>
                                                    </td>
                                                </tr>
                                            </ItemTemplate>
                                        </asp:Repeater>

                                    </table>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </section>

    <asp:Button ID="btnExportExcel" runat="server" Text="Export to Excel" BackColor="LimeGreen" ForeColor="White" Font-Bold="true" OnClick="btnExportExcel_Click" />

    <asp:SqlDataSource ID="dsSuppliers"
        ConnectionString="<%$ ConnectionStrings:connection_ %>"
        SelectCommand="SELECT * FROM Suppliertbl" runat="server" />

    <script type="text/javascript">
        function validateForm() {
            var supplierName = document.getElementById('<%= txtName.ClientID %>').value.trim();
            var address = document.getElementById('<%= ddlAddress.ClientID %>').value.trim();  // Get selected address from dropdown

            if (supplierName === "") {
                alert("Supplier Name cannot be empty!");
                return false;
            }

            if (address === "") {
                alert("Address cannot be empty!");
                return false;
            }

            return true;
        }

    </script>

</asp:Content>
