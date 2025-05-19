import pyodbc
from datetime import date
import tkinter as tk
from tkinter import ttk, messagebox

today = date.today().strftime("%Y-%m-%d")

def connect_to_db():
    return pyodbc.connect(
        r"DRIVER={SQL Server};"
        r"SERVER=DESKTOP-IN0L5HN;"  # replace with your server name
        r"DATABASE=ElegantBride;" # replace with your database name
        r"Trusted_Connection=yes;"
        )

class ElegantBrideApp:
    def __init__(self, root):
        self.root = root
        self.root.title("Elegant Bride App")
        self.root.geometry("1000x600")  # Reasonable default size

        # Main layout frames
        self.menu_frame = tk.Frame(self.root, width=200, bg="#f0f0f0")
        self.menu_frame.pack(side="left", fill="y")

        self.content_frame = tk.Frame(self.root, bg="#ffffff")
        self.content_frame.pack(side="right", fill="both", expand=True)

        self.create_main_menu()

    def create_main_menu(self):
        tk.Label(self.menu_frame, text="Menu", font=("Helvetica", 14, "bold"), bg="#f0f0f0").pack(pady=10)

        buttons = [
            ("Customer Entry", self.open_customer_entry),
            ("Product Entry", self.open_product_entry),
            ("Vendor Entry", self.open_vendor_entry),
            ("Sales Order Entry", self.open_so_entry),
            ("Purchase Order Entry", self.open_po_entry),
            ("Payment Entry", self.open_payment_entry),
            ("Payable Entry", self.open_payable_entry),
            ("Distribution Entry", self.open_distribution_entry),
            ("Reports", self.open_reports)
        ]

        for label, command in buttons:
            tk.Button(self.menu_frame, text=label, width=20, command=command).pack(pady=4, padx=10, anchor="w")

    def clear_content(self):
        for widget in self.content_frame.winfo_children():
            widget.destroy()

    def open_customer_entry(self):
        self.clear_content()
        frame = self.content_frame

        # --- Form Fields ---
        fields = ["Name*", "Phone*", "Address", "Notes"]
        entries = {}
        for i, field in enumerate(fields):
            tk.Label(frame, text=field).grid(row=i, column=0, padx=10, pady=4, sticky="e")
            entry = tk.Entry(frame, width=40)
            entry.grid(row=i, column=1, padx=10, pady=4)
            entries[field] = entry

        # Treeview (Customer List)
        cols = ("ID", "Name", "Phone", "Address", "Notes")
        tree = ttk.Treeview(frame, columns=cols, show="headings", height=8)
        for col in cols:
            tree.heading(col, text=col)
            tree.column(col, width=100 if col == "ID" else 150)
        tree.grid(row=5, column=0, columnspan=2, padx=10, pady=10)

        def load_customers():
            for row in tree.get_children():
                tree.delete(row)
            try:
                conn = connect_to_db()
                cursor = conn.cursor()
                cursor.execute("SELECT customer_id, name, phone, address, notes FROM customer")
                for row in cursor.fetchall():
                    tree.insert("", "end", values=(row.customer_id, row.name, row.phone, row.address, row.notes))
                conn.close()
            except Exception as e:
                messagebox.showerror("Error loading customers", str(e))

        def save_customer():
            name = entries["Name*"].get().strip()
            phone = entries["Phone*"].get().strip()
            address = entries["Address"].get().strip()
            notes = entries["Notes"].get().strip()

            if not name or not phone:
                messagebox.showerror("Validation Error", "Name and phone are required.")
                return

            selected = tree.selection()
            try:
                conn = connect_to_db()
                cursor = conn.cursor()
                if selected:
                    customer_id = tree.item(selected[0])["values"][0]
                    cursor.execute("""
                        UPDATE customer
                        SET name = ?, phone = ?, address = ?, notes = ?, last_update_timestamp = GETDATE()
                        WHERE customer_id = ?
                    """, (name, phone, address or None, notes or None, customer_id))
                else:
                    cursor.execute("""
                        INSERT INTO customer (name, phone, address, notes, create_date, last_update_timestamp)
                        VALUES (?, ?, ?, ?, CAST(GETDATE() AS DATE), GETDATE())
                    """, (name, phone, address or None, notes or None))
                conn.commit()
                conn.close()
                load_customers()
                clear_form()
                messagebox.showinfo("Success", "Customer saved.")
            except Exception as e:
                messagebox.showerror("Database Error", str(e))

        def clear_form():
            for entry in entries.values():
                entry.delete(0, tk.END)
            tree.selection_remove(tree.selection())

        def delete_customer():
            selected = tree.selection()
            if not selected:
                messagebox.showwarning("No Selection", "Select a customer to delete.")
                return
            customer_id = tree.item(selected[0])["values"][0]
            if messagebox.askyesno("Confirm Delete", f"Delete customer ID {customer_id}?"):
                try:
                    conn = connect_to_db()
                    cursor = conn.cursor()
                    cursor.execute("DELETE FROM customer WHERE customer_id = ?", (customer_id,))
                    conn.commit()
                    conn.close()
                    load_customers()
                    clear_form()
                except Exception as e:
                    messagebox.showerror("Delete Error", str(e))

        def on_tree_select(event):
            selected = tree.selection()
            if selected:
                values = tree.item(selected[0])["values"]
                entries["Name*"].delete(0, tk.END)
                entries["Name*"].insert(0, values[1])
                entries["Phone*"].delete(0, tk.END)
                entries["Phone*"].insert(0, values[2])
                entries["Address"].delete(0, tk.END)
                entries["Address"].insert(0, values[3] or "")
                entries["Notes"].delete(0, tk.END)
                entries["Notes"].insert(0, values[4] or "")

        tree.bind("<<TreeviewSelect>>", on_tree_select)

        # --- Buttons ---
        tk.Button(frame, text="Save", command=save_customer, bg="green", fg="white").grid(row=4, column=0, pady=5)
        tk.Button(frame, text="Clear", command=clear_form).grid(row=4, column=1, sticky="w")
        tk.Button(frame, text="Delete", command=delete_customer, fg="red").grid(row=6, column=0, columnspan=2, pady=5)

        load_customers()

    def open_product_entry(self):
        messagebox.showinfo("Product", "Product window (to be implemented)")

    def open_vendor_entry(self):
        messagebox.showinfo("Vendor", "Vendor window (to be implemented)")

    def open_so_entry(self):
        messagebox.showinfo("SO Entry", "Sales Order Entry window (to be implemented)")

    def open_po_entry(self):
        messagebox.showinfo("PO Entry", "Purchase Order window (to be implemented)")

    def open_payment_entry(self):
        messagebox.showinfo("Payment Entry", "Payment Entry window (to be implemented)")

    def open_payable_entry(self):
        messagebox.showinfo("Payable Entry", "Payable Entry window (to be implemented)")

    def open_distribution_entry(self):
        messagebox.showinfo("Disbursement Entry", "Disbursement window (to be implemented)")

    def open_reports(self):
        messagebox.showinfo("Reports", "Reports window (to be implemented)")

if __name__ == "__main__":
    root = tk.Tk()
    app = ElegantBrideApp(root)
    root.mainloop()
