<%@ Page Title="Part Management" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="partmng.aspx.cs" Inherits="popCrud.About" %>

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
            table-layout: auto;
            word-wrap: break-word;
            overflow-x: auto;
        }

        th, td {
            text-align: left;
            padding: 8px;
            word-wrap: break-word;
        }

        th {
            background-color: darkcyan;
            color: white;
            text-overflow: ellipsis;
            white-space: normal;
            overflow: hidden;
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

        @media (max-width: 768px) {
            table {
                display: block;
                overflow-x: auto;
                white-space: nowrap;
            }
        }

        .btn-group-vertical {
            display: flex;
            flex-direction: column;
            align-items: flex-start;
        }

        .btn-group {
            display: flex;
            gap: 10px;
        }

        /* Modal size adjustment */
        .modal-dialog {
            max-width: 800px; /* Increase modal width */
            margin: 30px auto; /* Keep modal centered */
        }

        .modal-body {
            padding: 40px; /* Increased padding for more space inside */
        }

        /* Center the modal title */
        .modal-header h4 {
            font-size: 1.5rem; /* Increase header font size */
            text-align: center; /* Align the title in the center */
            width: 100%; /* Ensure the title spans the full width */
        }

        /* Adjusted for justified alignment */
        .modal-body .form-group {
            display: flex;
            justify-content: space-between; /* Justify fields */
            margin-bottom: 20px; /* Increase spacing between form fields */
            align-items: center; /* Vertically align the elements */
        }

            .modal-body .form-group label {
                width: 30%; /* Label width */
                margin-bottom: 10px;
            }

            .modal-body .form-group input {
                width: 60%; /* Input width */
            }

            /* Optional: Add margin for inputs to keep them visually balanced */
            .modal-body .form-group input,
            .modal-body .form-group select {
                margin-left: 10px;
            }
    </style>


    <link href="https://stackpath.bootstrapcdn.com/bootstrap/4.3.1/css/bootstrap.min.css" rel="stylesheet" />
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css" />

    <div class="row">
        <div class="col-md-4">
            <asp:DropDownList ID="ddlProductSearch" CssClass="form-control" Font-Bold="true" BackColor="darkcyan" ForeColor="White" runat="server" AutoPostBack="True" OnSelectedIndexChanged="ddlProductSearch_SelectedIndexChanged">
                <asp:ListItem Value="">--Select Product--</asp:ListItem>
            </asp:DropDownList>
        </div>
    </div>

    <div class="container">
        <div class="modal fade" id="mymodal" data-backdrop="false" role="dialog">
            <div class="modal-dialog modal-dialog-centered">
                <div class="modal-content">
                    <div class="modal-header">
                        <h4 id="modalTitle" class="modal-title">Add new product</h4>
                        <asp:Label ID="lblmsg" Text="" runat="server" />
                        <button type="button" class="close" data-dismiss="modal">&times;</button>
                    </div>


                    <div class="modal-body">
                        <div class="form-group">
                            <label for="<%= txtname.ClientID %>">Part Name</label>
                            <asp:TextBox ID="txtname" CssClass="form-control" runat="server"></asp:TextBox>
                        </div>

                        <div class="form-group">
                            <label for="<%= txtprice.ClientID %>">Manufacturing Cost</label>
                            <asp:TextBox ID="txtprice" CssClass="form-control" runat="server"></asp:TextBox>
                        </div>

                        <div class="form-group">
                            <label for="<%= txtquantity.ClientID %>">Quantity</label>
                            <asp:TextBox ID="txtquantity" CssClass="form-control" runat="server"></asp:TextBox>
                        </div>

                        <asp:HiddenField ID="hdid" runat="server" />

                        <div class="form-group">
                            <label for="<%= ddl.ClientID %>">Product Name</label>
                            <asp:DropDownList ID="ddl" CssClass="form-control" runat="server">
                                <asp:ListItem Text="--Select Product--" Value="0"></asp:ListItem>
                            </asp:DropDownList>
                        </div>
                    </div>

                    <div class="modal-footer">
                        <asp:Button ID="btnsave" runat="server" Text="Save" OnClick="btnsave_Click" OnClientClick="return validateForm();" CssClass="btn-green" />
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
                        <h3 class="m-0 text-center w-100">Part Management</h3>
                        <asp:Button Text="Add New" ID="modal" CssClass="btn btn-primary" OnClick="modal_Click" runat="server" UseSubmitBehavior="false" />
                    </div>

                    <div class="card-content">
                        <div class="card-body">
                            <div class="row">
                                <div class="col-md-12 col-12">
                                    <table>
                                        <asp:Repeater ID="rpt1" runat="server">
                                            <HeaderTemplate>
                                                <tr>
                                                    <th>Part ID</th>
                                                    <th>Part Name</th>
                                                    <th>Manufacturing Cost</th>
                                                    <th>Quantity</th>
                                                    <th>Cost Per Quantity</th>
                                                    <th>Product Name</th>
                                                    <th>Product ID</th>
                                                    <th>Action</th>
                                                </tr>
                                            </HeaderTemplate>
                                            <ItemTemplate>
                                                <tr class="separator">
                                                    <td><%# Eval("PartID") %></td>
                                                    <td><%# Eval("Part_name") %></td>
                                                    <td><%# Eval("Cost") %></td>
                                                    <td><%# Eval("Quantity") %></td>
                                                    <td><%# Eval("CostPerQuantity") %></td>
                                                    <td><%# Eval("Product_Name") %></td>
                                                    <td><%# Eval("Product_ID") %></td>
                                                    <td>

                                                        <div class="btn-group">
                                                            <asp:LinkButton ID="updbtn" CommandName="Update" OnCommand="updbtn_Command" CommandArgument='<%# Eval("PartID") %>' CssClass="btn btn-sm btn-green" runat="server">
                                                            <i class="fas fa-pencil-alt"></i>
                                                            </asp:LinkButton>
                                                            <asp:LinkButton CommandName="Delete" ID="btndlt" CommandArgument='<%# Eval("PartID") %>' OnClientClick="return confirm('Are you sure you want to delete?');" OnCommand="dltbtn_Command" CssClass="btn btn-sm btn-danger" runat="server">
                                                            <i class="fas fa-trash-alt"></i>
                                                            </asp:LinkButton>

                                                        </div>
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

    <asp:SqlDataSource ID="ds1"
        ConnectionString="<%$ ConnectionStrings:connection_ %>"
        SelectCommand="SELECT * FROM part" runat="server" />


    <script type="text/javascript">
        function validateForm() {
            var partName = document.getElementById('<%= txtname.ClientID %>').value.trim();
            var cost = document.getElementById('<%= txtprice.ClientID %>').value.trim();
            var quantity = document.getElementById('<%= txtquantity.ClientID %>').value.trim();
            var productDropdown = document.getElementById('<%= ddl.ClientID %>');

            var nameRegex = /^[a-zA-Z\s]+$/;
            if (partName === "") {
                alert("Part Name cannot be empty!");
                return false;
            }
            if (!nameRegex.test(partName)) {
                alert("Part Name can only contain letters and spaces!");
                return false;
            }

            if (cost === "") {
                alert("Cost cannot be empty!");
                return false;
            }
            if (isNaN(cost)) {
                alert("Cost must be a valid number!");
                return false;
            }

            if (quantity === "") {
                alert("Quantity cannot be empty!");
                return false;
            }
            if (isNaN(quantity)) {
                alert("Quantity must be a valid number!");
                return false;
            }

            if (productDropdown.selectedIndex === 0) {
                alert("Please select a Product!");
                return false;
            }

            return true;
        }

        function setModalTitle(isEditMode) {
            if (isEditMode) {
                document.querySelector('.modal-title').textContent = 'Update The Part';
            } else {
                document.querySelector('.modal-title').textContent = 'Add a New Part';
            }
        }

    </script>

</asp:Content>
