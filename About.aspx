<%@ Page Title="About" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="About.aspx.cs" Inherits="popCrud.About1" %>

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

        .about-container {
            padding: 30px;
            background-color: #f4f4f4;
            border-radius: 8px;
        }

        .about-header {
            text-align: center;
            font-size: 30px;
            color: #333;
            margin-bottom: 20px;
        }

        .about-description {
            font-size: 18px;
            line-height: 1.6;
            color: #555;
        }

        .contact-info {
            margin-top: 30px;
            background-color: #ffffff;
            padding: 20px;
            border-radius: 8px;
            box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
        }

            .contact-info h4 {
                font-size: 24px;
                color: #333;
            }

            .contact-info p {
                font-size: 16px;
                color: #555;
            }

            .contact-info .email {
                color: #007bff;
                text-decoration: none;
            }

                .contact-info .email:hover {
                    text-decoration: underline;
                }
    </style>

    <div class="container">
        <div class="about-container">
            <h1 class="about-header">About Us</h1>

            <div class="about-description">
                <p>Welcome to <strong>TracknSupply</strong>,  where innovation meets precision. We specialize in producing high-quality parts. Each part is carefully sourced—either manufactured in-house or purchased from trusted suppliers.</p>

                <p>Our system ensures that we maintain an accurate inventory of parts, track stock quantities, and manage manufacturing costs with efficiency. For purchased parts, we collaborate with a network of suppliers, each offering unique pricing.</p>

                <p>The platform is designed with multiple user access levels, ensuring secure and tailored access based on your role in the company.</p>
            </div>

            <div class="contact-info">
                <h4>Contact Us</h4>
                <p>If you have any question, feel free to reach out to us:</p>
                <p><strong>Email:</strong> <a href="mailto:support@tracknsupply.com" class="email">support@tracknsupply.com</a></p>
                <p><strong>Phone:</strong> +880**********</p>
                <p><strong>Address:</strong> Kaliyakoir, Gazipur, Bangladesh.</p>
            </div>
        </div>
    </div>

</asp:Content>
