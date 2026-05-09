import { Injectable, signal } from '@angular/core';
import { PrintJob } from '../models';

@Injectable({ providedIn: 'root' })
export class PricingService {
  // Base prices in IQD, now as signals
  private PRICE_PER_PAGE_BW = signal(100);
  private PRICE_PER_PAGE_COLOR = signal(500);
  private DUPLEX_DISCOUNT_MULTIPLIER = signal(0.95); // 5% discount for duplex

  // Binding prices in IQD, now as signals
  private PRICE_BINDING_STAPLE = signal(500);
  private PRICE_BINDING_SPIRAL = signal(2500);

  // Getters for admin dashboard
  getPricePerPageBw = this.PRICE_PER_PAGE_BW.asReadonly();
  getPricePerPageColor = this.PRICE_PER_PAGE_COLOR.asReadonly();
  getPriceBindingStaple = this.PRICE_BINDING_STAPLE.asReadonly();
  getPriceBindingSpiral = this.PRICE_BINDING_SPIRAL.asReadonly();

  // Setters for admin dashboard
  setPricePerPageBw(price: number) { this.PRICE_PER_PAGE_BW.set(price); }
  setPricePerPageColor(price: number) { this.PRICE_PER_PAGE_COLOR.set(price); }
  setPriceBindingStaple(price: number) { this.PRICE_BINDING_STAPLE.set(price); }
  setPriceBindingSpiral(price: number) { this.PRICE_BINDING_SPIRAL.set(price); }


  calculatePrice(job: Omit<PrintJob, 'fileNames'>): number {
    let basePageCost = job.colorMode === 'color' ? this.PRICE_PER_PAGE_COLOR() : this.PRICE_PER_PAGE_BW();
    
    // Apply duplex discount
    if (job.duplex === 'double') {
        basePageCost *= this.DUPLEX_DISCOUNT_MULTIPLIER();
    }

    let totalPagesPrice = basePageCost * job.pageCount;
    let totalCopiesPrice = totalPagesPrice * job.copies;

    let bindingCostPerCopy = 0;
    if (job.binding === 'staple') {
      bindingCostPerCopy = this.PRICE_BINDING_STAPLE();
    } else if (job.binding === 'spiral') {
      bindingCostPerCopy = this.PRICE_BINDING_SPIRAL();
    }

    // The binding is applied to each copy, so multiply by the number of copies.
    const totalBindingCost = bindingCostPerCopy * job.copies;

    const totalPrice = totalCopiesPrice + totalBindingCost;
    
    // Ensure a minimum price for any print job
    return Math.max(totalPrice, 250);
  }
}