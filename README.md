# Sales Tracker App

A custom-built app I am building for fun. It is a **local desktop application** for managing international designer shoe sales, customer orders, purchase workflows, inventory tracking, and basic accounting with **multi-currency support (USD, LYD)**.

---

## 📦 Purpose
This tool is for **personal use** and runs entirely on your **local Windows machine**. It provides a complete end-to-end solution to track:

- Customer requests and orders
- Deposits and payment statuses
- Vendor purchases and shipments
- Inventory movements
- Accounts Receivable (AR) and Payable (AP)
- Multi-currency cash transactions (USD, LYD)
- Financial reporting and order fulfillment statuses

---

## 🛠 Technologies Used
- **Python 3.10+**
- **Microsoft SQL Server** (local instance)
- Install required Python packages (See requirements.txt)

---

## 🗃️ Database
The backend is powered by **SQL Server**, with normalized schema for accounting, inventory, and operational workflows.  
Key tables:
- `sales_order`, `sales_order_line`
- `purchase_order`, `purchase_order_line`
- `customer`, `product`, `vendor`, `brand`
- `cash_receipt`, `cash_disbursement`, `payable`
- `shipment_segment`, `inventory`, `accrual_register`
- `account_transfer`, `gl_account`

A full schema is included in `CreateDatabaseSchema.sql`.

---

## 📋 Features

### ✅ Sales Entry
- Select/create customer
- Record multi-product orders
- Handle deposit status (paid, unpaid, received by carrier)
- Automatically link to future purchase orders

### ✅ Purchase Order Entry
- Create PO tied to vendor and sales order (or standalone for inventory)
- Record multiple lines and costs
- Track vendor tracking and shipping status

### ✅ Master Data Management
- Add/edit customers, products, vendors, brands, GL accounts

### ✅ Payments & Payables
- Enter cash receipts (customer or carrier deposits)
- Enter payables and disbursements (vendor shipping, product cost, or other services)
- Support for both USD and LYD accounts

### ✅ Inventory & Shipment Tracking
- Monitor shipments by segment: vendor, international, domestic
- Track inventory status: in_stock, sold, damaged
- Attach shipment and warehouse tracking numbers

### ✅ Reporting Dashboard
- View profit per order
- Inventory valuation
- Outstanding AR / AP
- Total sales, purchase costs, and currency balances
- Exportable reports

---

## 🧱 Planned Windows (GUI)
| Window | Functionality |
|--------|---------------|
| `Customer` | Add/edit customers |
| `Product` | Add/edit products and brands |
| `Vendor` | Add/edit vendors |
| `SO Entry` | Add new sales orders (direct or inventory) |
| `PO Entry` | Create purchase orders and link to sales |
| `Payment Entry` | Record customer deposits and payments |
| `Payable Entry` | Track expenses owed to vendors/carriers |
| `Distribution Entry` | Record outflows (owner draw, misc) |
| `Reports` | View accounting, inventory, and financial reports |

---

## ✔️ GUI Progress so far

![alt text](https://github.com/AyubSherif/SalesApp/blob/main/Customer%20Entry.png)

---

## 💾 Setup Instructions
1. **Install SQL Server (Express or Developer)**
2. Run `CreateDatabaseSchema.sql` to set up the schema.
3. Install required Python packages:
   ```bash
   pip install -r requirements.txt
   ```
4. Run the GUI from `main.py`

---

## 🔒 Data Privacy
All data is stored locally and is never sent externally. This application is intended for **personal use only**, with no internet dependencies unless you integrate exchange rate APIs.

---

## 🧭 Future Ideas
- Backup/restore local data to cloud
- Integrate carrier service (USPS, UPS, FedEx) APIs for real time tracking.
---

## 👤 Author
**Ayub Sherif**  
For personal entrepreneurial use and learning.  
