import relationalStore from '@ohos.data.relationalStore';
import common from '@ohos.app.ability.common';

// 定义数据库值桶接口
interface UserValues extends relationalStore.ValuesBucket {
  username: string;
  password: string;
}

// 定义操作结果接口
interface OperationResult {
  success: boolean;
  message: string;
}

export class UserManager {
  private static instance: UserManager;
  private context: common.UIAbilityContext;
  private rdbStore: relationalStore.RdbStore | null = null;
  private readonly STORE_CONFIG: relationalStore.StoreConfig = {
    name: 'user_store.db',
    securityLevel: relationalStore.SecurityLevel.S1
  };

  private readonly SQL_CREATE_TABLE = `
    CREATE TABLE IF NOT EXISTS users (
      username TEXT PRIMARY KEY,
      password TEXT NOT NULL
    );
  `;

  private constructor(context: common.UIAbilityContext) {
    this.context = context;
  }

  public static getInstance(context: common.UIAbilityContext): UserManager {
    if (!UserManager.instance) {
      UserManager.instance = new UserManager(context);
    }
    return UserManager.instance;
  }

  // 初始化数据库
  public async init(): Promise<string | null> {
    try {
      this.rdbStore = await relationalStore.getRdbStore(this.context, this.STORE_CONFIG);
      await this.rdbStore.executeSql(this.SQL_CREATE_TABLE);
      return null;
    } catch (error) {
      console.error('Failed to initialize database:', error);
      return '数据库初始化失败';
    }
  }

  // 注册新用户
  public async registerUser(username: string, password: string): Promise<OperationResult> {
    try {
      if (!this.rdbStore) {
        return { success: false, message: '数据库未初始化' } as OperationResult;
      }

      // 检查用户是否已存在
      const predicates = new relationalStore.RdbPredicates('users');
      predicates.equalTo('username', username);
      const resultSet = await this.rdbStore.query(predicates, ['username']);
      if (resultSet.rowCount > 0) {
        resultSet.close();
        return { success: false, message: '用户名已存在' } as OperationResult;
      }
      resultSet.close();

      // 插入新用户
      const valuesBucket: UserValues = {
        username: username,
        password: password
      } as UserValues;
      await this.rdbStore.insert('users', valuesBucket);
      return { success: true, message: '注册成功' } as OperationResult;
    } catch (error) {
      console.error('Failed to register user:', error);
      return { success: false, message: '注册失败，请稍后重试' } as OperationResult;
    }
  }

  // 用户登录验证
  public async login(username: string, password: string): Promise<OperationResult> {
    try {
      if (!this.rdbStore) {
        return { success: false, message: '数据库未初始化' } as OperationResult;
      }

      const predicates = new relationalStore.RdbPredicates('users');
      predicates.equalTo('username', username)
        .and()
        .equalTo('password', password);
      const resultSet = await this.rdbStore.query(predicates, ['username']);
      const isValid = resultSet.rowCount > 0;
      resultSet.close();
      return { 
        success: isValid, 
        message: isValid ? '登录成功' : '用户名或密码错误' 
      } as OperationResult;
    } catch (error) {
      console.error('Failed to verify login:', error);
      return { success: false, message: '登录失败，请稍后重试' } as OperationResult;
    }
  }
} 