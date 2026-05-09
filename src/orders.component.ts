import { ChangeDetectionStrategy, Component, computed, inject } from '@angular/core';
import { CommonModule } from '@angular/common';
import { OrderService } from './services/order.service';
import { Order, PrintJob } from './models';
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
    // Admin sees all orders from this view as well
    if (this.authService.isAdmin()) {
        return this.orderService.orders();
    }
    return this.orderService.orders().filter(order => order.userId === currentUser.id);
  });
  
  getStatusClass(status: string) {
    switch (status) {
      case 'Pending': return 'bg-yellow-100 text-yellow-800';
      case 'In Progress': return 'bg-blue-100 text-blue-800';
      case 'Ready': return 'bg-green-100 text-green-800';
      case 'Delivered': return 'bg-slate-100 text-slate-800';
      default: return 'bg-gray-100 text-gray-800';
    }
  }

  translateStatus(status: Order['status']): string {
    switch (status) {
      case 'Pending': return 'قيد الانتظار';
      case 'In Progress': return 'قيد التنفيذ';
      case 'Ready': return 'جاهز للاستلام';
      case 'Delivered': return 'تم التوصيل';
      default: return status;
    }
  }

  translateBinding(binding: PrintJob['binding']): string {
    switch (binding) {
      case 'none': return 'بدون';
      case 'staple': return 'تدبيس';
      case 'spiral': return 'حلزوني';
      default: return '';
    }
  }

  translateDuplex(duplex: PrintJob['duplex']): string {
    return duplex === 'single' ? 'وجه واحد' : 'وجهين';
  }
}