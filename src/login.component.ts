import { ChangeDetectionStrategy, Component, inject, output, signal } from '@angular/core';
import { FormsModule } from '@angular/forms';
import { CommonModule } from '@angular/common';
import { AuthService } from './services/auth.service';

@Component({
  selector: 'app-login',
  imports: [FormsModule, CommonModule],
  template: `
    <div class="min-h-screen bg-[#004643] p-4 text-[#F0EDE5] sm:p-8">
      <div class="mx-auto grid min-h-[calc(100vh-2rem)] max-w-6xl overflow-hidden rounded-[2.5rem] border border-[#F0EDE5]/15 bg-[#F0EDE5] shadow-2xl lg:grid-cols-2">
        <section class="relative hidden bg-[#004643] p-12 lg:flex lg:flex-col lg:justify-between">
          <div class="absolute inset-0 bg-[radial-gradient(circle_at_25%_25%,rgba(240,237,229,0.22),transparent_28%),radial-gradient(circle_at_80%_80%,rgba(240,237,229,0.12),transparent_30%)]"></div>
          <div class="relative z-10">
            <div class="grid h-16 w-16 place-items-center rounded-3xl bg-[#F0EDE5] text-3xl font-black text-[#004643]">ق</div>
            <h1 class="mt-8 text-6xl font-black leading-none tracking-tight">مكتبة القلم</h1>
            <p class="mt-5 max-w-md text-lg leading-8 text-[#F0EDE5]/70">واجهة متجر حديثة بألوان Sand وCyprus لإدارة الطلبات والقرطاسية بسهولة.</p>
          </div>
          <div class="relative z-10 rounded-[2rem] border border-[#F0EDE5]/15 bg-[#F0EDE5]/10 p-6 backdrop-blur">
            <p class="text-sm text-[#F0EDE5]/60">تجربة المدير</p>
            <p class="mt-2 text-2xl font-black">admin / admin</p>
          </div>
        </section>

        <section class="flex items-center justify-center p-6 text-[#004643] sm:p-10 lg:p-14">
          <div class="w-full max-w-md">
            <div class="mb-8 lg:hidden">
              <div class="grid h-14 w-14 place-items-center rounded-2xl bg-[#004643] text-2xl font-black text-[#F0EDE5]">ق</div>
            </div>
            <p class="text-sm font-black uppercase tracking-[0.35em] text-[#004643]/45">Welcome back</p>
            <h2 class="mt-3 text-4xl font-black tracking-tight">تسجيل الدخول</h2>
            <p class="mt-3 text-[#004643]/60">ادخل بحسابك للمتجر. للتجربة كمدير استخدم: admin / admin</p>

            <form (ngSubmit)="onSubmit()" class="mt-8 space-y-5">
              <div>
                <label for="username" class="text-sm font-black text-[#004643]">اسم المستخدم</label>
                <input id="username" name="username" type="text" [(ngModel)]="username" required
                       class="mt-2 w-full rounded-2xl border border-[#004643]/10 bg-white px-5 py-4 font-bold text-[#004643] shadow-sm outline-none transition focus:border-[#004643] focus:ring-4 focus:ring-[#004643]/10">
              </div>

              <div>
                <label for="password" class="text-sm font-black text-[#004643]">كلمة المرور</label>
                <input id="password" name="password" type="password" [(ngModel)]="password" required
                       class="mt-2 w-full rounded-2xl border border-[#004643]/10 bg-white px-5 py-4 font-bold text-[#004643] shadow-sm outline-none transition focus:border-[#004643] focus:ring-4 focus:ring-[#004643]/10">
              </div>

              @if(errorMessage()) {
                <p class="rounded-2xl bg-red-50 px-4 py-3 text-sm font-bold text-red-700">{{ errorMessage() }}</p>
              }

              <button type="submit" class="w-full rounded-2xl bg-[#004643] px-5 py-4 text-lg font-black text-[#F0EDE5] shadow-xl shadow-[#004643]/20 transition hover:-translate-y-1 hover:bg-[#003B38]">
                دخول للمتجر
              </button>
            </form>
          </div>
        </section>
      </div>
    </div>
  `,
  changeDetection: ChangeDetectionStrategy.OnPush,
})
export class LoginComponent {
  authService = inject(AuthService);
  loginSuccess = output();

  username = '';
  password = '';
  errorMessage = signal('');

  onSubmit() {
    if (this.authService.login(this.username, this.password)) {
      this.loginSuccess.emit();
    } else {
      this.errorMessage.set('اسم المستخدم أو كلمة المرور غير صحيحة.');
    }
  }
}
