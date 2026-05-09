import { ChangeDetectionStrategy, Component, computed, inject, output, signal } from '@angular/core';
import { CommonModule } from '@angular/common';
import { CartService } from './services/cart.service';
import { AuthService } from './services/auth.service';
import { View } from './app.component';

@Component({
  selector: 'app-header',
  imports: [CommonModule],
  template: `
    <header class="sticky top-0 z-50 border-b border-[#F0EDE5]/10 bg-[#004643]/95 text-[#F0EDE5] shadow-2xl shadow-[#004643]/20 backdrop-blur-xl">
      <nav class="container mx-auto px-4 sm:px-6 lg:px-8">
        <div class="flex h-20 items-center justify-between gap-4">
          <button (click)="handleNav('home')" class="group flex items-center gap-3 text-right">
            <span class="grid h-12 w-12 place-items-center rounded-2xl bg-[#F0EDE5] text-[#004643] shadow-lg transition group-hover:rotate-3 group-hover:scale-105">
              <svg class="h-7 w-7" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke-width="1.8" stroke="currentColor">
                <path stroke-linecap="round" stroke-linejoin="round" d="M12 6.042A8.967 8.967 0 0 0 6 3.75c-1.052 0-2.062.18-3 .512v14.25A8.987 8.987 0 0 1 6 18c2.305 0 4.408.867 6 2.292m0-14.25A8.966 8.966 0 0 1 18 3.75c1.052 0 2.062.18 3 .512v14.25A8.987 8.987 0 0 0 18 18a8.967 8.967 0 0 0-6 2.292m0-14.25V21" />
              </svg>
            </span>
            <span>
              <span class="block text-xl font-black tracking-tight">مكتبة القلم</span>
              <span class="block text-xs text-[#F0EDE5]/60">Stationery Boutique</span>
            </span>
          </button>

          <div class="hidden items-center rounded-full border border-[#F0EDE5]/15 bg-[#F0EDE5]/10 p-1 md:flex">
            <button (click)="navigate.emit('home')" class="rounded-full px-5 py-2.5 text-sm font-bold text-[#F0EDE5]/80 transition hover:bg-[#F0EDE5] hover:text-[#004643]">الرئيسية</button>
            <button (click)="navigate.emit('store')" class="rounded-full px-5 py-2.5 text-sm font-bold text-[#F0EDE5]/80 transition hover:bg-[#F0EDE5] hover:text-[#004643]">المتجر</button>
            @if(authService.isLoggedIn()) {
              <button (click)="navigate.emit('orders')" class="rounded-full px-5 py-2.5 text-sm font-bold text-[#F0EDE5]/80 transition hover:bg-[#F0EDE5] hover:text-[#004643]">طلباتي</button>
            }
            @if(authService.isAdmin()) {
              <button (click)="navigate.emit('admin')" class="rounded-full bg-[#F0EDE5] px-5 py-2.5 text-sm font-black text-[#004643] shadow-lg">لوحة التحكم</button>
            }
          </div>

          <div class="flex items-center gap-2">
            @if(authService.isLoggedIn()) {
              <button (click)="navigate.emit('cart')" class="relative grid h-11 w-11 place-items-center rounded-2xl border border-[#F0EDE5]/15 bg-[#F0EDE5]/10 text-[#F0EDE5] transition hover:bg-[#F0EDE5] hover:text-[#004643]">
                <span class="sr-only">عرض السلة</span>
                <svg class="h-5 w-5" fill="none" viewBox="0 0 24 24" stroke-width="1.8" stroke="currentColor" aria-hidden="true">
                  <path stroke-linecap="round" stroke-linejoin="round" d="M2.25 3h1.386c.51 0 .955.343 1.087.835l.383 1.437M7.5 14.25a3 3 0 00-3 3h15.75m-12.75-3h11.218c.51 0 .962-.344 1.087-.835l1.828-6.823a.75.75 0 00-.11-.63.75.75 0 00-.63-.311H5.25M7.5 14.25L5.106 5.165M16.5 18a1.5 1.5 0 11-3 0 1.5 1.5 0 013 0zM8.25 18a1.5 1.5 0 11-3 0 1.5 1.5 0 013 0z" />
                </svg>
                @if (itemCount() > 0) {
                  <span class="absolute -top-1 -right-1 grid h-5 w-5 place-items-center rounded-full bg-[#F0EDE5] text-xs font-black text-[#004643] ring-2 ring-[#004643]">{{ itemCount() }}</span>
                }
              </button>
              <button (click)="logout()" class="hidden rounded-2xl px-4 py-2 text-sm font-bold text-[#F0EDE5]/70 transition hover:bg-[#F0EDE5]/10 hover:text-[#F0EDE5] sm:block">خروج</button>
            }

            <button (click)="toggleMobileMenu()" type="button" class="grid h-11 w-11 place-items-center rounded-2xl border border-[#F0EDE5]/15 bg-[#F0EDE5]/10 text-[#F0EDE5] md:hidden" aria-controls="mobile-menu" aria-expanded="false">
              <span class="sr-only">فتح القائمة الرئيسية</span>
              @if (!isMobileMenuOpen()) {
                <svg class="h-6 w-6" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke="currentColor" aria-hidden="true">
                  <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M4 6h16M4 12h16M4 18h16" />
                </svg>
              } @else {
                <svg class="h-6 w-6" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke="currentColor" aria-hidden="true">
                  <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M6 18L18 6M6 6l12 12" />
                </svg>
              }
            </button>
          </div>
        </div>

        @if (isMobileMenuOpen()) {
          <div class="pb-5 md:hidden" id="mobile-menu">
            <div class="grid gap-2 rounded-[2rem] border border-[#F0EDE5]/10 bg-[#F0EDE5]/10 p-3">
              <button (click)="handleNav('home')" class="rounded-2xl px-4 py-3 text-right text-base font-bold text-[#F0EDE5] hover:bg-[#F0EDE5] hover:text-[#004643]">الرئيسية</button>
              <button (click)="handleNav('store')" class="rounded-2xl px-4 py-3 text-right text-base font-bold text-[#F0EDE5] hover:bg-[#F0EDE5] hover:text-[#004643]">المتجر</button>
              @if(authService.isLoggedIn()) {
                <button (click)="handleNav('orders')" class="rounded-2xl px-4 py-3 text-right text-base font-bold text-[#F0EDE5] hover:bg-[#F0EDE5] hover:text-[#004643]">طلباتي</button>
              }
              @if(authService.isAdmin()) {
                <button (click)="handleNav('admin')" class="rounded-2xl px-4 py-3 text-right text-base font-bold text-[#004643] bg-[#F0EDE5]">لوحة التحكم</button>
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
  itemCount = computed(() => this.cartService.itemCount());
  isMobileMenuOpen = signal(false);

  handleNav(view: View) {
    this.navigate.emit(view);
    this.isMobileMenuOpen.set(false);
  }

  toggleMobileMenu() {
    this.isMobileMenuOpen.update(value => !value);
  }

  logout() {
    this.authService.logout();
    this.navigate.emit('login');
  }
}
