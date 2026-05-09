import { ChangeDetectionStrategy, Component, inject, signal } from '@angular/core';
import { CommonModule } from '@angular/common';
import { FormsModule } from '@angular/forms';
import { ProductService } from '../services/product.service';
import { Product } from '../models';

@Component({
  selector: 'app-product-manager',
  imports: [CommonModule, FormsModule],
  templateUrl: './product-manager.component.html',
  changeDetection: ChangeDetectionStrategy.OnPush,
})
export class ProductManagerComponent {
    productService = inject(ProductService);
    products = this.productService.getProducts();

    editingProduct = signal<Product | null>(null);
    // This object serves as the model for the form, for both adding and editing.
    productFormModel: Product | Omit<Product, 'id'> = this.resetNewProduct();
    
    private resetNewProduct(): Omit<Product, 'id'> {
        return { name: '', description: '', price: 0, imageUrl: '' };
    }

    startEditing(product: Product) {
        // Set the product being edited to control the form's mode
        this.editingProduct.set(product);
        // Create a copy of the product for editing in the form
        this.productFormModel = { ...product };
    }

    cancelEditing() {
        // Clear the editing state and reset the form to "add new" mode
        this.editingProduct.set(null);
        this.productFormModel = this.resetNewProduct();
    }

    saveProduct() {
        if(this.editingProduct()) {
            // Use the data from the form model to update the product
            this.productService.updateProduct(this.productFormModel as Product);
            this.cancelEditing(); // Reset the form
        }
    }

    addNewProduct() {
        const newProductData = this.productFormModel as Omit<Product, 'id'>;
        if(newProductData.name && newProductData.price > 0) {
            this.productService.addProduct(newProductData);
            this.productFormModel = this.resetNewProduct(); // Clear the form
        } else {
            alert("يرجى إدخال اسم وسعر صحيح للمنتج.")
        }
    }

    deleteProduct(productId: string) {
        if(confirm('هل أنت متأكد من رغبتك في حذف هذا المنتج؟')) {
            this.productService.deleteProduct(productId);
        }
    }
}
