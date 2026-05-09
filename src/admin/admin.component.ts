import { ChangeDetectionStrategy, Component, signal } from '@angular/core';
import { CommonModule } from '@angular/common';
import { ProductManagerComponent } from './product-manager.component';
import { OrderManagerComponent } from './order-manager.component';
import { PricingManagerComponent } from './pricing-manager.component';

type AdminView = 'products' | 'orders' | 'pricing';

@Component({
  selector: 'app-admin',
  imports: [CommonModule, ProductManagerComponent, OrderManagerComponent, PricingManagerComponent],
  template: `
    <div class="max-w-7xl mx-auto">
        <h2 class="text-3xl font-bold text-slate-800 mb-6">لوحة تحكم المدير</h2>

        <div class="border-b border-slate-200 mb-6">
            <nav class="-mb-px flex space-x-4 space-x-reverse" aria-label="Tabs">
                <button (click)="view.set('products')" 
                        [class]="currentViewClass('products')">
                    إدارة المنتجات
                </button>
                <button (click)="view.set('orders')" 
                        [class]="currentViewClass('orders')">
                    إدارة الطلبات
                </button>
                <button (click)="view.set('pricing')"
                        [class]="currentViewClass('pricing')">
                    إدارة الأسعار
                </button>
            </nav>
        </div>

        <div>
            @switch(view()) {
                @case('products') { <app-product-manager></app-product-manager> }
                @case('orders') { <app-order-manager></app-order-manager> }
                @case('pricing') { <app-pricing-manager></app-pricing-manager> }
            }
        </div>
    </div>
  `,
  changeDetection: ChangeDetectionStrategy.OnPush,
})
export class AdminComponent {
    view = signal<AdminView>('products');

    baseTabClass = 'whitespace-nowrap py-4 px-1 border-b-2 font-medium text-sm';
    activeTabClass = 'border-teal-500 text-teal-600';
    inactiveTabClass = 'border-transparent text-slate-500 hover:text-slate-700 hover:border-slate-300';

    currentViewClass(viewName: AdminView) {
        return `${this.baseTabClass} ${this.view() === viewName ? this.activeTabClass : this.inactiveTabClass}`;
    }
}
