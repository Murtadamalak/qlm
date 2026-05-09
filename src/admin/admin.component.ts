import { ChangeDetectionStrategy, Component, signal } from '@angular/core';
import { CommonModule } from '@angular/common';
import { ProductManagerComponent } from './product-manager.component';
import { OrderManagerComponent } from './order-manager.component';

type AdminView = 'products' | 'orders';

@Component({
  selector: 'app-admin',
  imports: [CommonModule, ProductManagerComponent, OrderManagerComponent],
  template: `
    <div class="mx-auto max-w-7xl">
      <div class="mb-8 overflow-hidden rounded-[2rem] bg-[#004643] p-7 text-[#F0EDE5] shadow-2xl shadow-[#004643]/15">
        <p class="text-sm font-black uppercase tracking-[0.35em] text-[#F0EDE5]/50">Admin</p>
        <h2 class="mt-3 text-4xl font-black tracking-tight">لوحة تحكم المدير</h2>
        <p class="mt-3 text-[#F0EDE5]/65">إدارة منتجات المتجر والطلبات بتصميم حديث وواضح.</p>
      </div>

      <div class="mb-6 rounded-[2rem] border border-[#004643]/10 bg-white/70 p-2 shadow-lg shadow-[#004643]/5 backdrop-blur">
        <nav class="flex gap-2" aria-label="Tabs">
          <button (click)="view.set('products')" [class]="currentViewClass('products')">إدارة المنتجات</button>
          <button (click)="view.set('orders')" [class]="currentViewClass('orders')">إدارة الطلبات</button>
        </nav>
      </div>

      @switch(view()) {
        @case('products') { <app-product-manager></app-product-manager> }
        @case('orders') { <app-order-manager></app-order-manager> }
      }
    </div>
  `,
  changeDetection: ChangeDetectionStrategy.OnPush,
})
export class AdminComponent {
  view = signal<AdminView>('products');

  currentViewClass(viewName: AdminView) {
    const base = 'flex-1 rounded-[1.5rem] px-5 py-3 text-sm font-black transition';
    return this.view() === viewName
      ? `${base} bg-[#004643] text-[#F0EDE5] shadow-lg`
      : `${base} text-[#004643]/65 hover:bg-[#F0EDE5] hover:text-[#004643]`;
  }
}
