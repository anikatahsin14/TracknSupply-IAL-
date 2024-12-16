<%@ Page Title="Login" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Login.aspx.cs" Inherits="popCrud.Login" %>

<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">
    <style>
        body {
            background-image: url('<%= ResolveUrl("~/Images/bg.png") %>');
            background-size: cover;
            background-position: center center;
            background-repeat: no-repeat;
            margin: 0;
            height: 100vh;
            display: flex;
            justify-content: center;
            align-items: center;
        }

        /* Flexbox container for form */
        .form-container {
            display: flex;
            justify-content: center;
            align-items: center;
            min-height: 100vh;
            width: 100%;  /* Ensure it takes full width */
            padding: 20px;
            box-sizing: border-box;
        }

        /* Card body styling */
        .card-body {
            width: 100%;
            max-width: 500px; /* Larger width for better spacing */
            padding: 40px; /* Increased padding for more space */
            box-shadow: 0 6px 12px rgba(0, 0, 0, 0.2);
            background-color: rgba(255, 255, 255, 0.9); /* Slightly opaque */
            border-radius: 8px;
        }

        /* Card Header */
        .card-header h4 {
            text-align: center;
            font-size: 1.75rem; /* Larger font size */
            margin-bottom: 20px;
        }

        /* Form Fields Styling */
        .form-group {
            display: flex;
            justify-content: space-between; /* Justified alignment of label and input */
            margin-bottom: 20px; /* Increased spacing between fields */
            align-items: center;
        }

        .form-group label {
            font-weight: bold;
            font-size: 1rem;
            width: 40%; /* Ensure labels don't take too much space */
            text-align: left;
        }

        .form-control {
            padding: 10px;
            font-size: 1rem;
            width: 55%; /* Ensuring the fields occupy the remaining space */
        }

        /* Button Styling */
        .btn {
            width: 100%;
            padding: 12px;
            font-size: 1.1rem; /* Slightly larger button */
            cursor: pointer;
        }

        .btn-primary {
            background-color: #007bff;
            border-color: #007bff;
        }

        /* Additional Links */
        .btn-link {
            text-decoration: none;
            color: #007bff;
            font-size: 1rem;
        }

        /* Centered Buttons */
        .text-center {
            text-align: center;
        }

        /* Error Message Styling */
        .text-center.mb-3 {
            font-size: 1rem;
            color: red;
        }

        /* Responsive design */
        @media (max-width: 768px) {
            .card-body {
                padding: 25px;
            }

            .card-header h4 {
                font-size: 1.5rem;
            }

            .form-group label {
                width: 35%;
            }

            .form-control {
                width: 60%;
            }

            .btn {
                padding: 10px;
                font-size: 1rem;
            }
        }
    </style>

    <div class="form-container">
        <div class="card">
            <div class="card-header">
                <h4>User Authentication</h4>
            </div>
            <div class="card-body">
                <asp:Label ID="lblLoginMessage" runat="server" ForeColor="Red" CssClass="text-center mb-3" />

                <!-- Username Field -->
                <div class="form-group">
                    <label for="txtUsername">Username</label>
                    <asp:TextBox ID="txtUsername" CssClass="form-control" placeholder="Enter Username" runat="server" required="true" />
                    <asp:RequiredFieldValidator ID="rfvUsername" runat="server" ControlToValidate="txtUsername" InitialValue="" ForeColor="Red" ErrorMessage="Username is required" CssClass="d-block" />
                </div>

                <!-- Password Field -->
                <div class="form-group">
                    <label for="txtPassword">Password</label>
                    <asp:TextBox ID="txtPassword" CssClass="form-control" placeholder="Enter Password" TextMode="Password" runat="server" required="true" />
                    <asp:RequiredFieldValidator ID="rfvPassword" runat="server" ControlToValidate="txtPassword" InitialValue="" ForeColor="Red" ErrorMessage="Password is required" CssClass="d-block" />
                </div>

                <!-- Login Button -->
                <div class="text-center mt-3">
                    <asp:Button ID="btnLogin" runat="server" Text="Login" CssClass="btn btn-primary" OnClick="btnLogin_Click" />
                </div>

                <!-- Additional Options -->
                <div class="text-center mt-3">
                    <asp:Button ID="btnRegisterRedirect" runat="server" Text="New User? Register Here" CssClass="btn btn-link" OnClientClick="window.location.href='Register.aspx'; return false;" />

                    <!-- Forgot Password Button under the Register Button -->
                    <br />
                    <asp:Button ID="btnForgotPassword" runat="server" Text="Forgot Password?" CssClass="btn btn-link" OnClientClick="window.location.href='ForgotPassword.aspx'; return false;" />
                </div>
            </div>
        </div>
    </div>
</asp:Content>
