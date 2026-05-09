export interface Product {
  id: string;
  name: string;
  price: number;
  imageUrl: string;
  description: string;
}

export interface PrintJob {
  fileNames: string[];
  paperSize: 'A4';
  colorMode: 'bw' | 'color';
  copies: number;
  binding: 'none' | 'staple' | 'spiral';
  duplex: 'single' | 'double';
  pageCount: number;
}

export type CartItem = (Product & { type: 'product' }) | (PrintJob & { type: 'print', price: number, name: string });

export interface Order {
  id: string;
  userId: string;
  customerName: string;
  items: CartItem[];
  total: number;
  status: 'Pending' | 'In Progress' | 'Ready' | 'Delivered';
  orderDate: Date;
}

export interface User {
    id: string;
    username: string;
    role: 'customer' | 'admin';
}