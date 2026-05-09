import { Injectable, signal } from '@angular/core';
import { Order, CartItem, User } from '../models';

@Injectable({ providedIn: 'root' })
export class OrderService {
  orders = signal<Order[]>([]);

  placeOrder(items: CartItem[], total: number, user: User): Order {
    const newOrder: Order = {
      id: `ORD-${Date.now()}`,
      userId: user.id,
      customerName: user.username,
      items: [...items],
      total,
      status: 'Pending',
      orderDate: new Date(),
    };
    this.orders.update(orders => [newOrder, ...orders]);
    return newOrder;
  }

  updateOrderStatus(orderId: string, status: Order['status']) {
    this.orders.update(orders => 
      orders.map(order => 
        order.id === orderId ? { ...order, status } : order
      )
    );
  }
}