import { ChangeDetectionStrategy, Component, inject, signal, OnInit } from '@angular/core';
import { CommonModule } from '@angular/common';
import { FormsModule } from '@angular/forms';
import { PricingService } from '../services/pricing.service';

@Component({
  selector: 'app-pricing-manager',
  imports: [CommonModule, FormsModule],
  templateUrl: './pricing-manager.component.html',
  changeDetection: ChangeDetectionStrategy.OnPush,
})
export class PricingManagerComponent implements OnInit {
    pricingService = inject(PricingService);

    // Use signals to hold form data locally
    priceBw = signal(0);
    priceColor = signal(0);
    priceStaple = signal(0);
    priceSpiral = signal(0);

    showSuccess = signal(false);

    ngOnInit() {
        // Initialize local signals from the service
        this.priceBw.set(this.pricingService.getPricePerPageBw());
        this.priceColor.set(this.pricingService.getPricePerPageColor());
        this.priceStaple.set(this.pricingService.getPriceBindingStaple());
        this.priceSpiral.set(this.pricingService.getPriceBindingSpiral());
    }

    savePrices() {
        this.pricingService.setPricePerPageBw(this.priceBw());
        this.pricingService.setPricePerPageColor(this.priceColor());
        this.pricingService.setPriceBindingStaple(this.priceStaple());
        this.pricingService.setPriceBindingSpiral(this.priceSpiral());

        this.showSuccess.set(true);
        setTimeout(() => this.showSuccess.set(false), 2000);
    }
}
