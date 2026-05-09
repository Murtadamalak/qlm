import { Injectable, signal, computed } from '@angular/core';
import { User } from '../models';

@Injectable({
  providedIn: 'root'
})
export class AuthService {
  currentUser = signal<User | null>(null);

  isLoggedIn = computed(() => !!this.currentUser());
  isAdmin = computed(() => this.currentUser()?.role === 'admin');

  login(username: string, password: string):boolean {
    // Mock authentication
    if (username.toLowerCase() === 'admin' && password === 'admin') {
      this.currentUser.set({ id: 'admin1', username: 'Admin', role: 'admin' });
      return true;
    }
    // Mock customer login
    if (username && password) {
        this.currentUser.set({id: `user-${Date.now()}`, username: username, role: 'customer'});
        return true;
    }
    return false;
  }

  logout() {
    this.currentUser.set(null);
  }
}
