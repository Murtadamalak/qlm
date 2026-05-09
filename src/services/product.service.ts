import { Injectable, signal } from '@angular/core';
import { Product } from '../models';

@Injectable({ providedIn: 'root' })
export class ProductService {
  private productsSignal = signal<Product[]>([
    { id: 'prod1', name: 'قلم حبر جاف فاخر', price: 3000, imageUrl: 'https://picsum.photos/seed/pen/400/300', description: 'كتابة سلسة، حبر أسود.' },
    { id: 'prod2', name: 'دفتر حلزوني (A5)', price: 5000, imageUrl: 'https://picsum.photos/seed/notebook/400/300', description: '120 صفحة، مسطر.' },
    { id: 'prod3', name: 'طقم أقلام تحديد (4 ألوان)', price: 7000, imageUrl: 'https://picsum.photos/seed/highlighter/400/300', description: 'ألوان زاهية، لا تسيل.' },
    { id: 'prod4', name: 'مجموعة أوراق ملاحظات لاصقة', price: 3500, imageUrl: 'https://picsum.photos/seed/stickynotes/400/300', description: '3x3 إنش، 100 ورقة.' },
    { id: 'prod5', name: 'دباسة متينة', price: 15000, imageUrl: 'https://picsum.photos/seed/stapler/400/300', description: 'تدبس حتى 50 ورقة.' },
    { id: 'prod6', name: 'مشابك ورق (200 قطعة)', price: 3000, imageUrl: 'https://picsum.photos/seed/clips/400/300', description: 'ألوان متنوعة، معدن متين.' },
  ]);

  getProducts() {
    return this.productsSignal;
  }

  addProduct(productData: Omit<Product, 'id'>) {
    const newProduct: Product = {
      ...productData,
      id: `prod-${Date.now()}`
    };
    this.productsSignal.update(products => [...products, newProduct]);
  }

  updateProduct(updatedProduct: Product) {
    this.productsSignal.update(products => 
      products.map(p => p.id === updatedProduct.id ? updatedProduct : p)
    );
  }

  deleteProduct(productId: string) {
    this.productsSignal.update(products => 
      products.filter(p => p.id !== productId)
    );
  }
}
