<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="LogView.aspx.cs" Inherits="popCrud.LogView" %>

<!DOCTYPE html>
<html>
<head runat="server">
    <style>
        body {
            background-image: url('<%= ResolveUrl("~/Images/bg.png") %>');
            background-size: cover;
            background-position: center center;
            background-repeat: no-repeat;
            margin: 0;
            height: 100vh;
        }

        .side-panel {
            position: fixed;
            top: 0;
            left: 0;
            height: 100%;
            width: 250px;
            background-color: darkcyan;
            padding-top: 20px;
            color: white;
            z-index: 1;
        }

        .content-area {
            margin-left: 250px;
            margin-right: auto;
            padding: 115px;
            width: calc(100% - 250px);
            box-sizing: border-box;
            border-radius: 10px;
            display: flex;
            flex-direction: column;
            align-items: center;
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
        }

        .log-table {
            width: 100%;
            border-collapse: separate;
            border-spacing: 0 10px;
            margin-top: 20px;
            font-family: 'Arial', sans-serif;
            box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
        }

        .log-table th, .log-table td {
            padding: 12px 18px;
            text-align: left;
            border: 1px solid #ddd;
            font-size: 14px;
        }

        .log-table th {
            background-color: darkcyan;
            color: white;
            font-weight: bold;
            text-transform: uppercase;
            border-radius: 8px 8px 0 0;
        }

        .log-table td {
            background-color: #fafafa;
            border-radius: 8px;
        }

        .log-table tr:nth-child(even) {
            background-color: #f1f1f1;
        }

        .log-table tr:hover {
            background-color: #e6e6e6;
        }

        .log-table td, .log-table th {
            transition: background-color 0.3s ease;
        }

        /* New Log Effect (this part will be added for highlighting) */
        .new-log-effect {
            animation: flash 2s ease-out;
            background-color: #fffb79; /* Highlight background color */
            transition: background-color 1s ease-out;
        }

        /* Flash effect animation */
        @keyframes flash {
            0% {
                background-color: #fffb79;
            }

            50% {
                background-color: #fff;
            }

            100% {
                background-color: #fffb79;
            }
        }

        /* Title Styling inside table */
        .log-title-container {
            width: 100%;
            text-align: center;
            background-color: darkcyan;
            color: white;
            font-family: 'Arial', sans-serif;
            font-size: 24px;
            font-weight: bold;
            padding: 15px 0;
            border-radius: 5px;
            box-shadow: 0 2px 6px rgba(0, 0, 0, 0.1);
        }
    </style>

    <script type="text/javascript">
        // This function will be triggered from the server-side code when a new log is added
        function showNewLogEffect() {
            var gridView = document.getElementById('<%= gvLogs.ClientID %>');

            // Adding the effect class to the GridView
            gridView.classList.add("new-log-effect");

            // Remove the effect after the animation is completed (after 2 seconds)
            setTimeout(function () {
                gridView.classList.remove("new-log-effect");
            }, 2000);
        }
    </script>
</head>

<body>
    <form id="form1" runat="server">
        <div class="side-panel">
            <h3>Menu</h3>
            <ul>
                <li><a class="nav-link" runat="server" href="~/partmng.aspx">Part Management</a></li>
                <li><a class="nav-link" runat="server" href="~/prodmng.aspx">Product Management</a></li>
                <li><a class="nav-link" runat="server" href="~/Supplier.aspx">Supplier Management</a></li>
                <li><a class="nav-link" runat="server" href="~/About.aspx">About</a></li>
            </ul>
        </div>

        <div class="content-area">
            <table class="log-table">
                <tr>
                    <td colspan="5">
                        <div class="log-title-container">
                            Log View
                        </div>
                    </td>
                </tr>

                <!-- Data Row (GridView) -->
                <tr>
                    <td colspan="5">
                        <!-- GridView for the log table -->
                        <asp:GridView ID="gvLogs" runat="server" AutoGenerateColumns="True" CssClass="log-table" />
                    </td>
                </tr>
            </table>
        </div>
    </form>
</body>
</html>
