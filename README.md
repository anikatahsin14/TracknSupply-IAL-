# TracknSupply - Inventory and Supplier Management System

**TracknSupply** is a web-based inventory management system developed for a company that produces products using internal parts and parts bought from suppliers. The application allows users to track parts in stock, monitor manufacturing costs, and manage supplier information (including supplier names, addresses, and prices for purchased parts).

The system has multiple user levels with different access privileges, ensuring that sensitive data is protected and only authorized users can perform certain actions. This system tracks the company's internal and purchased parts, providing an efficient interface for managing all parts of part procurement and inventory.

---

## Table of Contents

- [Features](#features)
- [Technologies Used](#technologies-used)
- [Installation Guide](#installation-guide)
- [How to Use](#how-to-use)
- [Database Structure](#database-structure)
- [License](#license)

---

Below is the Entity-Relationship Diagram (ERD) for the TracknSupply system:

![ERD Diagram](https://github.com/anikatahsin14/Project-1-IAL-/blob/main/ERD%20of%20TracknSupply.png)


---

## Features

### 1. **Supplier Management**: 
  - Add, edit, and delete suppliers.
  - Track supplier names, addresses, and prices for purchased parts.
  - Assign parts to specific suppliers.
  
### 2. **Parts Management**: 
  - Manage internal and purchased parts, including tracking of their names, quantities, and manufacturing costs.
  - Record the price of purchased parts from different suppliers.

### 3. **Product Management**: 
  - Add products that use internal or purchased parts.
  - Track stock quantities of finished products.

### 4. **User Management**:
  - Different levels of user access: Admin, Manager, and User.
  - Admins can manage everything, while Managers can edit parts and suppliers, and Users can only view inventory data.

### 5. **Excel Export**: 
  - Export supplier and inventory details to Excel for further analysis.

### 6. **Responsive Design**: 
  - Fully responsive design, ensuring the system works across all devices (desktop, tablet, and mobile).

---

## Technologies Used

- **Backend**: ASP.NET (C#)
- **Frontend**: HTML, CSS, Bootstrap 4, FontAwesome
- **Database**: MySQL Server 2017
- **Libraries**:
  - jQuery
  - Bootstrap 4
  - FontAwesome
- **Others**:
  - AjaxControlToolkit for asynchronous features
  - ASP.NET SQL DataSource for database connectivity

---

## Installation Guide

### Prerequisites

- **Visual Studio**: Ensure you have Visual Studio 2017 or later installed.
- **MySQL Server**: Ensure MySQL Server 2017 is installed and running on your local machine.

### Setup Instructions

1. **Clone the Repository**:
    ```bash
    git clone https://github.com/your-username/TracknSupply.git
    ```

2. **Set up MySQL Database**:
    - Create a database called `TracknSupply` in MySQL Server.
    - Import the provided SQL script to create the necessary tables and relationships:
    ```sql
    CREATE TABLE Suppliertbl (
        SupplierID INT AUTO_INCREMENT PRIMARY KEY,
        Name VARCHAR(100) NOT NULL,
        Address VARCHAR(255) NOT NULL,
        PartID INT,
        Price DECIMAL(10, 2) NOT NULL,
        FOREIGN KEY (PartID) REFERENCES Parttbl(PartID)
    );

    CREATE TABLE Parttbl (
        PartID INT AUTO_INCREMENT PRIMARY KEY,
        PartName VARCHAR(100) NOT NULL,
        QuantityInStock INT NOT NULL,
        ManufacturingCost DECIMAL(10, 2) NOT NULL,
        IsPurchased BOOLEAN DEFAULT FALSE
    );

    CREATE TABLE Producttbl (
        ProductID INT AUTO_INCREMENT PRIMARY KEY,
        ProductName VARCHAR(100) NOT NULL,
        PartID INT,
        QuantityInStock INT NOT NULL,
        FOREIGN KEY (PartID) REFERENCES Parttbl(PartID)
    );
    ```

3. **Configure the Connection String**:
    - Open the `Web.config` file in the project directory.
    - Update the connection string with your MySQL server credentials:
    ```xml
    <connectionStrings>
        <add name="connection_" connectionString="Server=localhost;Database=TracknSupply;Uid=root;Pwd=password;" providerName="MySql.Data.MySqlClient" />
    </connectionStrings>
    ```

4. **Run the Project**:
    - Open the project in Visual Studio.
    - Press `F5` or click **Start** to run the application locally.

---

## How to Use

1. **Login** (If user authentication is required):
    - Login to the application using your credentials (if applicable).

2. **Supplier Management**:
    - Add new suppliers by clicking the "Add New Supplier" button.
    - Edit and update supplier details, including address and prices for purchased parts.
    - View supplier information in a table format.

3. **Parts Management**:
    - Add new parts (either internal or purchased).
    - Update part details, including quantity in stock and manufacturing costs.
    - Select parts from the supplier list for purchased parts.

4. **Product Management**:
    - Add new products and associate them with parts.
    - Track the quantity in stock for each product.

5. **User Management**:
    - Admins can assign different roles to users (Admin, Manager, User).
    - Managers can edit parts and suppliers, while Users can only view data.

6. **Export Data to Excel**:
    - Click the "Export to Excel" button to export supplier and inventory details to an Excel file.

---

## Database Structure

The database consists of the following key tables:

1. **Suppliertbl**: Stores supplier details including `SupplierID`, `Name`, `Address`, `PartID` (foreign key referencing `Parttbl`), and `Price` for purchased parts.
2. **Part**: Stores part details including `PartID`, `PartName`, `QuantityInStock`, `ManufacturingCost`, and a flag `IsPurchased` to indicate whether the part is purchased or manufactured internally.
3. **prod_updated**: Stores product details including `ProductID`, `ProductName`, `PartID` (foreign key referencing `Parttbl`), and `QuantityInStock`.

You can extend this structure to include more tables based on your requirements.

---

## License

This project is open-source and available under the MIT License.

---



## Author

**Name**: Anika Tahsin Rithin  
**Company**: Interstoff Apparels LTD  
**Email**: anikatahsin1409@gmail.com

---

## Modules
![Login](https://github.com/anikatahsin14/Project-1-IAL-/blob/main/login.png)

![Registration](https://github.com/anikatahsin14/Project-1-IAL-/blob/main/registration.png)

![Home](https://github.com/anikatahsin14/Project-1-IAL-/blob/main/home.png)

![Forget Password](https://github.com/anikatahsin14/Project-1-IAL-/blob/main/forgotpassword.png)

![Part Management](https://github.com/anikatahsin14/Project-1-IAL-/blob/main/partmng1.png)

![Add a Part](https://github.com/anikatahsin14/Project-1-IAL-/blob/main/partmng2.png)

![Update Part](https://github.com/anikatahsin14/Project-1-IAL-/blob/main/partmng3.png)

![Search Part](https://github.com/anikatahsin14/Project-1-IAL-/blob/main/partmng4.png)

![Product Management](https://github.com/anikatahsin14/Project-1-IAL-/blob/main/productmng1.png)

![Update Product](https://github.com/anikatahsin14/Project-1-IAL-/blob/main/productmng2.png)

![Add New Product](https://github.com/anikatahsin14/Project-1-IAL-/blob/main/productmgn3.png)

![Supplier Management Module](https://github.com/anikatahsin14/Project-1-IAL-/blob/main/suppliermng.png)

![Add New Supplier](https://github.com/anikatahsin14/Project-1-IAL-/blob/main/suppliermng2.png)

![Update a Supplier](https://github.com/anikatahsin14/Project-1-IAL-/blob/main/suppliermng3.png)

![About](https://github.com/anikatahsin14/Project-1-IAL-/blob/main/aboutus.png)


