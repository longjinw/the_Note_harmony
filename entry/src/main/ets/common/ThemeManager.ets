import common from '@ohos.app.ability.common';
import preferences from '@ohos.data.preferences';

export class ThemeManager {
  private static instance: ThemeManager;
  private context: common.UIAbilityContext;
  private isDarkMode: boolean = false;
  private listeners: ((isDarkMode: boolean) => void)[] = [];
  private readonly PREFERENCES_NAME = 'theme_preferences';
  private readonly DARK_MODE_KEY = 'isDarkMode';

  private constructor(context: common.UIAbilityContext) {
    this.context = context;
  }

  public static getInstance(context: common.UIAbilityContext): ThemeManager {
    if (!ThemeManager.instance) {
      ThemeManager.instance = new ThemeManager(context);
    }
    return ThemeManager.instance;
  }

  public async init(): Promise<void> {
    try {
      const prefs = await preferences.getPreferences(this.context, this.PREFERENCES_NAME);
      this.isDarkMode = await prefs.get(this.DARK_MODE_KEY, false) as boolean;
    } catch {
      console.error('Failed to initialize theme preferences');
    }
  }

  public getIsDarkMode(): boolean {
    return this.isDarkMode;
  }

  public async setIsDarkMode(isDarkMode: boolean): Promise<void> {
    try {
      const prefs = await preferences.getPreferences(this.context, this.PREFERENCES_NAME);
      await prefs.put(this.DARK_MODE_KEY, isDarkMode);
      await prefs.flush();
      this.isDarkMode = isDarkMode;
      this.notifyListeners();
    } catch {
      console.error('Failed to save theme preference');
    }
  }

  public addListener(listener: (isDarkMode: boolean) => void): void {
    this.listeners.push(listener);
  }

  public removeListener(): void {
    this.listeners = [];
  }

  private notifyListeners(): void {
    this.listeners.forEach(listener => listener(this.isDarkMode));
  }
} 