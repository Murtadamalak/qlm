import { Injectable, computed, signal } from '@angular/core';
import { CartItem, PrintJob, Product } from '../models';
import { PricingService } from './pricing.service';
import { inject } from '@angular/core';

@Injectable({ providedIn: 'root' })
export class CartService {
  private pricingService = inject(PricingService);
  
  items = signal<CartItem[]>([]);
  
  total = computed(() => {
    return this.items().reduce((acc, item) => acc + item.price, 0);
  });
  
  itemCount = computed(() => this.items().length);

  addProduct(product: Product) {
    const cartProduct: CartItem = { ...product, type: 'product' };
    this.items.update(items => [...items, cartProduct]);
  }

  addPrintJob(job: PrintJob) {
    const price = this.pricingService.calculatePrice(job);
    const cartPrintJob: CartItem = { 
      ...job, 
      type: 'print', 
      price,
      name: `طلب طباعة (${job.fileNames.length} ملفات)`
    };
    this.items.update(items => [...items, cartPrintJob]);
  }

  removeItem(index: number) {
    this.items.update(items => items.filter((_, i) => i !== index));
  }

  clearCart() {
    this.items.set([]);
  }
}
