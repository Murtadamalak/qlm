import { ChangeDetectionStrategy, Component, inject, signal } from '@angular/core';
import { CommonModule } from '@angular/common';
import { FormsModule } from '@angular/forms';
import { OrderService } from '../services/order.service';
import { Order } from '../models';

@Component({
  selector: 'app-order-manager',
  imports: [CommonModule, FormsModule],
  templateUrl: './order-manager.component.html',
  changeDetection: ChangeDetectionStrategy.OnPush,
})
export class OrderManagerComponent {
  orderService = inject(OrderService);
  orders = this.orderService.orders;
  selectedOrder = signal<Order | null>(null);
  orderStatuses: Order['status'][] = ['Pending', 'In Progress', 'Ready', 'Delivered'];

  viewOrderDetails(order: Order) {
    this.selectedOrder.set(order);
  }

  closeOrderDetails() {
    this.selectedOrder.set(null);
  }

  onStatusChange(order: Order, event: Event) {
    const select = event.target as HTMLSelectElement;
    this.orderService.updateOrderStatus(order.id, select.value as Order['status']);
    if (this.selectedOrder()?.id === order.id) {
      this.selectedOrder.update(current => current ? { ...current, status: select.value as Order['status'] } : null);
    }
  }

  getStatusClass(status: Order['status']) {
    switch (status) {
      case 'Pending': return 'bg-amber-100 text-amber-800';
      case 'In Progress': return 'bg-[#F0EDE5] text-[#004643]';
      case 'Ready': return 'bg-emerald-100 text-emerald-800';
      case 'Delivered': return 'bg-slate-100 text-slate-800';
      default: return 'bg-gray-100 text-gray-800';
    }
  }

  translateStatus(status: Order['status']) {
    switch (status) {
      case 'Pending': return 'قيد الانتظار';
      case 'In Progress': return 'قيد التجهيز';
      case 'Ready': return 'جاهز للاستلام';
      case 'Delivered': return 'تم التوصيل';
      default: return status;
    }
  }
}
