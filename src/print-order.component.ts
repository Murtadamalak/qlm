import { ChangeDetectionStrategy, Component, inject, computed, signal, output } from '@angular/core';
import { FormsModule } from '@angular/forms';
import { CommonModule } from '@angular/common';
import { PricingService } from './services/pricing.service';
import { CartService } from './services/cart.service';
import { PrintJob } from './models';

@Component({
  selector: 'app-print-order',
  imports: [FormsModule, CommonModule],
  templateUrl: './print-order.component.html',
  changeDetection: ChangeDetectionStrategy.OnPush,
})
export class PrintOrderComponent {
  private pricingService = inject(PricingService);
  private cartService = inject(CartService);

  orderPlaced = output();

  fileNames = signal<string[]>([]);
  paperSize = signal<'A4'>('A4');
  colorMode = signal<'bw' | 'color'>('bw');
  copies = signal(1);
  binding = signal<'none' | 'staple' | 'spiral'>('none');
  duplex = signal<'single' | 'double'>('single');
  pageCount = signal(1);
  
  showSuccess = signal(false);

  price = computed(() => {
    // Prevent calculation if page count is invalid
    if (this.pageCount() < 1) return 0;

    return this.pricingService.calculatePrice({
      paperSize: this.paperSize(),
      colorMode: this.colorMode(),
      copies: this.copies(),
      binding: this.binding(),
      duplex: this.duplex(),
      pageCount: this.pageCount()
    });
  });

  handleFileInput(event: Event) {
    const target = event.target as HTMLInputElement;
    if (target.files && target.files.length > 0) {
      this.fileNames.set(Array.from(target.files).map(f => f.name));
    }
  }
  
  addToCart() {
    if (this.fileNames().length === 0) {
      alert('الرجاء رفع ملف واحد على الأقل.');
      return;
    }
    if (this.pageCount() <= 0) {
        alert('الرجاء إدخال عدد صحيح للصفحات.');
        return;
    }
    const job: PrintJob = {
      fileNames: this.fileNames(),
      paperSize: this.paperSize(),
      colorMode: this.colorMode(),
      copies: this.copies(),
      binding: this.binding(),
      duplex: this.duplex(),
      pageCount: this.pageCount(),
    };
    this.cartService.addPrintJob(job);
    this.showSuccess.set(true);
    setTimeout(() => {
        this.showSuccess.set(false);
        this.orderPlaced.emit();
    }, 2000);
  }
}
