import { ChangeDetectionStrategy, Component, effect, inject } from '@angular/core';
import { signal } from '@angular/core';
import { CommonModule } from '@angular/common';

// Components
import { HeaderComponent } from './header.component';
import { HomeComponent } from './home.component';
import { PrintOrderComponent } from './print-order.component';
import { StoreComponent } from './store.component';
import { CartComponent } from './cart.component';
import { OrdersComponent } from './orders.component';
import { LoginComponent } from './login.component';
import { AdminComponent } from './admin/admin.component';

// Services
import { AuthService } from './services/auth.service';

export type View = 'home' | 'print' | 'store' | 'cart' | 'orders' | 'login' | 'admin';

@Component({
  selector: 'app-root',
  templateUrl: './app.component.html',
  changeDetection: ChangeDetectionStrategy.OnPush,
  imports: [
    CommonModule,
    HeaderComponent,
    HomeComponent,
    PrintOrderComponent,
    StoreComponent,
    CartComponent,
    OrdersComponent,
    LoginComponent,
    AdminComponent,
  ],
})
export class AppComponent {
  authService = inject(AuthService);
  view = signal<View>('login');

  constructor() {
    effect(() => {
      if (this.authService.isLoggedIn()) {
        if(this.view() === 'login') {
            this.view.set('home');
        }
      } else {
        this.view.set('login');
      }
    });
  }

  onNavigate(view: View) {
    this.view.set(view);
    window.scrollTo(0, 0);
  }

  onLoginSuccess() {
    this.view.set('home');
  }
}
