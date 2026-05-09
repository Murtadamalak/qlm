import { ChangeDetectionStrategy, Component, inject, output } from '@angular/core';
import { CommonModule } from '@angular/common';
import { CartService } from './services/cart.service';
import { OrderService } from './services/order.service';
import { AuthService } from './services/auth.service';

@Component({
  selector: 'app-cart',
  imports: [CommonModule],
  templateUrl: './cart.component.html',
  changeDetection: ChangeDetectionStrategy.OnPush,
})
export class CartComponent {
  cartService = inject(CartService);
  orderService = inject(OrderService);
  authService = inject(AuthService);

  checkoutSuccess = output();

  placeOrder() {
    const currentUser = this.authService.currentUser();
    if (currentUser) {
      this.orderService.placeOrder(this.cartService.items(), this.cartService.total(), currentUser);
      this.cartService.clearCart();
      this.checkoutSuccess.emit();
    } else {
      // This should not happen if the cart view is protected, but as a safeguard:
      alert('الرجاء تسجيل الدخول أولاً لإتمام الطلب.');
    }
  }

  translateBinding(binding: 'none' | 'staple' | 'spiral'): string {
    switch (binding) {
      case 'none': return 'بدون';
      case 'staple': return 'تدبيس';
      case 'spiral': return 'حلزوني';
      default: return '';
    }
  }

  translateDuplex(duplex: 'single' | 'double'): string {
    return duplex === 'single' ? 'وجه واحد' : 'وجهين';
  }
}