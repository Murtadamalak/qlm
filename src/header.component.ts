import { ChangeDetectionStrategy, Component, inject, output, signal, computed } from '@angular/core';
import { CartService } from './services/cart.service';
import { AuthService } from './services/auth.service';
import { View } from './app.component';
import { CommonModule } from '@angular/common';

@Component({
  selector: 'app-header',
  imports: [CommonModule],
  template: `
    <header class="bg-white shadow-md sticky top-0 z-50">
      <nav class="container mx-auto px-4 sm:px-6 lg:px-8">
        <div class="flex items-center justify-between h-16">
          <div class="flex items-center">
            <button (click)="handleNav('home')" class="flex-shrink-0 flex items-center gap-2">
              <svg class="h-8 w-8 text-teal-600" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke-width="1.5" stroke="currentColor">
                <path stroke-linecap="round" stroke-linejoin="round" d="M12 6.042A8.967 8.967 0 0 0 6 3.75c-1.052 0-2.062.18-3 .512v14.25A8.987 8.987 0 0 1 6 18c2.305 0 4.408.867 6 2.292m0-14.25a8.966 8.966 0 0 1 6-2.292c1.052 0 2.062.18 3 .512v14.25A8.987 8.987 0 0 0 18 18a8.967 8.967 0 0 0-6-2.292m0 0V21M12 6.042A8.967 8.967 0 0 1 18 3.75m-6 2.292A8.967 8.967 0 0 0 6 3.75" />
              </svg>
              <span class="font-bold text-xl text-slate-800">مكتبة القلم</span>
            </button>
            <div class="hidden md:flex">
              <div class="ms-10 flex items-baseline space-x-4">
                <button (click)="navigate.emit('print')" class="text-slate-600 hover:bg-slate-100 hover:text-slate-900 px-3 py-2 rounded-md text-sm font-medium">خدمات الطباعة</button>
                <button (click)="navigate.emit('store')" class="text-slate-600 hover:bg-slate-100 hover:text-slate-900 px-3 py-2 rounded-md text-sm font-medium">متجر المنتجات</button>
                @if(authService.isLoggedIn()) {
                  <button (click)="navigate.emit('orders')" class="text-slate-600 hover:bg-slate-100 hover:text-slate-900 px-3 py-2 rounded-md text-sm font-medium">طلباتي</button>
                }
                @if(authService.isAdmin()) {
                  <button (click)="navigate.emit('admin')" class="text-slate-600 bg-teal-50 hover:bg-teal-100 hover:text-slate-900 px-3 py-2 rounded-md text-sm font-medium">لوحة التحكم</button>
                }
              </div>
            </div>
          </div>
          <div class="flex items-center">
             @if(authService.isLoggedIn()) {
              <button (click)="navigate.emit('cart')" class="relative p-2 rounded-full text-slate-500 hover:text-slate-800 hover:bg-slate-100 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-teal-500">
                <span class="sr-only">عرض السلة</span>
                <svg class="h-6 w-6" fill="none" viewBox="0 0 24 24" stroke-width="1.5" stroke="currentColor" aria-hidden="true">
                  <path stroke-linecap="round" stroke-linejoin="round" d="M2.25 3h1.386c.51 0 .955.343 1.087.835l.383 1.437M7.5 14.25a3 3 0 00-3 3h15.75m-12.75-3h11.218c.51 0 .962-.344 1.087-.835l1.828-6.823a.75.75 0 00-.11-.63.75.75 0 00-.63-.311H5.25M7.5 14.25L5.106 5.165M16.5 18a1.5 1.5 0 11-3 0 1.5 1.5 0 013 0zM8.25 18a1.5 1.5 0 11-3 0 1.5 1.5 0 013 0z" />
                </svg>
                @if (itemCount() > 0) {
                  <span class="absolute -top-1 -right-1 flex h-5 w-5 items-center justify-center rounded-full bg-red-500 text-xs font-medium text-white">{{ itemCount() }}</span>
                }
              </button>
               <button (click)="logout()" class="text-slate-600 hover:bg-slate-100 hover:text-slate-900 px-3 py-2 rounded-md text-sm font-medium">تسجيل الخروج</button>
             }
            <!-- Mobile menu button -->
            <div class="md:hidden ms-2">
              <button (click)="toggleMobileMenu()" type="button" class="inline-flex items-center justify-center p-2 rounded-md text-slate-400 hover:text-slate-800 hover:bg-slate-100 focus:outline-none focus:ring-2 focus:ring-inset focus:ring-teal-500" aria-controls="mobile-menu" aria-expanded="false">
                <span class="sr-only">فتح القائمة الرئيسية</span>
                @if (!isMobileMenuOpen()) {
                  <svg class="block h-6 w-6" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke="currentColor" aria-hidden="true">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M4 6h16M4 12h16M4 18h16" />
                  </svg>
                } @else {
                  <svg class="block h-6 w-6" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke="currentColor" aria-hidden="true">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M6 18L18 6M6 6l12 12" />
                  </svg>
                }
              </button>
            </div>
          </div>
        </div>
        <!-- Mobile menu, show/hide based on menu state. -->
        @if (isMobileMenuOpen()) {
          <div class="md:hidden" id="mobile-menu">
            <div class="px-2 pt-2 pb-3 space-y-1 sm:px-3">
              <button (click)="handleNav('print')" class="text-slate-600 hover:bg-slate-100 hover:text-slate-900 block w-full text-right px-3 py-2 rounded-md text-base font-medium">خدمات الطباعة</button>
              <button (click)="handleNav('store')" class="text-slate-600 hover:bg-slate-100 hover:text-slate-900 block w-full text-right px-3 py-2 rounded-md text-base font-medium">متجر المنتجات</button>
              @if(authService.isLoggedIn()) {
                <button (click)="handleNav('orders')" class="text-slate-600 hover:bg-slate-100 hover:text-slate-900 block w-full text-right px-3 py-2 rounded-md text-base font-medium">طلباتي</button>
              }
              @if(authService.isAdmin()) {
                <button (click)="handleNav('admin')" class="text-slate-600 bg-teal-50 hover:bg-teal-100 hover:text-slate-900 block w-full text-right px-3 py-2 rounded-md text-base font-medium">لوحة التحكم</button>
              }
            </div>
          </div>
        }
      </nav>
    </header>
  `,
  changeDetection: ChangeDetectionStrategy.OnPush,
})
export class HeaderComponent {
  cartService = inject(CartService);
  authService = inject(AuthService);
  navigate = output<View>();
  itemCount = this.cartService.itemCount;
  isMobileMenuOpen = signal(false);

  handleNav(view: View) {
    this.isMobileMenuOpen.set(false);
    this.navigate.emit(view);
  }

  toggleMobileMenu() {
    this.isMobileMenuOpen.update(v => !v);
  }

  logout() {
    this.authService.logout();
    this.handleNav('login');
  }
}
