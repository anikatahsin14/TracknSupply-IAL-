<%@ Page Title="Reset Password" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="ResetPassword.aspx.cs" Inherits="popCrud.ResetPassword" %>

<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">
<style>
    /* Ensure the body takes the full height of the page with background image */
    body {
        background-image: url('<%= ResolveUrl("Images/bg.png") %>');
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
    .body-container {
        display: flex;
        justify-content: center;
        align-items: center;
        width: 100%;
        height: 100vh;
    }

    /* Card styling */
    .card {
        width: 100%;
        max-width: 500px; /* Adjust card width */
        padding: 20px;
        box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
        margin-top: 20px; /* Add margin if needed */
        border-radius: 8px;
    }

    /* Styling for form groups and input fields */
    .form-group {
        margin-bottom: 15px;
    }

    .form-group label {
        display: block;
        text-align: left;
        font-weight: bold;
        margin-bottom: 5px;
    }

    .form-group input {
        width: 100%;
        padding: 10px;
        font-size: 16px;
        box-sizing: border-box;
        border-radius: 4px;
        border: 1px solid #ccc;
    }

    /* Button styling */
    .btn {
        width: 100%;
        padding: 10px;
        font-size: 16px;
        border-radius: 4px;
        border: none;
    }

    /* Make the login redirection button look like a link */
    .btn-link {
        background: none;
        color: #007bff;
        border: none;
        font-size: 14px;
    }

    /* Hide the sidebar */
    #sidebar {
        display: none;
    }

    /* Adjust the reset password panel to center everything */
    .card-body {
        display: flex;
        flex-direction: column;
        align-items: center;
    }

    /* Back to Login Button */
    .btn-back {
        background: none;
        color: #007bff;
        border: none;
        font-size: 14px;
        text-align: center;
        margin-top: 15px;
        padding: 10px;
        cursor: pointer;
    }
</style>

<!-- Main content container for centering the form -->
<div class="body-container">
    <div class="card shadow-sm">
        <div class="card-header text-center">
            <h4>Reset Password</h4>
        </div>
        <div class="card-body">
            <!-- Message will only appear if there's an issue with the token -->
            <asp:Label ID="lblMessage" runat="server" ForeColor="Red" Text="" CssClass="text-center mb-3" Visible="false" />

            <div class="form-group">
                <label for="txtNewPassword">New Password</label>
                <asp:TextBox ID="txtNewPassword" CssClass="form-control" TextMode="Password" placeholder="Enter New Password" runat="server" required="true" />
            </div>

            <div class="form-group">
                <label for="txtConfirmPassword">Confirm Password</label>
                <asp:TextBox ID="txtConfirmPassword" CssClass="form-control" TextMode="Password" placeholder="Confirm New Password" runat="server" required="true" />
            </div>

            <asp:Button ID="btnResetPassword" runat="server" Text="Reset Password" CssClass="btn btn-primary" OnClick="btnResetPassword_Click" />

            <!-- Back to Login Button -->
            <button class="btn-back" onclick="window.location.href='Login.aspx';">Back to Login</button>
        </div>
    </div>
</div>

</asp:Content>
