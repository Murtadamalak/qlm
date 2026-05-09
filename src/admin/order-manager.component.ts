import { ChangeDetectionStrategy, Component, inject, signal } from '@angular/core';
import { CommonModule } from '@angular/common';
import { FormsModule } from '@angular/forms';
import { OrderService } from '../services/order.service';
import { OrdersComponent } from '../orders.component'; // To reuse getStatusClass
import { Order, PrintJob } from '../models';

@Component({
  selector: 'app-order-manager',
  imports: [CommonModule, FormsModule],
  providers: [OrdersComponent], // Provide OrdersComponent to use its methods
  templateUrl: './order-manager.component.html',
  changeDetection: ChangeDetectionStrategy.OnPush,
})
export class OrderManagerComponent {
    orderService = inject(OrderService);
    ordersComponent = inject(OrdersComponent); // Inject to use its methods
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
        const selectElement = event.target as HTMLSelectElement;
        const newStatus = selectElement.value as Order['status'];
        this.orderService.updateOrderStatus(order.id, newStatus);
    }
    
    // Delegate to the injected OrdersComponent instance
    getStatusClass(status: string) {
        return this.ordersComponent.getStatusClass(status);
    }

    translateStatus(status: Order['status']) {
        return this.ordersComponent.translateStatus(status);
    }

    translateBinding(binding: PrintJob['binding']) {
        return this.ordersComponent.translateBinding(binding);
    }

    translateDuplex(duplex: PrintJob['duplex']) {
        return this.ordersComponent.translateDuplex(duplex);
    }
}