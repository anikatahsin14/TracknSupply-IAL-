<%@ Page Title="Home - PPMS" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Home.aspx.cs" Inherits="popCrud.Home" %>

<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">

    <style>
        /* Apply background image to the entire page */
        body {
            background-image: url('<%= ResolveUrl("Images/bg.png") %>'); /* Ensure the path is correct */
            background-size: cover;
            background-position: center center;
            background-repeat: no-repeat;
            margin: 0;
            height: 100%; /* Full viewport height */
            display: flex;
            justify-content: center;
            align-items: flex-start;
            font-family: 'Arial', sans-serif;
            flex-direction: column; /* Allow stacking of content */
            min-height: 100vh; /* Ensure full height for the viewport */
        }

        #sidebar {
            display: none;
        }

        /* Adjust container for the page */
        .container {
            margin-top: 20px;
            padding: 20px;
            background-color: rgba(255, 255, 255, 0.9); /* Slight transparent background */
            border-radius: 10px;
            box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
            width: 100%;
            max-width: 1200px; /* Maximum width */
            display: flex;
            flex-direction: column;
            justify-content: flex-start; /* Align items from the top */
            align-items: center;
            flex-grow: 1; /* Allow container to grow if content is more */
        }

        /* Ensure the text in the center looks good */
        .text-center h1 {
            font-size: 2.5rem;
            margin-bottom: 20px;
            font-weight: bold;
        }

        .text-center p {
            font-size: 1.2rem;
            text-align: center;
        }

        /* Adjust the row for centering the cards */
        .row {
            display: flex;
            flex-wrap: wrap; /* Allow the cards to wrap */
            justify-content: center; /* Center the cards horizontally */
            width: 100%;
            margin-top: 30px;
        }

        .col-md-3, .col-sm-6 {
            display: flex;
            justify-content: center;
            align-items: center;
            margin-bottom: 20px; /* Adjust space between cards */
        }

        .card {
            border-radius: 10px; /* Rounded corners */
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1); /* Card shadow */
            transition: transform 0.3s ease-in-out; /* Hover effect */
            width: 100%;
            max-width: 300px; /* Ensure cards don't stretch too wide */
            margin: 10px; /* Margin around each card */
        }

            .card:hover {
                transform: scale(1.05); /* Slight zoom on hover */
            }

        .card-body {
            padding: 20px;
        }

        .card-title {
            font-size: 1.2rem;
            font-weight: bold;
        }

        .card-text {
            font-size: 1rem;
            margin-bottom: 15px;
        }

        .btn {
            font-size: 1rem;
            padding: 10px 15px;
            border-radius: 5px;
            transition: background-color 0.3s ease;
        }

        .btn-primary {
            background-color: #007bff;
            border: none;
        }

            .btn-primary:hover {
                background-color: #0056b3;
            }

        .btn-success {
            background-color: #28a745;
            border: none;
        }

            .btn-success:hover {
                background-color: #218838;
            }

        .btn-warning {
            background-color: #ffc107;
            border: none;
        }

            .btn-warning:hover {
                background-color: #e0a800;
            }

        .btn-info {
            background-color: #17a2b8;
            border: none;
        }

            .btn-info:hover {
                background-color: #117a8b;
            }

        /* Side Panel Styles - Now on the left side */
        .side-panel {
            position: fixed;
            left: 0;
            top: 20%;
            width: 250px;
            background-color: rgba(255, 255, 255, 0.9);
            border-radius: 10px;
            box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
            padding: 20px;
            display: flex;
            flex-direction: column;
            align-items: flex-start;
            z-index: 1000;
        }

            .side-panel h3 {
                margin-bottom: 15px;
                font-size: 1.5rem;
                font-weight: bold;
            }

            .side-panel ul {
                list-style-type: none;
                padding-left: 0;
            }

            .side-panel li {
                font-size: 1.1rem;
                margin-bottom: 10px;
            }

                .side-panel li i {
                    margin-right: 10px;
                    color: #28a745; /* Green checkmark */
                }

        /* Responsive adjustments */
        @media (max-width: 768px) {
            .side-panel {
                top: 10%;
                width: 200px;
            }
        }

        @media (max-width: 480px) {
            .side-panel {
                top: 5%;
                width: 150px;
            }

                .side-panel h3 {
                    font-size: 1.2rem;
                }

                .side-panel li {
                    font-size: 1rem;
                }
        }

        .auto-style1 {
            font-size: medium;
        }
    </style>

    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta name="description" content="Part & Product Management System Home Page.">
    <meta name="keywords" content="PPMS, Parts, Products, Suppliers, Management">
    <meta name="author" content="PPMS">

    <div class="container">
        <div class="text-center mb-4">
            <h1>Welcome to TracknSupply</h1>
            <p class="lead">Manage your parts, products, and suppliers efficiently with our powerful system.</p>
        </div>

        <div class="row">

            <!-- Part Management Card -->
            <div class="col-md-3 col-sm-6 mb-4">
                <div class="card shadow-sm h-100">
                    <div class="card-body text-center">
                        <i class="fas fa-cogs fa-3x mb-3 text-primary"></i>
                        <h5 class="card-title">Part Management</h5>
                        <p class="card-text">Track, manage, and update your parts inventory with ease.</p>
                        <a href="partmng.aspx" class="btn btn-primary btn-sm">Go to Module</a>
                        <br />
                        <br />
                        <a href="LogView.aspx" class="btn btn-secondary btn-sm">View Logs</a>

                    </div>
                </div>
            </div>

            <!-- Product Management Card -->
            <div class="col-md-3 col-sm-6 mb-4">
                <div class="card shadow-sm h-100">
                    <div class="card-body text-center">
                        <i class="fas fa-box-open fa-3x mb-3 text-success"></i>
                        <h5 class="card-title">Product Management</h5>
                        <p class="card-text">Oversee product assembly, cost calculations, and more.</p>
                        <a href="prodmng.aspx" class="btn btn-success btn-sm">Go to Module</a>
                    </div>
                </div>
            </div>

            <!-- Supplier Management Card -->
            <div class="col-md-3 col-sm-6 mb-4">
                <div class="card shadow-sm h-100">
                    <div class="card-body text-center">
                        <i class="fas fa-truck fa-3x mb-3 text-warning"></i>
                        <h5 class="card-title">Supplier Management</h5>
                        <p class="card-text">Manage supplier details, contacts, and price information.</p>
                        <a href="Supplier.aspx" class="btn btn-warning btn-sm">Go to Module</a>
                    </div>
                </div>
            </div>


            <!-- About Card -->
            <div class="col-md-3 col-sm-6 mb-4">
                <div class="card shadow-sm h-100">
                    <div class="card-body text-center">
                        <i class="fas fa-info-circle fa-3x mb-3 text-info"></i>
                        <h5 class="card-title">About</h5>
                        <p class="card-text">Learn more about our system and its capabilities.</p>
                        <a href="About.aspx" class="btn btn-info btn-sm">Learn More</a>
                    </div>
                </div>
            </div>

        </div>

    </div>

    <!-- Side Panel -->
    <div class="side-panel">
        <h3>Features of TracknSupply</h3>
        <ul>
            <li><i class="fas fa-check-circle"></i>Real-time inventory tracking</li>
            <li><i class="fas fa-check-circle"></i>Efficient supplier management</li>
            <li><i class="fas fa-check-circle"></i>Automated part costing</li>
        </ul>
        <asp:Button ID="btnLogout" runat="server" Text="Logout" BackColor="Red" ForeColor="White" Font-Bold="true" OnClick="btnLogout_Click" CssClass="auto-style1" />
    </div>

    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css">
</asp:Content>
