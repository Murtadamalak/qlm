import { ChangeDetectionStrategy, Component, inject, output, signal } from '@angular/core';
import { FormsModule } from '@angular/forms';
import { CommonModule } from '@angular/common';
import { AuthService } from './services/auth.service';

@Component({
  selector: 'app-login',
  imports: [FormsModule, CommonModule],
  template: `
    <div class="flex items-center justify-center min-h-screen bg-slate-100">
      <div class="w-full max-w-md p-8 space-y-6 bg-white rounded-lg shadow-md">
        <div class="text-center">
            <h2 class="text-3xl font-bold text-slate-800">تسجيل الدخول</h2>
            <p class="mt-2 text-sm text-slate-600">للتجربة كمدير: admin / admin</p>
        </div>
        
        <form (ngSubmit)="onSubmit()" class="space-y-6">
          <div>
            <label for="username" class="text-sm font-medium text-slate-700">اسم المستخدم</label>
            <input id="username" name="username" type="text" [(ngModel)]="username" required 
                   class="w-full px-3 py-2 mt-1 border border-slate-300 rounded-md shadow-sm focus:outline-none focus:ring-teal-500 focus:border-teal-500">
          </div>
          
          <div>
            <label for="password" class="text-sm font-medium text-slate-700">كلمة المرور</label>
            <input id="password" name="password" type="password" [(ngModel)]="password" required 
                   class="w-full px-3 py-2 mt-1 border border-slate-300 rounded-md shadow-sm focus:outline-none focus:ring-teal-500 focus:border-teal-500">
          </div>
          
          @if(errorMessage()) {
            <p class="text-sm text-red-600">{{ errorMessage() }}</p>
          }
          
          <div>
            <button type="submit" 
                    class="w-full px-4 py-2 font-semibold text-white bg-teal-600 rounded-md hover:bg-teal-700 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-teal-500">
              تسجيل الدخول
            </button>
          </div>
        </form>
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
