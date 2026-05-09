import { ChangeDetectionStrategy, Component, output } from '@angular/core';
import { View } from './app.component';

@Component({
  selector: 'app-home',
  template: `
    <div class="text-center py-16">
      <h1 class="text-4xl font-bold tracking-tight text-slate-900 sm:text-6xl">خدمات مكتبتك في مكان واحد</h1>
      <p class="mt-6 text-lg leading-8 text-slate-600">طباعة عالية الجودة وقرطاسية أساسية، كل ذلك في متناول يدك.</p>
    </div>
    <div class="grid grid-cols-1 md:grid-cols-2 gap-8 max-w-4xl mx-auto">
      <div class="group relative cursor-pointer overflow-hidden rounded-lg bg-white shadow-lg" (click)="navigate.emit('print')">
        <img src="https://picsum.photos/seed/printing/600/400" alt="Printing services" class="w-full h-64 object-cover transition-transform duration-300 group-hover:scale-110">
        <div class="absolute inset-0 bg-black/50 flex items-center justify-center">
          <h2 class="text-3xl font-bold text-white">اطلب طباعة</h2>
        </div>
      </div>
      <div class="group relative cursor-pointer overflow-hidden rounded-lg bg-white shadow-lg" (click)="navigate.emit('store')">
        <img src="https://picsum.photos/seed/stationery/600/400" alt="Stationery products" class="w-full h-64 object-cover transition-transform duration-300 group-hover:scale-110">
        <div class="absolute inset-0 bg-black/50 flex items-center justify-center">
          <h2 class="text-3xl font-bold text-white">تسوق القرطاسية</h2>
        </div>
      </div>
    </div>
  `,
  changeDetection: ChangeDetectionStrategy.OnPush,
})
export class HomeComponent {
  navigate = output<Extract<View, 'print' | 'store'>>();
}
