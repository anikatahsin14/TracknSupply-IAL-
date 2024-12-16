<%@ Page Title="Register" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Register.aspx.cs" Inherits="popCrud.Register" %>

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

        .form-container {
            display: flex;
            justify-content: center;
            align-items: center;
            min-height: 100vh;
            padding: 0;
        }

        .card-body {
            width: 100%;
            max-width: 500px;
            padding: 60px;
            box-shadow: 0 6px 12px rgba(0, 0, 0, 0.2);
            background-color: rgba(255, 255, 255, 0.9);
            border-radius: 8px;
        }

        #sidebar {
            display: none;
        }

        .password-toggle {
            cursor: pointer;
            position: absolute;
            right: 10px;
            top: 50%;
            transform: translateY(-50%);
        }
    </style>

    <div class="container-fluid d-flex justify-content-center align-items-center min-vh-100">
        <div class="col-md-6 col-lg-4 col-12">
            <div class="card shadow-sm">
                <div class="card-header text-center">
                    <h4>Create an Account</h4>
                </div>
                <div class="card-body" align="center">
                    <asp:Label ID="lblRegisterMessage" runat="server" ForeColor="Red" CssClass="text-center mb-3" />

                    <div class="form-group" align="left">
                        <label for="txtUsername">Username</label>
                        <asp:TextBox ID="txtUsername" CssClass="form-control" placeholder="Enter Username" runat="server" required="true" />
                        <asp:RequiredFieldValidator ID="rfvUsername" runat="server" ControlToValidate="txtUsername" InitialValue="" ForeColor="Red" ErrorMessage="Username is required" CssClass="d-block" />
                    </div>

                    <div class="form-group" align="left">
                        <label for="txtPassword">Password</label>
                        <div class="input-group">
                            <asp:TextBox ID="txtPassword" CssClass="form-control" placeholder="Enter Password" TextMode="Password" runat="server" required="true" />
                            <span class="input-group-addon password-toggle" onclick="togglePasswordVisibility('txtPassword')">
                                <i id="passwordIcon" class="fa fa-eye"></i> <!-- Eye icon for show/hide -->
                            </span>
                        </div>
                        <asp:RequiredFieldValidator ID="rfvPassword" runat="server" ControlToValidate="txtPassword" InitialValue="" ForeColor="Red" ErrorMessage="Password is required" CssClass="d-block" />
                    </div>

                    <div class="form-group" align="left">
                        <label for="txtConfirmPassword">Confirm Password</label>
                        <div class="input-group">
                            <asp:TextBox ID="txtConfirmPassword" CssClass="form-control" placeholder="Confirm Password" TextMode="Password" runat="server" required="true" />
                            <span class="input-group-addon password-toggle" onclick="togglePasswordVisibility('txtConfirmPassword')">
                                <i id="confirmPasswordIcon" class="fa fa-eye"></i> <!-- Eye icon for show/hide -->
                            </span>
                        </div>
                        <asp:RequiredFieldValidator ID="rfvConfirmPassword" runat="server" ControlToValidate="txtConfirmPassword" InitialValue="" ForeColor="Red" ErrorMessage="Confirm Password is required" CssClass="d-block" />
                        <asp:CompareValidator ID="cvPassword" runat="server" ControlToValidate="txtConfirmPassword" ControlToCompare="txtPassword" ForeColor="Red" ErrorMessage="Passwords do not match" />
                    </div>

                    <asp:Button ID="btnRegister" runat="server" Text="Register" CssClass="btn btn-primary w-100" OnClick="btnRegister_Click" align="left" />

                    <!-- Login Redirection Button -->
                    <asp:Button ID="btnLoginRedirect" runat="server" Text="Already have an account? Login here" CssClass="btn btn-link mt-3" OnClientClick="window.location.href='Login.aspx'; return false;" />
                </div>
            </div>
        </div>
    </div>

    <script>
        // Function to toggle password visibility
        function togglePasswordVisibility(fieldId) {
            var passwordField = document.getElementById(fieldId);
            var passwordIcon = document.getElementById(fieldId + 'Icon');
            
            // Toggle password visibility
            if (passwordField.type === "password") {
                passwordField.type = "text";
                passwordIcon.classList.remove("fa-eye");
                passwordIcon.classList.add("fa-eye-slash");
            } else {
                passwordField.type = "password";
                passwordIcon.classList.remove("fa-eye-slash");
                passwordIcon.classList.add("fa-eye");
            }
        }
    </script>
</asp:Content>
