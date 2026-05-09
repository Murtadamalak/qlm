import { Injectable, computed, signal } from '@angular/core';
import { CartItem, Product } from '../models';

@Injectable({ providedIn: 'root' })
export class CartService {
  items = signal<CartItem[]>([]);

  total = computed(() => {
    return this.items().reduce((acc, item) => acc + item.price, 0);
  });

  itemCount = computed(() => this.items().length);

  addProduct(product: Product) {
    const cartProduct: CartItem = { ...product, type: 'product' };
    this.items.update(items => [...items, cartProduct]);
  }

  removeItem(index: number) {
    this.items.update(items => items.filter((_, i) => i !== index));
  }

  clearCart() {
    this.items.set([]);
  }
}
