<%@ Page Title="Forgot Password" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="ForgotPassword.aspx.cs" Inherits="popCrud.ForgotPassword" %>

<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">
 <style>
    /* Apply background image to the entire page */
    body {
        background-image: url('<%= ResolveUrl("Images/bg.png") %>'); /* Ensure the path is correct */
        background-size: cover;
        background-position: center center;
        background-repeat: no-repeat;
        margin: 0;
        height: 100vh;
        display: flex;
        justify-content: center;
        align-items: center;
    }

    /* Container to hold and center the card */
    .forgot-password-container {
        display: flex;
        justify-content: center;
        align-items: center;
        width: 100%;
        height: 100vh; /* Full height to center vertically */
    }

    /* Card styling */
    .forgot-password-card {
        width: 100%;
        max-width: 400px; /* Set max width of the card */
        padding: 30px;
        box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
        border-radius: 8px;
        background-color: white; /* Ensures visibility of the card */
        display: flex;
        flex-direction: column; /* Align content vertically */
        justify-content: space-between; /* Distribute the form fields and buttons evenly */
    }

    /* Styling for form groups and input fields */
    .form-group {
        margin-bottom: 15px; /* Reduced space between form fields */
    }

    .form-group label {
        display: block;
        font-weight: bold;
        margin-bottom: 5px;
    }

    .form-group input {
        width: 100%; /* Make input fields take full width of the card */
        padding: 15px 10px; /* Increased padding for better visibility */
        font-size: 16px;
        box-sizing: border-box;
        border-radius: 4px;
        border: 1px solid #ccc;
        margin-bottom: 0; /* Remove space below input field */
        line-height: 1.5; /* Make sure text and placeholder text fit properly */
        height: 45px; /* Set a fixed height for input fields */
    }

    /* Button styling */
    .btn {
        width: 100%;
        padding: 12px; /* Button padding */
        font-size: 16px; /* Button text size */
        border-radius: 4px;
        border: none;
        cursor: pointer;
        margin-top: 10px; /* Add small margin to separate from input fields */
    }

    .btn-link {
        background: none;
        color: #007bff;
        border: none;
        font-size: 14px;
        text-align: center;
        cursor: pointer;
        margin-top: 10px; /* Add margin to button */
    }

    /* Ensure the width of the form fields is appropriate */
    input[type="text"], input[type="email"], input[type="password"] {
        width: 100%; /* Ensures input takes full width available */
        padding: 15px 10px; /* Increased padding for more space inside */
        font-size: 16px;
        border-radius: 4px;
        border: 1px solid #ccc;
        box-sizing: border-box;
        margin-bottom: 0; /* Remove margin between fields */
        height: 45px; /* Ensure proper height for the input fields */
        line-height: 1.5; /* Ensures placeholder text fits well */
    }

    /* Align buttons inside the card */
    .card-body {
        display: flex;
        flex-direction: column;
        justify-content: center;
        padding-bottom: 0; /* Remove bottom padding to avoid extra space */
    }

    #sidebar {
        display: none;
    }
</style>


    <div class="container-fluid forgot-password-container">
        <div class="card forgot-password-card shadow-sm">
            <div class="card-header text-center">
                <h4>Forgot Password</h4>
            </div>
            <div class="card-body">
                <asp:Label ID="lblMessage" runat="server" ForeColor="Red" Text="" CssClass="text-center mb-3" />

                <div class="form-group">
                    <label for="txtEmail">Email Address</label>
                    <asp:TextBox ID="txtEmail" CssClass="form-control" placeholder="Enter the registered email" runat="server" required="true" />
                    <asp:RequiredFieldValidator ID="rfvEmail" runat="server" ControlToValidate="txtEmail" InitialValue="" ForeColor="Red" ErrorMessage="Email is required" CssClass="d-block" />
                    <asp:RegularExpressionValidator ID="revEmail" runat="server" ControlToValidate="txtEmail" ForeColor="Red" ValidationExpression="^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$" ErrorMessage="Invalid email format" CssClass="d-block" />
                </div>

                <asp:Button ID="btnSendResetLink" runat="server" Text="Send Reset Link" CssClass="btn btn-primary" OnClick="btnSendResetLink_Click" />

                <div class="mt-3 text-center">
                    <asp:Button ID="btnBackToLogin" runat="server" Text="Back to Login" CssClass="btn btn-link" OnClientClick="window.location.href='Login.aspx'; return false;" />
                </div>
            </div>
        </div>
    </div>
</asp:Content>
