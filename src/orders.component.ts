import { ChangeDetectionStrategy, Component, computed, inject } from '@angular/core';
import { CommonModule } from '@angular/common';
import { OrderService } from './services/order.service';
import { Order } from './models';
import { AuthService } from './services/auth.service';

@Component({
  selector: 'app-orders',
  imports: [CommonModule],
  templateUrl: './orders.component.html',
  changeDetection: ChangeDetectionStrategy.OnPush,
})
export class OrdersComponent {
  orderService = inject(OrderService);
  authService = inject(AuthService);

  userOrders = computed(() => {
    const currentUser = this.authService.currentUser();
    if (!currentUser) {
      return [];
    }
    if (this.authService.isAdmin()) {
      return this.orderService.orders();
    }
    return this.orderService.orders().filter(order => order.userId === currentUser.id);
  });

  getStatusClass(status: string) {
    switch (status) {
      case 'Pending': return 'bg-amber-100 text-amber-800';
      case 'In Progress': return 'bg-[#F0EDE5] text-[#004643]';
      case 'Ready': return 'bg-emerald-100 text-emerald-800';
      case 'Delivered': return 'bg-slate-100 text-slate-800';
      default: return 'bg-gray-100 text-gray-800';
    }
  }

  translateStatus(status: Order['status']): string {
    switch (status) {
      case 'Pending': return 'قيد الانتظار';
      case 'In Progress': return 'قيد التجهيز';
      case 'Ready': return 'جاهز للاستلام';
      case 'Delivered': return 'تم التوصيل';
      default: return status;
    }
  }
}
