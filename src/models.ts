export interface Product {
  id: string;
  name: string;
  price: number;
  imageUrl: string;
  description: string;
}

export type CartItem = Product & { type: 'product' };

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
