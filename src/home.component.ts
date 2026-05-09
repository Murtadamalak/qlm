import { ChangeDetectionStrategy, Component, output } from '@angular/core';
import { View } from './app.component';

@Component({
  selector: 'app-home',
  template: `
    <section class="overflow-hidden rounded-[2.5rem] border border-[#004643]/10 bg-[#004643] shadow-2xl shadow-[#004643]/20">
      <div class="grid min-h-[560px] lg:grid-cols-2">
        <div class="relative flex flex-col justify-between bg-[#F0EDE5] p-8 text-[#004643] sm:p-12 lg:p-16">
          <div class="absolute -left-16 top-16 h-40 w-40 rounded-full border-[28px] border-[#004643]/10"></div>
          <div class="relative z-10">
            <span class="inline-flex rounded-full border border-[#004643]/15 bg-white/60 px-4 py-2 text-sm font-black shadow-sm">ألوان Sand + Cyprus</span>
            <h1 class="mt-8 max-w-xl text-5xl font-black leading-[0.95] tracking-tight sm:text-7xl">
              قرطاسية أنيقة لطلاب ومحترفي اليوم
            </h1>
            <p class="mt-6 max-w-lg text-lg leading-8 text-[#004643]/70">
              متجر مكتبة القلم بتجربة حديثة وسريعة للشراء والمتابعة — منتجات مختارة، طلبات واضحة، ودفع عند الاستلام.
            </p>
          </div>

          <div class="relative z-10 mt-10 flex flex-col gap-3 sm:flex-row">
            <button (click)="navigate.emit('store')" class="rounded-2xl bg-[#004643] px-7 py-4 text-base font-black text-[#F0EDE5] shadow-xl shadow-[#004643]/20 transition hover:-translate-y-1 hover:bg-[#003B38]">
              تسوق الآن
            </button>
            <button (click)="navigate.emit('orders')" class="rounded-2xl border border-[#004643]/15 bg-white/70 px-7 py-4 text-base font-black text-[#004643] transition hover:-translate-y-1 hover:bg-white">
              تابع طلباتك
            </button>
          </div>
        </div>

        <div class="relative bg-[#004643] p-8 text-[#F0EDE5] sm:p-12 lg:p-16">
          <div class="absolute inset-0 bg-[radial-gradient(circle_at_20%_20%,rgba(240,237,229,0.18),transparent_30%),radial-gradient(circle_at_80%_70%,rgba(240,237,229,0.14),transparent_26%)]"></div>
          <div class="relative z-10 flex h-full flex-col justify-between gap-8">
            <div class="flex justify-end">
              <div class="rounded-3xl border border-[#F0EDE5]/15 bg-[#F0EDE5]/10 p-4 text-center backdrop-blur">
                <p class="text-4xl font-black">#004643</p>
                <p class="text-xs uppercase tracking-[0.35em] text-[#F0EDE5]/60">Cyprus</p>
              </div>
            </div>

            <div class="grid gap-4 sm:grid-cols-2">
              <div class="rounded-[2rem] bg-[#F0EDE5] p-6 text-[#004643] shadow-2xl">
                <p class="text-sm font-bold text-[#004643]/60">منتجات مميزة</p>
                <p class="mt-3 text-4xl font-black">+120</p>
                <p class="mt-2 text-sm text-[#004643]/70">أقلام، دفاتر، ملفات، وأدوات مكتبية.</p>
              </div>
              <div class="rounded-[2rem] border border-[#F0EDE5]/15 bg-[#F0EDE5]/10 p-6 backdrop-blur">
                <p class="text-sm font-bold text-[#F0EDE5]/60">تجربة سلسة</p>
                <p class="mt-3 text-4xl font-black">COD</p>
                <p class="mt-2 text-sm text-[#F0EDE5]/70">الدفع عند الاستلام مع متابعة حالة الطلب.</p>
              </div>
            </div>

            <div class="rounded-[2rem] border border-[#F0EDE5]/15 bg-black/10 p-5 backdrop-blur">
              <div class="flex items-center justify-between gap-4">
                <div>
                  <p class="text-sm text-[#F0EDE5]/60">Today's pick</p>
                  <p class="mt-1 text-2xl font-black">دفاتر وأقلام بتصميم عصري</p>
                </div>
                <div class="grid h-16 w-16 place-items-center rounded-2xl bg-[#F0EDE5] text-3xl text-[#004643]">✦</div>
              </div>
            </div>
          </div>
        </div>
      </div>
    </section>

    <section class="mt-10 grid gap-5 md:grid-cols-3">
      @for (feature of features; track feature.title) {
        <div class="rounded-[2rem] border border-[#004643]/10 bg-white/60 p-6 shadow-lg shadow-[#004643]/5 backdrop-blur transition hover:-translate-y-1 hover:bg-white">
          <div class="grid h-12 w-12 place-items-center rounded-2xl bg-[#004643] text-xl text-[#F0EDE5]">{{ feature.icon }}</div>
          <h3 class="mt-5 text-xl font-black text-[#004643]">{{ feature.title }}</h3>
          <p class="mt-2 leading-7 text-[#004643]/65">{{ feature.description }}</p>
        </div>
      }
    </section>
  `,
  changeDetection: ChangeDetectionStrategy.OnPush,
})
export class HomeComponent {
  navigate = output<Extract<View, 'store' | 'orders'>>();

  features = [
    { icon: '01', title: 'تصميم حديث', description: 'واجهة نظيفة ومتجاوبة للهاتف والكمبيوتر بألوان Sand وCyprus.' },
    { icon: '02', title: 'متجر سريع', description: 'بحث مباشر، بطاقات منتجات واضحة، وإضافة للسلة بنقرة واحدة.' },
    { icon: '03', title: 'متابعة الطلب', description: 'اعرف حالة طلبك من لحظة التأكيد وحتى التسليم.' },
  ];
}
