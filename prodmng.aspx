<%@ Page Title="Product Management" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="prodmng.aspx.cs" Inherits="popCrud.Part" %>

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


        section {
            width: 100%;
            padding: 20px;
            background-color: rgba(255, 255, 255, 0.8); /* Slightly transparent background */
            border-radius: 10px;
            box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
            margin-top: 20px;
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

        .btn-green {
            background-color: limegreen;
            color: white;
            border: solid;
            padding: 10px 20px;
            font-size: 14px;
            cursor: pointer;
        }

            .btn-green:hover {
                background-color: forestgreen;
            }

        .btn-red {
            background-color: orangered;
            color: white;
            border: solid;
            padding: 10px 20px;
            font-size: 14px;
            cursor: pointer;
        }

            .btn-red:hover {
                background-color: red;
            }

        input[disabled] {
            background-color: #f0f0f0;
            color: #999;
        }

        .modal-dialog {
            max-width: 600px; /* Adjust width of the modal */
        }
    </style>

    <link href="https://stackpath.bootstrapcdn.com/bootstrap/4.3.1/css/bootstrap.min.css" rel="stylesheet" />
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css" />

    <div class="modal fade" id="productModal" data-backdrop="false" role="dialog">
        <div class="modal-dialog modal-dialog-centered">
            <div class="modal-content">
                <div class="modal-header">
                    <h4 id="modalTitle" class="modal-title">Add New Product</h4>
                    <asp:Label ID="lblProductMessage" Text="" runat="server" />
                    <button type="button" class="close" data-dismiss="modal">&times;</button>
                </div>
                <div class="modal-body">
                    <div class="form-group">
                        <label for="txtProductNameInput">Product Name</label>
                        <asp:TextBox ID="txtProductNameInput" CssClass="form-control" runat="server"></asp:TextBox>
                    </div>
                    <div class="form-group">
                        <label for="txtPriceInput">Price</label>
                        <asp:TextBox ID="txtPriceInput" CssClass="form-control" runat="server"></asp:TextBox>
                    </div>
                    <asp:HiddenField ID="hdProductIdentifier" runat="server" />
                </div>
                <div class="modal-footer">
                    <asp:Button ID="btnSaveProduct" runat="server" Text="Save" OnClick="btnSaveProduct_Click" OnClientClick="return validateForm();" CssClass="btn-green" />
                    <button type="button" class="btn btn-danger" data-dismiss="modal">Close</button>
                </div>
            </div>
        </div>
    </div>

    <section id="sectionProduct">
        <div class="row match-height">
            <div class="col-12">
                <div class="card">
                    <div class="card-header d-flex justify-content-between align-items-center">
                        <h3 class="m-0 text-center w-100">Product Management</h3>
                        <asp:Button Text="Add New" ID="btnAddNewProduct" CssClass="btn btn-primary" OnClick="btnAddNewProduct_Click" runat="server" UseSubmitBehavior="false" />
                    </div>
                    <div class="card-content">
                        <div class="card-body">
                            <div class="row">
                                <div class="col-md-12 col-12">
                                    <table>
                                        <asp:Repeater ID="rptProductList" runat="server">
                                            <HeaderTemplate>
                                                <tr>
                                                    <th>Product ID</th>
                                                    <th>Product Name</th>
                                                    <th>Price</th>
                                                    <th>Action</th>
                                                </tr>
                                            </HeaderTemplate>
                                            <ItemTemplate>
                                                <tr>
                                                    <td><%# Eval("Product_ID") %></td>
                                                    <td><%# Eval("Product_Name") %></td>
                                                    <td><%# Eval("Price") %></td>
                                                    <td>
                                                        <asp:LinkButton ID="btnEditProduct" CommandName="Edit" OnCommand="btnEditProduct_Command" CommandArgument='<%# Eval("Product_ID") %>' CssClass="btn btn-sm btn-green" runat="server"><i class="fas fa-pencil-alt"></i></asp:LinkButton>
                                                        <asp:LinkButton CommandName="Delete" ID="btnDeleteProduct" CommandArgument='<%# Eval("Product_ID") %>' OnClientClick="return confirm('Are you sure you want to delete this product?');" OnCommand="btnDeleteProduct_Command" CssClass="btn btn-sm btn-danger" runat="server"><i class="fas fa-trash-alt"></i></asp:LinkButton>
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

    <asp:Button ID="btnExportExcel" runat="server" Text="Export to Excel Report" BackColor="LimeGreen" ForeColor="White" Font-Bold="true" OnClick="btnExportExcel_Click" />

    <asp:SqlDataSource ID="dsProductList" ConnectionString="<%$ ConnectionStrings:connection_ %>" SelectCommand="SELECT * FROM prod_updated" runat="server" />

    <script type="text/javascript">
        function validateForm() {
            var productName = document.getElementById('<%= txtProductNameInput.ClientID %>').value.trim();
            var price = document.getElementById('<%= txtPriceInput.ClientID %>').value.trim();

            if (productName === "") {
                alert("Product Name cannot be empty!");
                return false;
            }

            if (price === "") {
                alert("Price cannot be empty!");
                return false;
            }

            if (isNaN(price)) {
                alert("Price must be a valid number!");
                return false;
            }

            return true;
        }

        function setModalTitle(isEditMode) {
            if (isEditMode) {
                document.querySelector('.modal-title').textContent = 'Update Product';
            } else {
                document.querySelector('.modal-title').textContent = 'Add New Product';
            }
        }
    </script>

    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <script src="https://stackpath.bootstrapcdn.com/bootstrap/4.3.1/js/bootstrap.bundle.min.js"></script>

</asp:Content>
