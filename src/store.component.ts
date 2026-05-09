import { ChangeDetectionStrategy, Component, inject, signal, computed } from '@angular/core';
import { ProductService } from './services/product.service';
import { CartService } from './services/cart.service';
import { Product } from './models';
import { CommonModule } from '@angular/common';

@Component({
  selector: 'app-store',
  imports: [CommonModule],
  templateUrl: './store.component.html',
  changeDetection: ChangeDetectionStrategy.OnPush,
})
export class StoreComponent {
  private productService = inject(ProductService);
  private cartService = inject(CartService);

  private products = this.productService.getProducts();
  addedProductId = signal<string | null>(null);
  searchTerm = signal('');

  filteredProducts = computed(() => {
    const term = this.searchTerm().toLowerCase().trim();
    if (!term) {
      return this.products();
    }
    return this.products().filter(product =>
      product.name.toLowerCase().includes(term)
    );
  });

  onSearch(event: Event) {
    const input = event.target as HTMLInputElement;
    this.searchTerm.set(input.value);
  }

  addToCart(product: Product) {
    this.cartService.addProduct(product);
    this.addedProductId.set(product.id);
    setTimeout(() => this.addedProductId.set(null), 1500);
  }
}